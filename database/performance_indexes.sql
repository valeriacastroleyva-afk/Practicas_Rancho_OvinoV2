-- Optional indexes for sorting, animal lookups, and linked sale details.
-- Safe to run repeatedly on an existing Supabase database.
create index if not exists idx_animales_created_at
  on public.animales (created_at desc);
create index if not exists idx_reproduccion_created_at
  on public.reproduccion (created_at desc);
create index if not exists idx_reproduccion_fecha_empadre
  on public.reproduccion (fecha_empadre desc);
create index if not exists idx_produccion_fecha
  on public.produccion (fecha desc);
create index if not exists idx_produccion_animal_fecha
  on public.produccion (id_animal, fecha desc);
create index if not exists idx_salud_fecha
  on public.salud (fecha desc);
create index if not exists idx_salud_animal_fecha
  on public.salud (id_animal, fecha desc);
create index if not exists idx_ventas_fecha
  on public.ventas (fecha desc);
create index if not exists idx_detalle_venta_id_venta
  on public.detalle_venta (id_venta);
create index if not exists idx_detalle_venta_id_animal
  on public.detalle_venta (id_animal);
