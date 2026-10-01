-- Configura a Valeria como administradora cuando esta sea la unica cuenta.
-- Ejecuta este archivo una sola vez en Supabase > SQL Editor.
DO $$
DECLARE
  account_count integer;
  account_id uuid;
BEGIN
  SELECT count(*) INTO account_count FROM auth.users;
  IF account_count <> 1 THEN
    RAISE EXCEPTION
      'Se esperaba exactamente una cuenta en auth.users; se encontraron %.',
      account_count;
  END IF;

  SELECT id INTO account_id FROM auth.users;

  UPDATE auth.users
  SET raw_user_meta_data = coalesce(raw_user_meta_data, '{}'::jsonb)
    || jsonb_build_object('nombre', 'Valeria Castro Leyva', 'rol', 'admin')
  WHERE id = account_id;

  INSERT INTO public.usuarios (id, nombre, rol)
  VALUES (account_id, 'Valeria Castro Leyva', 'admin')
  ON CONFLICT (id) DO UPDATE SET
    nombre = excluded.nombre,
    rol = excluded.rol;
END;
$$;
