-- ============================================================
-- TEAM ALUM — VISITOR COUNTER
-- Run this in: Supabase Dashboard > SQL Editor > New query
-- ============================================================

-- 1. Stats table (single row, id = 1)
create table if not exists public.site_stats (
  id int primary key default 1,
  total_visits bigint not null default 0,
  updated_at timestamptz not null default now(),
  constraint site_stats_single_row check (id = 1)
);

insert into public.site_stats (id) values (1) on conflict (id) do nothing;

-- 2. Atomic increment function (bypasses RLS via SECURITY DEFINER)
create or replace function public.increment_visits()
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  new_count bigint;
begin
  update public.site_stats
     set total_visits = total_visits + 1,
         updated_at = now()
   where id = 1
  returning total_visits into new_count;

  return new_count;
end;
$$;

-- 3. Anyone can increment; nobody can write to the table directly
grant execute on function public.increment_visits() to anon, authenticated;
revoke all on table public.site_stats from anon;

-- 4. Row Level Security: read-only for everyone, writes only via the function
alter table public.site_stats enable row level security;

drop policy if exists "site_stats read" on public.site_stats;
create policy "site_stats read"
  on public.site_stats for select
  to anon, authenticated
  using (true);
