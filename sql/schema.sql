-- CREATE SCHEMA SCRIPT FOR NEXSHOP GROUP S.A.
CREATE DATABASE IF NOT EXISTS nexshop_db;
USE nexshop_db;

-- 1. SEDES Y EMPLEADOS
CREATE TABLE SEDES (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    tipo_sede VARCHAR(50) NOT NULL
);

CREATE TABLE EMPLEADOS (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    email_corporativo VARCHAR(100) NOT NULL UNIQUE,
    fecha_incorporacion DATE NOT NULL,
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES SEDES(id_sede) ON DELETE SET NULL
);

-- 2. CLIENTES, DIRECCIONES Y PUNTOS
CREATE TABLE CLIENTES (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    saldo_puntos_actual INT DEFAULT 0
);

CREATE TABLE DIRECCIONES_CLIENTES (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    calle VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    piso VARCHAR(10),
    codigo_postal VARCHAR(10) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE
);

CREATE TABLE MOVIMIENTOS_PUNTOS (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    cantidad_puntos INT NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,
    fecha_movimiento DATETIME NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE
);

-- 3. PRODUCTOS Y CATEGORIAS
CREATE TABLE CATEGORIAS (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE SUBCATEGORIAS (
    id_subcategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_subcategoria VARCHAR(100) NOT NULL,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria) ON DELETE CASCADE
);

CREATE TABLE PRODUCTOS (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    referencia VARCHAR(50) NOT NULL UNIQUE,
    nombre_product VARCHAR(150) NOT NULL,
    stock_actual INT DEFAULT 0,
    id_subcategoria INT,
    FOREIGN KEY (id_subcategoria) REFERENCES SUBCATEGORIAS(id_subcategoria) ON DELETE SET NULL
);

-- 4. TRANSFERENCIAS, PROVEEDORES Y PROMOCIONES
CREATE TABLE PROVEEDORES (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE PRODUCTOS_PROVEEDORES (
    id_producto INT,
    id_proveedor INT,
    precio_coste DECIMAL(10,2) NOT NULL,
    plazo_entrega_dias INT NOT NULL,
    PRIMARY KEY (id_producto, id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor) ON DELETE CASCADE
);

CREATE TABLE PROMOCIONES (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    descuento_porcentual DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

CREATE TABLE PRODUCTOS_PROMOCIONES (
    id_producto INT,
    id_promocion INT,
    PRIMARY KEY (id_producto, id_promocion),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_promocion) REFERENCES PROMOCIONES(id_promocion) ON DELETE CASCADE
);

CREATE TABLE TRANSFERENCIAS_STOCK (
    id_transferencia INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    cantidad INT NOT NULL,
    id_sede_origen INT,
    id_sede_destino INT,
    id_empleado_autoriza INT,
    id_producto INT,
    FOREIGN KEY (id_sede_origen) REFERENCES SEDES(id_sede),
    FOREIGN KEY (id_sede_destino) REFERENCES SEDES(id_sede),
    FOREIGN KEY (id_empleado_autoriza) REFERENCES EMPLEADOS(id_empleado),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto)
);

CREATE TABLE VALORACIONES (
    id_cliente INT,
    id_producto INT,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    verificada VARCHAR(2) DEFAULT 'NO',
    fecha_valoracion DATE NOT NULL,
    PRIMARY KEY (id_cliente, id_producto),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto) ON DELETE CASCADE
);

-- 5. PEDIDOS ONLINE Y ENVIOS
CREATE TABLE PEDIDOS_ONLINE (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pedido DATETIME NOT NULL,
    estado_pedido VARCHAR(30) NOT NULL,
    total_pagado DECIMAL(10,2) NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente) ON DELETE SET NULL
);

CREATE TABLE LINEAS_PEDIDOS_ONLINE (
    id_linea_pedido INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario_aplicado DECIMAL(10,2) NOT NULL,
    id_pedido INT,
    id_producto INT,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS_ONLINE(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto) ON DELETE SET NULL
);

CREATE TABLE ENVIOS (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    numero_seguimiento VARCHAR(100) NOT NULL UNIQUE,
    transportista VARCHAR(50) NOT NULL,
    fecha_estimada_entrega DATE NOT NULL,
    estado_envio VARCHAR(30) NOT NULL,
    id_pedido INT,
    id_sede_origen INT,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS_ONLINE(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_sede_origen) REFERENCES SEDES(id_sede) ON DELETE SET NULL
);

-- 6. TICKETS FISICOS
CREATE TABLE TICKETS_VENTA_FISICA (
    id_ticket INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATETIME NOT NULL,
    total_ticket DECIMAL(10,2) NOT NULL,
    id_sede INT,
    id_empleado INT,
    FOREIGN KEY (id_sede) REFERENCES SEDES(id_sede),
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADOS(id_empleado)
);

CREATE TABLE LINEAS_TICKET_FISICA (
    id_linea_ticket INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario_aplicado DECIMAL(10,2) NOT NULL,
    id_ticket INT,
    id_producto INT,
    FOREIGN KEY (id_ticket) REFERENCES TICKETS_VENTA_FISICA(id_ticket) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto) ON DELETE SET NULL
);

-- 7. INCIDENCIAS
CREATE TABLE TICKETS_INCIDENCIA (
    id_ticket INT AUTO_INCREMENT PRIMARY KEY,
    asunto VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_apertura DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL,
    fecha_cierre DATETIME,
    resolucion TEXT,
    id_cliente INT,
    id_empleado_asignado INT,
    id_pedido_online INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_empleado_asignado) REFERENCES EMPLEADOS(id_empleado) ON DELETE SET NULL,
    FOREIGN KEY (id_pedido_online) REFERENCES PEDIDOS_ONLINE(id_pedido) ON DELETE SET NULL
);
