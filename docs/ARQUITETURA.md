# Arquitetura — TapeDrill

Mapa de onde fica cada coisa neste repositório. Se você não sabe onde mexer, comece aqui.

## Mapa do repositório

```
Tradeapp/
├── index.html                → Pressel (site público de vendas)
├── cenarios.html             → Galeria dos 4 casos do Modo Exame
├── metodo.html               → Texto sobre os princípios do método
├── login/
│   ├── index.html            → Login/cadastro (email+senha e Google)
│   └── reset.html            → Redefinição de senha (destino do link por email)
├── inicio/
│   └── index.html            → Hub de produtos pós-login (escolha produto + dificuldade)
├── simulador-vwap.html       → O APP em si (simulador de pregão)
├── assets/style.css          → Design system do site público (não do simulador)
├── supabase/
│   ├── schema.sql            → Criação das tabelas + RLS
│   └── migration_001_*.sql   → Ajustes de tipos na tabela trades
├── docs/
│   ├── ARQUITETURA.md        → este arquivo
│   ├── CURRICULO.md          → as fases do curso, o que já foi feito
│   ├── SUPABASE.md           → configuração da nuvem + fluxo de navegação
│   ├── TAPEDRILL_PRO.md      → plano das ferramentas profissionais (Book, T&T, VAP…)
│   └── NIVEIS_DIFICULDADE.md → tudo que muda entre Iniciante/Intermediário/Trader
├── CNAME                     → domínio customizado (tapedrill.com)
└── README.md                 → visão geral rápida + navegação
```

## Fluxo de navegação

```
tapedrill.com (Pressel) → /login/ → /inicio/ (hub) → /simulador-vwap.html
```

Detalhes do fluxo e das tabelas: `docs/SUPABASE.md`.

## Três partes que não se misturam

**1. O site público** (`index.html`, `cenarios.html`, `metodo.html` + `assets/style.css`)
Tipografia: só EB Garamond. Se for mudar cor/fonte/espaçamento do site, mexe em `assets/style.css`.

**2. As páginas de autenticação e o hub** (`login/`, `inicio/`)
Páginas independentes, cada uma com CSS próprio embutido (alinhado manualmente à paleta do site). Falam com o Supabase.

**3. O simulador** (`simulador-vwap.html`)
Um único arquivo com HTML + CSS + JS. Dependências externas: supabase-js e Three.js
(via CDN) + fontes do Google. O JS é dividido em blocos `/* ==== nome ==== */` —
Ctrl+F pelo nome pra pular direto.

## Hospedagem

Site estático no **GitHub Pages** (branch `main`), servido em **https://tapedrill.com**
(domínio na Cloudflare, DNS apontando pro Pages). Push na `main` → ao vivo em 1-2 min.

## Convenções

- Commits em português, descritivos, direto na `main`
- Antes de todo push: validar divs balanceados + `node --check` no JS extraído
- Peças novas seguem a regra de níveis em `docs/NIVEIS_DIFICULDADE.md`
