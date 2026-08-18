# Níveis de dificuldade — critérios completos

Referência única de tudo que muda entre Iniciante, Intermediário e Trader.
Serve pra manter consistência conforme novas peças forem entrando (Book de
Ofertas, VAP, etc.) — a regra geral é sempre a mesma:

> **Iniciante e Intermediário têm muletas pedagógicas. Trader não tem
> nenhuma — só existe o que existiria numa tela real de operação.**

---

## 1. Motor de mercado sintético (`gerarPregao`)

| Parâmetro | Iniciante | Intermediário | Trader |
|---|---|---|---|
| Força de reversão ao VWAP (`pull`) | 0.10 (forte — padrões óbvios) | 0.06 (padrão) | 0.03 (fraca — zonas ambíguas) |
| Multiplicador de ruído (`volMul`) | 0.70 (menos ruído) | 1.00 (padrão) | 1.35 (mais ruído) |
| Chance de troca de regime por candle (`chaveTroca`) | 0.006 (tendências longas e limpas) | 0.012 (padrão) | 0.020 (picotado, mais difícil de ler) |
| Chance de ter catalisador no pregão (`evChance`) | 40% | 55% | 70% |
| Intensidade do catalisador (`evBoost`) | 3×–6× o ruído normal | 5×–11× | 6×–15× (mais violento) |

## 2. Ajuda visual / alertas

| Item | Iniciante | Intermediário | Trader |
|---|---|---|---|
| Alerta de catalisador (banner antes do evento) | ✅ Mostra | ✅ Mostra | ❌ Nunca mostra |
| Painel "Calendário do pregão" (lista de eventos, janela de risco) | ✅ Visível | ✅ Visível | ❌ Escondido |
| Gate de critérios (trava a ordem até marcar o checklist) | ✅ Ativo | ❌ Ordem livre | ❌ Ordem livre |
| Times & Trades (fita de negócios) | ❌ Escondido | ✅ Visível | ✅ Visível |

## 3. Boleta — o que existe numa tela real vs. o que é pedagógico

| Elemento | Existe numa boleta profissional real? | Iniciante | Intermediário | Trader |
|---|---|---|---|---|
| Compra / Venda | ✅ Sim | Visível | Visível | Visível |
| Stop / Alvo (distância em R$) | ✅ Sim (campo "Stop Of." no Profit) | Visível | Visível | Visível |
| Quantidade | ✅ Sim | Visível | Visível | Visível |
| Entrada (último preço) | ✅ Sim | Visível | Visível | Visível |
| Capital total / Risco por operação (%) | ❌ Não existe numa boleta real | Visível | Visível | **Escondido** |
| Quantidade sugerida pelo risco | ❌ Invenção nossa | Visível | Visível | **Escondido** |
| Preview de Risco / Ganho / Relação R:R | ❌ Não aparece calculado automaticamente numa boleta real | Visível | Visível | **Escondido** |
| Estado emocional antes de entrar | ❌ Não existe numa boleta real | Visível | Visível | **Escondido** |

No Trader, quem quiser saber o R:R ou dimensionar por risco precisa fazer
essa conta de cabeça ou no papel — exatamente como na vida real.

## 4. O que é igual em todos os níveis (não muda)

- Diário de operações (registro pós-trade, incluindo estado emocional e "seguiu o processo?") — é uma ferramenta de reflexão, não faz parte da execução em si, então continua existindo em todos os níveis, inclusive Trader
- Modo Exame (casos roteirizados) — não depende de dificuldade, é um modo à parte
- Formato Stop/Alvo como distância em R$ (não preço absoluto) — mudou pra todos os níveis de uma vez, é assim que funciona na vida real

---

## Regra pra decidir onde uma peça nova entra

Antes de adicionar qualquer coisa nova na tela, perguntar:

1. **Isso existe numa tela de operação profissional de verdade?**
   - Não existe → é pedagógico → visível só em Iniciante/Intermediário, nunca em Trader
   - Existe → é real → visível em todos os níveis (a dificuldade de generation dos dados é que muda, não a existência da ferramenta)
2. **Isso ajuda a pessoa sem ela precisar pensar?** (alertas, sugestões, cálculos automáticos)
   - Sim → esconder no Trader
   - Não, é só informação bruta (tipo o Book de Ofertas mostrando os preços) → mantém em todos os níveis

Essa regra vai guiar Book de Ofertas, VAP, e o resto do plano em `docs/TAPEDRILL_PRO.md`.
