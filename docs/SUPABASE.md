# Supabase — cadastro e login de usuários

Status: ✅ **conectado.** Login, cadastro e sincronização de diário/configurações
já funcionam em `simulador-vwap.html`.

## Onde estão as credenciais

`SUPABASE_URL` e `SUPABASE_ANON_KEY` ficam num bloco comentado perto do topo
do `<script>` em `simulador-vwap.html` (procure por `const SUPABASE_URL`).
Se o projeto Supabase for recriado, troque os dois valores ali.

A chave `anon` é pública por design — ela só funciona dentro do que as
políticas de RLS permitirem, então não tem problema ela estar visível no
código do site. A chave `service_role` (essa sim secreta) nunca é usada aqui.

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

Se for um projeto Supabase novo, rode só `schema.sql` (já vem correto).
Se seu projeto já existia antes desta atualização, rode também, nessa ordem:
1. `migration_001_ajuste_trades.sql` — corrige os tipos de duas colunas que
   não batiam com o formato real que o app usa (`data`/`hora` como texto,
   não como data/hora de calendário).
2. `migration_002_grants.sql` — garante as permissões de tabela (`GRANT`)
   pro role `authenticated`. RLS sozinho não dá acesso a nada — ele só
   filtra quais linhas aparecem depois que o Postgres já confirmou que o
   usuário tem permissão de tabela. Sem isso, o erro é
   `permission denied for table X`, mesmo com as políticas de RLS certas.

| Tabela | Guarda | RLS |
|---|---|---|
| `profiles` | Um perfil por pessoa, criado automaticamente no cadastro | Cada um só vê/edita o próprio |
| `trades` | O diário de operações (mesmos campos do diário atual do simulador) | Cada um só vê/edita as próprias linhas |
| `progresso` | Fases concluídas do currículo, casos do Modo Exame feitos (coluna `jsonb` livre pra crescer) | Cada um só vê/edita o próprio |
| `configuracoes` | Capital, % de risco, critérios do setup, preferências (coluna `jsonb` livre) | Cada um só vê/edita o próprio |

Toda tabela nasce com **Row Level Security ligado** e uma política do tipo
`auth.uid() = user_id` — sem isso, qualquer pessoa com a chave anon conseguiria
ler a tabela inteira de todo mundo. Não é opcional aqui.

## Fluxo de navegação (Pressel → login → hub → produto)

```
tapedrill.com (Pressel, site público)
   ↓ qualquer CTA
tapedrill.com/login/ (autenticação)
   ↓ login validado
tapedrill.com/inicio/ (hub de produtos)
   ↓ escolhe TapeDrill → escolhe dificuldade
tapedrill.com/simulador-vwap.html (a ferramenta)
```

O hub em `/inicio/` é onde produtos futuros entram (ex: "Trilha de Aprendizagem",
hoje mostrado como card desativado "Em breve"). Cada produto pode ter sua própria
lógica de configuração antes de entrar — no caso do TapeDrill, é a escolha de
dificuldade, salva em `localStorage` (`simvwap_dificuldade`) antes de navegar
pro simulador, que já lê esse valor sozinho.

## Como funciona hoje

- Sem login: tudo continua salvando no `localStorage`, exatamente como antes.
- Com login: diário (`trades`) e configurações (`configuracoes`) sincronizam
  com a nuvem — ao entrar, os dados da nuvem substituem o que estava local;
  ao sair, volta a mostrar o que está salvo neste navegador.
- A tabela `progresso` já está conectada: cada caso concluído do Modo Exame
  salva uma linha (`tipo:'caso_exame'`), usada na tela "Minha conta" pra
  mostrar quantos dos 4 casos já foram feitos.

## Onde estão as credenciais

**Não commitar a `anon key` disfarçada de segredo é desnecessário** (ela é pública
por design), mas ainda assim, pra manter organizado, o valor real vai ficar
declarado dentro do próprio `simulador-vwap.html` num bloco `const SUPABASE_CONFIG`
perto do topo do `<script>`, com comentário indicando onde trocar se o projeto
Supabase mudar.
