var express = require("express");
var router = express.Router();
const authenticateToken = require("../middleware/auth");
var pool = require("../config/database");
const CambiosProducto = require("../models/CambiosProducto");
const Transaccion = require("../models/Transaccion");

/* GET products */
router.get("/", authenticateToken, async function (req, res) {
  try {
    let userId =
      req.user && req.user.userId
        ? req.user.userId
        : res.status(401).json({
          error: "No autenticado. Por favor, inicie sesión para continuar.",
        });

    let usuario = req.user.usuario;
    let role = req.user.role;

    if (role === "administrador" || role === "operador") {
      // Usar la vista para obtener todos los productos
      const [products] = await pool.query(
        "SELECT * FROM ReporteInventarioGeneral"
      );

      const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: products.length > 0 
        ? "Consulta de Inventario de Productos exitosa" 
        : "Consulta de Inventario de Productos sin resultados"});
      await transaccion.save();

      res.json({ products: products });
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para ver los productos" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

/* GET product by code */
router.get(
  "/codigo/:cod_producto",
  authenticateToken,
  async function (req, res) {
    try {
      let userId =
        req.user && req.user.userId
          ? req.user.userId
          : res.status(401).json({
            error: "No autenticado. Por favor, inicie sesión para continuar.",
          });

      let usuario = req.user.usuario;
      let role = req.user.role;

      if (role === "administrador" || role === "operador") {
        const cod_producto = req.params.cod_producto;

        const [result] = await pool.query("CALL BuscarProductoPorCodigo(?)", [
          cod_producto,
        ]);

        if (!result[0] || result[0].length === 0) {
          return res.status(404).json({ message: "Producto no encontrado" });
        }

        const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: result.length > 0 
          ? "Consulta de Producto por codigo exitosa" 
          : "Consulta de Producto por codigo sin resultados"});
        await transaccion.save();

        res.status(200).json({ producto: result[0][0] });
      } else {
        res
          .status(401)
          .json({ message: "No tiene permisos para ver los productos" });
      }
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  }
);

/* POST product */
router.post("/", authenticateToken, async function (req, res) {
  try {
    const { descripcion, precio_unitario, estado } = req.body;

    if (!descripcion || !precio_unitario || !estado) {
      return res
        .status(400)
        .json({ message: "Faltan datos para crear el producto" });
    }

    let userId =
      req.user && req.user.userId
        ? req.user.userId
        : res.status(401).json({
          error: "No autenticado. Por favor, inicie sesión para continuar.",
        });

    let usuario = req.user.usuario;
    let role = req.user.role;

    if (role === "administrador") {
      const [result] = await pool.query("CALL AgregarProducto(?, ?, ?)", [
        descripcion,
        precio_unitario,
        estado,
      ]);

      // Asumiendo que el procedimiento devuelve un mensaje en la primera fila
      if (result[0] && result[0][0] && result[0][0].mensaje.includes("Error")) {
        
        const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Creacion de producto fallida"});
        await transaccion.save();

        return res.status(500).json({ message: result[0][0].mensaje });
      }

        const cambiosP = new CambiosProducto({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Creacion de producto", cod_producto: result[0][0].cod_producto});
        await cambiosP.save();

      res.status(201).json({ message: "Producto creado exitosamente" });
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para crear nuevos productos" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

/* PATCH product */
router.patch("/:cod_producto", authenticateToken, async function (req, res) {
  try {
    let userId =
      req.user && req.user.userId
        ? req.user.userId
        : res.status(401).json({
          error: "No autenticado. Por favor, inicie sesión para continuar.",
        });

    let usuario = req.user.usuario;
    let role = req.user.role;

    if (role === "administrador") {

      const cod_producto = req.params.cod_producto;
      const { descripcion, precio_unitario, estado } = req.body;

      if (!descripcion && !precio_unitario && !estado) {
        return res
          .status(400)
          .json({ message: "No se enviaron datos para actualizar" });
      }

      const [result] = await pool.query("CALL ActualizarProducto(?, ?, ?, ?)", [
        cod_producto, descripcion, precio_unitario, estado,]);

      if (
        result[0] && result[0][0] && result[0][0].mensaje && result[0][0].mensaje.includes("no existe")
      ) {
        const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Actualizacion de producto fallida"});
        await transaccion.save();

        return res.status(404).json({ message: result[0][0].mensaje });
      }

      if (
        result[0] && result[0][0] && result[0][0].mensaje && result[0][0].mensaje.includes("actualizado correctamente")
      ) {
        const cambiosP = new CambiosProducto({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Actualizacion de producto", cod_producto: result[0][0].cod_producto});
        await cambiosP.save();

        return res.status(200).json({ message: result[0][0].mensaje });
      }

      res.status(500).json({ message: "Error al actualizar el producto" });
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para modificar productos" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});


/* DELETE product */
router.delete("/:cod_producto", authenticateToken, async function (req, res) {
  try {
    let userId =
      req.user && req.user.userId
        ? req.user.userId
        : res.status(401).json({
          error: "No autenticado. Por favor, inicie sesión para continuar.",
        });

    let usuario = req.user.usuario;
    let role = req.user.role;

    if (role === "administrador") {

      const cod_producto = req.params.cod_producto;

      const [result] = await pool.query("CALL EliminarProducto(?)", [
        cod_producto,
      ]);

      // Verificar si el mensaje de éxito está presente
      if (result[0] && result[0][0] && result[0][0].mensaje) {
        const mensaje = result[0][0].mensaje;

        if (mensaje.includes("no existe")) {

          const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Eliminacion de producto fallida, producto no existe"});
          await transaccion.save();

          return res.status(404).json({ message: mensaje });
        } else if (mensaje.includes("eliminado correctamente")) {

          const cambiosP = new CambiosProducto({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Eliminación de Producto", cod_producto: cod_producto });
          await cambiosP.save();

          return res.status(200).json({ message: mensaje });
        } else {
          // Si el mensaje no coincide con ninguno de los esperados, asumir un error
          return res
            .status(500)
            .json({ message: "Error al eliminar el producto" });
        }
      } else {
        // Si no hay mensaje, asumir un error general
        return res.status(500).json({ message: "Error al eliminar el producto" });
      }
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para eliminar productos" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
