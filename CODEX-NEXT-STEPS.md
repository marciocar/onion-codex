# 🧅➡️🤖 Onion no Codex — Próximos Passos (Pós-Migração)

> **Para o agente Codex que abrir este repositório.** Este arquivo lista o que ainda
> precisa ser feito após o cut-over de Claude Code → OpenAI Codex. A migração de
> arquivos está **completa**; o que falta é **validação em runtime** e **configuração de credenciais**,
> que exigem o `codex` CLI instalado/autenticado e os tokens dos serviços.
>
> Base de referência da migração: [docs/knowledge-base/platforms/openai-codex.md](docs/knowledge-base/platforms/openai-codex.md).
> Histórico do que foi migrado: ver o commit `feat(codex): migra Sistema Onion ...`.

---

## ✅ Já concluído (não refazer)

- `AGENTS.md` (constituição) + `.codex/config.toml` + `.codex/rules/default.rules` + `.codex/hooks.json`
- **82 skills** em `.agents/skills/<slug>/SKILL.md` (invocação `$slug`)
- **49 subagentes** em `.codex/agents/*.toml` (todos parseiam como TOML válido)
- Task Manager Abstraction em `.agents/skills/task-manager/references/`
- Meta-specs, README, CONTRIBUTING e guias `docs/onion/` reescritos para Codex
- `.claude/`, `CLAUDE.md`, `.claudeignore` removidos

---

## 🔧 Tarefas pendentes (fazer em ordem)

### 1. Validar a fundação no Codex CLI
```bash
codex --version                                   # confirmar instalação
# Abrir o repo e confirmar no 1º turno que AGENTS.md foi carregado
codex execpolicy check "git status"               # esperado: allow
codex execpolicy check "git push --force"         # esperado: forbidden
```
- [ ] `AGENTS.md` carrega no início da sessão
- [ ] `config.toml` parseia sem erro (`codex --config` não reclama)
- [ ] Rules respondem allow/forbidden conforme esperado

### 2. Configurar os MCP servers (Task Manager)
Em [.codex/config.toml](.codex/config.toml) os blocos `[mcp_servers.*]` estão **comentados como template**.
Descomentar e preencher conforme o provider ativo no `.env` (`TASK_MANAGER_PROVIDER`):

- [ ] Definir `TASK_MANAGER_PROVIDER` em `.env` (`clickup` | `jira` | `asana` | `linear` | `none`)
- [ ] Descomentar o `[mcp_servers.<provider>]` correspondente e injetar os tokens via `${VAR}`
- [ ] Confirmar que o **nome** do server (`clickup`/`atlassian`/`asana`/`linear`) bate com o `mcp_servers = [...]`
      declarado no subagente especialista em `.codex/agents/<provider>-specialist.toml`
- [ ] Validar uma operação read (ex.: buscar uma task) via `@clickup-specialist` ou `@jira-specialist`

### 3. Validar skills e subagentes
- [ ] Invocar `$onion` (orquestrador) → deve mostrar roteamento por intenção
- [ ] Invocar `$engineer-start` → deve seguir o fluxo de início de feature
- [ ] `/skills` lista as 82 skills sem colisão de nome
- [ ] Spawn explícito de `@gitflow-specialist` → executa com `sandbox_mode`/`mcp_servers` corretos
- [ ] Spawn de um subagente read-only (ex.: `@research-agent`, `@code-reviewer`) → sem `sandbox_mode` write

### 4. Detecção de provider (hook)
- [ ] Com `.env` preenchido, iniciar sessão → o hook `SessionStart` deve reportar
      `Onion: TASK_MANAGER_PROVIDER ativo = <provider>`

### 5. Sweep de regressão final
```bash
# Não deve sobrar referência viva ao Claude Code (exceto comparações intencionais)
grep -rn "\.claude/" --exclude-dir=.git .
grep -rni "claude code" --exclude-dir=.git .
```
Referências **esperadas/intencionais** (não corrigir):
- `docs/knowledge-base/platforms/openai-codex.md` (KB comparativa)
- `docs/sdaal/sdaal.md` linha ~348 (tabela de concorrentes — "Claude Code" é produto externo)
- Banners de documentos históricos em `docs/analysis/`, `docs/plans/` e KBs de direções abandonadas
- Anotações de proveniência "(era .claude/...)" em `docs/meta-specs/architecture.md`

---

## ⚠️ Pontos de atenção conhecidos

- **`meta-all-tools`**: contém marcador `> **TODO Codex:** reescrever inventário de ferramentas para o toolset do Codex` — completar a reescrita do inventário de ferramentas.
- **Skills de meta-criação** (`$meta-create-agent`, `$meta-create-command`, `$meta-create-skill`):
  já reapontadas para gerar artefatos Codex (TOML/SKILL.md). Validar gerando 1 agente e 1 skill de teste.
- **`project_doc_max_bytes = 32768`** em `config.toml`: ampliado porque o `AGENTS.md` do Onion é grande.
  Se o Codex truncar, aumentar mais.
- **Limites**: skills `< 500` linhas, subagentes (`developer_instructions`) `< 300` linhas. Validar com a skill `$onion-validation`.

---

## 🧹 Limpeza opcional

- [ ] Arquivar/renomear o repositório antigo `marciocar/onion-claude` no GitHub
- [ ] Remover o remote local de backup: `git remote remove old-claude`
- [ ] Após validação completa, remover este arquivo (`CODEX-NEXT-STEPS.md`)

---

**Gerado em:** 2026-06-04 · **Status:** migração de arquivos concluída, validação runtime pendente
