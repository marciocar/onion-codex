# 🧅 Sistema Onion - OpenAI Codex Rules

## 🎯 Contexto do Projeto

Este é o **Sistema Onion** — um **framework template em `.codex/` + `.agents/`** projetado para ser instalado e aplicado em qualquer projeto (novo, legado ou regulado) para orquestrar o ciclo completo de desenvolvimento com OpenAI Codex.

**Identidade canônica** (migração Claude Code → Codex; base em [docs/knowledge-base/platforms/openai-codex.md](docs/knowledge-base/platforms/openai-codex.md)):

- Framework template em `.codex/` (config, rules, hooks, subagentes) + `.agents/skills/` (skills) — **não é produto npm**, não é distribuído publicamente, **não tem CLI standalone próprio** (roda sobre o `codex` CLI)
- Plataforma única: **OpenAI Codex**
- Cobre **três dimensões peer** do ciclo: produto, engenharia, compliance/governança
- **Workflows faseados retomáveis** com sessões persistentes — `product/collect→feature` (descoberta a backlog) e `engineer/plan→pr-update` (planejamento a entrega) são invariantes do framework, não devem ser consolidados

**Inventário atual**:

- ~92 skills invocáveis por categoria (`product`, `git`, `engineer`, `docs`, `meta`, `validate`, `test`, `development`, `quick`) — invocadas por `$skill-slug` ou `/skills`; fragmentos compartilhados em `docs/onion/shared/`
- 49 subagentes especializados em `.codex/agents/*.toml` (9 domínios: `compliance`, `deployment`, `development`, `git`, `meta`, `product`, `research`, `review`, `testing`)
- 4 skills-base em `.agents/skills/` (`onion` — orquestrador; `onion-patterns`; `onion-validation`; `language-standards`)
- **Task Manager Abstraction** plugável (Jira, ClickUp, Asana, Linear) via `.agents/skills/task-manager/references/`
- Workflows automatizados de desenvolvimento (GitFlow + sessions persistentes em `.codex/sessions/`)

---

## 🔌 Task Manager - Detecção e Roteamento

O Sistema Onion é **provider-agnóstico** para gerenciamento de tarefas. Antes de operar com tasks, **sempre verifique qual provider está ativo** lendo a variável `TASK_MANAGER_PROVIDER` em `.env`.

### Fluxo obrigatório antes de operar com tasks

1. **Carregar** variáveis do `.env` (ex: `set -a; source .env; set +a`)
2. **Ler** `TASK_MANAGER_PROVIDER` → valor possível: `jira` | `clickup` | `asana` | `linear` | `none`
3. **Conferir** variáveis específicas do provider ativo (tabela abaixo)
4. **Delegar** ao subagente correto e usar formatação adequada

> O hook `SessionStart` em `.codex/hooks.json` reporta o provider ativo no início da sessão.

### Mapa Provider → Variáveis → Subagente → Adapter

| Provider | Variáveis obrigatórias | Variáveis opcionais | Subagente especialista | Adapter doc |
|----------|------------------------|---------------------|---------------------|-------------|
| **`jira`** | `JIRA_HOST`, `JIRA_EMAIL`, `JIRA_API_TOKEN` | `JIRA_PROJECT_KEY`, `JIRA_AUTH_TYPE` (basic/bearer), `JIRA_API_VERSION` (3/2) | `@jira-specialist` | `.agents/skills/task-manager/references/adapters/jira.md` |
| **`clickup`** | `CLICKUP_API_TOKEN` | `CLICKUP_WORKSPACE_ID`, `CLICKUP_DEFAULT_LIST_ID` | `@clickup-specialist` | `.agents/skills/task-manager/references/adapters/clickup.md` |
| **`asana`** | `ASANA_ACCESS_TOKEN` | `ASANA_WORKSPACE_ID`, `ASANA_DEFAULT_PROJECT_ID` | _(agnóstico via `@task-specialist`)_ | `.agents/skills/task-manager/references/adapters/asana.md` |
| **`linear`** | `LINEAR_API_KEY` | `LINEAR_TEAM_ID` | _(agnóstico via `@task-specialist`)_ | `.agents/skills/task-manager/references/adapters/linear.md` |
| **`none`** | — | — | `@task-specialist` (decompõe localmente, sem persistir) | — |

### Regras de delegação

- **Estratégia / gestão / priorização** → `@product-agent` (qualquer provider)
- **Decomposição hierárquica de tasks** (agnóstico) → `@task-specialist`
- **Operação técnica do provider ativo** → subagente especialista:
  - `jira` → `@jira-specialist` (JQL, ADF, transitions, bulk, sprints/boards)
  - `clickup` → `@clickup-specialist` (MCP, listas, custom fields, comentários Unicode)
- **Sem provider configurado** (`none`) → operar offline com `@task-specialist`; **não** tentar API calls

> Os subagentes especialistas declaram `mcp_servers` no seu `.codex/agents/<agente>.toml`; os servidores MCP são configurados em `.codex/config.toml` (`[mcp_servers.*]`).

### Fallback gracioso

Se variáveis obrigatórias do provider estiverem ausentes ou inválidas:
1. **Avisar** o usuário em pt-BR indicando qual variável falta
2. **Sugerir** `$meta-setup-integration` para reconfigurar
3. **Não inventar** valores nem assumir outro provider

---

## 📝 Diretrizes de Linguagem
- **Comentários e documentação**: Português brasileiro (pt-BR)
- **Código, variáveis, funções**: Inglês
- **Commits**: Português brasileiro
- **Logs e debugging**: Inglês

---

## 🛠️ Padrões Técnicos

### Estrutura de Arquivos
- Skills: `.agents/skills/<slug>/SKILL.md` (slug prefixado por categoria — ex.: `engineer-start`, `git-feature-start`)
- Subagentes: `.codex/agents/<agente>.toml` (`name` + `description` + `developer_instructions`)
- Config: `.codex/config.toml` (modelo, sandbox, approval, features, MCP servers)
- Rules: `.codex/rules/default.rules` (Starlark `prefix_rule`)
- Hooks: `.codex/hooks.json`
- Sessões: `.codex/sessions/<feature>/` para contexto de desenvolvimento
- Abstração task manager: `.agents/skills/task-manager/references/`
- Fragmentos compartilhados (prompts/templates): `docs/onion/shared/`
- **Spec as Code** (documentação estruturada):
  - Meta Specs (L0 — constituição): `docs/meta-specs/`
  - Business Context: `docs/business-context/` (gerado por `$docs-build-business-docs`)
  - Technical Context: `docs/technical-context/` (gerado por `$docs-build-tech-docs`)
  - Knowledge Bases: `docs/knowledge-base/` (gerado por `$meta-create-knowledge-base`)

### Padrões de Código
- Siga convenções estabelecidas de cada linguagem/framework
- Priorize legibilidade e manutenibilidade
- Use type hints quando disponível
- Documente funções complexas

### Subagentes Especializados (mais usados)
- `@onion` — orquestrador master / ponto de entrada
- `@product-agent` — gestão estratégica de produto (qualquer task manager)
- `@task-specialist` — decomposição agnóstica de tasks
- `@jira-specialist` — Jira REST API v3/v2, JQL, ADF, transitions, bulk
- `@clickup-specialist` — ClickUp MCP, formatação Unicode, custom fields
- `@codex-specialist` — config/workspace/troubleshooting do Codex
- `@react-developer` / `@nodejs-specialist` — desenvolvimento frontend/backend
- `@code-reviewer` — review prático de código
- `@test-engineer` / `@test-agent` — testes unitários e estratégia
- `@metaspec-gate-keeper` — validação de conformidade arquitetural

> Subagentes só são disparados por instrução explícita (ex.: *"use o @gitflow-specialist"* / *"spawn the gitflow-specialist agent"*). Veja `.codex/config.toml` › `[agents]` para limites de concorrência/profundidade.

---

## 🎨 Formatação por Provider

A formatação de descrições e comentários **muda conforme o provider ativo**.

### Jira Cloud (`TASK_MANAGER_PROVIDER=jira` + REST v3)
- **Descrições e comments**: obrigatoriamente em **ADF (Atlassian Document Format)** — JSON estruturado
  ```json
  { "type": "doc", "version": 1, "content": [
    { "type": "heading", "attrs": { "level": 2 }, "content": [{ "type": "text", "text": "Objetivo" }] },
    { "type": "paragraph", "content": [{ "type": "text", "text": "..." }] }
  ]}
  ```
- **Workflow-aware**: nunca setar `status` direto — sempre `POST /issue/{key}/transitions`
- **Bulk**: usar `POST /rest/api/3/issue/bulk` (até 50/req) para >5 issues
- **Search**: `POST /rest/api/3/search/jql` com `nextPageToken` (o antigo `/search` foi removido em maio/2025)
- **Referência**: `@jira-specialist` (`.codex/agents/jira-specialist.toml`)

### Jira Server/DC (`JIRA_API_VERSION=2`)
- Descrições em **wiki markup** ou plain text (string, não JSON)
- Search via `GET /rest/api/2/search` com `startAt`

### ClickUp (`TASK_MANAGER_PROVIDER=clickup`)
**Estratégia dual:**

- **📋 Task Descriptions (`markdown_description`)**: Markdown nativo
  - Use: `## Headers`, `| Tabelas |`, `**Bold**`, `- Listas`
  - Quando: `create_task`, `update_task` descriptions
  - Templates: `docs/onion/shared/clickup-patterns.md` — seção DESCRIPTIONS

- **💬 Task Comments (`commentText`)**: Formatação visual Unicode
  - Use: `━━━`, `∟`, `▶`, `◆`, `✅`
  - Quando: `create_task_comment`, progress updates, PR comments
  - **Obrigatório**: timestamp + status em todos os comments
  - **Estrutura**: Header + separador + conteúdo + footer
  - Templates: `docs/onion/shared/clickup-patterns.md` — seção COMMENTS

### Asana / Linear
- Asana: descrição em HTML notes (subset) ou plain text
- Linear: Markdown nativo (suporte rico)
- Consulte o adapter doc correspondente em `.agents/skills/task-manager/references/adapters/`

---

## 🔗 Princípios de Integração com Task Manager
- **Sincronização contínua**: tasks no provider sempre refletem o estado real do trabalho
- **Tags/labels** apropriadas para organização (`bug`, `feature`, `tech-debt`, etc.)
- **Atualização de progresso em tempo real** via comments/transitions
- **Comentar mudanças importantes** (PR aberto, blocker, decisão técnica) na própria task
- **Bulk-first** quando operar em lote (Jira `/issue/bulk`, ClickUp bulk endpoints) — evita N+1 calls

---

## ⚡ Performance e Produtividade
- Minimize arquivos irrelevantes com `.codexignore`/`.gitignore`
- Use `model_reasoning_effort` adequado por tarefa (low/medium/high/xhigh)
- Prefira chunks menores para melhor performance
- Configure modelos e MCP servers em `.codex/config.toml`
- **Field selection**: ao buscar issues, especifique apenas campos necessários (`fields=summary,status,assignee`) — reduz payload em 70%+

---

## 📚 Documentação
- Mantenha documentação sincronizada em `docs/onion/`
- Use exemplos práticos e casos de uso reais
- Estruture informação para consumo por IA
- Inclua troubleshooting para problemas comuns
- KB de referência: `docs/knowledge-base/concepts/task-manager-abstraction.md`

---

## 🧪 Testes e Qualidade
- Inclua testes para funcionalidades críticas
- Valide mudanças arquiteturais com `@metaspec-gate-keeper`
- Use linting e formatting automático
- Mantenha cobertura de testes adequada

---

## 🚀 Deployment
- Siga fluxos `$engineer-*` para desenvolvimento
- Use feature branches para mudanças
- Mantenha commits atômicos e descritivos
- Documente breaking changes

---

Lembre-se: O Sistema Onion é sobre **eficiência**, **qualidade** e **automação inteligente**. Sempre detecte o provider ativo antes de operar com tasks — a mesma skill funciona em Jira, ClickUp, Asana ou Linear quando o roteamento respeita o `.env`.
