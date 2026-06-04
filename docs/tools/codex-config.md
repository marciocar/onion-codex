# Configuracao Codex

## Arquivos

| Arquivo | Papel | Estado |
|---|---|---|
| `.codex/config.toml` | Configuracao de modelo, sandbox, approvals, features e MCP templates | TOML valido |
| `AGENTS.md` | Constituicao operacional do projeto para Codex | 10.949 bytes, dentro de `project_doc_max_bytes = 32768` |
| `.codex/hooks.json` | Hooks de ciclo de vida | JSON valido |
| `.codex/rules/default.rules` | Regras Starlark de permissao de shell | 6 regras declaradas |

## Configuracao Ativa

- `model = "gpt-5.4"`
- `model_reasoning_effort = "medium"`
- `sandbox_mode = "workspace-write"`
- `approval_policy = "on-request"`
- `features.memories = true`
- `features.multi_agent = true`
- `agents.max_threads = 6`
- `agents.max_depth = 1`

## Observacoes

- Os blocos `[mcp_servers.*]` estao comentados como templates.
- Configuracoes sensiveis e provider ativo devem vir de `.env`, nao do repositorio.
- Runtime local validado com `codex doctor --summary`: 17 ok, 0 warn, 0 fail.
