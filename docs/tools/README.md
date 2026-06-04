# Inventario de Ferramentas Codex

> Ultima atualizacao: 2026-06-04 | Fonte: auditoria pos-migracao para OpenAI Codex

Este diretorio documenta o toolset real do Sistema Onion no Codex. Ele separa recursos locais ja validaveis de pendencias runtime que dependem do `codex` CLI autenticado, trust da camada `.codex/` ou credenciais externas.

## Resumo

| Categoria | Estado |
|---|---|
| Config Codex | `.codex/config.toml` parseia como TOML valido |
| Skills | 82 skills em `.agents/skills/*/SKILL.md` |
| Subagentes | 49 subagentes em `.codex/agents/*.toml` |
| Playbooks | 31 playbooks detalhados em `docs/knowledge-base/agents/` |
| Hooks | `.codex/hooks.json` parseia como JSON valido |
| Rules | 6 `prefix_rule()` em `.codex/rules/default.rules` |
| MCPs | Templates comentados; ativacao depende de `.env` e credenciais |

## Arquivos

- [codex-config.md](codex-config.md) - configuracao do Codex no projeto.
- [skills.md](skills.md) - inventario e regras de skills.
- [subagents.md](subagents.md) - inventario e regras de subagentes.
- [mcp-servers.md](mcp-servers.md) - templates MCP e variaveis por provider.
- [rules-hooks.md](rules-hooks.md) - regras de execucao e hooks.
- [task-manager.md](task-manager.md) - deteccao e roteamento de Task Manager.

## Runtime

- `codex --version` responde `codex-cli 0.137.0`.
- `codex doctor --summary` retorna `17 ok`, `0 warn`, `0 fail`.
- `codex execpolicy check --rules .codex/rules/default.rules git status` retorna `allow`.
- `codex execpolicy check --rules .codex/rules/default.rules git push --force` retorna `forbidden`.
- No Windows, o comando foi liberado via npm em `C:\Users\Carva\AppData\Roaming\npm` e shims em `C:\Program Files\nodejs`, evitando o alias bloqueado em `WindowsApps`.
- MCPs seguem inativos ate existir `.env` com `TASK_MANAGER_PROVIDER` e tokens do provider escolhido.
- Hooks locais so rodam quando a camada `.codex/` do projeto estiver confiada no Codex.
