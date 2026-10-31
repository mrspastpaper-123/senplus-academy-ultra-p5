-- Schema only. Never put question payloads or answer keys in this repository.
-- The private seed is a separate owner-only deliverable, executed in SQL Editor.
begin;
create table if not exists public.paper_generator_banks (
  bank_key text primary key,
  version text not null,
  payload jsonb not null check (jsonb_typeof(payload) = 'object'),
  updated_at timestamptz not null default now()
);
-- Refuse to proceed if a pre-existing policy would broaden this new boundary.
do $$
begin
  if exists (
    select 1 from pg_policies where schemaname='public' and tablename='paper_generator_banks'
      and policyname <> 'paper_generator_enabled_admin_select'
  ) then
    raise exception 'Unexpected existing policies on paper_generator_banks; review them before continuing.';
  end if;
end;
$$;
alter table public.paper_generator_banks enable row level security;
alter table public.paper_generator_banks force row level security;
revoke all on table public.paper_generator_banks from public, anon, authenticated;
grant select on table public.paper_generator_banks to authenticated;
drop policy if exists paper_generator_enabled_admin_select on public.paper_generator_banks;
create policy paper_generator_enabled_admin_select
  on public.paper_generator_banks for select to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = (select auth.uid())
        and p.role = 'admin'
        and p.login_allowed is true
    )
  );
-- No insert/update/delete grants or policies for browser roles.
comment on table public.paper_generator_banks is 'Private admin-only examination content. Never export payloads to a public repository.';
commit;
