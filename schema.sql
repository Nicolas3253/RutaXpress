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
ORDER BY e.fecha_creacion DESC;

SELECT 
    estado,
    COUNT(*) AS total_envios,
    ROUND(AVG(peso_kg), 2) AS peso_promedio_kg,
    SUM(costo) AS ingresos_totales
FROM envios
GROUP BY estado
ORDER BY total_envios DESC;


---Vista
CREATE OR REPLACE VIEW vw_envios_pendientes AS
SELECT 
    id AS envio_id,
    codigo_rastreo,
    cliente_id,
    origen_via,
    origen_numero,
    origen_barrio,
    destino_via,
    destino_numero,
    destino_barrio,
    peso_kg,
    costo,
    fecha_creacion
FROM envios
WHERE estado = 'pendiente';


--Roles y permisos
CREATE ROLE rol_admin_rx NOLOGIN;
CREATE ROLE rol_repartidor_rx NOLOGIN;
CREATE ROLE rol_cliente_rx NOLOGIN;

GRANT USAGE ON SCHEMA public TO rol_admin_rx, rol_repartidor_rx, rol_cliente_rx;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_admin_rx, rol_repartidor_rx, rol_cliente_rx;

GRANT SELECT, INSERT, UPDATE, DELETE ON rol, usuarios, clientes, transportistas, envios TO rol_admin_rx;
GRANT SELECT, INSERT ON historial_ubicaciones_envio TO rol_admin_rx;

GRANT SELECT ON vw_envios_pendientes, envios, transportistas TO rol_repartidor_rx;
GRANT INSERT ON historial_ubicaciones_envio TO rol_repartidor_rx;
GRANT UPDATE (estado, transportista_id) ON envios TO rol_repartidor_rx;
GRANT UPDATE (disponible) ON transportistas TO rol_repartidor_rx;

GRANT SELECT, INSERT ON envios TO rol_cliente_rx;
GRANT SELECT, UPDATE (via, numero_via, placa, barrio, ciudad) ON clientes TO rol_cliente_rx;
GRANT SELECT (id, nombre, apellido, email, telefono) ON usuarios TO rol_cliente_rx;

CREATE USER user_repartidor_demo WITH PASSWORD 'Repartidor2026*';
GRANT rol_repartidor_rx TO user_repartidor_demo;

CREATE USER user_cliente_demo WITH PASSWORD 'Cliente2026*';
GRANT rol_cliente_rx TO user_cliente_demo;



--Funciones
CREATE OR REPLACE FUNCTION fn_calcular_tarifa(
    p_peso DECIMAL,
    p_misma_ciudad BOOLEAN DEFAULT TRUE
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tarifa_base DECIMAL(10,2) := 6000.00;
    v_adicional_kg DECIMAL(10,2) := 2000.00;
    v_recargo_intermunicipal DECIMAL(10,2) := 4000.00;
    v_total DECIMAL(10,2);
BEGIN
    IF p_peso IS NULL OR p_peso <= 0 THEN
        RAISE EXCEPTION 'El peso del envío debe ser mayor a 0 kg.';
    END IF;

    IF p_peso <= 1.0 THEN
        v_total := v_tarifa_base;
    ELSE
        v_total := v_tarifa_base + ((p_peso - 1.0) * v_adicional_kg);
    END IF;

    IF NOT COALESCE(p_misma_ciudad, TRUE) THEN
        v_total := v_total + v_recargo_intermunicipal;
    END IF;

    RETURN ROUND(v_total, 2);
END;
$$;



--Procedimiento
CREATE OR REPLACE PROCEDURE sp_asignar_envio(
    p_envio_id INT,
    p_transportista_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM envios WHERE id = p_envio_id AND estado = 'pendiente'
    ) THEN
        RAISE EXCEPTION 'El envío % no existe o ya no está pendiente.', p_envio_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM transportistas WHERE id = p_transportista_id AND disponible = TRUE
    ) THEN
        RAISE EXCEPTION 'El transportista % no está disponible.', p_transportista_id;
    END IF;

    UPDATE envios
    SET transportista_id = p_transportista_id,
        estado = 'en_camino'
    WHERE id = p_envio_id;

    UPDATE transportistas
    SET disponible = FALSE
    WHERE id = p_transportista_id;
END;
$$;



--Trigger1
CREATE OR REPLACE FUNCTION fn_validar_actualizacion_envio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.estado IN ('entregado', 'cancelado') THEN
        RAISE EXCEPTION 'No se puede modificar un envío en estado %.', OLD.estado;
    END IF;
    IF OLD.estado = 'pendiente' AND NEW.estado = 'entregado' THEN
        RAISE EXCEPTION 'Un envío pendiente debe pasar primero a estado en_camino.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_validar_actualizacion_envio
BEFORE UPDATE ON envios
FOR EACH ROW
EXECUTE FUNCTION fn_validar_actualizacion_envio();


--trigger2
CREATE OR REPLACE FUNCTION fn_automatizar_cierre_envio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.estado IS DISTINCT FROM NEW.estado
       AND NEW.estado IN ('entregado', 'cancelado')
       AND NEW.transportista_id IS NOT NULL THEN
        UPDATE transportistas
        SET disponible = TRUE
        WHERE id = NEW.transportista_id;
        INSERT INTO historial_ubicaciones_envio (
            envio_id, transportista_id, latitud, longitud, estado_reportado
        )
        VALUES (
            NEW.id, NEW.transportista_id, 7.11934900, -73.12274100, NEW.estado
        );
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_automatizar_cierre_envio
AFTER UPDATE ON envios
FOR EACH ROW
EXECUTE FUNCTION fn_automatizar_cierre_envio();
