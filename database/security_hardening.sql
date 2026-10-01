-- Run in the Supabase SQL editor for an existing installation.
-- Authenticated users intentionally share one ranch; per-ranch isolation
-- requires adding an ownership/tenant key before changing these policies.
begin;

grant usage on schema public to authenticated, service_role;

do $$
declare
  target_table text;
  existing_policy record;
begin
  foreach target_table in array array[
    'animales', 'reproduccion', 'produccion', 'salud',
    'ventas', 'detalle_venta', 'razas', 'usuarios'
  ]
  loop
    if to_regclass(format('public.%I', target_table)) is null then
      continue;
    end if;

    for existing_policy in
      select policyname
      from pg_policies
      where schemaname = 'public' and tablename = target_table
    loop
      execute format('drop policy %I on public.%I', existing_policy.policyname, target_table);
    end loop;

    execute format('alter table public.%I enable row level security', target_table);
    execute format('revoke all privileges on table public.%I from anon, public', target_table);

    if target_table = 'usuarios' then
      execute 'create policy usuarios_select_propios on public.usuarios for select to authenticated using (auth.uid() = id)';
      execute 'create policy usuarios_insert_propios on public.usuarios for insert to authenticated with check (auth.uid() = id)';
      execute 'create policy usuarios_update_propios on public.usuarios for update to authenticated using (auth.uid() = id) with check (auth.uid() = id)';
      execute 'grant select, insert, update on public.usuarios to authenticated, service_role';
    else
      execute format(
        'create policy authenticated_shared_access on public.%I for all to authenticated using (true) with check (true)',
        target_table
      );
      execute format(
        'grant select, insert, update, delete on table public.%I to authenticated, service_role',
        target_table
      );
    end if;
  end loop;
end;
$$;

revoke all privileges on all sequences in schema public from anon, public;
grant all privileges on all sequences in schema public to authenticated, service_role;
revoke execute on all routines in schema public from anon, public;
grant execute on all routines in schema public to authenticated, service_role;

commit;
