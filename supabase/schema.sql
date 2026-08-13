-- ============================================================
-- Pregão de Treino — schema inicial (Supabase / Postgres)
-- Rode isso em: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- ---------- perfis ----------
-- Um perfil por usuário autenticado. Criado automaticamente no primeiro login.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "usuário vê o próprio perfil"
  on public.profiles for select
  using (auth.uid() = id);

create policy "usuário edita o próprio perfil"
  on public.profiles for update
  using (auth.uid() = id);

create policy "usuário cria o próprio perfil"
  on public.profiles for insert
  with check (auth.uid() = id);


-- ---------- diário de operações ----------
create table if not exists public.trades (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  data date not null,
  hora time not null,
  ativo text not null,
  lado text not null check (lado in ('buy','sell')),
  qtd numeric not null,
  entrada numeric not null,
  saida numeric not null,
  motivo text,
  resultado numeric not null,
  r numeric not null,
  emocional int,
  seguiu_processo boolean,
  perto_evento boolean,
  nota text,
  created_at timestamptz not null default now()
);

alter table public.trades enable row level security;

create policy "usuário vê o próprio diário"
  on public.trades for select
  using (auth.uid() = user_id);

create policy "usuário insere no próprio diário"
  on public.trades for insert
  with check (auth.uid() = user_id);

create policy "usuário edita o próprio diário"
  on public.trades for update
  using (auth.uid() = user_id);

create policy "usuário apaga do próprio diário"
  on public.trades for delete
  using (auth.uid() = user_id);

create index if not exists trades_user_id_idx on public.trades(user_id);


-- ---------- progresso no currículo ----------
-- Uma linha por item de progresso (fase concluída, caso do Modo Exame feito, etc.)
create table if not exists public.progresso (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  tipo text not null,              -- ex: 'fase', 'caso_exame'
  chave text not null,             -- ex: 'fase_3', 'caso_2'
  status text not null default 'concluido',
  detalhe jsonb,                   -- espaço livre pra dados extras sem precisar migrar schema depois
  updated_at timestamptz not null default now(),
  unique (user_id, tipo, chave)
);

alter table public.progresso enable row level security;

create policy "usuário vê o próprio progresso"
  on public.progresso for select
  using (auth.uid() = user_id);

create policy "usuário insere o próprio progresso"
  on public.progresso for insert
  with check (auth.uid() = user_id);

create policy "usuário atualiza o próprio progresso"
  on public.progresso for update
  using (auth.uid() = user_id);


-- ---------- configurações pessoais ----------
-- Uma linha por usuário. jsonb livre pra ir crescendo sem precisar alterar tabela.
create table if not exists public.configuracoes (
  user_id uuid primary key references auth.users(id) on delete cascade,
  capital_total numeric default 1000,
  risco_pct numeric default 1,
  criterios jsonb,
  preferencias jsonb,
  updated_at timestamptz not null default now()
);

alter table public.configuracoes enable row level security;

create policy "usuário vê a própria configuração"
  on public.configuracoes for select
  using (auth.uid() = user_id);

create policy "usuário insere a própria configuração"
  on public.configuracoes for insert
  with check (auth.uid() = user_id);

create policy "usuário atualiza a própria configuração"
  on public.configuracoes for update
  using (auth.uid() = user_id);


-- ---------- cria perfil automaticamente no primeiro cadastro ----------
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, new.raw_user_meta_data->>'display_name');
  return new;
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
