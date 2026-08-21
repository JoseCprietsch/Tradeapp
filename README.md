# TapeDrill

Site + simulador de pregão sintético para treinar leitura de fluxo, rejeições
no VWAP e disciplina de risco antes de operar com capital real.

🔗 **No ar em:** https://tapedrill.com

## Comece por aqui

| Se você quer... | Vá em... |
|---|---|
| Ver como o repositório inteiro se organiza | [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md) |
| Saber em que fase do curso o projeto está | [`docs/CURRICULO.md`](docs/CURRICULO.md) |
| Ver o roadmap de ferramentas profissionais (Book, Times & Trades, VAP, barra de estudos) | [`docs/TAPEDRILL_PRO.md`](docs/TAPEDRILL_PRO.md) |
| Ver o que muda entre Iniciante/Intermediário/Trader | [`docs/NIVEIS_DIFICULDADE.md`](docs/NIVEIS_DIFICULDADE.md) |
| Configurar login/cadastro (Supabase) | [`docs/SUPABASE.md`](docs/SUPABASE.md) |
| Mexer no visual do site (home/método/cenários) | [`assets/style.css`](assets/style.css) |
| Mexer no simulador em si | [`simulador-vwap.html`](simulador-vwap.html) — mapa de seções no comentário do topo do arquivo |

## O que tem aqui

- **Home, Método, Cenários** — páginas de apresentação do projeto
- **Login/Início** — cadastro e login via Supabase (Google OAuth + e-mail/senha), hub do produto
- **Simulador** — o app: gerador de pregão sintético, checklist de critérios,
  boleta com cálculo de posição por risco, catalisadores macro simulados,
  diário de operações com métricas, Modo Exame com 4 casos comentados,
  barra de ferramentas de desenho (linhas, setas, lápis, Fibonacci) e
  notas flutuantes
- **`supabase/schema.sql`** — script pronto pra criar as tabelas de usuário
  (diário, progresso, configurações) com Row Level Security já configurado

## Estado atual

| Peça | Status |
|---|---|
| Site (home, cenários, método) | ✅ |
| Simulador — visual e responsividade mobile | ✅ |
| Login por conta / dados na nuvem | ✅ conectado, ver `docs/SUPABASE.md` |
| Barra de estudos (desenho no gráfico) e notas flutuantes | ✅ Fase 1 concluída, Fase 2 no roadmap — ver `docs/TAPEDRILL_PRO.md` |
| Fase 3 do currículo (100+ trades simulados) | 🔲 em andamento |

## Princípios do projeto

- Progressão por **competência**, nunca por tempo
- Pensar em **EV e probabilidade** — nenhuma ferramenta aqui promete resultado
- **R/R mínimo 1:2 a 1:3**, preservação de capital antes de ganho
- Honestidade sobre os números: 74–89% dos day traders de varejo perdem
  dinheiro de forma persistente — isso orienta o desenho de tudo aqui

Mais detalhes em [`docs/CURRICULO.md`](docs/CURRICULO.md).
