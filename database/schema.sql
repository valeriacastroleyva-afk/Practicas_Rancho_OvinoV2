-- =============================================
-- SCHEMA.SQL — Rancho Ovino
-- Ejecuta este archivo en Supabase > SQL Editor
-- =============================================

create extension if not exists "pgcrypto";

-- 1. USUARIOS
create table usuarios (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre text,
  rol text check (rol in ('productor','veterinario','admin')),
  telefono text,
  created_at timestamp default now()
);

create or replace function public.crear_perfil_usuario()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.usuarios (id, nombre, rol, telefono)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'nombre', ''), 'Usuario'),
    case
      when new.raw_user_meta_data ->> 'rol' in ('productor','veterinario','admin')
      then new.raw_user_meta_data ->> 'rol'
      else null
    end,
    nullif(new.raw_user_meta_data ->> 'telefono', '')
  )
  on conflict (id) do update set
    nombre = coalesce(excluded.nombre, public.usuarios.nombre),
    rol = coalesce(excluded.rol, public.usuarios.rol),
    telefono = coalesce(excluded.telefono, public.usuarios.telefono);
  return new;
end;
$$;

create trigger crear_perfil_despues_registro
after insert on auth.users
for each row execute function public.crear_perfil_usuario();

insert into public.usuarios (id, nombre, rol, telefono)
select
  id,
  coalesce(nullif(raw_user_meta_data ->> 'nombre', ''), 'Usuario'),
  case
    when raw_user_meta_data ->> 'rol' in ('productor','veterinario','admin')
    then raw_user_meta_data ->> 'rol'
    else null
  end,
  nullif(raw_user_meta_data ->> 'telefono', '')
from auth.users
on conflict (id) do nothing;

-- 2. ANIMALES
create table animales (
  id uuid primary key default gen_random_uuid(),
  identificador text unique not null,
  nombre text,
  especie text default 'borrego',
  raza text,
  sexo text check (sexo in ('macho','hembra')) not null,
  fecha_nacimiento date,
  fecha_ingreso date default now(),
  estado text default 'activo' check (estado in ('activo','vendido','muerto')),
  imagen_url text,
  id_padre uuid,
  id_madre uuid,
  created_at timestamp default now(),
  constraint fk_padre foreign key (id_padre) references animales(id),
  constraint fk_madre foreign key (id_madre) references animales(id)
);

-- 3. REPRODUCCIÓN
create table reproduccion (
  id uuid primary key default gen_random_uuid(),
  id_hembra uuid not null,
  id_macho uuid not null,
  fecha_empadre date not null,
  fecha_parto_estimada date,
  fecha_parto_real date,
  numero_crias int,
  estado text default 'gestando' check (estado in ('gestando','pario','fallido')),
  observaciones text,
  created_at timestamp default now(),
  constraint fk_hembra foreign key (id_hembra) references animales(id),
  constraint fk_macho  foreign key (id_macho)  references animales(id)
);

-- Trigger: calcular fecha parto automáticamente (5 meses)
create or replace function calcular_parto()
returns trigger as $$
begin
  new.fecha_parto_estimada := new.fecha_empadre + interval '5 months';
  return new;
end;
$$ language plpgsql;

create trigger trigger_calcular_parto
before insert on reproduccion
for each row execute function calcular_parto();

-- 4. PRODUCCIÓN (PESOS)
create table produccion (
  id uuid primary key default gen_random_uuid(),
  id_animal uuid not null,
  fecha date not null,
  peso numeric(6,2),
  observaciones text,
  created_at timestamp default now(),
  constraint fk_animal_produccion foreign key (id_animal) references animales(id) on delete cascade,
  constraint unique_peso_por_dia unique (id_animal, fecha)
);

-- 5. SALUD
create table salud (
  id uuid primary key default gen_random_uuid(),
  id_animal uuid not null,
  id_usuario uuid,
  fecha date not null,
  tipo text check (tipo in ('enfermedad','vacuna','tratamiento','desparasitacion')),
  diagnostico text,
  tratamiento text,
  medicamento text,
  dosis text,
  observaciones text,
  created_at timestamp default now(),
  constraint fk_animal_salud  foreign key (id_animal)  references animales(id) on delete cascade,
  constraint fk_usuario_salud foreign key (id_usuario) references usuarios(id)
);

-- 6. VENTAS
create table ventas (
  id uuid primary key default gen_random_uuid(),
  fecha date default now(),
  cliente text,
  tipo_venta text default 'carne' check (tipo_venta in ('carne','pie_cria')),
  total numeric(10,2),
  costo numeric(10,2),
  notas text,
  created_at timestamp default now()
);

-- 7. DETALLE DE VENTA
create table detalle_venta (
  id uuid primary key default gen_random_uuid(),
  id_venta uuid not null,
  id_animal uuid not null,
  precio numeric(10,2),
  peso numeric(6,2),
  constraint fk_venta        foreign key (id_venta)  references ventas(id)   on delete cascade,
  constraint fk_animal_venta foreign key (id_animal) references animales(id)
);

create index if not exists idx_animales_created_at on animales (created_at desc);
create index if not exists idx_reproduccion_created_at on reproduccion (created_at desc);
create index if not exists idx_reproduccion_fecha_empadre on reproduccion (fecha_empadre desc);
create index if not exists idx_produccion_fecha on produccion (fecha desc);
create index if not exists idx_produccion_animal_fecha on produccion (id_animal, fecha desc);
create index if not exists idx_salud_fecha on salud (fecha desc);
create index if not exists idx_salud_animal_fecha on salud (id_animal, fecha desc);
create index if not exists idx_ventas_fecha on ventas (fecha desc);
create index if not exists idx_detalle_venta_id_venta on detalle_venta (id_venta);
create index if not exists idx_detalle_venta_id_animal on detalle_venta (id_animal);

-- Mantener el estado del animal sincronizado con sus vínculos a ventas.
create or replace function sincronizar_estado_animal_venta()
returns trigger as $$
begin
  if TG_OP = 'DELETE' then
    update public.animales
    set estado = 'activo'
    where id = OLD.id_animal
      and estado = 'vendido'
      and not exists (
        select 1 from public.detalle_venta
        where id_animal = OLD.id_animal
      );
    return OLD;
  elsif TG_OP = 'UPDATE' then
    if OLD.id_animal is distinct from NEW.id_animal then
      update public.animales
      set estado = 'activo'
      where id = OLD.id_animal
        and estado = 'vendido'
        and not exists (
          select 1 from public.detalle_venta
          where id_animal = OLD.id_animal
        );
      update public.animales set estado = 'vendido' where id = NEW.id_animal;
    end if;
    return NEW;
  elsif TG_OP = 'INSERT' then
    update public.animales set estado = 'vendido' where id = NEW.id_animal;
    return NEW;
  end if;

  return NEW;
end;
$$ language plpgsql;

create trigger trigger_animal_vendido
after insert on detalle_venta
for each row execute function sincronizar_estado_animal_venta();

create trigger trigger_animal_vendido_actualizar
after update of id_animal on detalle_venta
for each row execute function sincronizar_estado_animal_venta();

create trigger trigger_animal_vendido_eliminar
after delete on detalle_venta
for each row execute function sincronizar_estado_animal_venta();

-- =============================================
-- ROW LEVEL SECURITY
-- Los usuarios autenticados comparten los datos de un solo rancho.
-- Si se necesitan varios ranchos, se debe añadir tenant_id antes de cambiar estas políticas.
-- =============================================
alter table animales     enable row level security;
alter table usuarios     enable row level security;
alter table reproduccion enable row level security;
alter table produccion   enable row level security;
alter table salud        enable row level security;
alter table ventas       enable row level security;
alter table detalle_venta enable row level security;

create policy "permitir todo animales"      on animales      for all to authenticated using (true) with check (true);
create policy usuarios_select_propios on usuarios
  for select to authenticated using (auth.uid() = id);
create policy usuarios_insert_propios on usuarios
  for insert to authenticated with check (auth.uid() = id);
create policy usuarios_update_propios on usuarios
  for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);
create policy "permitir todo reproduccion"  on reproduccion  for all to authenticated using (true) with check (true);
create policy "permitir todo produccion"    on produccion    for all to authenticated using (true) with check (true);
create policy "permitir todo salud"         on salud         for all to authenticated using (true) with check (true);
create policy "permitir todo ventas"        on ventas        for all to authenticated using (true) with check (true);
create policy "permitir todo detalle"       on detalle_venta for all to authenticated using (true) with check (true);

-- Permisos SQL requeridos por la API de Supabase; RLS sigue aplicando sus políticas
grant usage on schema public to authenticated, service_role;
grant select, insert, update, delete on
  animales, reproduccion, produccion, salud, ventas, detalle_venta
  to authenticated, service_role;
grant select, insert, update on usuarios to authenticated, service_role;
grant all privileges on all sequences in schema public to authenticated, service_role;
grant execute on all routines in schema public to authenticated, service_role;
revoke all privileges on
  animales, usuarios, reproduccion, produccion, salud, ventas, detalle_venta
  from anon, public;
revoke all privileges on all sequences in schema public from anon, public;
revoke execute on all routines in schema public from anon, public;
