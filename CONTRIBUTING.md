# Contribuindo com o Sistema Onion 🧅

Obrigado por considerar contribuir com o Onion!

O Onion é um **framework template em `.codex/` + `.agents/`** — instalável em
qualquer projeto (novo, legado ou regulado) para orquestrar produto, engenharia
e compliance com Codex. **Não é produto npm, não é distribuído publicamente e
não tem CLI standalone próprio** — roda sobre o `codex` CLI. Plataforma única:
**OpenAI Codex**.

Por isso, contribuir aqui é **escrever Markdown + TOML + YAML** (skills,
subagentes, knowledge bases e documentação) — não código JavaScript/Node.

---

## 📋 Índice

- [Código de Conduta](#-código-de-conduta)
- [Pré-requisitos](#-pré-requisitos)
- [Estrutura do projeto](#-estrutura-do-projeto)
- [Tipos de contribuição](#-tipos-de-contribuição)
- [Padrões (meta-specs)](#-padrões-meta-specs)
- [Fluxo de Pull Request](#-fluxo-de-pull-request)
- [Idioma e commits](#-idioma-e-commits)
- [Validação](#-validação)

---

## 📜 Código de Conduta

Seja respeitoso, colaborativo, inclusivo e profissional em todas as interações.

---

## 🚀 Pré-requisitos

- **Git**
- **Codex CLI** (plataforma única do framework): `npm install -g @openai/codex`
  (ou via `curl`/Homebrew). Autentique com conta ChatGPT ou OpenAI API key.

Não há toolchain de build: o Onion é interpretado em runtime pelo Codex a partir
de `AGENTS.md` + `.codex/` + `.agents/skills/` (Markdown + TOML + YAML). Não há
`package.json`, Node ou pnpm.

```bash
# 1. Fork e clone
git clone https://github.com/your-username/onion-codex.git
cd onion-codex

# 2. Instale o Codex CLI (se ainda não tiver) e abra o projeto
npm install -g @openai/codex
codex
# → autenticar com conta ChatGPT ou OpenAI API key

# O framework é ativado pela presença de AGENTS.md + .codex/ + .agents/skills/.
# Skills e subagentes carregam automaticamente.
# Para começar: $warm-up e depois $onion
```

---

## 🛠️ Estrutura do projeto

```
onion-codex/
├── .agents/
│   └── skills/             # Skills invocáveis ($slug) por categoria
│       └── task-manager/   # Task Manager Abstraction (references/)
├── .codex/                 # Sistema Onion operacional (Codex-nativo)
│   ├── agents/             # Subagentes especializados (*.toml) por domínio
│   ├── sessions/           # Sessões persistentes de desenvolvimento
│   ├── utils/              # Utilitários
│   └── config.toml         # Configuração + permissions (versionado)
├── docs/                   # Documentação (Spec as Code)
│   ├── meta-specs/         # L0 — "constituição" do framework
│   ├── knowledge-base/     # Knowledge bases estruturadas
│   │   └── platforms/openai-codex.md  # Fonte de verdade da plataforma
│   ├── business-context/   # Gerado por $docs-build-business-docs
│   ├── technical-context/  # Gerado por $docs-build-tech-docs
│   └── onion/              # Guias e referências
└── AGENTS.md               # Project rules carregados pelo Codex
```

---

## 🤝 Tipos de contribuição

- **🐛 Bugs** — abra uma issue com: skill/subagente envolvido, o que aconteceu,
  comportamento esperado, passos de reprodução.
- **✨ Novas skills/subagentes** — use os criadores do próprio framework:
  `$meta-create-command`, `$meta-create-agent`, `$meta-create-skill`. Eles já
  aplicam os padrões das meta-specs.
- **📚 Documentação e knowledge bases** — correções, clareza, exemplos,
  `$meta-create-knowledge-base`.
- **🔌 Integrações (Task Manager)** — novos adapters seguindo o padrão SDAAL em
  `.agents/skills/task-manager/references/` (ver `docs/meta-specs/integrations.md`).

---

## 📏 Padrões (meta-specs)

As meta-specs L0 em `docs/meta-specs/` são a **fonte canônica** de padrões.
Consulte antes de criar/alterar artefatos:

| Você vai mexer em… | Consulte |
|---|---|
| Subagente | [`agents.md`](docs/meta-specs/agents.md) — TOML obrigatório, categorias, limites de tamanho |
| Skill | [`commands.md`](docs/meta-specs/commands.md) — frontmatter, permissions (§1.3), workflows faseados, limites (§5) |
| Arquitetura/estrutura | [`architecture.md`](docs/meta-specs/architecture.md) — framework instalável, dependências |
| Idioma/estilo/naming | [`code-standards.md`](docs/meta-specs/code-standards.md) |
| Integração externa | [`integrations.md`](docs/meta-specs/integrations.md) — adapters, `.env`, MCP config |

Pontos-chave:

- **Tamanho**: subagente ≤1.200 linhas (hard >1.500); skill ≤500 (hard >800).
  Excedeu? Extraia conteúdo de referência para `docs/knowledge-base/` e mantenha
  o artefato como orquestrador enxuto.
- **Permissions** em skills sensíveis (git/escrita/Task Manager) — escopo
  mínimo (ver `commands.md §1.3`).
- **Frontmatter obrigatório** em skills (`description`, YAML) e subagentes
  (`name`, `description`, `tools`, `model`, TOML).
- **Sem assunções sobre o projeto-alvo**: nada de path absoluto; o framework é
  instalável em qualquer repo.

---

## 🔀 Fluxo de Pull Request

1. **Branch** a partir de `main` (GitFlow): `feature/...` ou `fix/...`
   (ou use `$git-feature-start`).
2. **Mude** seguindo as meta-specs; atualize docs/índices afetados.
3. **Valide** localmente (ver abaixo).
4. **Commit** com Conventional Commits **em pt-BR** (ver próxima seção).
5. **Abra o PR** com título claro, descrição do quê/porquê, issues relacionadas
   e breaking changes (se houver).

---

## 🌍 Idioma e commits

Convenção do Onion (ver `code-standards.md`):

- **Código, nomes de arquivo, slugs, branches, variáveis**: inglês.
- **Comentários, documentação, mensagens ao usuário**: português brasileiro.
- **Mensagens de commit**: português brasileiro, seguindo
  [Conventional Commits](https://www.conventionalcommits.org/).

```bash
git commit -m "feat(product): adiciona comando de priorização de backlog"
git commit -m "fix(task-manager): corrige detecção de provider ausente no .env"
git commit -m "docs(meta-specs): esclarece convenção de allowed-tools"
```

Tipos: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `style`, `perf`.

---

## 🧪 Validação

Antes de abrir o PR:

- `$validate-workflow` — completude de workflows.
- Skills `onion-validation` e `onion-patterns` — conformidade de artefatos
  (frontmatter, categorias, limites de tamanho, naming).
- `@metaspec-gate-keeper` — validação de conformidade arquitetural contra as
  5 meta-specs.

Checklist:

- [ ] Segue as meta-specs aplicáveis.
- [ ] Frontmatter correto (YAML em skills, TOML em subagentes).
- [ ] Dentro dos limites de tamanho (ou refatorado com extração para KB).
- [ ] Documentação/índices atualizados (`$docs-build-index` se necessário).
- [ ] Commits em pt-BR, Conventional Commits.

---

## 🔗 Links úteis

- [Identidade e visão geral (README)](README.md)
- [Índice da documentação](docs/INDEX.md)
- [Meta-specs (constituição)](docs/meta-specs/index.md)
- [Guias de aplicação](docs/applying/) — greenfield, legado, regulado

---

**Obrigado por contribuir com o Onion! 🧅**
