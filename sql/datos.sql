-- DML DATA INSERT SCRIPT FOR NEXSHOP GROUP S.A.
USE nexshop_db;

-- DATOS DE PRUEBA REALISTAS DE SEDES
INSERT INTO SEDES (nombre_sede, ciudad, tipo_sede) VALUES
('Sede Valencia Central', 'Valencia', 'Tienda y Almacén'),
('Sede Madrid Norte', 'Madrid', 'Tienda Física'),
('Sede Barcelona Puerto', 'Barcelona', 'Tienda y Almacén');

-- EMPLEADOS
INSERT INTO EMPLEADOS (dni, nombre, email_corporativo, fecha_incorporacion, id_sede) VALUES
('12345678A', 'Carlos García', 'cgarcia@nexshop.com', '2020-01-15', 1),
('87654321B', 'Ana Martínez', 'amartinez@nexshop.com', '2021-06-20', 2),
('45678912C', 'Luis Peralta', 'lperalta@nexshop.com', '2022-03-10', 3);

-- CLIENTES
INSERT INTO CLIENTES (nombre, apellidos, email, contraseña, fecha_nacimiento, saldo_puntos_actual) VALUES
('Juan', 'Pérez Gómez', 'juan.perez@email.com', 'clave123', '1990-05-12', 150),
('María', 'López Ruiz', 'maria.lopez@email.com', 'maria456', '1985-11-23', 340),
('Pedro', 'Sánchez Soler', 'pedro.sanchez@email.com', 'pedro789', '1995-07-04', 50);

-- DIRECCIONES
INSERT INTO DIRECCIONES_CLIENTES (calle, numero, piso, codigo_postal, ciudad, pais, id_cliente) VALUES
('Calle Mayor', '12', '2A', '46001', 'Valencia', 'España', 1),
('Avenida de la Constitución', '45', 'Bajo', '28002', 'Madrid', 'España', 2),
('Gran Via', '789', '4-1', '08007', 'Barcelona', 'España', 3);

-- CATEGORIAS Y SUBCATEGORIAS
INSERT INTO CATEGORIAS (nombre_categoria) VALUES ('Electrónica'), ('Hogar');
INSERT INTO SUBCATEGORIAS (nombre_subcategoria, id_categoria) VALUES 
('Smartphones', 1), 
('Televisores', 1),
('Electrodomésticos', 2);

-- PRODUCTOS
INSERT INTO PRODUCTOS (referencia, nombre_product, stock_actual, id_subcategoria) VALUES
('REF-SMART-01', 'Teléfono Smartphone Pro 128GB', 50, 1),
('REF-TV-4K-02', 'Televisor SmartTV 55 Pulgadas 4K', 20, 2),
('REF-CAFE-03', 'Cafetera Automática Express', 15, 3);

-- PROVEEDORES Y SUS PRECIOS DE COSTE
INSERT INTO PROVEEDORES (nombre, telefono) VALUES ('TechDistri S.A.', '963000111'), ('ElectroHogar S.L.', '915000222');
INSERT INTO PRODUCTOS_PROVEEDORES (id_producto, id_proveedor, precio_coste, plazo_entrega_dias) VALUES
(1, 1, 450.00, 3),
(2, 1, 299.00, 5),
(3, 2, 85.00, 2);

-- PROMOCIONES
INSERT INTO PROMOCIONES (descuento_porcentual, fecha_inicio, fecha_fin) VALUES
(10.00, '2026-06-01', '2026-06-30'),
(20.00, '2026-07-01', '2026-07-15');

INSERT INTO PRODUCTOS_PROMOCIONES (id_producto, id_promocion) VALUES (1, 1), (2, 2);

-- VALORACIONES
INSERT INTO VALORACIONES (id_cliente, id_producto, puntuacion, comentario, verificada, fecha_valoracion) VALUES
(1, 1, 5, 'Excelente teléfono, rápido y buena cámara.', 'SI', '2026-06-05'),
(2, 2, 4, 'Buena imagen aunque el sonido podría mejorar.', 'SI', '2026-06-06');

-- PEDIDOS ONLINE Y ENVIOS
INSERT INTO PEDIDOS_ONLINE (fecha_pedido, estado_pedido, total_pagado, id_cliente) VALUES
('2026-06-05 10:30:00', 'Entregado', 599.00, 1);

INSERT INTO LINEAS_PEDIDOS_ONLINE (cantidad, precio_unitario_aplicado, id_pedido, id_producto) VALUES
(1, 599.00, 1, 1);

INSERT INTO ENVIOS (numero_seguimiento, transportista, fecha_estimada_entrega, estado_envio, id_pedido, id_sede_origen) VALUES
('TRACK-998877', 'Seur Express', '2026-06-08', 'Entregado', 1, 1);

-- TICKETS FISICOS
INSERT INTO TICKETS_VENTA_FISICA (fecha_venta, total_ticket, id_sede, id_empleado) VALUES
('2026-06-06 17:15:00', 120.00, 2, 2);

INSERT INTO LINEAS_TICKET_FISICA (cantidad, precio_unitario_aplicado, id_ticket, id_producto) VALUES
(1, 120.00, 1, 3);

-- TICKETS DE INCIDENCIA
INSERT INTO TICKETS_INCIDENCIA (asunto, descripcion, fecha_apertura, estado, id_cliente, id_empleado_asignado) VALUES
('Duda con los puntos', 'El cliente no visualiza correctamente sus últimos 50 puntos acumulados.', '2026-06-07 09:00:00', 'Abierto', 1, 1);
