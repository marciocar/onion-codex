# Task Manager

## Provider-Aware

Antes de qualquer operacao com tasks, leia `TASK_MANAGER_PROVIDER` em `.env`.

Valores validos:

- `jira`
- `clickup`
- `asana`
- `linear`
- `none`

## Roteamento

| Provider | Subagente tecnico | Adapter |
|---|---|---|
| Jira | `@jira-specialist` | `.agents/skills/task-manager/references/adapters/jira.md` |
| ClickUp | `@clickup-specialist` | `.agents/skills/task-manager/references/adapters/clickup.md` |
| Asana | `@task-specialist` | `.agents/skills/task-manager/references/adapters/asana.md` |
| Linear | `@task-specialist` | `.agents/skills/task-manager/references/adapters/linear.md` |
| none | `@task-specialist` | offline, sem persistencia externa |

## Estado Atual do Workspace

Nao ha `.env` versionado. Portanto, nenhuma operacao de task manager deve chamar API externa ate a configuracao ser criada pelo usuario.

## Formatos

- Jira Cloud REST v3: ADF para descricoes e comentarios.
- Jira Server/DC v2: wiki markup ou plain text.
- ClickUp: Markdown em `markdown_description`; Unicode visual em `commentText`.
- Asana: HTML notes ou plain text.
- Linear: Markdown nativo.
