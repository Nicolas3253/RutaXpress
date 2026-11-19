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





