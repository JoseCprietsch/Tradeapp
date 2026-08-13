# Currículo — Professor Trade

Registro do progresso no curso de day trade, pra não depender só da memória
das conversas com o Claude. Progressão sempre por **competência, nunca por tempo**.

## Fases

| Fase | Conteúdo | Status |
|---|---|---|
| **0** | Fundamento estatístico — EV, R/R, win rate vs. payoff, variância | ✅ Concluída |
| **1** | Estrutura de mercado — fluxo institucional, iceberg, dark pools, VWAP, "tocar vs. sustentar" um nível, sizing de posição | ✅ Concluída |
| **2** | Macro e catalisadores — calendário econômico, "surpresa vs. consenso", "compra o boato, vende o fato" | ✅ Concluída |
| **3** | Um único setup + 100+ trades simulados com diário obrigatório | 🔲 Em andamento — é o que o simulador deste repo serve pra treinar |
| **4** | Capital real mínimo, risco de 0,25–0,5% por operação | ⏳ Condicionada à Fase 3 |
| **5** | Escala condicional — só com 200+ trades reais com expectância positiva | ⏳ Futura |

## Princípios inegociáveis (valem pra qualquer fase)

- Pensar em **EV e probabilidade**, nunca em certeza — nenhuma ferramenta garante resultado
- **R/R mínimo de 1:2 a 1:3** — preservação de capital antes de expectativa de ganho
- **Fluxo institucional** (VWAP, sustentação, volume) acima de padrão gráfico puro
- **Honestidade epistêmica**: 74–89% dos day traders de varejo perdem dinheiro de forma
  persistente (consistente com dados da CVM/FGV no Brasil) — isso orienta o desenho
  de toda ferramenta aqui, não é rodapé
- Retail não compete com HFT em velocidade — a vantagem possível é seletividade
  extrema em timeframes mais altos, com risco controlado

## Ferramentas já entregues

- **Excel EV Simulation** — calculadora de EV, comparação de cenários, Monte Carlo de 1.000 trades
- **Diário de Trades (Excel)** — 150 linhas, dropdown validado, dashboard com win rate/expectância/payoff
- **Simulador HTML** (este repositório) — pregão sintético, gate de critérios, boleta com
  sizing por risco, diário integrado, Modo Exame com 4 casos desenhados à mão

## O setup que o simulador treina

Rejeição no VWAP (2+ vezes) → rompimento → sustentação mínima → volume acima da
média → sem catalisador de alto impacto nos próximos 30-60min → R/R ≥ 1,5:1.
Os 4 critérios exatos (editáveis) estão no gate do simulador.

## Investidores estudados (dossiê de referência)

Graham, Buffett, Soros, Dalio, Lynch, e um grupo de VCs (Sequoia, HongShan, a16z).
Padrões transversais: sistema explícito, assimetria de risco/retorno, horizonte
longo e compounding, falhas formativas, temperamento acima de QI. Nenhum construiu
patrimônio via day trade intradiário — framing usado em `metodo.html`.
