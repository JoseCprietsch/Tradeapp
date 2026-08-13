# Arquitetura — Pregão de Treino

Mapa de onde fica cada coisa neste repositório. Se você não sabe onde mexer, comece aqui.

## Mapa do repositório

```
Tradeapp/
├── index.html              → Home do site
├── cenarios.html            → Galeria dos 4 casos do Modo Exame
├── metodo.html               → Texto sobre os princípios do método
├── simulador-vwap.html       → O APP em si (simulador de pregão)
├── assets/
│   └── style.css             → Design system do site (não do simulador)
├── supabase/
│   └── schema.sql            → Script de criação das tabelas + RLS
├── docs/
│   ├── ARQUITETURA.md         → este arquivo
│   ├── CURRICULO.md           → as fases do curso, o que já foi feito
│   └── SUPABASE.md            → guia de configuração da conta na nuvem
└── README.md                 → visão geral rápida (o que qualquer visitante vê primeiro)
```

## Duas partes que não se misturam

**1. O site (`index.html`, `cenarios.html`, `metodo.html` + `assets/style.css`)**
Páginas de marketing/apresentação. Todas compartilham o mesmo `assets/style.css`.
Se for mudar uma cor, fonte ou espaçamento do *site*, mexe só nesse arquivo.

**2. O simulador (`simulador-vwap.html`)**
Um único arquivo com HTML + CSS + JavaScript, sem build e sem dependências além
das fontes do Google. Isso é proposital: continua funcionando mesmo se abrir
localmente sem internet (exceto pelas fontes). O CSS dele é próprio (não usa
`assets/style.css`), mas a paleta de cores foi alinhada manualmente pra combinar
com o site — se mudar o dourado/verde/vermelho em um lugar, ajusta no outro também.

Dentro do `simulador-vwap.html`, o JavaScript é dividido em blocos marcados
com comentários `/* ==== nome da seção ==== */`. Use Ctrl+F pelo nome pra pular
direto — a lista completa está no comentário no topo do arquivo.

## Hospedagem

O site inteiro é estático (nenhum servidor próprio) e roda via **GitHub Pages**,
direto da branch `main`. Qualquer push pra `main` atualiza o site ao vivo em
`https://josecprietsch.github.io/Tradeapp/` (leva 1-2 minutos pra propagar).

## Estado atual vs. planejado

| Peça | Status |
|---|---|
| Site (home, cenários, método) | ✅ no ar |
| Simulador | ✅ no ar, acordeão mobile + gráfico arrastável |
| Login por conta (Supabase Auth) | 🔲 planejado — ver `docs/SUPABASE.md` |
| Diário/progresso salvos na nuvem | 🔲 depende do login acima |

Quando o login for implementado, o simulador passa a ter dois modos:
sem login (localStorage, como hoje) e logado (dados na nuvem, sincroniza entre
dispositivos). O objetivo é não quebrar o uso sem conta — continua funcionando
pra quem só quer treinar sem se cadastrar.
