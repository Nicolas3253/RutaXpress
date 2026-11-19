-- Tablas
CREATE TABLE rol (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    rol_id INT NOT NULL REFERENCES rol(id),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL REFERENCES usuarios(id),
    via VARCHAR(20) NOT NULL CHECK (via IN ('Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal')),
    numero_via VARCHAR(10) NOT NULL,
    placa VARCHAR(15) NOT NULL,
    barrio VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL
);

CREATE TABLE transportistas (
    id SERIAL PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL REFERENCES usuarios(id),
    tipo_vehiculo VARCHAR(30) NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE envios (
    id SERIAL PRIMARY KEY,
    codigo_rastreo VARCHAR(20) UNIQUE NOT NULL,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    transportista_id INT REFERENCES transportistas(id),
    origen_via VARCHAR(20) NOT NULL CHECK (origen_via IN ('Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal')),
    origen_numero VARCHAR(20) NOT NULL,
    origen_barrio VARCHAR(50) NOT NULL,
    destino_via VARCHAR(20) NOT NULL CHECK (destino_via IN ('Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal')),
    destino_numero VARCHAR(20) NOT NULL,
    destino_barrio VARCHAR(50) NOT NULL,
    peso_kg DECIMAL(5,2) NOT NULL CHECK (peso_kg > 0),
    costo DECIMAL(10,2) NOT NULL CHECK (costo >= 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'en_camino', 'entregado', 'cancelado')),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historial_ubicaciones_envio (
    id SERIAL PRIMARY KEY,
    envio_id INT NOT NULL REFERENCES envios(id),
    transportista_id INT NOT NULL REFERENCES transportistas(id),
    latitud DECIMAL(10, 8) NOT NULL,
    longitud DECIMAL(11, 8) NOT NULL,
    estado_reportado VARCHAR(30) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



-- Insert de datos
INSERT INTO rol (nombre) VALUES
('ADMINISTRADOR'),
('REPARTIDOR'),
('CLIENTE');

INSERT INTO usuarios (nombre, apellido, email, password_hash, telefono, rol_id) VALUES
('Carlos', 'Mendoza', 'carlos.mendoza@email.com', '$2b$10$hash_demo_01', '3151234567', 3),
('Diana', 'Gómez', 'diana.gomez@email.com', '$2b$10$hash_demo_02', '3109876543', 3),
('Andrés', 'Silva', 'andres.silva@email.com', '$2b$10$hash_demo_03', '3124567890', 3),
('Beatriz', 'Rincón', 'beatriz.rincon@email.com', '$2b$10$hash_demo_04', '3187654321', 3),
('Camilo', 'Suárez', 'camilo.suarez@email.com', '$2b$10$hash_demo_05', '3001122334', 3),
('Javier', 'Hernández', 'javier.h@transpor.com', '$2b$10$hash_demo_06', '3189998877', 2),
('Mateo', 'Pérez', 'mateo.perez@transpor.com', '$2b$10$hash_demo_07', '3012223344', 2),
('Luisa', 'Torres', 'luisa.torres@transpor.com', '$2b$10$hash_demo_08', '3165554433', 2),
('Jorge', 'Ramírez', 'jorge.ramirez@transpor.com', '$2b$10$hash_demo_09', '3208887766', 2),
('Sofía', 'Vargas', 'sofia.admin@rutaexpress.com', '$2b$10$hash_demo_10', '3114445566', 1);

INSERT INTO clientes (usuario_id, via, numero_via, placa, barrio, ciudad) VALUES
(1, 'Calle', '36', '# 15-23', 'Centro', 'Bucaramanga'),
(2, 'Carrera', '27', '# 45-10', 'Sotomayor', 'Bucaramanga'),
(3, 'Calle', '105', '# 24-50', 'Provenza', 'Bucaramanga'),
(4, 'Carrera', '12', '# 8-30', 'Cañaveral', 'Floridablanca'),
(5, 'Calle', '6', '# 4-12', 'Centro', 'Piedecuesta');

INSERT INTO transportistas (usuario_id, tipo_vehiculo, placa, disponible) VALUES
(6, 'Moto', 'XYZ123', TRUE),
(7, 'Carro', 'JKL789', TRUE),
(8, 'Moto', 'ABC456', FALSE),
(9, 'Camioneta', 'MNO321', TRUE);

INSERT INTO envios (
    codigo_rastreo, cliente_id, transportista_id,
    origen_via, origen_numero, origen_barrio,
    destino_via, destino_numero, destino_barrio,
    peso_kg, costo, estado
) VALUES
('RTX-001', 1, 1, 'Calle', '36 # 15-23', 'Centro', 'Carrera', '27 # 45-10', 'Sotomayor', 2.50, 8500.00, 'en_camino'),
('RTX-002', 2, 2, 'Calle', '105 # 24-50', 'Provenza', 'Carrera', '12 # 8-30', 'Cañaveral', 5.00, 12000.00, 'entregado'),
('RTX-003', 1, NULL, 'Carrera', '25 # 52-11', 'Cabecera', 'Calle', '6 # 4-12', 'Centro', 1.20, 15000.00, 'pendiente'),
('RTX-004', 3, 3, 'Carrera', '15 # 33-10', 'Alarcón', 'Calle', '45 # 28-05', 'Tejar', 0.80, 7000.00, 'entregado'),
('RTX-005', 4, 4, 'Avenida', '200 # 12-04', 'Cañaveral', 'Calle', '36 # 15-23', 'Centro', 12.50, 25000.00, 'en_camino');

INSERT INTO historial_ubicaciones_envio (envio_id, transportista_id, latitud, longitud, estado_reportado) VALUES
(1, 1, 7.12539000, -73.11980000, 'recogido'),
(1, 1, 7.11420000, -73.11250000, 'en_ruta'),
(2, 2, 7.06215000, -73.08642000, 'llegada_destino'),
(4, 3, 7.11890000, -73.12410000, 'llegada_destino'),
(5, 4, 7.07120000, -73.09530000, 'en_ruta');



--Joinn
SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id = u_rep.id
ORDER BY e.fecha_creacion DESC; SELECT 
    e.codigo_rastreo,
    u_cli.nombre AS nombre_cliente,
    u_cli.apellido AS apellido_cliente,
    e.destino_via,
    e.destino_numero,
    e.destino_barrio,
    e.costo,
    e.estado,
    u_rep.nombre AS repartidor_asignado
FROM envios e
INNER JOIN clientes c ON e.cliente_id = c.id
INNER JOIN usuarios u_cli ON c.usuario_id = u_cli.id
LEFT JOIN transportistas t ON e.transportista_id = t.id
LEFT JOIN usuarios u_rep ON t.usuario_id

