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

Forma exigida pelo Codex: um objeto com a chave `hooks` no topo, e os eventos dentro dela
(`{"hooks": {"SessionStart": [...]}}`). O topo aceita só `hooks` e `description` (opcional),
segundo a doc oficial (learn.chatgpt.com/docs/hooks). JSON válido não basta: com o evento direto no
topo, o Codex 0.164.0 recusa o arquivo (`unknown field 'SessionStart', expected 'description' or
'hooks'`), sai com 0 e segue sem hook. A guarda R-HOOKS de `.codex/validation/lint-artifacts.sh`
reprova o arquivo fora dessa forma.

## Observacoes

- Hooks locais so carregam quando a camada `.codex/` do projeto esta confiada.
- Mudancas em hooks exigem nova revisao/trust no Codex.
- Validado com `codex execpolicy check --rules .codex/rules/default.rules git status` (`allow`) e `git push --force` (`forbidden`).
