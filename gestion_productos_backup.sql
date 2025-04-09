-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: gestion_productos
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `almacenes`
--

DROP TABLE IF EXISTS `almacenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `almacenes` (
  `id_almacen` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  PRIMARY KEY (`id_almacen`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `almacenes`
--

LOCK TABLES `almacenes` WRITE;
/*!40000 ALTER TABLE `almacenes` DISABLE KEYS */;
INSERT INTO `almacenes` VALUES (1,'Almacen Central','Ciudad de Guatemala, Zona 1','1234-5678'),(2,'Almacen Norte','Zona Franca, Zona 18','9012-3456'),(3,'Almacen Sur','Escuintla, Zona Industrial','7890-1234'),(4,'Almacen Occidente','Quetzaltenango, Zona Comercial','4567-8901');
/*!40000 ALTER TABLE `almacenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `cod_producto` varchar(20) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `estado` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`cod_producto`),
  KEY `idx_cod_producto` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES ('P00001','Arroz Blanco',10.00,1),('P00002','Frijoles Negros',12.00,1),('P00003','Aceite Vegetal',25.00,1),('P00004','Azucar Blanca',8.00,1),('P00005','Cafe Instantaneo',30.00,1),('P00006','Tortillas de Maiz',5.00,1),('P00007','Pollo Entero',40.00,1),('P00008','Carne de Res Molida',60.00,1),('P00009','Mantequilla',20.00,1),('P00010','Queso Fresco',25.00,1),('P00011','Pan Blanco',12.00,1),('P00012','Galletas',18.00,1),('P00013','Jugo de Soja',35.00,1),('P00014','Leche Entera',15.00,1),('P00015','Yogur Natural',20.00,1),('P00016','Huevos Docena',10.00,1),('P00017','Cereal de Avena',22.00,1),('P00018','Harina de Trigo',18.00,1),('P00019','Pasta Seca',12.00,1),('P00020','Salsa de Soja',10.00,1),('P00021','Juego de naranaja',25.00,1);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos_almacenes`
--

DROP TABLE IF EXISTS `productos_almacenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos_almacenes` (
  `id_almacen` int NOT NULL,
  `cod_producto` varchar(20) NOT NULL,
  `existencia` int NOT NULL,
  PRIMARY KEY (`id_almacen`,`cod_producto`),
  KEY `cod_producto` (`cod_producto`),
  CONSTRAINT `productos_almacenes_ibfk_1` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes` (`id_almacen`),
  CONSTRAINT `productos_almacenes_ibfk_2` FOREIGN KEY (`cod_producto`) REFERENCES `productos` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos_almacenes`
--

LOCK TABLES `productos_almacenes` WRITE;
/*!40000 ALTER TABLE `productos_almacenes` DISABLE KEYS */;
INSERT INTO `productos_almacenes` VALUES (1,'P00001',50),(1,'P00002',30),(1,'P00006',100),(1,'P00010',60),(1,'P00014',110),(1,'P00018',150),(2,'P00003',20),(2,'P00007',50),(2,'P00011',80),(2,'P00015',130),(2,'P00019',160),(3,'P00004',40),(3,'P00008',30),(3,'P00012',70),(3,'P00016',120),(3,'P00020',170),(4,'P00005',60),(4,'P00009',40),(4,'P00013',90),(4,'P00017',140);
/*!40000 ALTER TABLE `productos_almacenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `reporteinventariogeneral`
--

DROP TABLE IF EXISTS `reporteinventariogeneral`;
/*!50001 DROP VIEW IF EXISTS `reporteinventariogeneral`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `reporteinventariogeneral` AS SELECT 
 1 AS `Codigo`,
 1 AS `Nombre`,
 1 AS `StockActual`,
 1 AS `PrecioUnitario`,
 1 AS `ValorTotal`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `cod_usuario` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('administrador','operador') NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cod_usuario`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'admin','3eb3fe66b31e3b4d10fa70b5cad49c7112294af6ae4e476a1c405155d45aa121','administrador','2025-04-09 03:10:26'),(2,'operador','97239946a68c3fe68a6f4f92084a915327a3ddfbf42ae597a4f1d8ff92f415c8','operador','2025-04-09 03:10:26');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `cod_usuario` int NOT NULL,
  `id_almacen` int NOT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `cod_usuario` (`cod_usuario`),
  KEY `id_almacen` (`id_almacen`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cod_usuario`) REFERENCES `usuarios` (`cod_usuario`),
  CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes` (`id_almacen`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (1,'2023-01-01',100.00,2,1);
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas_detalle`
--

DROP TABLE IF EXISTS `ventas_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas_detalle` (
  `id_venta` int NOT NULL,
  `cod_producto` varchar(20) NOT NULL,
  `cantidad` int NOT NULL,
  `sub_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_venta`,`cod_producto`),
  KEY `cod_producto` (`cod_producto`),
  CONSTRAINT `ventas_detalle_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`),
  CONSTRAINT `ventas_detalle_ibfk_2` FOREIGN KEY (`cod_producto`) REFERENCES `productos` (`cod_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas_detalle`
--

LOCK TABLES `ventas_detalle` WRITE;
/*!40000 ALTER TABLE `ventas_detalle` DISABLE KEYS */;
INSERT INTO `ventas_detalle` VALUES (1,'P00001',2,20.00),(1,'P00002',1,12.00);
/*!40000 ALTER TABLE `ventas_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `reporteinventariogeneral`
--

/*!50001 DROP VIEW IF EXISTS `reporteinventariogeneral`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `reporteinventariogeneral` AS select `p`.`cod_producto` AS `Codigo`,`p`.`descripcion` AS `Nombre`,coalesce(sum(`pa`.`existencia`),0) AS `StockActual`,`p`.`precio_unitario` AS `PrecioUnitario`,(coalesce(sum(`pa`.`existencia`),0) * `p`.`precio_unitario`) AS `ValorTotal` from (`productos` `p` left join `productos_almacenes` `pa` on((`p`.`cod_producto` = `pa`.`cod_producto`))) group by `p`.`cod_producto`,`p`.`descripcion`,`p`.`precio_unitario` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-08 21:36:16
