-- ============================================================
-- Migração 002 — garante as permissões de tabela (GRANT) que faltavam
-- Rode isso em: Supabase Dashboard → SQL Editor → New query → Run
-- Seguro rodar mesmo que já esteja certo, não duplica nem apaga nada.
--
-- Por quê: RLS (Row Level Security) sozinho não dá acesso a nada — ele
-- só FILTRA quais linhas aparecem depois que o Postgres já confirmou
-- que o usuário tem permissão de tabela. Sem o GRANT abaixo, o erro é
-- "permission denied for table X", mesmo com as políticas de RLS certas.
-- ============================================================

grant usage on schema public to authenticated, anon;

grant select, insert, update, delete on public.profiles     to authenticated;
grant select, insert, update, delete on public.trades       to authenticated;
grant select, insert, update, delete on public.progresso    to authenticated;
grant select, insert, update, delete on public.configuracoes to authenticated;
