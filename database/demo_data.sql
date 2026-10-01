-- Datos ficticios de demostracion para Rancho Ovino.
-- Ejecutar en el SQL Editor del proyecto Supabase despues de schema_update.sql.
-- Los registros se identifican con el prefijo DEMO- y la marca DEMO_RANCHO_PRUEBAS_2026.
-- Se puede volver a ejecutar: reutiliza los mismos UUID y no crea duplicados.

BEGIN;

DO $$
DECLARE
  demo_ids uuid[] := ARRAY[
    'd0000000-0000-4000-8000-000000000001'::uuid,
    'd0000000-0000-4000-8000-000000000002'::uuid,
    'd0000000-0000-4000-8000-000000000003'::uuid,
    'd0000000-0000-4000-8000-000000000004'::uuid,
    'd0000000-0000-4000-8000-000000000005'::uuid,
    'd0000000-0000-4000-8000-000000000006'::uuid,
    'd0000000-0000-4000-8000-000000000007'::uuid,
    'd0000000-0000-4000-8000-000000000008'::uuid,
    'd0000000-0000-4000-8000-000000000009'::uuid,
    'd0000000-0000-4000-8000-000000000010'::uuid,
    'd0000000-0000-4000-8000-000000000011'::uuid,
    'd0000000-0000-4000-8000-000000000012'::uuid,
    'd0000000-0000-4000-8000-000000000013'::uuid,
    'd0000000-0000-4000-8000-000000000014'::uuid,
    'd0000000-0000-4000-8000-000000000015'::uuid,
    'd0000000-0000-4000-8000-000000000016'::uuid,
    'd0000000-0000-4000-8000-000000000017'::uuid,
    'd0000000-0000-4000-8000-000000000018'::uuid,
    'd0000000-0000-4000-8000-000000000019'::uuid,
    'd0000000-0000-4000-8000-000000000020'::uuid,
    'd0000000-0000-4000-8000-000000000021'::uuid,
    'd0000000-0000-4000-8000-000000000022'::uuid
  ];
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.animales
    WHERE id = ANY(demo_ids)
      AND (notas IS DISTINCT FROM 'DEMO_RANCHO_PRUEBAS_2026'
        OR identificador NOT LIKE 'DEMO-%')
    UNION ALL
    SELECT 1
    FROM public.animales
    WHERE identificador IN (
      'DEMO-001','DEMO-002','DEMO-003','DEMO-004','DEMO-005','DEMO-006','DEMO-007',
      'DEMO-008','DEMO-009','DEMO-010','DEMO-011','DEMO-012','DEMO-013',
      'DEMO-014','DEMO-015','DEMO-016','DEMO-017','DEMO-018','DEMO-019','DEMO-020',
      'DEMO-021','DEMO-022'
    )
      AND id <> ALL(demo_ids)
    UNION ALL
    SELECT 1 FROM public.reproduccion
    WHERE id = ANY(ARRAY[
      'd1000000-0000-4000-8000-000000000001'::uuid,
      'd1000000-0000-4000-8000-000000000002'::uuid,
      'd1000000-0000-4000-8000-000000000003'::uuid,
      'd1000000-0000-4000-8000-000000000004'::uuid,
      'd1000000-0000-4000-8000-000000000005'::uuid,
      'd1000000-0000-4000-8000-000000000006'::uuid,
      'd1000000-0000-4000-8000-000000000007'::uuid,
      'd1000000-0000-4000-8000-000000000008'::uuid,
      'd1000000-0000-4000-8000-000000000009'::uuid,
      'd1000000-0000-4000-8000-000000000010'::uuid,
      'd1000000-0000-4000-8000-000000000011'::uuid,
      'd1000000-0000-4000-8000-000000000012'::uuid
    ]) AND notas IS DISTINCT FROM 'DEMO_RANCHO_PRUEBAS_2026'
    UNION ALL
    SELECT 1 FROM public.produccion
    WHERE id = ANY(ARRAY[
      'd2000000-0000-4000-8000-000000000001'::uuid,
      'd2000000-0000-4000-8000-000000000002'::uuid,
      'd2000000-0000-4000-8000-000000000003'::uuid,
      'd2000000-0000-4000-8000-000000000004'::uuid,
      'd2000000-0000-4000-8000-000000000005'::uuid,
      'd2000000-0000-4000-8000-000000000006'::uuid,
      'd2000000-0000-4000-8000-000000000007'::uuid,
      'd2000000-0000-4000-8000-000000000008'::uuid,
      'd2000000-0000-4000-8000-000000000009'::uuid,
      'd2000000-0000-4000-8000-000000000010'::uuid,
      'd2000000-0000-4000-8000-000000000011'::uuid,
      'd2000000-0000-4000-8000-000000000012'::uuid,
      'd2000000-0000-4000-8000-000000000013'::uuid,
      'd2000000-0000-4000-8000-000000000014'::uuid,
      'd2000000-0000-4000-8000-000000000015'::uuid,
      'd2000000-0000-4000-8000-000000000016'::uuid,
      'd2000000-0000-4000-8000-000000000017'::uuid,
      'd2000000-0000-4000-8000-000000000018'::uuid,
      'd2000000-0000-4000-8000-000000000019'::uuid,
      'd2000000-0000-4000-8000-000000000020'::uuid,
      'd2000000-0000-4000-8000-000000000021'::uuid,
      'd2000000-0000-4000-8000-000000000022'::uuid,
      'd2000000-0000-4000-8000-000000000023'::uuid,
      'd2000000-0000-4000-8000-000000000024'::uuid,
      'd2000000-0000-4000-8000-000000000025'::uuid,
      'd2000000-0000-4000-8000-000000000026'::uuid,
      'd2000000-0000-4000-8000-000000000027'::uuid,
      'd2000000-0000-4000-8000-000000000028'::uuid,
      'd2000000-0000-4000-8000-000000000029'::uuid,
      'd2000000-0000-4000-8000-000000000030'::uuid,
      'd2000000-0000-4000-8000-000000000031'::uuid,
      'd2000000-0000-4000-8000-000000000032'::uuid,
      'd2000000-0000-4000-8000-000000000033'::uuid,
      'd2000000-0000-4000-8000-000000000034'::uuid,
      'd2000000-0000-4000-8000-000000000035'::uuid,
      'd2000000-0000-4000-8000-000000000036'::uuid,
      'd2000000-0000-4000-8000-000000000037'::uuid,
      'd2000000-0000-4000-8000-000000000038'::uuid,
      'd2000000-0000-4000-8000-000000000039'::uuid,
      'd2000000-0000-4000-8000-000000000040'::uuid,
      'd2000000-0000-4000-8000-000000000041'::uuid,
      'd2000000-0000-4000-8000-000000000042'::uuid,
      'd2000000-0000-4000-8000-000000000043'::uuid,
      'd2000000-0000-4000-8000-000000000044'::uuid,
      'd2000000-0000-4000-8000-000000000045'::uuid
    ]) AND observaciones IS DISTINCT FROM 'DEMO_RANCHO_PRUEBAS_2026'
    UNION ALL
    SELECT 1 FROM public.salud
    WHERE id = ANY(ARRAY[
      'd3000000-0000-4000-8000-000000000001'::uuid,
      'd3000000-0000-4000-8000-000000000002'::uuid,
      'd3000000-0000-4000-8000-000000000003'::uuid,
      'd3000000-0000-4000-8000-000000000004'::uuid,
      'd3000000-0000-4000-8000-000000000005'::uuid,
      'd3000000-0000-4000-8000-000000000006'::uuid,
      'd3000000-0000-4000-8000-000000000007'::uuid,
      'd3000000-0000-4000-8000-000000000008'::uuid,
      'd3000000-0000-4000-8000-000000000009'::uuid,
      'd3000000-0000-4000-8000-000000000010'::uuid,
      'd3000000-0000-4000-8000-000000000011'::uuid,
      'd3000000-0000-4000-8000-000000000012'::uuid
    ]) AND notas IS DISTINCT FROM 'DEMO_RANCHO_PRUEBAS_2026'
    UNION ALL
    SELECT 1 FROM public.ventas
    WHERE id = ANY(ARRAY[
      'd4000000-0000-4000-8000-000000000001'::uuid,
      'd4000000-0000-4000-8000-000000000002'::uuid,
      'd4000000-0000-4000-8000-000000000003'::uuid,
      'd4000000-0000-4000-8000-000000000004'::uuid,
      'd4000000-0000-4000-8000-000000000005'::uuid,
      'd4000000-0000-4000-8000-000000000006'::uuid,
      'd4000000-0000-4000-8000-000000000007'::uuid,
      'd4000000-0000-4000-8000-000000000008'::uuid,
      'd4000000-0000-4000-8000-000000000009'::uuid,
      'd4000000-0000-4000-8000-000000000010'::uuid,
      'd4000000-0000-4000-8000-000000000011'::uuid,
      'd4000000-0000-4000-8000-000000000012'::uuid
    ]) AND notas IS DISTINCT FROM 'DEMO_RANCHO_PRUEBAS_2026'
    UNION ALL
    SELECT 1 FROM public.detalle_venta
    WHERE id = ANY(ARRAY[
      'd5000000-0000-4000-8000-000000000001'::uuid,
      'd5000000-0000-4000-8000-000000000002'::uuid,
      'd5000000-0000-4000-8000-000000000003'::uuid,
      'd5000000-0000-4000-8000-000000000004'::uuid,
      'd5000000-0000-4000-8000-000000000005'::uuid,
      'd5000000-0000-4000-8000-000000000006'::uuid,
      'd5000000-0000-4000-8000-000000000007'::uuid,
      'd5000000-0000-4000-8000-000000000008'::uuid,
      'd5000000-0000-4000-8000-000000000009'::uuid,
      'd5000000-0000-4000-8000-000000000010'::uuid,
      'd5000000-0000-4000-8000-000000000011'::uuid,
      'd5000000-0000-4000-8000-000000000012'::uuid
    ]) AND notas IS DISTINCT FROM 'DEMO_RANCHO_PRUEBAS_2026'
  ) THEN
    RAISE EXCEPTION 'Un identificador reservado para datos demo ya pertenece a un registro real. No se insertaron datos.';
  END IF;
END;
$$;

INSERT INTO public.animales (
  id, identificador, nombre, especie, raza, sexo, fecha_nacimiento,
  estado, estado_productivo, numero_partos, tipo_nacimiento, notas
) VALUES
  ('d0000000-0000-4000-8000-000000000001', 'DEMO-001', 'Lucero', 'borrego', 'Dorper', 'hembra', current_date - 540, 'activo', 'lactando', 2, 'doble', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000002', 'DEMO-002', 'Canela', 'borrego', 'Pelibuey', 'hembra', current_date - 420, 'activo', 'gestante', 1, 'sencillo', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000003', 'DEMO-003', 'Estrella', 'borrego', 'Blackbelly', 'hembra', current_date - 680, 'activo', 'parida', 3, 'doble', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000004', 'DEMO-004', 'Trueno', 'borrego', 'Dorper', 'macho', current_date - 730, 'activo', 'semental', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000005', 'DEMO-005', 'Norteño', 'borrego', 'Suffolk', 'macho', current_date - 600, 'activo', 'engorda', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000006', 'DEMO-006', 'Miel', 'borrego', 'Katahdin', 'hembra', current_date - 500, 'activo', 'destetada', 1, 'sencillo', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000007', 'DEMO-007', 'Copo', 'borrego', 'Rambouillet', 'macho', current_date - 800, 'muerto', NULL, 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000008', 'DEMO-008', 'Nube', 'borrego', 'Dorper', 'hembra', current_date - 390, 'activo', 'gestante', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000009', 'DEMO-009', 'Relámpago', 'borrego', 'Suffolk', 'macho', current_date - 900, 'activo', 'semental', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000010', 'DEMO-010', 'Pinta', 'borrego', 'Pelibuey', 'hembra', current_date - 320, 'activo', 'parida', 1, 'sencillo', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000011', 'DEMO-011', 'Luna', 'borrego', 'Katahdin', 'hembra', current_date - 270, 'activo', 'servicio', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000012', 'DEMO-012', 'Canelo', 'borrego', 'Blackbelly', 'macho', current_date - 410, 'activo', 'engorda', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000013', 'DEMO-013', 'Rocío', 'borrego', 'Dorper', 'hembra', current_date - 460, 'activo', 'lactando', 2, 'doble', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000014', 'DEMO-014', 'Centella', 'borrego', 'Suffolk', 'macho', current_date - 650, 'activo', 'semental', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000015', 'DEMO-015', 'Mora', 'borrego', 'Pelibuey', 'hembra', current_date - 350, 'activo', 'gestante', 1, 'sencillo', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000016', 'DEMO-016', 'Manchas', 'borrego', 'Blackbelly', 'macho', current_date - 520, 'activo', 'engorda', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000017', 'DEMO-017', 'Perla', 'borrego', 'Katahdin', 'hembra', current_date - 410, 'activo', 'parida', 2, 'doble', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000018', 'DEMO-018', 'Bronco', 'borrego', 'Dorper', 'macho', current_date - 700, 'activo', 'semental', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000019', 'DEMO-019', 'Tambor', 'borrego', 'Rambouillet', 'macho', current_date - 330, 'activo', 'engorda', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000020', 'DEMO-020', 'Azucena', 'borrego', 'Pelibuey', 'hembra', current_date - 300, 'activo', 'servicio', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000021', 'DEMO-021', 'Castaña', 'borrego', 'Katahdin', 'hembra', current_date - 380, 'activo', 'lactando', 1, 'doble', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d0000000-0000-4000-8000-000000000022', 'DEMO-022', 'Capitán', 'borrego', 'Dorper', 'macho', current_date - 560, 'activo', 'engorda', 0, NULL, 'DEMO_RANCHO_PRUEBAS_2026')
ON CONFLICT (id) DO UPDATE SET
  identificador = EXCLUDED.identificador,
  nombre = EXCLUDED.nombre,
  especie = EXCLUDED.especie,
  raza = EXCLUDED.raza,
  sexo = EXCLUDED.sexo,
  fecha_nacimiento = EXCLUDED.fecha_nacimiento,
  estado = EXCLUDED.estado,
  estado_productivo = EXCLUDED.estado_productivo,
  numero_partos = EXCLUDED.numero_partos,
  tipo_nacimiento = EXCLUDED.tipo_nacimiento,
  notas = EXCLUDED.notas
WHERE public.animales.notas = 'DEMO_RANCHO_PRUEBAS_2026';

INSERT INTO public.reproduccion (
  id, id_hembra, id_macho, fecha_empadre, fecha_parto_real,
  numero_crias, estado, observaciones, notas
) VALUES
  ('d1000000-0000-4000-8000-000000000001', 'd0000000-0000-4000-8000-000000000002', 'd0000000-0000-4000-8000-000000000004', current_date - interval '3 months', NULL, NULL, 'gestando', 'Empadre ficticio para demostracion.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000002', 'd0000000-0000-4000-8000-000000000003', 'd0000000-0000-4000-8000-000000000004', current_date - interval '8 months', current_date - interval '3 months', 2, 'pario', 'Parto ficticio con dos crias.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000003', 'd0000000-0000-4000-8000-000000000006', 'd0000000-0000-4000-8000-000000000004', current_date - interval '5 months', NULL, 0, 'fallido', 'Registro ficticio de empadre fallido.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000004', 'd0000000-0000-4000-8000-000000000008', 'd0000000-0000-4000-8000-000000000009', current_date - interval '3 months', NULL, NULL, 'gestando', 'Empadre ficticio reciente.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000005', 'd0000000-0000-4000-8000-000000000010', 'd0000000-0000-4000-8000-000000000009', current_date - interval '8 months', current_date - interval '3 months', 1, 'pario', 'Parto ficticio con una cria.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000006', 'd0000000-0000-4000-8000-000000000011', 'd0000000-0000-4000-8000-000000000012', current_date - interval '5 months', NULL, 0, 'fallido', 'Empadre ficticio fallido.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000007', 'd0000000-0000-4000-8000-000000000013', 'd0000000-0000-4000-8000-000000000014', current_date - interval '7 months', current_date - interval '2 months', 2, 'pario', 'Parto ficticio en periodo anterior.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000008', 'd0000000-0000-4000-8000-000000000015', 'd0000000-0000-4000-8000-000000000014', current_date - interval '3 months', NULL, NULL, 'gestando', 'Empadre ficticio de hace tres meses.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000009', 'd0000000-0000-4000-8000-000000000017', 'd0000000-0000-4000-8000-000000000018', current_date - interval '10 months', current_date - interval '5 months', 2, 'pario', 'Parto ficticio con dos crias.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000010', 'd0000000-0000-4000-8000-000000000020', 'd0000000-0000-4000-8000-000000000018', current_date - interval '2 months', NULL, NULL, 'gestando', 'Empadre ficticio reciente.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000011', 'd0000000-0000-4000-8000-000000000013', 'd0000000-0000-4000-8000-000000000016', current_date - interval '12 months', NULL, 0, 'fallido', 'Registro ficticio de empadre fallido.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d1000000-0000-4000-8000-000000000012', 'd0000000-0000-4000-8000-000000000015', 'd0000000-0000-4000-8000-000000000016', current_date - interval '6 months', current_date - interval '1 month', 1, 'pario', 'Parto ficticio de una cria.', 'DEMO_RANCHO_PRUEBAS_2026')
ON CONFLICT (id) DO UPDATE SET
  id_hembra = EXCLUDED.id_hembra,
  id_macho = EXCLUDED.id_macho,
  fecha_empadre = EXCLUDED.fecha_empadre,
  fecha_parto_estimada = EXCLUDED.fecha_parto_estimada,
  fecha_parto_real = EXCLUDED.fecha_parto_real,
  numero_crias = EXCLUDED.numero_crias,
  estado = EXCLUDED.estado,
  observaciones = EXCLUDED.observaciones,
  notas = EXCLUDED.notas
WHERE public.reproduccion.notas = 'DEMO_RANCHO_PRUEBAS_2026';

INSERT INTO public.produccion (id, id_animal, fecha, peso, observaciones) VALUES
  ('d2000000-0000-4000-8000-000000000001', 'd0000000-0000-4000-8000-000000000001', current_date - 60, 42.50, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000002', 'd0000000-0000-4000-8000-000000000001', current_date - 30, 44.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000003', 'd0000000-0000-4000-8000-000000000001', current_date - 5, 45.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000004', 'd0000000-0000-4000-8000-000000000002', current_date - 60, 36.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000005', 'd0000000-0000-4000-8000-000000000002', current_date - 30, 38.40, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000006', 'd0000000-0000-4000-8000-000000000002', current_date - 5, 40.25, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000007', 'd0000000-0000-4000-8000-000000000003', current_date - 60, 48.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000008', 'd0000000-0000-4000-8000-000000000003', current_date - 30, 49.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000009', 'd0000000-0000-4000-8000-000000000003', current_date - 5, 50.30, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000010', 'd0000000-0000-4000-8000-000000000008', current_date - 60, 34.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000011', 'd0000000-0000-4000-8000-000000000008', current_date - 30, 36.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000012', 'd0000000-0000-4000-8000-000000000008', current_date - 5, 37.80, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000013', 'd0000000-0000-4000-8000-000000000009', current_date - 60, 68.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000014', 'd0000000-0000-4000-8000-000000000009', current_date - 30, 69.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000015', 'd0000000-0000-4000-8000-000000000009', current_date - 5, 70.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000016', 'd0000000-0000-4000-8000-000000000010', current_date - 180, 31.50, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000017', 'd0000000-0000-4000-8000-000000000010', current_date - 150, 32.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000018', 'd0000000-0000-4000-8000-000000000010', current_date - 120, 33.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000019', 'd0000000-0000-4000-8000-000000000011', current_date - 120, 29.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000020', 'd0000000-0000-4000-8000-000000000011', current_date - 90, 30.40, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000021', 'd0000000-0000-4000-8000-000000000011', current_date - 60, 31.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000022', 'd0000000-0000-4000-8000-000000000013', current_date - 180, 35.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000023', 'd0000000-0000-4000-8000-000000000013', current_date - 150, 36.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000024', 'd0000000-0000-4000-8000-000000000013', current_date - 120, 37.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000025', 'd0000000-0000-4000-8000-000000000013', current_date - 90, 38.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000026', 'd0000000-0000-4000-8000-000000000013', current_date - 60, 39.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000027', 'd0000000-0000-4000-8000-000000000013', current_date - 30, 40.30, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000028', 'd0000000-0000-4000-8000-000000000014', current_date - 180, 61.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000029', 'd0000000-0000-4000-8000-000000000014', current_date - 150, 62.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000030', 'd0000000-0000-4000-8000-000000000014', current_date - 120, 63.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000031', 'd0000000-0000-4000-8000-000000000014', current_date - 90, 64.30, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000032', 'd0000000-0000-4000-8000-000000000014', current_date - 60, 65.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000033', 'd0000000-0000-4000-8000-000000000014', current_date - 30, 66.40, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000034', 'd0000000-0000-4000-8000-000000000015', current_date - 180, 32.40, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000035', 'd0000000-0000-4000-8000-000000000015', current_date - 150, 33.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000036', 'd0000000-0000-4000-8000-000000000015', current_date - 120, 34.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000037', 'd0000000-0000-4000-8000-000000000015', current_date - 90, 35.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000038', 'd0000000-0000-4000-8000-000000000015', current_date - 60, 36.30, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000039', 'd0000000-0000-4000-8000-000000000015', current_date - 30, 37.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000040', 'd0000000-0000-4000-8000-000000000016', current_date - 180, 40.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000041', 'd0000000-0000-4000-8000-000000000016', current_date - 150, 41.30, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000042', 'd0000000-0000-4000-8000-000000000016', current_date - 120, 42.10, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000043', 'd0000000-0000-4000-8000-000000000016', current_date - 90, 43.40, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000044', 'd0000000-0000-4000-8000-000000000016', current_date - 60, 44.20, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d2000000-0000-4000-8000-000000000045', 'd0000000-0000-4000-8000-000000000016', current_date - 30, 45.10, 'DEMO_RANCHO_PRUEBAS_2026')
ON CONFLICT (id) DO UPDATE SET
  id_animal = EXCLUDED.id_animal,
  fecha = EXCLUDED.fecha,
  peso = EXCLUDED.peso,
  observaciones = EXCLUDED.observaciones
WHERE public.produccion.observaciones = 'DEMO_RANCHO_PRUEBAS_2026';

INSERT INTO public.salud (
  id, id_animal, fecha, tipo, diagnostico, tratamiento,
  medicamento, dosis, observaciones, notas
) VALUES
  ('d3000000-0000-4000-8000-000000000001', 'd0000000-0000-4000-8000-000000000001', current_date - 3, 'vacuna', 'Revision preventiva', 'Aplicacion de vacuna anual', 'Vacuna clostridial', '2 ml', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000002', 'd0000000-0000-4000-8000-000000000002', current_date - 25, 'desparasitacion', 'Control preventivo', 'Desparasitacion programada', 'Ivermectina', '1 ml', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000003', 'd0000000-0000-4000-8000-000000000003', current_date - 50, 'tratamiento', 'Irritacion leve', 'Revision y seguimiento', 'Antiseptico', 'Uso topico', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000004', 'd0000000-0000-4000-8000-000000000008', current_date - 12, 'vacuna', 'Refuerzo preventivo', 'Aplicacion de refuerzo', 'Vacuna clostridial', '2 ml', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000005', 'd0000000-0000-4000-8000-000000000010', current_date - 40, 'desparasitacion', 'Control rutinario', 'Desparasitacion preventiva', 'Ivermectina', '1 ml', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000006', 'd0000000-0000-4000-8000-000000000012', current_date - 75, 'tratamiento', 'Revision general', 'Seguimiento preventivo', 'Antiseptico', 'Uso topico', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000007', 'd0000000-0000-4000-8000-000000000013', current_date - 7, 'vacuna', 'Refuerzo preventivo', 'Aplicacion de vacuna', 'Vacuna clostridial', '2 ml', 'Registro ficticio de fecha reciente.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000008', 'd0000000-0000-4000-8000-000000000014', current_date - 22, 'desparasitacion', 'Control preventivo', 'Desparasitacion programada', 'Ivermectina', '1 ml', 'Registro ficticio de fecha reciente.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000009', 'd0000000-0000-4000-8000-000000000015', current_date - 45, 'tratamiento', 'Revision reproductiva', 'Seguimiento veterinario', 'Antiseptico', 'Uso topico', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000010', 'd0000000-0000-4000-8000-000000000016', current_date - 90, 'vacuna', 'Vacunacion programada', 'Aplicacion anual', 'Vacuna clostridial', '2 ml', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000011', 'd0000000-0000-4000-8000-000000000017', current_date - 150, 'desparasitacion', 'Control estacional', 'Desparasitacion preventiva', 'Ivermectina', '1 ml', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d3000000-0000-4000-8000-000000000012', 'd0000000-0000-4000-8000-000000000018', current_date - 240, 'tratamiento', 'Revision general', 'Atencion ficticia para demostracion', 'Antiseptico', 'Uso topico', 'Registro ficticio para pruebas.', 'DEMO_RANCHO_PRUEBAS_2026')
ON CONFLICT (id) DO UPDATE SET
  id_animal = EXCLUDED.id_animal,
  fecha = EXCLUDED.fecha,
  tipo = EXCLUDED.tipo,
  diagnostico = EXCLUDED.diagnostico,
  tratamiento = EXCLUDED.tratamiento,
  medicamento = EXCLUDED.medicamento,
  dosis = EXCLUDED.dosis,
  observaciones = EXCLUDED.observaciones,
  notas = EXCLUDED.notas
WHERE public.salud.notas = 'DEMO_RANCHO_PRUEBAS_2026';

INSERT INTO public.ventas (id, fecha, cliente, tipo_venta, total, costo, notas) VALUES
  ('d4000000-0000-4000-8000-000000000001', current_date - 5, 'Cliente Demo Norte', 'pie_cria', 8500.00, 3100.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000002', current_date - 35, 'Mercado Demo', 'carne', 6200.00, 2800.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000003', current_date - 65, 'Cliente Demo Sur', 'pie_cria', 7900.00, 3000.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000004', current_date - 12, 'Cliente Demo Este', 'pie_cria', 9100.00, 3400.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000005', current_date - 42, 'Mercado Demo Centro', 'carne', 6800.00, 2950.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000006', current_date - 72, 'Cliente Demo Oeste', 'carne', 7300.00, 3200.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000007', current_date - 2, 'Cliente Demo Valle', 'pie_cria', 9400.00, 3500.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000008', current_date - 18, 'Mercado Demo Sierra', 'carne', 7100.00, 3050.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000009', current_date - 48, 'Cliente Demo Llano', 'carne', 7600.00, 3300.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000010', current_date - 95, 'Cliente Demo Encino', 'pie_cria', 8800.00, 3250.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000011', current_date - 140, 'Mercado Demo Regional', 'carne', 6500.00, 2750.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d4000000-0000-4000-8000-000000000012', current_date - 210, 'Cliente Demo Camino', 'pie_cria', 8200.00, 3000.00, 'DEMO_RANCHO_PRUEBAS_2026')
ON CONFLICT (id) DO UPDATE SET
  fecha = EXCLUDED.fecha,
  cliente = EXCLUDED.cliente,
  tipo_venta = EXCLUDED.tipo_venta,
  total = EXCLUDED.total,
  costo = EXCLUDED.costo,
  notas = EXCLUDED.notas
WHERE public.ventas.notas = 'DEMO_RANCHO_PRUEBAS_2026';

INSERT INTO public.detalle_venta (id, id_venta, id_animal, precio, peso, notas) VALUES
  ('d5000000-0000-4000-8000-000000000001', 'd4000000-0000-4000-8000-000000000001', 'd0000000-0000-4000-8000-000000000005', 8500.00, 48.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000002', 'd4000000-0000-4000-8000-000000000002', 'd0000000-0000-4000-8000-000000000006', 6200.00, 39.50, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000003', 'd4000000-0000-4000-8000-000000000003', 'd0000000-0000-4000-8000-000000000004', 7900.00, 52.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000004', 'd4000000-0000-4000-8000-000000000004', 'd0000000-0000-4000-8000-000000000010', 9100.00, 36.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000005', 'd4000000-0000-4000-8000-000000000005', 'd0000000-0000-4000-8000-000000000011', 6800.00, 33.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000006', 'd4000000-0000-4000-8000-000000000006', 'd0000000-0000-4000-8000-000000000012', 7300.00, 43.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000007', 'd4000000-0000-4000-8000-000000000007', 'd0000000-0000-4000-8000-000000000017', 9400.00, 39.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000008', 'd4000000-0000-4000-8000-000000000008', 'd0000000-0000-4000-8000-000000000018', 7100.00, 55.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000009', 'd4000000-0000-4000-8000-000000000009', 'd0000000-0000-4000-8000-000000000019', 7600.00, 46.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000010', 'd4000000-0000-4000-8000-000000000010', 'd0000000-0000-4000-8000-000000000020', 8800.00, 35.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000011', 'd4000000-0000-4000-8000-000000000011', 'd0000000-0000-4000-8000-000000000021', 6500.00, 38.00, 'DEMO_RANCHO_PRUEBAS_2026'),
  ('d5000000-0000-4000-8000-000000000012', 'd4000000-0000-4000-8000-000000000012', 'd0000000-0000-4000-8000-000000000022', 8200.00, 54.00, 'DEMO_RANCHO_PRUEBAS_2026')
ON CONFLICT (id) DO UPDATE SET
  id_venta = EXCLUDED.id_venta,
  id_animal = EXCLUDED.id_animal,
  precio = EXCLUDED.precio,
  peso = EXCLUDED.peso,
  notas = EXCLUDED.notas
WHERE public.detalle_venta.notas = 'DEMO_RANCHO_PRUEBAS_2026';

UPDATE public.animales
SET estado = 'vendido'
WHERE id IN (
  'd0000000-0000-4000-8000-000000000004',
  'd0000000-0000-4000-8000-000000000005',
  'd0000000-0000-4000-8000-000000000006',
  'd0000000-0000-4000-8000-000000000010',
  'd0000000-0000-4000-8000-000000000011',
  'd0000000-0000-4000-8000-000000000012',
  'd0000000-0000-4000-8000-000000000017',
  'd0000000-0000-4000-8000-000000000018',
  'd0000000-0000-4000-8000-000000000019',
  'd0000000-0000-4000-8000-000000000020',
  'd0000000-0000-4000-8000-000000000021',
  'd0000000-0000-4000-8000-000000000022'
)
  AND notas = 'DEMO_RANCHO_PRUEBAS_2026';

SELECT 'Datos ficticios DEMO cargados: 22 animales, 12 registros reproductivos, 45 pesajes, 12 eventos de salud y 12 ventas en fechas distribuidas a lo largo de varios meses. Para retirarlos, ejecutar database/demo_data_cleanup.sql.' AS resultado;

COMMIT;
