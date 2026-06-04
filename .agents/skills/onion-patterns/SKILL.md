---
name: onion-patterns
description: >
  Padrões de nomenclatura, estrutura e convenções do Sistema Onion (Codex). Use ao
  criar ou editar skills, subagentes, sessions ou qualquer artefato em `.agents/`
  ou `.codex/`. Cobre estrutura de diretórios, kebab-case slugs, frontmatter de
  SKILL.md, campos de subagente TOML, limites de linhas, formatação de comments
  ClickUp e fluxos principais. Ative mesmo sem o usuário mencionar "padrão".
---

## Estrutura de Diretórios

### `.agents/skills/` (~92 skills + 4 base, slugs prefixados por categoria)
```
.agents/skills/
├── onion/                  # orquestrador mestre
├── onion-patterns/         # esta skill
├── onion-validation/       # validação
├── language-standards/     # idioma
├── engineer-*/             # fluxos de desenvolvimento (start, work, pr, ...)
├── product-*/              # gestão de produto e descoberta
├── git-*/                  # GitFlow (git-feature-start, git-hotfix-finish, ...)
├── docs-*/                 # documentação técnica e business
├── meta-*/                 # meta-skills (criar agente, skill, command)
├── validate-*/             # validações (test-strategy, qa-points, collab)
├── test-*/                 # test-unit, test-integration, test-e2e
├── development-*/           # runflow-dev
├── quick-*/                # ações rápidas
└── task-manager/           # abstração (references/)
```

### `.codex/agents/` (49 subagentes TOML)
```
.codex/agents/
├── onion.toml              # 5 meta
├── metaspec-gate-keeper.toml
├── react-developer.toml    # 20 development
├── product-agent.toml      # 8 product
├── iso-27001-specialist.toml # 5 compliance
├── branch-code-reviewer.toml # 4 git
├── test-agent.toml         # 3 testing
├── code-reviewer.toml      # 2 review
├── research-agent.toml     # 1 research
└── docker-specialist.toml  # 1 deployment
```

### `.agents/skills/<slug>/`
Cada skill em pasta própria com `SKILL.md`. Opcionalmente:
- `scripts/` — código executável (Python/Bash) para comportamento determinístico
- `references/` — docs adicionais carregadas sob demanda
- `assets/` — templates e recursos
- `agents/openai.yaml` — configuração de UI/dependências (opcional)

### `.codex/sessions/<feature-slug>/`
- `context.md` — objetivos e IDs do task manager
- `architecture.md` — decisões arquiteturais
- `plan.md` — plano de fases
- `notes.md` — notas de desenvolvimento

## Nomenclatura

### Feature slugs — kebab-case obrigatório
```
✅ user-authentication
✅ payment-integration
✅ onion-v3-refactoring

❌ UserAuth          (PascalCase)
❌ payment_integration (snake_case)
❌ feature123          (não descritivo)
```

### Skills
- Pasta: `<categoria>-<nome>/SKILL.md` em kebab-case (slug prefixado evita colisão)
- Invocação: `$categoria-nome` ou `/skills`
- Ex: `$engineer-start`, `$product-task`, `$git-feature-start`, `$meta-create-skill`

### Subagentes
- Arquivo: `nome-especialista.toml` em kebab-case (flat em `.codex/agents/`)
- Referência inline: `@nome-especialista` (sem extensão)
- Ex: `@react-developer`, `@jira-specialist`, `@onion`

## Formato de Frontmatter / Campos

### Skill (`.agents/skills/<slug>/SKILL.md`)
```yaml
---
name: categoria-nome           # kebab-case, único
description: >
  [Verbo imperativo] [o que faz]. Use quando [contexto explícito],
  mesmo que o usuário não mencione [keyword] diretamente.
---
```
> Codex usa apenas `name` + `description`. NÃO usar `model`, `category`, `tags`,
> `version`, `allowed-tools`, `paths` ou `includes` (não suportados em SKILL.md).
> Conteúdo compartilhado vai por path em `docs/onion/shared/` ou em `references/`.

### Subagente (`.codex/agents/<nome>.toml`)
```toml
name = "nome-agente"
description = "Descrição da especialização e quando usar"
developer_instructions = """
[corpo de instruções do agente — comportamento, regras, expertise]
"""
model = "gpt-5.4"               # opus→gpt-5.5, sonnet→gpt-5.4, haiku→gpt-5.4-mini
model_reasoning_effort = "medium"  # alta→high, média→medium, baixa→low
sandbox_mode = "workspace-write"   # só se o agente edita arquivos
# [mcp_servers.clickup]            # se o subagente definir MCP próprio
```
> Campos não suportados (`color`, `priority`, `category`, `expertise`, `related_*`,
> `tools`) saem do frontmatter — preservar `related_*` como texto no corpo se útil.

## Limites e Métricas

| Métrica | Limite | Razão |
|---------|--------|-------|
| Skill (SKILL.md) | < 500 linhas | Lifecycle persistente em contexto |
| Subagente (developer_instructions) | < 300 linhas | Foco e clareza |
| Description em skill | < 1024 chars | Trigger budget |

## Formatação por Provider (ClickUp)

Quando `TASK_MANAGER_PROVIDER=clickup`, comments seguem padrão visual Unicode:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ FASE N CONCLUÍDA — Nome da Fase
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 YYYY-MM-DD | Status: DONE

📊 Resultados:
∟ Item 1: valor
∟ Item 2: valor

🚀 Próxima: Fase N+1 — Nome
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Regras**:
- **Subtask**: comentário **detalhado** (métricas, arquivos, decisões)
- **Task principal**: comentário **resumido** (fase, status, próximo)
- Sempre incluir **timestamp** e **status**

Para Jira (`TASK_MANAGER_PROVIDER=jira`), usar **ADF** (JSON estruturado) — não Markdown nem Unicode.

## Fluxos Principais

### Feature Development
```
$product-task "descrição" → $engineer-start <slug> → $engineer-work → $engineer-pre-pr → $engineer-pr
```

### Hotfix
```
$engineer-hotfix → $engineer-work → $engineer-pr → $git-hotfix-finish
```

### Criação de componentes Onion
```
$meta-create-agent           # novo subagente especializado (.codex/agents/*.toml)
$meta-create-skill           # nova skill (.agents/skills/<slug>/SKILL.md)
$meta-create-command         # nova skill de workflow
$meta-create-knowledge-base  # nova KB em docs/knowledge-base/
```

## Gotchas

- **Feature slug com underscore quebra GitFlow**: branches Git e pastas de sessão usam o mesmo slug — kebab-case é obrigatório
- **Colisão de nome de subagente**: built-ins Codex (`default`, `worker`, `explorer`) são sobrescritos por nome — evitar reusá-los
- **Skill sem `name` no frontmatter não é descoberta**: sempre incluir `name` + `description`
- **TOML multi-line** em `developer_instructions`: usar `"""..."""` e escapar aspas internas

## Referências

- Knowledge Base: `docs/knowledge-base/concepts/task-manager-abstraction.md`
- KB de plataforma: `docs/knowledge-base/platforms/openai-codex.md`
- Templates compartilhados: `docs/onion/shared/`
- Skill relacionada: `language-standards` (idioma e docs)
- Skill relacionada: `onion-validation` (regras de validação)
- Subagente: `@metaspec-gate-keeper` (valida conformidade)
