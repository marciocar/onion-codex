# MCP Servers

## Estado Atual

Os MCP servers estao declarados como templates comentados em `.codex/config.toml`. Nenhum MCP deve ser tratado como ativo ate o provider ser configurado em `.env` e o bloco correspondente ser descomentado.

## Templates

| Provider | Server id esperado | Variaveis obrigatorias |
|---|---|---|
| ClickUp | `clickup` | `CLICKUP_API_TOKEN` |
| Jira | `atlassian` | `JIRA_HOST`, `JIRA_EMAIL`, `JIRA_API_TOKEN` |
| Asana | `asana` | `ASANA_ACCESS_TOKEN` |
| Linear | `linear` | `LINEAR_API_KEY` |

## Regras

- Nao commitar tokens.
- Nao assumir provider quando `.env` estiver ausente.
- Se `TASK_MANAGER_PROVIDER=none`, operar offline via `@task-specialist`.
- Validar leitura simples no provider antes de executar escrita ou bulk.

## Pendencia Runtime

Ativar MCPs depende de credenciais externas e trust da camada `.codex/` no Codex.
