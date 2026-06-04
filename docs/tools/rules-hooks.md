# Rules e Hooks

## Rules

Arquivo: `.codex/rules/default.rules`

| Regra | Decisao |
|---|---|
| `git status`, `git branch`, `git log`, `git diff`, `git show` | allow |
| `ls` | allow |
| `cat .env` | allow |
| `wc -l` | allow |
| `find .codex` | allow |
| `git push --force` | forbidden |

## Hooks

Arquivo: `.codex/hooks.json`

| Evento | Objetivo |
|---|---|
| `SessionStart` | Detectar `TASK_MANAGER_PROVIDER` em `.env` e reportar o provider ativo |

Script chamado: `.codex/hooks/session-start-provider.py`.

## Observacoes

- Hooks locais so carregam quando a camada `.codex/` do projeto esta confiada.
- Mudancas em hooks exigem nova revisao/trust no Codex.
- Validado com `codex execpolicy check --rules .codex/rules/default.rules git status` (`allow`) e `git push --force` (`forbidden`).
