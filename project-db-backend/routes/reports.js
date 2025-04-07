const express = require('express');
const router = express.Router();
const db = require('../config/database');
const authenticateToken = require('../middleware/auth');

//Productos Disponibles
router.get('/productos', authenticateToken, async (req, res) => {
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

            const [rows] = await db.query(`
            SELECT cod_producto, descripcion, precio_unitario, 
                CASE WHEN estado = 1 THEN 'Activo' ELSE 'Inactivo' END AS estado
            FROM Productos
            ORDER BY descripcion;`
            );
            res.render('reports/productos', { productos: rows });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }
    }
    catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

//Inventario por Almacen
router.get('/inventario', authenticateToken, async (req, res) => {
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

            const [rows] = await db.query(`
            SELECT A.nombre AS almacen, P.descripcion AS producto, PA.existencia AS existencia
            FROM Productos_Almacenes PA
            JOIN Almacenes A ON PA.id_almacen = A.id_almacen
            JOIN Productos P ON PA.cod_producto = P.cod_producto
            ORDER BY A.nombre, P.descripcion
        `);
            res.render('reports/inventario', { inventario: rows });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).send("Error interno del servidor");
    }
});

//Detalle de Venta Específica
router.get('/detalle-venta/:id', authenticateToken, async (req, res) => {
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

            const ventaId = req.params.id;
            const [rows] = await db.query(`
            SELECT VD.id_venta, P.descripcion, VD.cantidad, VD.sub_total
            FROM Ventas_Detalle VD
            JOIN Productos P ON VD.cod_producto = P.cod_producto
            WHERE VD.id_venta = ?
        `, [ventaId]);
            res.render('reports/detalle_venta', { detalle: rows, ventaId });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }

    } catch (error) {
        console.error(error);
        res.status(500).send("Error interno del servidor");
    }
});

//Total Ventas por Usuario
router.get('/ventas-usuarios', authenticateToken, async (req, res) => {
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

            const [rows] = await db.query(`
            SELECT U.usuario, COUNT(V.id_venta) AS total_ventas, SUM(V.total) AS monto_total
            FROM Ventas V
            JOIN Usuarios U ON V.cod_usuario = U.cod_usuario
            GROUP BY U.usuario
            ORDER BY monto_total DESC
        `);
            res.render('reports/ventas_usuarios', { ventasUsuarios: rows });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).send("Error interno del servidor");
    }
});

//Total Ventas por Almacen
router.get('/ventas-almacenes', authenticateToken, async (req, res) => {
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
            const [rows] = await db.query(`
            SELECT A.nombre AS almacen, COUNT(V.id_venta) AS total_ventas, SUM(V.total) AS monto_total
            FROM Ventas V
            JOIN Almacenes A ON V.id_almacen = A.id_almacen
            GROUP BY A.nombre
            ORDER BY monto_total DESC
        `);
            res.render('reports/ventas_almacenes', { ventasAlmacenes: rows });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).send("Error interno del servidor");
    }
});

//Usuarios Registrados
router.get('/usuarios', authenticateToken, async (req, res) => {
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
            const [rows] = await db.query(`
            SELECT usuario, role, DATE_FORMAT(fecha_creacion, "%d/%m/%y %H:%i:%s") as fecha_creacion FROM Usuarios
        `);
            res.render('reports/usuarios', { usuarios: rows });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).send("Error interno del servidor");
    }
});

//Consultar Existencia de Producto
router.get('/existencia/:codigo', authenticateToken, async (req, res) => {
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

            const codigoProducto = req.params.codigo;
            const [rows] = await db.query(`
            SELECT A.nombre AS almacen, PA.existencia AS stock
            FROM Productos_Almacenes PA
            JOIN Almacenes A ON PA.id_almacen = A.id_almacen
            WHERE PA.cod_producto = ?
        `, [codigoProducto]);
            res.render('reports/existencia', { existencia: rows, codigoProducto });
        } else {
            res
                .status(401)
                .json({ message: "No tiene permisos para ver los productos" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).send("Error interno del servidor");
    }
});

module.exports = router;