-- ============================================================
-- Migração 001 — ajusta a tabela trades pro formato real do app
-- Rode isso em: Supabase Dashboard → SQL Editor → New query → Run
-- Seguro mesmo com a tabela já criada: ela ainda está vazia.
-- ============================================================

alter table public.trades alter column data type text using data::text;
alter table public.trades alter column hora type text using hora::text;
alter table public.trades add column if not exists criterios jsonb;
