# TapeDrill Pro — plano de arquitetura

Estrutura pra aproximar o simulador de uma plataforma profissional de verdade
(referência: Profit/Nelogica, a plataforma dominante no mercado brasileiro).
Baseado em pesquisa sobre o fluxo real de um trader — do login até o fechamento
do pregão — documentado em detalhe nesta conversa.

Isso é um **plano**, não uma implementação — serve pra guiar as próximas fases
de construção, uma de cada vez.

---

## O que já existe hoje vs. o que falta

| Ferramenta profissional | Equivalente hoje no TapeDrill | Status |
|---|---|---|
| Gráfico com VWAP, volume | Gráfico de candles + VWAP | ✅ Existe |
| Boleta com sizing por risco | Boleta com capital/risco → quantidade | ✅ Existe |
| Gate de critérios obrigatório | Checklist de 4-5 critérios | ✅ Existe (é uma peça nossa, sem equivalente direto no Profit) |
| Calendário de catalisadores | Painel "Calendário do pregão" | ✅ Existe |
| Diário com métricas (R, expectância) | Diário do simulador | ✅ Existe |
| Níveis de dificuldade | Iniciante/Intermediário/Trader | ✅ Existe |
| **Book de Ofertas (Level 2)** | — | 🔲 Falta |
| **Times & Trades (fita/tape reading)** | — | 🔲 Falta |
| **Volume at Price (VAP)** | — | 🔲 Falta |
| **Tipos de ordem (limitada, stop, OCO)** | Só stop/alvo simples | 🔲 Falta |
| **Painel de posição com P&L ao vivo** | Básico (cardPos) | 🔲 Melhorar |
| **Atalhos de teclado** (F3, F5, F6...) | Só Espaço/P | 🔲 Falta |
| **Múltiplos layouts/workspaces** | Layout único | 🔲 Falta (baixa prioridade) |

---

## Peça 1 — Motor de dados sintéticos mais rico

Hoje `gerarPregao()` produz só candles de 1 minuto com OHLCV. Pra alimentar
Book de Ofertas e Times & Trades, precisa gerar dados numa granularidade menor:

```
gerarPregao(seed, nivel)
  → candles (como já existe, 1/min)
  → NOVO: ticks (vários negócios sintéticos por candle, cada um com
    {hora, preço, qtd, agressor: 'comprador'|'vendedor'})
  → NOVO: bookSnapshot(candleIdx) — função que gera, sob demanda, uma
    "foto" do livro de ofertas naquele instante: 5-8 níveis de preço
    acima/abaixo do último negócio, cada um com uma quantidade ofertada
    (derivada da volatilidade/volume do candle — mais volátil = ofertas
    mais finas e dispersas; mais calmo = ofertas mais grossas e concentradas)
```

Os ticks dentro de cada candle já têm informação suficiente pra alimentar o
Times & Trades; o book pode ser recalculado a cada tick sem precisar guardar
histórico completo dele (só o snapshot atual importa pra quem está operando).

## Peça 2 — Times & Trades (a fita)

Painel novo, lista rolante, mais simples de construir dos dois (não precisa
de um "livro" persistente, só mostrar os ticks conforme acontecem):

- Colunas: hora, preço, quantidade, agressor (cor verde=comprador / vermelho=vendedor)
- Realce visual pra negócios "grandes" (acima de um múltiplo da média do dia)
- É a ferramenta mais alinhada com o que já ensinamos (controle comprador/vendedor,
  Fase 1 do currículo) — devia ser a **primeira peça nova a construir**

## Peça 3 — Book de Ofertas (Level 2)

- 5-8 níveis de compra (azul) e venda (vermelho) acima/abaixo do preço atual
- Cada nível mostra preço + quantidade ofertada
- Atualiza a cada candle (não precisa ser tick-a-tick pra começar)
- Visual: duas colunas espelhadas, como o padrão do mercado

## Peça 4 — Volume at Price (VAP)

- Histograma horizontal ao lado do gráfico, mostrando volume por faixa de preço
- Reaproveita os dados que o candle já tem (soma de volume por bucket de preço)
- O ponto de maior volume (POC) pode ser destacado — é um nível natural de
  suporte/resistência, reforça a leitura do gráfico principal

## Peça 5 — Boleta expandida (tipos de ordem)

Hoje a boleta só manda "compra/venda com stop e alvo". Adicionar:

- **Ordem limitada**: define um preço, só executa se o mercado chegar lá
- **Ordem stop de entrada**: só dispara se o preço romper um nível (não é
  a mesma coisa que o stop de proteção que já existe)
- **OCO**: já meio que existe conceitualmente (stop + alvo simultâneos),
  só falta nomear e deixar explícito na interface

## Peça 6 — Atalhos de teclado

Mapeamento sugerido (adaptado do padrão Profit, mas com nossas teclas já
ocupadas por Espaço/P preservadas):

| Tecla | Ação |
|---|---|
| `C` | Compra a mercado |
| `V` | Venda a mercado |
| `Z` | Zerar posição |
| `I` | Inverter posição |
| `Espaço` | Avança 1 candle *(já existe)* |
| `P` | Reproduz/pausa *(já existe)* |

## Peça 7 — Painel de posição com P&L ao vivo

Melhorar o `cardPos` existente pra mostrar, atualizando a cada candle
enquanto a posição está aberta: preço médio, quantidade, resultado em R$
flutuante, e resultado em unidades de R (não só no fechamento da operação).

---

## Como isso se conecta com os níveis de dificuldade

As ferramentas "pro" (Book, Times & Trades, VAP) fazem mais sentido
condicionadas ao nível escolhido, não sempre visíveis:

| Nível | O que aparece |
|---|---|
| **Iniciante** | Só o gráfico + boleta simples, como hoje — informação de mais atrapalha quem está começando |
| **Intermediário** | Adiciona Times & Trades (a peça mais pedagógica) |
| **Trader** | Tudo: Book de Ofertas, Times & Trades, VAP, boleta com todos os tipos de ordem — sem ajuda visual (igual já vale hoje pro calendário/catalisador) |

Isso também resolve um problema de design: a tela do Profit "parece um
cockpit de avião" pra quem começa — não queremos isso pro Iniciante,
queremos isso só pra quem já provou que aguenta a complexidade.

---

## Ordem de implementação sugerida

1. **Times & Trades** — maior valor pedagógico, menor esforço técnico
2. **Painel de posição com P&L ao vivo** — melhora o que já existe, sem
   depender de dados novos
3. **Book de Ofertas** — precisa do motor de dados sintéticos da Peça 1
4. **Volume at Price** — reaproveita dados já existentes, esforço menor
5. **Boleta expandida (tipos de ordem)** — maior mudança na lógica de negócio
6. **Atalhos de teclado** — polish, fazer por último
7. **Workspaces/layouts múltiplos** — baixa prioridade, complexidade alta
   pra pouco ganho num produto web (diferente de um app desktop)

## Fontes da pesquisa

Nelogica (blog.nelogica.com.br, ajuda.nelogica.com.br), Traders.com.br,
Toro Investimentos, ModalMais — todos documentando o Profit/Profit Pro,
a plataforma de referência do mercado brasileiro.
