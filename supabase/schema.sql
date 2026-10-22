-- Modeva Progress: Supabase schema
-- วิธีใช้: Supabase Dashboard -> SQL Editor -> New query -> วางทั้งไฟล์ -> Run

create table if not exists public.docs (
  col        text        not null,            -- works | grids | meta
  id         text        not null,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);

-- รวม JSON แบบลึก ใช้ให้ 2 คนแก้คนละช่องพร้อมกันได้โดยไม่ทับกัน
create or replace function public.jsonb_deep_merge(a jsonb, b jsonb)
returns jsonb language plpgsql immutable as $$
declare k text; r jsonb;
begin
  if jsonb_typeof(a) = 'object' and jsonb_typeof(b) = 'object' then
    r := a;
    for k in select jsonb_object_keys(b) loop
      r := jsonb_set(r, array[k], public.jsonb_deep_merge(coalesce(a -> k, 'null'::jsonb), b -> k), true);
    end loop;
    return r;
  end if;
  return b;
end $$;

create or replace function public.patch_doc(p_col text, p_id text, p_patch jsonb)
returns void language plpgsql security invoker as $$
begin
  update public.docs
     set data = public.jsonb_deep_merge(data, p_patch), updated_at = now()
   where col = p_col and id = p_id;
end $$;

-- สิทธิ์: ทุกคนอ่านได้ เฉพาะผู้ใช้ที่เข้าสู่ระบบเท่านั้นที่เขียนได้
alter table public.docs enable row level security;

drop policy if exists "docs read"   on public.docs;
drop policy if exists "docs insert" on public.docs;
drop policy if exists "docs update" on public.docs;
drop policy if exists "docs delete" on public.docs;
create policy "docs read"   on public.docs for select to anon, authenticated using (true);
create policy "docs insert" on public.docs for insert to authenticated with check (true);
create policy "docs update" on public.docs for update to authenticated using (true) with check (true);
create policy "docs delete" on public.docs for delete to authenticated using (true);

grant select on public.docs to anon;
grant select, insert, update, delete on public.docs to authenticated;
grant execute on function public.patch_doc(text, text, jsonb) to authenticated;

-- ซิงก์ทันที (Realtime)
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;
