# Pregão de Treino

Site + simulador de pregão sintético para treinar leitura de fluxo, rejeições
no VWAP e disciplina de risco antes de operar com capital real.

🔗 **No ar em:** https://josecprietsch.github.io/Tradeapp/

## Comece por aqui

| Se você quer... | Vá em... |
|---|---|
| Ver como o repositório inteiro se organiza | [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md) |
| Saber em que fase do curso o projeto está | [`docs/CURRICULO.md`](docs/CURRICULO.md) |
| Ver o plano de ferramentas profissionais (Book, Times & Trades, VAP) | [`docs/TAPEDRILL_PRO.md`](docs/TAPEDRILL_PRO.md) |
| Ver o que muda entre Iniciante/Intermediário/Trader | [`docs/NIVEIS_DIFICULDADE.md`](docs/NIVEIS_DIFICULDADE.md) |
| Configurar login/cadastro (Supabase) | [`docs/SUPABASE.md`](docs/SUPABASE.md) |
| Mexer no visual do site (home/método/cenários) | [`assets/style.css`](assets/style.css) |
| Mexer no simulador em si | [`simulador-vwap.html`](simulador-vwap.html) — mapa de seções no comentário do topo do arquivo |

## O que tem aqui

- **Home, Método, Cenários** — páginas de apresentação do projeto
- **Simulador** — o app: gerador de pregão sintético, checklist de critérios,
  boleta com cálculo de posição por risco, catalisadores macro simulados,
  diário de operações com métricas, e um Modo Exame com 4 casos comentados
- **`supabase/schema.sql`** — script pronto pra criar as tabelas de usuário
  (diário, progresso, configurações) com Row Level Security já configurado

## Estado atual

| Peça | Status |
|---|---|
| Site (home, cenários, método) | ✅ |
| Simulador — visual e responsividade mobile | ✅ |
| Login por conta / dados na nuvem | 🔲 planejado, ver `docs/SUPABASE.md` |
| Fase 3 do currículo (100+ trades simulados) | 🔲 em andamento |

## Princípios do projeto

- Progressão por **competência**, nunca por tempo
- Pensar em **EV e probabilidade** — nenhuma ferramenta aqui promete resultado
- **R/R mínimo 1:2 a 1:3**, preservação de capital antes de ganho
- Honestidade sobre os números: 74–89% dos day traders de varejo perdem
  dinheiro de forma persistente — isso orienta o desenho de tudo aqui

Mais detalhes em [`docs/CURRICULO.md`](docs/CURRICULO.md).
