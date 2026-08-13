# Tradeapp — Simulador VWAP + Currículo de Day Trade

Repositório central do projeto de formação em day trade (currículo "Professor Trade") e das ferramentas desenvolvidas ao longo das fases.

## Ferramenta principal

**`simulador-vwap.html`** — simulador de pregão sintético, 100% offline (basta abrir no navegador). Recursos:

- Gerador de pregão com regimes de *range* (rejeições no VWAP) e *tendência* (rompimentos)
- **Gate de critérios**: checklist obrigatório dos 4 critérios do setup antes de liberar a boleta
- **Sizing por risco**: capital total + % de risco por operação → quantidade sugerida automaticamente (Risco ÷ distância do stop)
- **Catalisadores macro simulados**: eventos que injetam volatilidade no meio do pregão (disciplina da Fase 2)
- Execução conservadora de stop/alvo (stop tem prioridade se o candle tocar ambos)
- **Diário integrado** com estado emocional, "segui o processo?", taxa de acerto, expectância em R e payoff ratio
- **Modo Exame**: 4 casos desenhados à mão com ponto de decisão, gabarito comentado e continuação do pregão ("ver o que aconteceu depois")
- Importação de CSV do TradingView e exportação do diário

## Estado do currículo

| Fase | Conteúdo | Status |
|------|----------|--------|
| 0 | Fundamento estatístico (EV, R/R, variância) | ✅ Concluída |
| 1 | Estrutura de mercado (fluxo institucional, VWAP, sizing) | ✅ Concluída |
| 2 | Macro e catalisadores (surpresa vs. consenso) | ✅ Concluída |
| 3 | Um único setup + 100+ trades simulados com diário | 🔲 Em andamento |
| 4 | Capital real mínimo (risco 0,25–0,5% por trade) | ⏳ Condicionada à Fase 3 |
| 5 | Escala condicional (200+ trades reais com expectância positiva) | ⏳ Futura |

Progressão por **competência, nunca por tempo**.

## Princípios inegociáveis

- Pensar em probabilidades e EV — nenhum resultado é garantido
- R/R mínimo de 1:2 a 1:3; preservação de capital acima de tudo
- Honestidade epistêmica: 74–89% dos day traders de varejo perdem dinheiro de forma persistente
