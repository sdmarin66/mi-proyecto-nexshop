-- ============================================================ --
FASE 5: CONSULTAS DE EXPLOTACIÓN DE LA BASE DE DATOS (consultas.sql)
-- ============================================================
USE nexshop_db;
-- 1. Listar todos los productos del catálogo con su subcategoría correspondiente
SELECT P.id_producto, P.referencia, P.nombre_producto, P.pvp_actual,
S.nombre_subcategoria FROM PRODUCTOS P JOIN SUBCATEGORIAS S ON
P.id_subcategoria = S.id_subcategoria;
-- 2. Mostrar los empleados y el nombre de la sede o tienda en la que trabajan
SELECT E.id_empleado, E.nombre, E.email_corporativo, S.nombre_sede, S.ciudad
FROM EMPLEADOS E JOIN SEDES S ON E.id_sede = S.id_sede;
-- 3. Consultar el stock disponible de cada producto detallando en qué sede física se
encuentra SELECT P.nombre_producto, S.nombre_sede, ST.cantidad_disponible
FROM STOCKS ST JOIN PRODUCTOS P ON ST.id_producto = P.id_producto
JOIN SEDES S ON ST.id_sede = S.id_sede ORDER BY P.nombre_producto;
-- 4. Obtener todos los pedidos online realizados junto con el nombre del cliente y su
ciudad de entrega SELECT P.id_pedido, P.fecha_pedido, P.total_pagado,
P.estado_pedido, C.nombre, D.ciudad FROM PEDIDOS_ONLINE P JOIN
CLIENTES C ON P.id_cliente = C.id_cliente JOIN DIRECCIONES_CLIENTE D ON
P.id_direccion_entrega = D.id_direccion;
-- 5. Listar el desglose de artículos (líneas de pedido) comprados en el pedido online
número 2 SELECT L.id_linea_pedido, P.nombre_producto, L.cantidad,
L.precio_unitario_aplicado, (L.cantidad * L.precio_unitario_aplicado) AS subtotal
FROM LINEAS_PEDIDO_ONLINE L JOIN PRODUCTOS P ON L.id_producto =
P.id_producto WHERE L.id_pedido = 2;
-- 6. Ver el historial de todos los envíos realizados, indicando la empresa
transportista y el número de pedido SELECT E.id_envio, E.numero_seguimiento,
E.transportista, E.estado_envio, E.id_pedido, S.nombre_sede AS origen_stock
FROM ENVIOS E JOIN SEDES S ON E.id_sede_origen = S.id_sede;
-- 7. Mostrar el registro completo de movimientos de puntos de fidelización de los
clientes SELECT M.id_movimiento, C.nombre, C.apellidos, M.cantidad_puntos,
M.tipo_movimiento, M.fecha_movimiento FROM MOVIMIENTOS_PUNTOS M JOIN
CLIENTES C ON M.id_cliente = C.id_cliente;
-- 8. Consultar las ventas físicas (tickets de tienda) detallando qué empleado hizo la
venta y en qué tienda SELECT T.id_ticket, T.fecha_venta, T.total_ticket,
S.nombre_sede, E.nombre AS nombre_empleado FROM TICKETS_VENTA_FISICA
T JOIN SEDES S ON T.id_sede_tienda = S.id_sede JOIN EMPLEADOS E ON
T.id_empleado_vendedor = E.id_empleado;
-- 9. Listar el desglose de productos vendidos de forma presencial en el ticket de
tienda número 1 SELECT L.id_linea_ticket, P.nombre_producto, L.cantidad,
L.precio_unitario_aplicado FROM LINEAS_TICKET_FISICA L JOIN PRODUCTOS
P ON L.id_producto = P.id_producto WHERE L.id_ticket = 1;
-- 10. Calcular el dinero total que ha ingresado la empresa sumando pedidos online
y ventas físicas SELECT (SELECT IFNULL(SUM(total_pagado), 0) FROM
PEDIDOS_ONLINE WHERE estado_pedido != 'Cancelado') AS ingresos_online,
(SELECT IFNULL(SUM(total_ticket), 0) FROM TICKETS_VENTA_FISICA) AS
ingresos_tiendas_fisicas, ((SELECT IFNULL(SUM(total_pagado), 0) FROM
PEDIDOS_ONLINE WHERE estado_pedido != 'Cancelado') + (SELECT
IFNULL(SUM(total_ticket), 0) FROM TICKETS_VENTA_FISICA)) AS
ingresos_totales_empresa;
-- 11. Encontrar qué productos tienen un stock crítico (menos de 10 unidades) en las
tiendas físicas SELECT P.nombre_producto, S.nombre_sede,
ST.cantidad_disponible FROM STOCKS ST JOIN PRODUCTOS P ON
ST.id_producto = P.id_producto JOIN SEDES S ON ST.id_sede = S.id_sede
WHERE ST.cantidad_disponible < 10 AND S.tipo_sede = 'Tienda';
-- 12. Mostrar los clientes ordenados de mayor a menor según el saldo de puntos
acumulados que poseen SELECT id_cliente, nombre, apellidos, email,
saldo_puntos_actual FROM CLIENTES ORDER BY saldo_puntos_actual DESC;
-- 13. Agrupar las ventas físicas para saber cuánto dinero ha recaudado cada una
de las tiendas independientes SELECT S.nombre_sede, S.ciudad,
IFNULL(SUM(T.total_ticket), 0) AS total_recaudado FROM SEDES S LEFT JOIN
TICKETS_VENTA_FISICA T ON S.id_sede = T.id_sede_tienda WHERE
S.tipo_sede = 'Tienda' GROUP BY S.id_sede;
-- 14. Buscar productos tecnológicos que tengan un precio superior a 1000 euros en
el catálogo SELECT P.id_producto, P.nombre_producto, P.pvp_actual,
C.nombre_categoria FROM PRODUCTOS P JOIN SUBCATEGORIAS S ON
P.id_subcategoria = S.id_subcategoria JOIN CATEGORIAS C ON S.id_categoria =
C.id_categoria WHERE P.pvp_actual > 1000.00 AND C.nombre_categoria =
'Tecnologia';