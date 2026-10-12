-- 3-qism: kino lavhalari. Guruh a'zolari YouTube'dagi sahnalarni darsga qo'shadi; video YouTube'dan o'ynaydi.
create table if not exists public.clips (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  lesson text not null,
  video text not null check (video ~ '^[A-Za-z0-9_-]{11}$'),
  start_s int not null default 0 check (start_s >= 0),
  phrase text not null default '' check (length(phrase) <= 200)
);
alter table public.clips enable row level security;
create policy "clips read" on public.clips for select to authenticated using (true);
create policy "clips add own" on public.clips for insert to authenticated with check (auth.uid() = user_id);
create policy "clips delete own" on public.clips for delete to authenticated
  using (auth.uid() = user_id or exists (select 1 from public.roles r where r.user_id = auth.uid() and r.role = 'admin'));
grant select, insert, delete on public.clips to authenticated;
