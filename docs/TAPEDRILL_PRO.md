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

---

## v3 — auditoria completa contra o print real (18/08/2026)

Varredura região por região do print real fornecido pelo José, comparando
com o que existe hoje. Tudo que faltava, com julgamento sobre o que vale
construir.

| # | Item do print real | Vale construir? | Por quê |
|---|---|---|---|
| 1 | 4 médias móveis coloridas no gráfico | ✅ Sim — médio esforço | Leitura técnica real, valor pedagógico direto |
| 2 | Abas de múltiplos ativos abertos ao mesmo tempo | ⚠️ Grande — decisão de arquitetura | Muda o modelo "1 posição por vez"; avaliar com calma antes |
| 3 | Grid C Stop/V Limite/C Mercado/V Mercado | ⚠️ Médio-alto risco | Redesenho da interação da boleta, já testada e estável |
| 4 | Readout OHLC+Ajuste sempre visível (não só hover) | ✅ Sim — baixo esforço | Pequena mudança, ganho de realismo direto |
| 5 | Barra de ferramentas de desenho completa (20 ícones) | ✅ Sim — decisão revertida em 20/08/2026, ver seção v4 abaixo | José pediu o escopo completo estilo Profit; Fase 1 já entregue, Fase 2 (padrões avançados) documentada como próximo passo |
| 6 | "Ponto de Cobertura" (limite de perda da conta) | ✅ Sim — baixo esforço | Reforça gestão de risco a nível de conta, não só por trade — liga direto com o sistema de saldo/meta que já existe |
| 7 | Bid e Ask simultâneos (dois preços, não um) | ✅ Sim — médio esforço | Mais realista que só "último preço"; o Book de Ofertas já tem esse dado, só falta refletir no gráfico |
| 8 | Relógio flutuante solto | ❌ Não | Puramente estético, zero valor pedagógico, e já temos o relógio na barra de status |
| 9 | Média móvel sobre o volume | ✅ Sim — baixo esforço | Reaproveita dado que já existe, esforço pequeno |
| 10 | Painel de IFR/RSI | ✅ Sim — médio esforço | Indicador técnico padrão, ensina divergência/sobrecompra-sobrevenda |
| 11 | Multi-dia contínuo no eixo de tempo | ❌ Não, por enquanto | Contradiz a regra de "sem posição overnight" que já ensinamos; múltiplos dias implicaria em persistência de gráfico que não existe no nosso modelo |
| 12 | Boleta: campo "Preço", "Estrat.", conta c/ cadeado, Total, Médio | ⚠️ Parcial | "Total" e "Médio" fazem sentido e são baratos; "Estrat." e conta/cadeado são puramente decorativos pro nosso caso |
| 13 | Contador regressivo (03:35) | ✅ Sim — baixo esforço | Fácil, reforça a pressão real de tempo do pregão |

### Ordem sugerida (só os itens marcados ✅, do mais barato pro mais caro)

1. Readout OHLC persistente (item 4)
2. Contador regressivo (item 13)
3. "Ponto de Cobertura" — limite de perda da conta (item 6)
4. Média móvel sobre volume (item 9)
5. Médias móveis no candle (item 1)
6. Bid/Ask simultâneos no gráfico (item 7)
7. Total + Médio na boleta (parte do item 12)
8. Painel de IFR/RSI (item 10)

Itens 2 e 3 (abas múltiplas, grid de botões) ficam como **decisão separada**,
não entram nessa leva — são mudanças estruturais que merecem conversa própria
antes de codar.

---

## v4 — Barra de estudos completa (20/08/2026)

Pesquisa contra a documentação oficial da Nelogica (ajuda.nelogica.com.br)
mostrou que a "barra de estudos" real do Profit é um pacote de análise
técnica clássica inteiro — bem mais do que ferramentas de desenho simples.
Lista completa encontrada:

- **Navegação/interação:** Cursor, Mira (crosshair), Zoom, Mão (pan), Ímã (magnet)
- **Mão livre:** Lápis, Marcador, Seta
- **Linhas:** reta, horizontal, vertical, tendência, ângulo de tendência, régua
- **Formas:** retângulo, elipse, texto
- **Fibonacci (5 variações):** retração, extensão, canal, leque, sequência
- **Estatística/padrões avançados:** canal, canal desvio padrão, regressão
  linear, linha de suporte automático, ABCD, XABCD, ondas de Elliott

Isso é essencialmente um segundo produto (análise técnica clássica/geometria
de preço) dentro do TapeDrill, que hoje ensina uma escola diferente (tape
reading, fluxo de ordens, VWAP, EV). Flag registrada: ABCD/XABCD/Elliott são
ferramentas de reconhecimento de padrão subjetivas, sem evidência empírica
forte de edge — isso não impede a construção (José decidiu ir com o escopo
completo), só entra como nota de honestidade pedagógica a mencionar quando o
Professor Trade ensinar essas ferramentas no currículo.

José escolheu o escopo **completo estilo Profit**, incluindo Elliott/ABCD/
Regressão. Dado o tamanho, a entrega foi dividida em fases:

### Fase 1 — ✅ Concluída (20/08/2026)

Arquitetura genérica de "estudos" (multi-ponto, multi-tipo) + barra vertical
na lateral do gráfico:

- Cursor, Mão, Mira (crosshair livre com etiqueta de preço), Ímã (encaixa no
  O/H/L/C do candle)
- Linha horizontal, Linha vertical, Linha de tendência, Retângulo, Texto
- Retração de Fibonacci (7 níveis: 0/23,6/38,2/50/61,8/78,6/100%)
- Painel "Estudos" lista todos e permite remover individualmente ou limpar
  tudo; Esc cancela uma forma em construção
- Testado ponta a ponta via jsdom simulando cliques reais em cada ferramenta

### Fase 2 — em andamento (20/08/2026)

Ferramentas avançadas de Fibonacci e padrões, na ordem sugerida de esforço
crescente:

1. ✅ **Extensão de Fibonacci** — entregue. Reaproveitou a arquitetura da
   retração (2 pontos, mesma lógica de níveis), só trocando o conjunto de
   níveis pra projeção além do 2º ponto (0/61,8/100/161,8/261,8/423,6%)
2. ✅ **Canal** (2 linhas paralelas) — entregue. Primeira ferramenta de 3
   pontos: arraste define a linha principal, um 3º clique define a largura/
   paralela, com prévia ao vivo enquanto aguarda esse clique. Essa
   arquitetura de 3 pontos é a base pro Canal de Fibonacci e Leque abaixo
3. ✅ **Canal de Fibonacci** e **Leque de Fibonacci** — entregues. O Canal de
   Fibonacci reaproveitou o fluxo de 3 cliques do Canal (item 2), com 7
   níveis intermediários entre as duas linhas em vez de só uma linha oposta.
   O Leque é uma ferramenta de 2 pontos (igual Fib/Fib+): três linhas saindo
   do ponto inicial nos ângulos 38,2/50/61,8% até a borda direita
4. ✅ **Régua de medição** (mostra Δpreço, Δ% e nº de candles entre 2 pontos,
   sem persistir como estudo) — entregue. Some sozinha depois de ~4s
5. ✅ **Sequência de Fibonacci** — entregue. Ferramenta de 1 clique (igual
   Linha horizontal/vertical): marca linhas verticais nos intervalos
   1/2/3/5/8/13/21/34/55/89/144 candles a partir do ponto
6. ✅ **Regressão Linear** e **Canal Desvio Padrão** — entregues. Pressione+
   arraste seleciona o intervalo de candles, mas o desenho segue os
   fechamentos reais via mínimos quadrados (não os pontos do clique).
   Canal Desvio Padrão adiciona bandas em ±1 e ±2 desvios padrão dos
   resíduos
7. **Linha de Suporte Automático** — pendente. Detecção automática de
   suporte via regressão sobre mínimos locais, esforço médio-alto
8. **ABCD / XABCD** (padrões harmônicos, 4-5 pontos com proporções
   Fibonacci entre pernas) — pendente, esforço alto, precisa de validação
   de proporção e rótulos nos vértices
9. **Ondas de Elliott** (rotulagem manual de 5 ondas de impulso + 3 de
   correção, com numeração/lettering) — pendente, esforço alto, é
   majoritariamente
   uma ferramenta de anotação manual (o usuário decide onde ficam as ondas)

Lápis/Marcador/Seta (mão livre) e Zoom não entraram na Fase 1 nem estão
priorizados na Fase 2 — baixo valor pedagógico pra um simulador de tape
reading; revisar só se José pedir explicitamente.

