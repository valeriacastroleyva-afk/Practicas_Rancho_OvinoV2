-- Crear perfiles y guardarlos automáticamente al registrar cuentas

CREATE TABLE IF NOT EXISTS public.usuarios (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre text,
  rol text check (rol in ('productor','veterinario','admin')),
  telefono text,
  created_at timestamp default now()
);

ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'usuarios'
      AND policyname = 'usuarios_select_propios'
  ) THEN
    CREATE POLICY usuarios_select_propios ON public.usuarios
      FOR SELECT USING (auth.uid() = id);
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'usuarios'
      AND policyname = 'usuarios_insert_propios'
  ) THEN
    CREATE POLICY usuarios_insert_propios ON public.usuarios
      FOR INSERT WITH CHECK (auth.uid() = id);
  END IF;
END;
$$;

DROP POLICY IF EXISTS usuarios_update_propios ON public.usuarios;
CREATE POLICY usuarios_update_propios ON public.usuarios
  FOR UPDATE TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

GRANT SELECT, INSERT, UPDATE ON TABLE public.usuarios TO authenticated;

CREATE OR REPLACE FUNCTION public.crear_perfil_usuario()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.usuarios (id, nombre, rol, telefono)
  VALUES (
    NEW.id,
    COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'nombre', ''), 'Usuario'),
    CASE
      WHEN NEW.raw_user_meta_data ->> 'rol' IN ('productor','veterinario','admin')
      THEN NEW.raw_user_meta_data ->> 'rol'
      ELSE NULL
    END,
    NULLIF(NEW.raw_user_meta_data ->> 'telefono', '')
  )
  ON CONFLICT (id) DO UPDATE SET
    nombre = COALESCE(EXCLUDED.nombre, public.usuarios.nombre),
    rol = COALESCE(EXCLUDED.rol, public.usuarios.rol),
    telefono = COALESCE(EXCLUDED.telefono, public.usuarios.telefono);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS crear_perfil_despues_registro ON auth.users;
CREATE TRIGGER crear_perfil_despues_registro
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.crear_perfil_usuario();

INSERT INTO public.usuarios (id, nombre, rol, telefono)
SELECT
  id,
  COALESCE(NULLIF(raw_user_meta_data ->> 'nombre', ''), 'Usuario'),
  CASE
    WHEN raw_user_meta_data ->> 'rol' IN ('productor','veterinario','admin')
    THEN raw_user_meta_data ->> 'rol'
    ELSE NULL
  END,
  NULLIF(raw_user_meta_data ->> 'telefono', '')
FROM auth.users
ON CONFLICT (id) DO NOTHING;

-- Agregar nuevos campos a la tabla animales
ALTER TABLE animales 
  ADD COLUMN IF NOT EXISTS estado_productivo text 
    CHECK (estado_productivo IN ('gestante','parida','servicio','primala','cordera','lactando','destetada','semental','engorda')),
  ADD COLUMN IF NOT EXISTS numero_partos int DEFAULT 0,
  ADD COLUMN IF NOT EXISTS tipo_nacimiento text 
    CHECK (tipo_nacimiento IN ('sencillo','doble','triple')),
  ADD COLUMN IF NOT EXISTS notas text,
  ADD COLUMN IF NOT EXISTS nombre_padre text,
  ADD COLUMN IF NOT EXISTS nombre_madre text,
  ADD COLUMN IF NOT EXISTS peso_inicial numeric(6,2);

-- Actualizar el CHECK de estado para incluir más opciones
-- (el estado original activo/vendido/muerto se mantiene igual)

-- Crear tabla de razas personalizadas
CREATE TABLE IF NOT EXISTS razas (
  id uuid primary key default gen_random_uuid(),
  nombre text unique not null,
  created_at timestamp default now()
);

-- Insertar razas base
INSERT INTO razas (nombre) VALUES 
  ('Pelibuey'),('Dorper'),('Blackbelly'),('Suffolk'),
  ('Rambouillet'),('Katahdin'),('Merino'),('Corriedale')
ON CONFLICT (nombre) DO NOTHING;

-- RLS para razas
ALTER TABLE razas ENABLE ROW LEVEL SECURITY;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'razas'
      AND policyname = 'permitir todo razas'
  ) THEN
    CREATE POLICY "permitir todo razas" ON razas
      FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
END;
$$;

-- Agregar campos a ventas
ALTER TABLE public.ventas
  ADD COLUMN IF NOT EXISTS notas text,
  ADD COLUMN IF NOT EXISTS tipo_venta text DEFAULT 'carne'
    CHECK (tipo_venta IN ('carne','pie_cria')),
  ADD COLUMN IF NOT EXISTS costo numeric(10,2);

-- Crear el detalle si la instalación existente aún no tenía esta tabla
CREATE TABLE IF NOT EXISTS detalle_venta (
  id uuid primary key default gen_random_uuid(),
  id_venta uuid not null references ventas(id) on delete cascade,
  id_animal uuid not null references animales(id),
  precio numeric(10,2),
  peso numeric(6,2),
  notas text
);

-- Agregar campos a detalle_venta  
ALTER TABLE detalle_venta
  ADD COLUMN IF NOT EXISTS notas text;

-- Sincronizar el estado del animal con los vínculos de ventas.
CREATE OR REPLACE FUNCTION sincronizar_estado_animal_venta()
RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    UPDATE public.animales
    SET estado = 'activo'
    WHERE id = OLD.id_animal
      AND estado = 'vendido'
      AND NOT EXISTS (
        SELECT 1 FROM public.detalle_venta
        WHERE id_animal = OLD.id_animal
      );
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    IF OLD.id_animal IS DISTINCT FROM NEW.id_animal THEN
      UPDATE public.animales
      SET estado = 'activo'
      WHERE id = OLD.id_animal
        AND estado = 'vendido'
        AND NOT EXISTS (
          SELECT 1 FROM public.detalle_venta
          WHERE id_animal = OLD.id_animal
        );
      UPDATE public.animales SET estado = 'vendido' WHERE id = NEW.id_animal;
    END IF;
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    UPDATE public.animales SET estado = 'vendido' WHERE id = NEW.id_animal;
    RETURN NEW;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_animal_vendido ON detalle_venta;
DROP TRIGGER IF EXISTS trigger_sincronizar_estado_animal_venta ON detalle_venta;
DROP TRIGGER IF EXISTS trigger_animal_vendido_actualizar ON detalle_venta;
DROP TRIGGER IF EXISTS trigger_animal_vendido_eliminar ON detalle_venta;
CREATE TRIGGER trigger_animal_vendido
AFTER INSERT ON detalle_venta
FOR EACH ROW EXECUTE FUNCTION sincronizar_estado_animal_venta();
CREATE TRIGGER trigger_animal_vendido_actualizar
AFTER UPDATE OF id_animal ON detalle_venta
FOR EACH ROW EXECUTE FUNCTION sincronizar_estado_animal_venta();
CREATE TRIGGER trigger_animal_vendido_eliminar
AFTER DELETE ON detalle_venta
FOR EACH ROW EXECUTE FUNCTION sincronizar_estado_animal_venta();

-- Repair sold statuses left behind by sales that have since been deleted.
UPDATE public.animales AS animal
SET estado = 'activo'
WHERE animal.estado = 'vendido'
  AND NOT EXISTS (
    SELECT 1 FROM public.detalle_venta AS detalle
    WHERE detalle.id_animal = animal.id
  );

-- Habilitar el acceso definido para el resto de las tablas de la aplicación
ALTER TABLE detalle_venta ENABLE ROW LEVEL SECURITY;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'detalle_venta'
      AND policyname = 'permitir todo detalle'
  ) THEN
    CREATE POLICY "permitir todo detalle" ON detalle_venta
      FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
END;
$$;
-- Agregar campos a salud
ALTER TABLE salud
  ADD COLUMN IF NOT EXISTS notas text;

-- Agregar campos a reproduccion
ALTER TABLE reproduccion
  ADD COLUMN IF NOT EXISTS notas text;

SELECT '✅ Actualización completada' as resultado;

-- Endurecer también las instalaciones existentes, quitando políticas abiertas previas.
GRANT USAGE ON SCHEMA public TO authenticated, service_role;
DO $$
DECLARE
  target_table text;
  existing_policy record;
BEGIN
  FOREACH target_table IN ARRAY ARRAY[
    'animales', 'reproduccion', 'produccion', 'salud',
    'ventas', 'detalle_venta', 'razas', 'usuarios'
  ]
  LOOP
    IF to_regclass(format('public.%I', target_table)) IS NULL THEN
      CONTINUE;
    END IF;

    FOR existing_policy IN
      SELECT policyname
      FROM pg_policies
      WHERE schemaname = 'public' AND tablename = target_table
    LOOP
      EXECUTE format('DROP POLICY %I ON public.%I', existing_policy.policyname, target_table);
    END LOOP;

    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', target_table);
    EXECUTE format('REVOKE ALL PRIVILEGES ON TABLE public.%I FROM anon, public', target_table);

    IF target_table = 'usuarios' THEN
      EXECUTE 'CREATE POLICY usuarios_select_propios ON public.usuarios FOR SELECT TO authenticated USING (auth.uid() = id)';
      EXECUTE 'CREATE POLICY usuarios_insert_propios ON public.usuarios FOR INSERT TO authenticated WITH CHECK (auth.uid() = id)';
      EXECUTE 'CREATE POLICY usuarios_update_propios ON public.usuarios FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id)';
      EXECUTE 'GRANT SELECT, INSERT, UPDATE ON public.usuarios TO authenticated, service_role';
    ELSE
      EXECUTE format(
        'CREATE POLICY authenticated_shared_access ON public.%I FOR ALL TO authenticated USING (true) WITH CHECK (true)',
        target_table
      );
      EXECUTE format(
        'GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.%I TO authenticated, service_role',
        target_table
      );
    END IF;
  END LOOP;
END;
$$;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM anon, public;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO authenticated, service_role;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA public FROM anon, public;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public TO authenticated, service_role;

CREATE INDEX IF NOT EXISTS idx_animales_created_at ON public.animales (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reproduccion_created_at ON public.reproduccion (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reproduccion_fecha_empadre ON public.reproduccion (fecha_empadre DESC);
CREATE INDEX IF NOT EXISTS idx_produccion_fecha ON public.produccion (fecha DESC);
CREATE INDEX IF NOT EXISTS idx_produccion_animal_fecha ON public.produccion (id_animal, fecha DESC);
CREATE INDEX IF NOT EXISTS idx_salud_fecha ON public.salud (fecha DESC);
CREATE INDEX IF NOT EXISTS idx_salud_animal_fecha ON public.salud (id_animal, fecha DESC);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON public.ventas (fecha DESC);
CREATE INDEX IF NOT EXISTS idx_detalle_venta_id_venta ON public.detalle_venta (id_venta);
CREATE INDEX IF NOT EXISTS idx_detalle_venta_id_animal ON public.detalle_venta (id_animal);

NOTIFY pgrst, 'reload schema';
