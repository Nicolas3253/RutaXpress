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
PLANTILLA INTEGRADORA DEL PROYECTO
Buenas prácticas de Base de Datos II en PostgreSQL
Tercer corte · Trabajo en grupos · Preparación de exposición
Asignatura	Base de Datos II
Grupo	D195
Docente	Pedro Antonio Ramírez García
Fecha de trabajo autónomo	12 de noviembre de 2026
Exposición	Lunes 16 de noviembre de 2026
Modalidad	Trabajo grupal aplicado al proyecto
Propósito: Organizar y evidenciar, en una sola plantilla, las buenas prácticas desarrolladas durante el semestre sobre el proyecto de cada grupo: diseño, integridad, consultas, optimización, seguridad, funciones, procedimientos y disparadores. La plantilla diligenciada será la base de la exposición del lunes 16 de noviembre de 2026.

Regla principal: NO se aceptan ejemplos genéricos de tienda, productos o casos copiados de las guías. Todo debe corresponder al proyecto real del grupo y poder demostrarse en PostgreSQL.


 0. Instrucciones generales
•	Trabajen sobre la misma base de datos y el mismo proyecto que el grupo ha desarrollado durante el semestre.
•	Esta plantilla NO reemplaza el proyecto: sirve para organizarlo, demostrarlo y prepararlo para la exposición.
•	No peguen código sin explicación. Antes de cada bloque SQL, expliquen en lenguaje natural qué problema resuelve.
•	Todas las evidencias deben corresponder a ejecuciones reales en PostgreSQL. Las capturas deben ser legibles.
•	Cada integrante debe conocer el proyecto completo y participar en la exposición.
•	Revisen nombres de tablas, claves, relaciones, restricciones y código antes de entregar; el proyecto debe poder ejecutarse sin errores.
•	Entrega sugerida: un PDF de esta plantilla diligenciada + un archivo .SQL maestro con el proyecto ordenado.
Orden de trabajo recomendado: Primero documenten y limpien lo que ya existe. Después corrijan errores. Solo al final agreguen o ajusten los triggers. La meta no es llenar páginas: es dejar un proyecto coherente, ejecutable y defendible.

1. Identificación del proyecto y del equipo
Dato	Información del grupo
Nombre del proyecto	RutaXpress.
Problema que resuelve	Gestión y administración de paquetes
Usuario o población objetivo	Empresas de mensajería
Nombre de la base de datos	RutaXpress
Motor / versión utilizada	PostgreSQL
Repositorio o ubicación del script (si aplica)	https://github.com/Nicolas3253/RutaXpress.git
1.1 Integrantes y responsabilidad durante la exposición
Integrante	Responsabilidad técnica principal	Parte que explicará en la exposición
Arley Nicolas Suarez Hernandez	Diseñar y desarrollar la base de datos	El Proyecto en su totalidad
Importante: La responsabilidad asignada NO significa que el estudiante solo deba conocer esa parte. Cualquier integrante puede ser preguntado sobre tablas, seguridad, funciones, procedimientos o triggers.

2. Resumen funcional del proyecto
Pregunta	Respuesta del grupo
¿Qué necesidad real resuelve?	Gestionar el proceso de administrar información de mensajerías y mejorar su atención a sus clientes.
¿Qué información administra?	Nombres de usuarios, emails, direcciones
¿Cuáles son los procesos principales?	Registro de usuarios, direcciones atomizadas, cálculo de tarifas, asignación de envíos a repartidores, registro de ubicaciones, seguimiento del estado de los paquetes.
¿Qué usuarios/roles interactúan con la base de datos?	Cliente, mensajería, repartidor
¿Qué parte del proyecto consideran más crítica y por qué?	Evitar que haya fugas de información de las empresas de mensajería como por ejemplo la dirección, teléfono o datos de contacto de los clientes
2.1 Flujo principal en lenguaje natural
Describan el proceso principal como si se lo explicaran a una persona que no conoce SQL. Ejemplo de estructura: “El usuario registra…, la base valida…, luego consulta…, finalmente…”.
DESCRIPCIÓN DEL FLUJO PRINCIPAL

El usuario se registra o inicia sesión en la plataforma dependiendo de su rol y la base de datos valida si los datos son los mismos, después el cliente registra un envío ingresando los datos del paquete y las direcciones de origen y destino separadas por campos (vía, número, barrio y ciudad) y se registra el envío con su costo y estado inicial, después se asigna ese envío a un repartidor disponible y a mientras avanza o llega a la dirección final, se guardan las coordenadas y el estado del envío en el historial, y tanto el cliente como la empresa pueden consultar el estado del envío y verificar cuándo fué recibido por el repartidor y cuando llegó a la dirección final si llega a surgir una inquietud.

3. Modelo de datos y buenas prácticas de diseño
3.1 Diagrama entidad-relación / modelo relacional
.  
3.2 Entidades y relaciones principales
Tabla / entidad	Propósito	PK	FK principales	Relación más importante
rol	Define los roles del sistema	id	Ninguna	1:N con usuarios
usuarios	Guarda identidad, credenciales y contacto para el acceso del usuario	id	rol_id	1:1 con clientes y 1:1 con transportistas según el perfil
clientes	Guarda perfil del cliente y su dirección atomizada	id	usuarios_id	1:N con envios
transportistas	Registra vehículo, placa y disponibilidad del repartidor	id	Usuario_id	1:N con envios y historial_ubicaciones_envio
envios	Controla la guía, origen y destino atomizados, peso, costo y estado	id	cliente_id, transportista_id	1:N con historial_ubicaciones_envio
historial_ubicaciones_envio	Guarda coordenadas y estados reportados	id	transportista_id, envio_id	Depende de envios y transportistas para verificar entregas.
3.3 Reglas de integridad y normalización
Regla / decisión	Cómo se implementó	¿Por qué es necesaria?
Direcciones atomizadas	Columnas separadas para vía, número, placa/barrio y ciudad en clientes y envios	Evita mezclar datos en un solo texto libre y facilita validaciones, búsquedas y consistencia
Restricción en tipo de vía	Con una restricción CHECK con valores permitidos (ej. 'Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal')	Evita variantes que pueden cambiar como "cll" en comparación  a "Calle" y evita entradas inválidas
Claves foráneas (FK) y unicidad (UNIQUE)	FK en relaciones entre tablas y UNIQUE en email, codigo_rastreo y placa de vehículo	Garantiza que no haya envíos huérfanos, correos repetidos, guías duplicadas ni placas duplicadas
Almacenamiento de clave e historial	password_hash en usuarios y latitud/longitud en DECIMAL en historial_ubicaciones_envio	Protege credenciales al login y permite comprobar llegadas
Revise: Eviten datos repetidos sin necesidad, campos multivaluados, claves foráneas sin relación, tipos de dato inadecuados y nombres ambiguos. Justifiquen las decisiones importantes.

4. Diccionario y creación de tablas
Seleccione las tablas principales del proyecto. Si son muchas, documente al menos las más importantes y adjunte el script completo en el archivo SQL maestro.
Tabla	Campo	Tipo	PK/FK	NULL	DEFAULT	Regla / descripción
rol	id	SERIAL	PK	NO	Auto-incremento	Identificador único del rol.
rol	nombre	VARCHAR(30)		NO	Ninguno	UNIQUE  Roles permitidos (ADMINISTRADOR, REPARTIDOR, CLIENTE)
usuarios.	id	SERIAL	PK	NO	Auto-incremento	Identificador único del usuario
usuarios	nombre	VARCHAR(50)		NO	Ninguno	Primer/segundo nombre del usuario
usuarios	apellido	VARCHAR(50)		NO	Ninguno	Apellidos del usuario
usuarios	email	VARCHAR(100)		NO	Ninguno	UNIQUE Correo electrónico de acceso al sistema
usuarios	password_hash	VARCHAR(255)		NO	Escriba aquí...	Hash encriptado de la contraseña para login seguro
usuarios	telefono	VARCHAR(20)		SÍ	Escriba aquí...	Número de contacto telefónico
usuarios	rol_id	INT	PK	NO	Ninguno	Referencia a rol_id y define los permisos del usuario
usuarios	fecha_creacion	TIMESTAMP		NO	CURRENT_TIMESTAMP	Fecha y hora exacta de registro
4.1 Script representativo de creación de tablas
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




5. Datos de prueba e integridad
Prueba	Qué se intenta	Resultado esperado	Resultado obtenido
Prueba 1 (Válida)	Insertar un envío con codigo_rastreo único, cliente_id existente, vía permitida ('Calle'), peso > 0 y costo >= 0	Inserción exitosa (INSERT 0 1) y estado inicial 'pendiente'	Inserción exitosa con estado 'pendiente' por defecto
Prueba 2 (Inválida - CHECK vía)	Insertar o actualizar un envío o cliente usando 'cll' en lugar de 'Calle' en la columna de vía	PostgreSQL rechaza la operación por violar la restricción CHECK de vía válida	Error de violación de restricción CHECK (chk_... / envios_origen_via_check); el dato no entra
Prueba 3 (Inválida - UNIQUE)	Registrar un segundo usuario con un email ya existente o un envío con un codigo_rastreo repetido	PostgreSQL bloquea el registro por duplicidad en restricción UNIQUE	Error de clave duplicada (duplicate key value violates unique constraint); no se duplica
Prueba 4 (Inválida - FK / CHECK peso)	Insertar un envío con cliente_id inexistente o peso_kg = -2.50	PostgreSQL rechaza la fila por llave foránea inexistente o por peso_kg > 0	Error por violación de FOREIGN KEY o CHECK (peso_kg > 0); base íntegra
5.1 INSERT de datos de prueba
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

