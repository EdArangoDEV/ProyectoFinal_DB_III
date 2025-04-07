var express = require("express");
var router = express.Router();
const authenticateToken = require("../middleware/auth");
var pool = require("../config/database");
const Transaccion = require("../models/Transaccion");

router.get("/", authenticateToken, async function (req, res) {
  try {
    let userId = req.user && req.user.userId
      ? req.user.userId
      : res.status(401).json({ error: "No autenticado. Por favor, inicie sesión para continuar." });

    let usuario = req.user.usuario;
    let role = req.user.role;

    if (role === "administrador" || role === "operador") {
      // Usar la vista para obtener todos los productos
      const [almacenes] = await pool.query("SELECT * FROM almacenes;");

      const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Consulta de almacenes" });
      await transaccion.save();

      res.json({ almacenes: almacenes });
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para ver los almacenes" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});


/* POST agregar producto a almacén */
router.post("/producto/:id_almacen", authenticateToken, async function (req, res) {
  try {
    let userId =
      req.user && req.user.userId
        ? req.user.userId
        : res.status(401).json({ error: "No autenticado. Por favor, inicie sesión para continuar." });

    let role = req.user.role;
    let usuario = req.user.usuario;

    if (role === "administrador") {

      const id_almacen = req.params.id_almacen;
      const { cod_producto, existencia } = req.body;

      if (!cod_producto || !existencia) {
        return res.status(400).json({ message: "No se enviaron todos los datos necesarios" });
      }

      const [result] = await pool.query(
        "CALL AgregarProductoAlmacen(?, ?, ?)",
        [id_almacen, cod_producto, existencia]
      );

      // Procesar resultado del SP
      const mensaje = result[0]?.[0]?.mensaje;

      if (!mensaje) {
        return res.status(500).json({ message: "Error inesperado al procesar la solicitud" });
      }

      // Determinar código de estado basado en el mensaje
      if (mensaje.includes("agregado al almacén")) {

        const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Agregar producto " + cod_producto + " a almacen con id " + id_almacen });
        await transaccion.save();

        return res.status(201).json({ message: mensaje });
      }
      if (mensaje.includes("ya existe")) {
        return res.status(409).json({ message: mensaje }); // 409 Conflict
      }
      if (mensaje.includes("no existe")) {
        return res.status(404).json({ message: mensaje });
      }

      res.status(500).json({ message: "Error al agregar el producto al almacén" });
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para agregar productos a almacenes" });
    }
  }
  catch (error) {
    res.status(400).json({ error: error.message });
  }
});


/* PATCH actualizar existencia de producto en almacén */
router.patch("/existencia/:id_almacen", authenticateToken, async function (req, res) {
  try {
    let userId =
      req.user && req.user.userId
        ? req.user.userId
        : res.status(401).json({ error: "No autenticado. Por favor, inicie sesión para continuar." });

    let usuario = req.user.usuario;
    let role = req.user.role;

    if (role === "administrador") {

      const id_almacen = req.params.id_almacen;
      const { cod_producto, nueva_existencia } = req.body;

      if (!cod_producto || !nueva_existencia) {
        return res.status(400).json({ message: "No se enviaron todos los datos necesarios" });
      }

      const [result] = await pool.query(
        "CALL ExistenciaProducto(?, ?, ?)",
        [id_almacen, cod_producto, nueva_existencia]
      );

      if (result[0] && result[0][0] && result[0][0].mensaje) {
        if (result[0][0].mensaje.includes("no existe")) {
          if (result[0][0].mensaje.includes("almacén")) {
            return res.status(404).json({ message: result[0][0].mensaje });
          } else if (result[0][0].mensaje.includes("producto")) {
            return res.status(404).json({ message: result[0][0].mensaje });
          } else {
            return res.status(404).json({ message: result[0][0].mensaje });
          }
        } else if (result[0][0].mensaje.includes("actualizada correctamente")) {

          const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Actualizacion de existencia de producto " + cod_producto + " en almacen con id " + id_almacen });
          await transaccion.save();

          return res.status(200).json({ message: result[0][0].mensaje });
        } else {
          return res.status(400).json({ message: result[0][0].mensaje });
        }
      }

      res.status(500).json({ message: "Error al actualizar la existencia del producto" });
    } else {
      res
        .status(401)
        .json({ message: "No tiene permisos para actualizar existencias de los productos" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});



module.exports = router;
