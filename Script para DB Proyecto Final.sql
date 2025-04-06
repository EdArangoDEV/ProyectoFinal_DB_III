-- ------   ***  CREACION DE BASE DE DATOS    *** --------

-- Crear la base de datos
CREATE DATABASE gestion_productos;

-- Usar la base de datos
USE gestion_productos;



-- Crear la tabla Almacenes
CREATE TABLE Almacenes (
    id_almacen INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

-- Crear la tabla Usuarios
CREATE TABLE Usuarios (
    cod_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('administrador', 'operador') NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla Productos
CREATE TABLE Productos (
    cod_producto VARCHAR(20) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(200) NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    estado BOOLEAN DEFAULT 1
);

-- Crear la tabla Ventas
CREATE TABLE Ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    cod_usuario INT NOT NULL,
    id_almacen INT NOT NULL,
    FOREIGN KEY (cod_usuario) REFERENCES Usuarios(cod_usuario),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen)
);

-- Crear la tabla Detalles de Ventas
CREATE TABLE Ventas_Detalle (
    id_venta INT NOT NULL,
    cod_producto VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_venta, cod_producto),
    cantidad INT NOT NULL,
    sub_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (cod_producto) REFERENCES Productos(cod_producto)
);

-- Crear la tabla Productos Almacenes
CREATE TABLE Productos_Almacenes (
    id_almacen INT NOT NULL,
    cod_producto VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_almacen, cod_producto),
    existencia INT NOT NULL,
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen),
    FOREIGN KEY (cod_producto) REFERENCES Productos(cod_producto)
);



-- ------  **  INSERTS EN TABLAS

INSERT INTO Usuarios (cod_usuario, usuario, password, role)
VALUES 
(1, 'admin', SHA2('Admin123!', 256), 'administrador'),
(2, 'operador', SHA2('Operador123!', 256),'operador');


INSERT INTO Almacenes (id_almacen, nombre, direccion, telefono)
VALUES
(1, 'Almacen Central', 'Ciudad de Guatemala, Zona 1', '1234-5678'),
(2, 'Almacen Norte', 'Zona Franca, Zona 18', '9012-3456'),
(3, 'Almacen Sur', 'Escuintla, Zona Industrial', '7890-1234'),
(4, 'Almacen Occidente', 'Quetzaltenango, Zona Comercial', '4567-8901');


INSERT INTO Productos (cod_producto, descripcion, precio_unitario, estado)
VALUES
('P00001', 'Arroz Blanco', 10.00, 1),
('P00002', 'Frijoles Negros', 12.00, 1),
('P00003', 'Aceite Vegetal', 25.00, 1),
('P00004', 'Azucar Blanca', 8.00, 1),
('P00005', 'Cafe Instantaneo', 30.00, 1),
('P00006', 'Tortillas de Maiz', 5.00, 1),
('P00007', 'Pollo Entero', 40.00, 1),
('P00008', 'Carne de Res Molida', 60.00, 1),
('P00009', 'Mantequilla', 20.00, 1),
('P00010', 'Queso Fresco', 25.00, 1),
('P00011', 'Pan Blanco', 12.00, 1),
('P00012', 'Galletas', 18.00, 1),
('P00013', 'Jugo de Soja', 35.00, 1),
('P00014', 'Leche Entera', 15.00, 1),
('P00015', 'Yogur Natural', 20.00, 1),
('P00016', 'Huevos Docena', 10.00, 1),
('P00017', 'Cereal de Avena', 22.00, 1),
('P00018', 'Harina de Trigo', 18.00, 1),
('P00019', 'Pasta Seca', 12.00, 1),
('P00020', 'Salsa de Soja', 10.00, 1);


INSERT INTO Ventas (id_venta, fecha, total, cod_usuario, id_almacen)
VALUES
(1, '2023-01-01', 100.00, 2, 1);


INSERT INTO Ventas_Detalle (id_venta, cod_producto, cantidad, sub_total)
VALUES
(1, 'P00001', 2, 20.00),
(1, 'P00002', 1, 12.00);


INSERT INTO Productos_Almacenes (id_almacen, cod_producto, existencia)
VALUES
(1, 'P00001', 50),
(1, 'P00002', 30),
(2, 'P00003', 20),
(3, 'P00004', 40),
(4, 'P00005', 60),
(1, 'P00006', 100),
(2, 'P00007', 50),
(3, 'P00008', 30),
(4, 'P00009', 40),
(1, 'P00010', 60),
(2, 'P00011', 80),
(3, 'P00012', 70),
(4, 'P00013', 90),
(1, 'P00014', 110),
(2, 'P00015', 130),
(3, 'P00016', 120),
(4, 'P00017', 140),
(1, 'P00018', 150),
(2, 'P00019', 160),
(3, 'P00020', 170);



-- --- ** INDICES

CREATE INDEX idx_cod_producto ON Productos (cod_producto);




-- ------ ** USUARIOS

-- CREAR USUARIO ADMIN
CREATE USER 'administrador'@'%' IDENTIFIED BY 'Admin123!';
GRANT ALL PRIVILEGES ON gestion_productos TO 'administrador'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- SI USUARIO administrador YA ESTA CREADO
SELECT User, Host FROM mysql.user WHERE User = 'administrador';
ALTER USER 'administrador'@'%' IDENTIFIED BY 'Admin123!';
FLUSH PRIVILEGES;

-- CREAR USUARIO OPERADOR
CREATE USER 'operador'@'%' IDENTIFIED BY 'Operador123!';
FLUSH PRIVILEGES;

-- SI USUARIO operador YA ESTA CREADO
SELECT User, Host FROM mysql.user WHERE User = 'operador';
ALTER USER 'operador'@'%' IDENTIFIED BY 'Operador123!';
FLUSH PRIVILEGES;

-- Permitir que el usuario operador ejecute los procedimientos InsertarVenta y InsertarDetalleVenta
GRANT EXECUTE ON PROCEDURE gestion_productos.InsertarVenta TO 'operador'@'%';
GRANT EXECUTE ON PROCEDURE gestion_productos.InsertarDetalleVenta TO 'operador'@'%';
GRANT SELECT ON gestion_productos.* TO 'operador'@'%';
GRANT SELECT ON gestion_productos.Ventas TO 'operador'@'%';
GRANT SELECT ON gestion_productos.Ventas_Detalle TO 'operador'@'%';
FLUSH PRIVILEGES;


-- Permitir que el usuario operador ejecute los procedimientos InsertarVenta y InsertarDetalleVenta
GRANT EXECUTE ON PROCEDURE gestion_productos.InsertarVenta TO 'operador'@'%';
GRANT EXECUTE ON PROCEDURE gestion_productos.InsertarDetalleVenta TO 'operador'@'%';
FLUSH PRIVILEGES;

-- Ver Grants para operador
SHOW GRANTS FOR 'operador'@'%';

-- VER USUARIOS CREADOS
USE mysql;
SELECT * FROM user;


-- verificar usuarios
USE gestion_productos;
-- SELECT * FROM Usuarios;



-- ------ ** FUNCIONES

-- FUNCION PARA OBTENER CODIGO DE USUARIO
DROP FUNCTION  IF EXISTS ObtenerCodigoUsuarioActual;

DELIMITER //
CREATE FUNCTION ObtenerCodigoUsuarioActual()
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE usuarioActual VARCHAR(50);
    DECLARE cod_usuario_actual INT;

    SET usuarioActual = SUBSTRING_INDEX(USER(), '@', 1);
    SET cod_usuario_actual = (SELECT cod_usuario FROM Usuarios WHERE nombre = usuarioActual);

    IF cod_usuario_actual IS NULL THEN
        RETURN CONCAT('El usuario ', usuarioActual, ' no existe en la tabla Usuarios');
    ELSE
        RETURN CAST(cod_usuario_actual AS CHAR);
    END IF;
END//
DELIMITER ;

-- SELECT ObtenerCodigoUsuarioActual();


--  FUNCION VERIFICAR PRODUCTO
DROP FUNCTION IF EXISTS VerificarProducto;

DELIMITER //
CREATE FUNCTION VerificarProducto(
    p_cod_producto VARCHAR(20)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN EXISTS (SELECT 1 FROM Productos WHERE cod_producto = p_cod_producto);
END//
DELIMITER ;

-- SELECT  VerificarProducto('P00001'); 



-- PARA CALCULAR SUBTOTAL
DROP FUNCTION IF EXISTS CalcularSubtotal;

DELIMITER //
CREATE FUNCTION CalcularSubtotal(
    p_cod_producto VARCHAR(20),
    p_cantidad INT
)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE precio_u DECIMAL(10, 2);
    
    -- Verificar existencia del producto
    IF NOT EXISTS (SELECT cod_producto FROM Productos WHERE cod_producto = p_cod_producto) THEN
        RETURN NULL;
    END IF;
    
    -- Obtener precio del producto
    SELECT precio_unitario INTO precio_u
    FROM Productos
    WHERE cod_producto = p_cod_producto;

    -- Calcular subtotal
    RETURN p_cantidad * precio_u;
END//
DELIMITER ;

-- SELECT CalcularSubtotal('P00001', 10);






-- ------  ** PROCEDIMIENTOS 

-- SP-1 Agregar Producto 
DROP PROCEDURE IF EXISTS AgregarProducto;
DELIMITER //
CREATE PROCEDURE AgregarProducto(
    IN p_descripcion VARCHAR(200),
    IN p_precio_unitario DECIMAL(10, 2),
    IN p_estado BOOLEAN
)
BEGIN
    DECLARE nuevo_codigo VARCHAR(20);
    DECLARE cantidad INT;
    
    -- Generar código correlativo
    SELECT IFNULL(MAX(SUBSTR(cod_producto, 2)), 0) + 1 INTO @numero
    FROM Productos;
    SET nuevo_codigo = CONCAT('P', LPAD(@numero, 5, '0')); -- Formato P00001
    
    -- Verificar existencia del código generado
    SELECT COUNT(*) INTO cantidad
    FROM Productos
    WHERE cod_producto = nuevo_codigo;

    IF cantidad > 0 THEN
        SELECT CONCAT('Error: Código ', nuevo_codigo, ' ya existe') AS mensaje;
    ELSE
        INSERT INTO Productos (cod_producto, descripcion, precio_unitario, estado)
        VALUES (nuevo_codigo, p_descripcion, p_precio_unitario, p_estado);

        SELECT CONCAT('Producto agregado') AS mensaje, nuevo_codigo AS cod_producto;
    END IF;
END//
DELIMITER ;

-- CALL AgregarProducto('Juego de naranaja', 25.00, 1);



-- SP-2 ActualizarProducto Modificado
DROP PROCEDURE IF EXISTS ActualizarProducto;
DELIMITER //
CREATE PROCEDURE ActualizarProducto(
    IN p_cod_producto VARCHAR(20),
    IN p_descripcion VARCHAR(200),
    IN p_precio_unitario DECIMAL(10, 2),
    IN p_estado BOOLEAN
)
BEGIN
    IF EXISTS (SELECT 1 FROM Productos WHERE cod_producto = p_cod_producto) THEN
        UPDATE Productos
        SET descripcion = p_descripcion,
            precio_unitario = p_precio_unitario,
            estado = p_estado
        WHERE cod_producto = p_cod_producto;

        -- Devuelve dos columnas: mensaje y cod_producto
        SELECT 
            'Producto actualizado correctamente' AS mensaje,
            p_cod_producto AS cod_producto;
    ELSE
        SELECT 
            'El producto no existe' AS mensaje,
            NULL AS cod_producto;
    END IF;
END//
DELIMITER ;



-- CALL ActualizarProducto('P00021', 'Jugo de naranaja', 20.00, 0);



-- SP-3 EliminarProducto
DROP PROCEDURE IF EXISTS EliminarProducto;
DELIMITER //
CREATE PROCEDURE EliminarProducto(
    IN p_cod_producto VARCHAR(20)
)
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad
    FROM Productos
    WHERE cod_producto = p_cod_producto;

    IF cantidad > 0 THEN
        -- Eliminar registros relacionados en Ventas_Detalle
        DELETE FROM Ventas_Detalle
        WHERE cod_producto = p_cod_producto;

        -- Eliminar registros relacionados en Productos_Almacenes
        DELETE FROM Productos_Almacenes
        WHERE cod_producto = p_cod_producto;

        -- Eliminar el producto
        DELETE FROM Productos
        WHERE cod_producto = p_cod_producto;

        SELECT 'Producto eliminado correctamente' AS mensaje;
    ELSE
        SELECT 'El producto no existe' AS mensaje;
    END IF;
END//
DELIMITER ;

-- CALL EliminarProducto('P00021');




-------  ***  GESTION DE INVENTARIO

-- SP-4 AgregarProductoAlmacen
DROP PROCEDURE IF EXISTS AgregarProductoAlmacen;

DELIMITER //
CREATE PROCEDURE AgregarProductoAlmacen(
    IN p_id_almacen INT,
    IN p_cod_producto VARCHAR(20),
    IN p_existencia INT
)
BEGIN
    DECLARE cantidad_almacen INT;
    DECLARE cantidad_producto INT;
    
    SELECT COUNT(*) INTO cantidad_almacen
    FROM Almacenes
    WHERE id_almacen = p_id_almacen;

    SELECT COUNT(*) INTO cantidad_producto
    FROM Productos
    WHERE cod_producto = p_cod_producto;

    IF cantidad_almacen > 0 AND cantidad_producto > 0 THEN
        IF NOT EXISTS (SELECT 1 FROM Productos_Almacenes WHERE id_almacen = p_id_almacen AND cod_producto = p_cod_producto) THEN
            INSERT INTO Productos_Almacenes (id_almacen, cod_producto, existencia)
            VALUES (p_id_almacen, p_cod_producto, p_existencia);

            SELECT CONCAT('Producto ', p_cod_producto, ' agregado al almacén con Id:', p_id_almacen, ' correctamente') AS mensaje;
        ELSE
            SELECT CONCAT('El producto ', p_cod_producto, ' ya existe en el almacén con Id: ', p_id_almacen) AS mensaje;
        END IF;
    ELSE
        IF cantidad_almacen = 0 THEN
            SELECT CONCAT('El almacén con Id: ', p_id_almacen, ' no existe') AS mensaje;
        ELSEIF cantidad_producto = 0 THEN
            SELECT CONCAT('El producto con código ', p_cod_producto, ' no existe') AS mensaje;
        END IF;
    END IF;
END//
DELIMITER ;

-- CALL AgregarProductoAlmacen(1, 'P00020', 5);




-- SP-5 ExistenciaProducto
DROP PROCEDURE IF EXISTS ExistenciaProducto;
DELIMITER //
CREATE PROCEDURE ExistenciaProducto(
    IN p_id_almacen INT,
    IN p_cod_producto VARCHAR(20),
    IN p_nueva_existencia INT
)
BEGIN
    DECLARE cantidad_almacen INT;
    DECLARE cantidad_producto INT;
    
    SELECT COUNT(*) INTO cantidad_almacen
    FROM Almacenes
    WHERE id_almacen = p_id_almacen;

    SELECT COUNT(*) INTO cantidad_producto
    FROM Productos
    WHERE cod_producto = p_cod_producto;

    IF cantidad_almacen > 0 AND cantidad_producto > 0 THEN
        IF EXISTS (SELECT 1 FROM Productos_Almacenes WHERE id_almacen = p_id_almacen AND cod_producto = p_cod_producto) THEN
            UPDATE Productos_Almacenes
            SET existencia = p_nueva_existencia
            WHERE id_almacen = p_id_almacen AND cod_producto = p_cod_producto;

            SELECT CONCAT('Existencia del producto ', p_cod_producto, ' en el almacén ', p_id_almacen, ' actualizada correctamente') AS mensaje;
        ELSE
            SELECT CONCAT('El producto ', p_cod_producto, ' no existe en el almacén ', p_id_almacen) AS mensaje;
        END IF;
    ELSE
        IF cantidad_almacen = 0 THEN
            SELECT CONCAT('El almacén con ID ', p_id_almacen, ' no existe') AS mensaje;
        ELSEIF cantidad_producto = 0 THEN
            SELECT CONCAT('El producto con código ', p_cod_producto, ' no existe') AS mensaje;
        END IF;
    END IF;
END//
DELIMITER ;

-- CALL ExistenciaProducto(1, 'P00020', 5);



-- Se acutlizo 04042025
-- SP-6 InsertarVenta
DROP PROCEDURE IF EXISTS InsertarVenta;
DELIMITER //
CREATE PROCEDURE InsertarVenta(
    IN p_id_almacen INT,
    IN p_cod_usuario INT
)
BEGIN
    DECLARE id_venta_insertada INT;
    DECLARE fecha_actual DATE;

    -- Obtener fecha actual
    SET fecha_actual = CURDATE();

    -- Insertar la venta con fecha actual y total inicial en 0
    INSERT INTO Ventas (fecha, total, cod_usuario, id_almacen)
    VALUES (fecha_actual, 0, p_cod_usuario, p_id_almacen);

    -- Obtener el ID de la venta recién insertada
    SET id_venta_insertada = LAST_INSERT_ID();

    SELECT id_venta_insertada AS id_venta;
END//
DELIMITER ;


-- CALL InsertarVenta(1);



-- SP-7 InsertarDetalleVenta

DROP PROCEDURE IF EXISTS InsertarDetalleVenta;
DELIMITER //
CREATE PROCEDURE InsertarDetalleVenta(
    IN p_id_venta INT,
    IN p_cod_usuario INT,
    IN p_cod_producto VARCHAR(20),
    IN p_cantidad INT
)
BEGIN
    DECLARE id_venta_actual INT;
    DECLARE prodValido BOOLEAN;
    DECLARE existencia_actual INT;
    DECLARE sub_total DECIMAL(10, 2);
    DECLARE fecha_actual DATE;
    DECLARE id_almacen_actual INT;

    -- Obtener la fecha actual
    SET fecha_actual = CURDATE();

    -- Obtener el ID de la venta más reciente del usuario para el día actual
    SET id_venta_actual = (SELECT id_venta
                           FROM Ventas
                           WHERE cod_usuario = p_cod_usuario
                           AND DATE(fecha) = fecha_actual
                           ORDER BY id_venta DESC LIMIT 1);

    -- Verificar si el ID de venta es exactamente el último
    IF p_id_venta = id_venta_actual THEN
        SET prodValido =  VerificarProducto(p_cod_producto); 
        IF prodValido = 1 THEN
            -- Obtener el ID del almacén de la venta actual
            SET id_almacen_actual = (SELECT id_almacen FROM Ventas WHERE id_venta = p_id_venta);

            -- Verificar si el producto está en el almacén
            IF EXISTS (SELECT 1 FROM Productos_Almacenes WHERE id_almacen = id_almacen_actual AND cod_producto = p_cod_producto) THEN
                -- Obtener la existencia actual del producto
                SET existencia_actual = (SELECT existencia FROM Productos_Almacenes
                                         WHERE id_almacen = id_almacen_actual
                                         AND cod_producto = p_cod_producto);

                IF existencia_actual >= p_cantidad THEN
                    SET sub_total = CalcularSubtotal(p_cod_producto, p_cantidad);
                    
                    -- Insertar el detalle de la venta en la tabla Ventas_Detalle
                    INSERT INTO Ventas_Detalle (id_venta, cod_producto, cantidad, sub_total)
                    VALUES (p_id_venta, p_cod_producto, p_cantidad, sub_total);

                    -- Actualizar el total de la venta
                    UPDATE Ventas
                    SET total = total + sub_total
                    WHERE id_venta = p_id_venta;

                    SELECT 'Detalle de venta insertado correctamente' AS mensaje;
                ELSE
                    SELECT 'No hay suficientes existencias del producto' AS mensaje;
                END IF;
            ELSE
                SELECT CONCAT('El producto ', p_cod_producto, ' no está disponible en el almacén.') AS mensaje;
            END IF;
        ELSE
            SELECT CONCAT('El producto ', p_cod_producto, ' no existe.') AS mensaje;
        END IF;    
    ELSE
        SELECT 'No se puede insertar detalles para una venta diferente a la última del día actual' AS mensaje;
    END IF;
END//
DELIMITER ;


-- CALL InsertarDetalleVenta(1, 2, 'P00018', 2);



-- SP-8 VerificarDuplicidadProductos
DROP PROCEDURE IF EXISTS VerificarDuplicidadProductos;

DELIMITER //
CREATE PROCEDURE VerificarDuplicidadProductos()
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad
    FROM (
        SELECT descripcion
        FROM Productos
        GROUP BY descripcion
        HAVING COUNT(*) > 1
    ) AS duplicados;

    IF cantidad > 0 THEN
        SELECT cod_producto, descripcion, COUNT(*) AS cantidad
        FROM Productos
        GROUP BY descripcion
        HAVING COUNT(*) > 1;
    ELSE
        SELECT 'No hay productos duplicados' AS mensaje;
    END IF;
END//
DELIMITER ;

-- CALL VerificarDuplicidadProductos;




-- SP-9 BuscarProductoPorCodigo
DELIMITER //
CREATE PROCEDURE BuscarProductoPorCodigo(
    IN p_cod_producto VARCHAR(20)
)
BEGIN
    SELECT * FROM Productos
    WHERE cod_producto = p_cod_producto;
END//
DELIMITER ;

-- CALL BuscarProductoPorCodigo('P00001');




-- ------  ** TRIGGERS

-- T-1 ActualizarExistencias
DROP TRIGGER IF EXISTS ActualizarExistencias;
DELIMITER //
CREATE TRIGGER ActualizarExistencias
AFTER INSERT ON Ventas_Detalle
FOR EACH ROW
BEGIN
    UPDATE Productos_Almacenes
    SET existencia = existencia - NEW.cantidad
    WHERE id_almacen = (SELECT id_almacen FROM Ventas WHERE id_venta = NEW.id_venta)
    AND cod_producto = NEW.cod_producto;
END//
DELIMITER ;




-- VISTA PARA REPORTE GENERAL
CREATE VIEW ReporteInventarioGeneral AS
SELECT 
    P.cod_producto AS Codigo,
    P.descripcion AS Nombre,
    COALESCE(SUM(PA.existencia), 0) AS StockActual,
    P.precio_unitario AS PrecioUnitario,
    COALESCE(SUM(PA.existencia), 0) * P.precio_unitario AS ValorTotal
FROM Productos P
LEFT JOIN Productos_Almacenes PA 
ON P.cod_producto = PA.cod_producto
GROUP BY 
    P.cod_producto, P.descripcion, P.precio_unitario;



-- ------  ** REPORTES GENERALES


-- REPORTE PRODUCTOS DISPONIBLES
SELECT cod_producto, descripcion, precio_unitario, 
       CASE WHEN estado = 1 THEN 'Activo' ELSE 'Inactivo' END AS estado
FROM Productos
ORDER BY descripcion;


-- INVENTARIO POR ALMACEN
SELECT A.nombre AS almacen, P.descripcion AS producto, PA.existencia AS stock
FROM Productos_Almacenes PA
JOIN Almacenes A ON PA.id_almacen = A.id_almacen
JOIN Productos P ON PA.cod_producto = P.cod_producto
ORDER BY A.nombre, P.descripcion;


-- DETALLE DE VENTA ESPECIFICA 
SELECT VD.id_venta, P.descripcion, VD.cantidad, VD.sub_total
FROM Ventas_Detalle VD
JOIN Productos P ON VD.cod_producto = P.cod_producto
WHERE VD.id_venta = 1;


-- TOTAL VENTAS POR USUARIO
SELECT U.usuario, COUNT(V.id_venta) AS total_ventas, SUM(V.total) AS monto_total
FROM Ventas V
JOIN Usuarios U ON V.cod_usuario = U.cod_usuario
GROUP BY U.usuario
ORDER BY monto_total DESC;


-- TOTAL VENTAS POR ALMACEN
SELECT A.nombre AS almacen, COUNT(V.id_venta) AS total_ventas, SUM(V.total) AS monto_total
FROM Ventas V
JOIN Almacenes A ON V.id_almacen = A.id_almacen
GROUP BY A.nombre
ORDER BY monto_total DESC;


-- USUARIOS REGISTRADOS Y ROL
SELECT usuario, role, fecha_creacion 
FROM Usuarios;


-- CONSULTAR EXISTENCIA DE PRODUCTO
SELECT A.nombre AS almacen, PA.existencia AS stock
FROM Productos_Almacenes PA
JOIN Almacenes A ON PA.id_almacen = A.id_almacen
WHERE PA.cod_producto = 'P00001';