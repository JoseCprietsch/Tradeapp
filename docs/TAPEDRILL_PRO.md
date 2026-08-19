# TapeDrill Pro — plano de arquitetura (v2, validado contra a tela real)

**Status: ✅ as 9 fases concluídas.** Fora de escopo, por decisão consciente:
Bookmap/CVD (item 20, complexidade alta pra valor marginal de treino).

Estrutura pra aproximar o simulador de uma plataforma profissional de verdade.
Referência: Profit Pro (Nelogica) — validado contra screenshots reais da tela
completa e pesquisa na documentação oficial da Nelogica, ModalMais, Toro,
InfoMoney e Traders.com.br.

A v1 deste plano cobria só as ferramentas centrais de operação. A v2 cobre
**o dia inteiro de um trader** — tudo que ele vê e faz, do momento em que abre
a plataforma até o fim do pregão.

---

## O mapa completo da tela profissional (o que a tela real do Profit tem)

```
┌──────────────────────────────────────────────────────────────────────┐
│ Menu (Arquivo·Gráfico·Estudos·Negociação·Notícias·Workspaces) [conta] │
├──────────────┬──────────────────────────────┬────────────────────────┤
│ GRADE DE     │ GRÁFICO (ticker · timeframe  │ BOLETA COMPLETA        │
│ COTAÇÕES     │  · candles · VWAP · desenho) │ (conta Sim/Real,       │
│ (ativos por  │                              │  preço, stop, qtd,     │
│  setor, mini │                              │  validade, C/V Limite, │
│  sparkline,  │                              │  C/V Mercado, Zerar,   │
│  último, %)  │                              │  Cancelar+Zerar)       │
│              ├──────────────────────────────┤────────────────────────┤
│              │ POSIÇÃO / DAY TRADE          │ BOOK DE OFERTAS        │
│              │ (Res. Aberto R$/%, Res. Dia  │ (barra de pressão %,   │
│              │  R$/%, tabela por ativo)     │  níveis compra/venda,  │
│              │                              │  barras de volume)     │
├──────────────┴──────────────────────────────┴────────────────────────┤
│ Abas de layout (Layout 1·2·3)   ·   Status: hora · Conectado · versão │
└──────────────────────────────────────────────────────────────────────┘
```

Ferramentas que abrem em janelas: Times & Trades, VAP, Medidores de Pressão,
Notícias, SuperDOM.

---

## Checklist completo: item da tela real → equivalente TapeDrill

| # | Item da tela real | O que é | Status no TapeDrill |
|---|---|---|---|
| 1 | Gráfico com VWAP e volume | Núcleo da leitura | ✅ Existe |
| 2 | Boleta com sizing por risco | Envio de ordem | ✅ Existe (simples) |
| 3 | Seletor de conta "Sim/Real" | Simulador embutido | ✅ Somos 100% sim — virar selo visível |
| 4 | Calendário econômico | Catalisadores do dia | ✅ Existe (nosso painel) |
| 5 | Diário/registro | Avaliação contínua | ✅ Existe |
| 6 | **Grade de Cotações** | Lista de ativos por setor, último preço, variação % — é onde o trader ESCOLHE o que operar | ✅ Feito — banco de 12 empresas fictícias, 6-10 sorteadas por dia, só ~40% com setup válido |
| 7 | **Times & Trades** | Negócios executados: hora, preço, qtd, agressor | ✅ Feito |
| 8 | **Book de Ofertas** | Níveis de compra (azul) e venda (vermelho) com quantidades | ✅ Feito — com estratégia Iceberg embutida |
| 9 | **Barra de pressão/agressão** | % compradores × vendedores em cima do book e do T&T | ✅ Feito |
| 10 | **VAP (Volume at Price)** | Volume por faixa de preço, POC destacado | 🔲 NOVO |
| 11 | **Boleta completa** | Preço, stop offset, qtd + botões rápidos (100/200/300), validade, C/V Limite, C/V Mercado, Cancelar Ord., Inverter, Zerar, Cancelar+Zerar | 🔲 Expandir a atual |
| 12 | **Painel Posição/Day Trade** | Res. Aberto R$ e %, Res. Dia R$ e %, tabela por ativo | 🔲 Melhorar cardPos + criar "resultado do dia" |
| 13 | **Notícias** | Feed de notícias ligado aos ativos | 🔲 **NOVO** — reaproveitar os catalisadores sintéticos como "manchetes" no feed |
| 14 | **Timeframe/período** | 1min, 5min, 15min... | 🔲 **NOVO** — hoje somos fixos em 1min; agregar candles é cálculo simples |
| 15 | **Abas de layout** | Layout 1/2/3 salvos | 🔲 Baixa prioridade |
| 16 | **Ferramentas de desenho** | Linha de tendência, retângulo, fibo | 🔲 Baixa prioridade (linha horizontal de suporte/resistência primeiro) |
| 17 | **Barra de status** | Hora, versão, "Conectado" | 🔲 Fácil — relógio do pregão já existe, falta o resto |
| 18 | Atalhos (F3/F5/F6, Ctrl+R) | Agilidade | 🔲 NOVO (C/V/Z/I adaptados) |
| 19 | Medidores de Pressão (janela própria) | Pressão do book + agressão do T&T lado a lado | 🔲 Coberto pelo item 9 de forma integrada |
| 20 | Bookmap/CVD (heatmap, delta cumulativo) | Módulo avançado pago do Profit | ❌ Fora de escopo (complexidade altíssima, valor marginal pro treino) |

---

## O motor de dados que sustenta tudo (pré-requisito)

`gerarPregao()` precisa evoluir de "1 ativo, candles de 1min" para:

```
gerarDia(seed, nivel)
  → ativos[]: 6-10 empresas fictícias com ticker/nome/setor fixos
    (banco de ~12 empresas, sorteia 6-10 por dia), cada uma com seu
    próprio gerarPregao (seeds derivados) — uns em tendência, uns
    laterais, uns com catalisador. SÓ ALGUNS têm setup válido no dia
    (treina a seleção: a maioria dos dias/ativos NÃO vale operar)
  → por ativo:
      candles (como hoje)
      ticks: negócios sintéticos por candle {hora, preço, qtd, agressor}
      bookSnapshot(idx): níveis de oferta derivados de vol/volume
      manchetes: catalisadores viram notícias com horário
      iceberg: null ou {preco, qtdVisivel} — ver abaixo
```

### Empresas fictícias (evolução da Grade de Cotações)

Banco fixo de ~12 empresas fictícias (nome + ticker + setor), pra dar
identidade e repetição — a pessoa passa a "conhecer" os papéis ao longo
do tempo, como um trader real conhece os ativos que acompanha. Cada dia
sorteia 6-10 delas pra aparecer na Grade.

### Estratégia Iceberg (ordem institucional escondida)

Uma ordem grande (ex: 50.000 ações) que só mostra uma fatia pequena no
book (ex: 2.000) — quando essa fatia é consumida pelos negócios, ela
"reaparece" no mesmo preço, revelando aos poucos que existe uma mão
grande por trás. Implementação: um nível do book marcado como iceberg
tem sua quantidade **reabastecida** sempre que os ticks do candle
consomem volume suficiente naquele preço — ao contrário dos outros
níveis, que apenas oscilam aleatoriamente.

**Presente em todos os níveis, mas com sutileza diferente:**

| Nível | Como aparece |
|---|---|
| Iniciante | Existe, e a interface **avisa explicitamente** ("essa oferta está sendo reabastecida — pode ser ordem institucional grande escondida") |
| Intermediário | Existe, sem aviso — mas o padrão de reabastecimento é bem regular/óbvio pra quem prestar atenção |
| Trader | Existe, sem aviso, com variação natural na quantidade reabastecida — bem mais difícil de distinguir de ruído normal do book |

## Ordem de implementação (v2)

| Fase | Entrega | Por quê nessa ordem |
|---|---|---|
| 1 | Motor de ticks + **Times & Trades** | ✅ Concluída |
| 2 | **Posição/Resultado do dia** (Res. Aberto, Res. Dia em R$ e R) | ✅ Concluída |
| 3 | **Book de Ofertas + barra de pressão** | ✅ Concluída |
| 4 | **Grade de Cotações** (multi-ativos) | ✅ Concluída |
| 5 | **VAP + timeframes** | ✅ Concluída |
| 6 | **Boleta completa** (limitada, stop, validade, botões rápidos) | ✅ Concluída |
| 7 | **Notícias sintéticas + barra de status + selo Sim** | ✅ Concluída |
| 8 | Atalhos de teclado | ✅ Concluída |
| 9 | Desenho no gráfico + abas de layout | ✅ Concluída |

## Ligação com os níveis de dificuldade (mantida da v1, expandida)

| Nível | O que aparece |
|---|---|
| **Iniciante** | Gráfico + boleta simples + calendário. 1 ativo só (sem Grade — escolher ativo é habilidade avançada) |
| **Intermediário** | + Times & Trades, + Grade com 4-5 ativos, + painel de resultado |
| **Trader** | Tudo: Grade completa, Book + pressão, VAP, boleta completa, notícias — sem calendário, sem alertas (já vale hoje) |

## Fontes

Nelogica (docs oficiais: Grade de Cotações, Livro de Ofertas, SuperDOM,
Times & Trades, Medidores de Pressão, Workspaces), ModalMais, Toro,
InfoMoney, Traders.com.br, Portal do Trader. Screenshots reais do
Profit Pro 5.5 fornecidos pelo José.
