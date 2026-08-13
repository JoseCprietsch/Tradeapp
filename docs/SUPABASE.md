# Supabase — cadastro e login de usuários

Status: 🔲 **planejado, ainda não conectado ao simulador.**

## Por quê

O simulador hoje salva diário/progresso só no `localStorage` do navegador —
some se trocar de aparelho ou limpar os dados do navegador. A ideia é permitir
conta própria pra cada pessoa, com diário e progresso salvos na nuvem.

## Passo a passo pra criar o projeto

1. Em [supabase.com/dashboard](https://supabase.com/dashboard), **New project**.
   Nome sugerido: `pregao-de-treino`. Região: **São Paulo (sa-east-1)**.
2. **Authentication → Providers**: "Email" já vem ativado por padrão.
   Google OAuth pode ser adicionado depois, não é bloqueante.
3. **Authentication → URL Configuration**: definir a Site URL como
   `https://josecprietsch.github.io/Tradeapp/`.
4. **SQL Editor → New query**: colar o conteúdo de `/supabase/schema.sql`
   deste repositório e rodar (`Run`).
5. **Project Settings → API**: copiar `Project URL` e a chave `anon public`.

## As duas chaves — qual pode ficar pública

| Chave | Pode aparecer no código do site? |
|---|---|
| `anon` (pública) | **Sim.** Ela só funciona dentro dos limites que o RLS permitir — sozinha não dá acesso a nada que a política não libere. |
| `service_role` (chave mestra) | **Nunca.** Ignora todo RLS. Só pode existir em servidor, nunca em HTML/JS que vai pro navegador. Este projeto não usa essa chave em lugar nenhum do front-end. |

## O que o `schema.sql` cria

| Tabela | Guarda | RLS |
|---|---|---|
| `profiles` | Um perfil por pessoa, criado automaticamente no cadastro | Cada um só vê/edita o próprio |
| `trades` | O diário de operações (mesmos campos do diário atual do simulador) | Cada um só vê/edita as próprias linhas |
| `progresso` | Fases concluídas do currículo, casos do Modo Exame feitos (coluna `jsonb` livre pra crescer) | Cada um só vê/edita o próprio |
| `configuracoes` | Capital, % de risco, critérios do setup, preferências (coluna `jsonb` livre) | Cada um só vê/edita o próprio |

Toda tabela nasce com **Row Level Security ligado** e uma política do tipo
`auth.uid() = user_id` — sem isso, qualquer pessoa com a chave anon conseguiria
ler a tabela inteira de todo mundo. Não é opcional aqui.

## Depois de configurado

Quando a URL + chave anon estiverem em mãos, o próximo passo é adicionar ao
`simulador-vwap.html`:
- SDK `@supabase/supabase-js` via CDN
- Tela de login/cadastro (email+senha, com Google como próxima etapa)
- Troca do `localStorage` por leitura/escrita nas tabelas acima quando logado
- Uso sem login continua funcionando normalmente (localStorage como está hoje)

## Onde estão as credenciais

**Não commitar a `anon key` disfarçada de segredo é desnecessário** (ela é pública
por design), mas ainda assim, pra manter organizado, o valor real vai ficar
declarado dentro do próprio `simulador-vwap.html` num bloco `const SUPABASE_CONFIG`
perto do topo do `<script>`, com comentário indicando onde trocar se o projeto
Supabase mudar.
