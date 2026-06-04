---
name: task-manager
description: >
  Abstração provider-agnóstica de gerenciamento de tarefas do Sistema Onion. Use ao
  criar, ler, atualizar, comentar ou mudar status de tasks em qualquer provider
  (ClickUp, Jira, Asana, Linear) ou offline (none). Detecta o provider ativo via
  TASK_MANAGER_PROVIDER no .env e delega ao subagente especialista correto. Ative
  sempre antes de qualquer operação com tasks, mesmo sem o usuário mencionar o provider.
---

## Fluxo obrigatório

1. **Carregar** `.env` (`set -a; source .env; set +a`)
2. **Ler** `TASK_MANAGER_PROVIDER` → `jira` | `clickup` | `asana` | `linear` | `none`
3. **Conferir** variáveis obrigatórias do provider (ver `references/detector.md`)
4. **Delegar** ao subagente correto e formatar conforme o provider

## Roteamento

| Provider | Subagente | MCP server (config.toml) |
|----------|-----------|--------------------------|
| `jira` | `@jira-specialist` | `atlassian` |
| `clickup` | `@clickup-specialist` | `clickup` |
| `asana` | `@task-specialist` (agnóstico) | `asana` |
| `linear` | `@task-specialist` (agnóstico) | `linear` |
| `none` | `@task-specialist` (offline, não persiste) | — |

- Estratégia/priorização → `@product-agent`
- Decomposição hierárquica agnóstica → `@task-specialist`

## Contrato (ITaskManager)

A interface unificada (`createTask`, `getTask`, `updateTask`, `addComment`, `updateStatus`,
`createSubtask`, `getSubtasks`, `updateCustomField`) está em `references/interface.md`.
Detecção, factory e tipos em `references/detector.md`, `references/factory.md`, `references/types.md`.

## Formatação por provider

- **ClickUp**: descriptions em Markdown nativo; comments em Unicode visual (`━━━`, `▶`, `◆`) — ver `references/adapters/clickup.md`
- **Jira Cloud (v3)**: descriptions/comments em **ADF** (JSON); transitions via `POST /issue/{key}/transitions` — ver `references/adapters/jira.md`
- **Asana**: HTML notes ou plain text — `references/adapters/asana.md`
- **Linear**: Markdown nativo — `references/adapters/linear.md`

## Fallback gracioso

Se variável obrigatória ausente/inválida:
1. Avisar em pt-BR qual variável falta
2. Sugerir `$meta-setup-integration`
3. Não inventar valores nem assumir outro provider

## Referências

- Detalhes completos: `.agents/skills/task-manager/references/`
- KB: `docs/knowledge-base/concepts/task-manager-abstraction.md`
- Wrappers MCP ClickUp: `.codex/utils/clickup-mcp-wrappers.md`
