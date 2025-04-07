var express = require("express");
var router = express.Router();
const authenticateToken = require("../middleware/auth");
var pool = require("../config/database");
const Transaccion = require("../models/Transaccion");


/* POST insertar venta */
router.post("/venta/:id_almacen", authenticateToken, async function (req, res) {
    try {
        let userId =
            req.user && req.user.userId
                ? req.user.userId
                : res.status(401).json({ error: "No autenticado. Por favor, inicie sesión para continuar." });

        let usuario = req.user.usuario;
        let role = req.user.role;

        if (role === "administrador" || role === "operador") {

            const id_almacen = req.params.id_almacen;

            const [result] = await pool.query(
                "CALL InsertarVenta(?, ?)",
                [id_almacen, userId]
            );

            const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Creacion de venta fallida"});
                     

            if (result[0] && result[0][0] && result[0][0].id_venta) {

                transaccion.tipoTransaccion = "Creacion de venta con Id: " + result[0][0].id_venta;
                await transaccion.save();

                return res.status(201).json({ message: `Venta creada con ID: ${result[0][0].id_venta}` });
            }

            await transaccion.save();
            res.status(500).json({ message: "Error al crear la venta" });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para crear ventas" });
        }
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

/* POST insertar detalle de venta */
router.post("/venta/detalle/:id_venta", authenticateToken, async function (req, res) {
    try {
        let userId =
            req.user && req.user.userId
                ? req.user.userId
                : res.status(401).json({ error: "No autenticado. Por favor, inicie sesión para continuar." });
        
        let usuario = req.user.usuario;
        let role = req.user.role;

        if (role === "administrador" || role === "operador") {

            const id_venta = req.params.id_venta;
            const { cod_producto, cantidad } = req.body;

            if (!cod_producto || !cantidad) {
                return res.status(400).json({ message: "No se enviaron todos los datos necesarios" });
            }

            const [result] = await pool.query(
                "CALL InsertarDetalleVenta(?, ?, ?, ?)",
                [id_venta, userId, cod_producto, cantidad]
            );

            const transaccion = new Transaccion({ usuarioId: userId, usuario: usuario, tipoTransaccion: "Creacion de detalle de venta fallida"});

            if (result[0] && result[0][0] && result[0][0].mensaje) {
                if (result[0][0].mensaje.includes("insertado correctamente")) {

                    transaccion.tipoTransaccion = "Creacion de detalle de venta con Id: " + result[0][0].id_venta;
                    await transaccion.save();
                    return res.status(201).json({ message: result[0][0].mensaje });
                } else if (result[0][0].mensaje.includes("no existe")) {
                    transaccion.tipoTransaccion = "Creacion de detalle de venta fallida";
                    await transaccion.save();
                    return res.status(404).json({ message: result[0][0].mensaje });
                } else if (result[0][0].mensaje.includes("suficientes existencias")) {

                    transaccion.tipoTransaccion = "Creacion de detalle de venta fallida, por falta de existencias";
                    await transaccion.save();
                    return res.status(400).json({ message: result[0][0].mensaje });
                } else {
                    await transaccion.save();
                    return res.status(400).json({ message: result[0][0].mensaje });
                }
            }
            
            await transaccion.save();
            res.status(500).json({ message: "Error al insertar el detalle de la venta" });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para insertar detalles de venta" });
        }
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});



module.exports = router;