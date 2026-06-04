---
name: meta-create-skill
description: |
  Orquestrador para criar, validar, otimizar e migrar Agent Skills via
  @agent-skills-specialist. Padrão Codex: skills em .agents/skills/.
---

# 🧩 Agent Skills — Criar / Validar / Otimizar / Migrar

Orquestrador para o `@agent-skills-specialist`. Detecta o modo de operação, coleta contexto e delega.

## 🎯 Objetivo

Guiar a criação e manutenção de **Agent Skills** — formato que estende capacidades do Codex via pastas com `SKILL.md`. No Sistema Onion, o padrão é `.agents/skills/`.

**Lembrete crítico**: no Codex, skills são a forma recomendada para workflows novos (suportam supporting files, frontmatter, ativação automática). Cada skill é uma pasta `.agents/skills/<slug>/SKILL.md` com frontmatter contendo apenas `name` + `description`.

---

## ⚡ Fluxo de Execução

### Passo 1: Detectar Modo de Operação

Ler a entrada do usuário e determinar:

| Argumento | Modo | O que faz |
|-----------|------|-----------|
| `create` (default) | **Criar** | Novo skill em `.agents/skills/<name>/` |
| `validate` | **Validar** | Checar skill existente (estrutura, frontmatter, lifecycle cost) |
| `optimize` | **Otimizar** | Melhorar description trigger via eval set |
| `migrate` | **Migrar** | Converter `.agents/skills/X/SKILL.md` legado em skill atualizada |
| `eval` | **Avaliar** | Configurar test cases de qualidade |

Defaults inteligentes:
- Sem modo + path para SKILL.md existente → perguntar: validate/optimize/eval?
- Sem modo + path para skill legada → sugerir `migrate`
- Sem modo + descrição livre → `create`

### Passo 2: Coletar Inputs

**Modo `create`** — perguntar se não fornecidos:
1. **Nome do skill** (kebab-case, ex: `pdf-processing`)
2. **Expertise/domínio**: que erro sistemático ou conhecimento não-óbvio o skill encapsula?
3. **Artefatos de referência**: runbooks, schemas, histórico de PRs, API specs?
4. **Scripts necessários?** Python/Bash/Deno?
5. **Features aplicáveis?**
   - Dados live (ex.: `git diff`) injetados na execução?
   - Skill destrutivo (tipo deploy) que requer confirmação explícita?
   - Pesquisa que poluiria a conversa (rodar em contexto isolado)?
   - Ativar apenas em certos arquivos (glob de paths)?

**Modo `validate`** — coletar:
1. Path do skill: `find . -name "SKILL.md" -path "*skills/*"`
2. Checar: frontmatter (apenas name + description), contagem de linhas (< 500), description quality, lifecycle cost

**Modo `optimize`** — coletar:
1. Path do skill
2. Exemplos de queries que deveriam (e não deveriam) ativar
3. Output de diagnóstico se description estiver overflow

**Modo `migrate`** — coletar:
1. Path do skill/comando legacy
2. Razões para migrar (precisa scripts? supporting files? ativação automática?)

**Modo `eval`** — coletar:
1. Path do skill
2. 2-3 tasks reais como ponto de partida

### Passo 3: Verificações Rápidas

```bash
# Estrutura padrão Codex
ls .agents/skills/ 2>/dev/null || echo "Pasta .agents/skills/ ainda não existe"

# Verificar duplicação
find . -name "SKILL.md" 2>/dev/null | xargs grep -l "^name:\s*<skill_name>\|^description:" 2>/dev/null

# Skills existentes
ls .agents/skills/ 2>/dev/null
```

### Passo 4: Delegar para @agent-skills-specialist

Invocar com contexto estruturado:

```
@agent-skills-specialist

Modo: {{action}}
Skill: {{skill_name}}
Localização alvo: .agents/skills/{{skill_name}}/SKILL.md
KB de referência: docs/knowledge-base/tools/agent-skills.md

Contexto do domínio:
{{context coletado}}

Artefatos disponíveis:
{{runbooks, schemas, exemplos}}

Features desejadas:
{{dynamic injection, contexto isolado, paths, etc.}}
```

O agente vai:
- **create**: gerar `SKILL.md` + estrutura de pasta, com frontmatter contendo apenas `name` + `description`
- **validate**: checar coerência (description quality, lifecycle cost, paths, etc.)
- **optimize**: propor iterações da description com técnica train/validation
- **migrate**: converter artefato legado em skill
- **eval**: estruturar `evals/evals.json` com test cases e assertions

### Passo 5: Confirmação Pós-Operação

```bash
# Estrutura criada
find .agents/skills/<name> -type f | sort

# Tamanho do SKILL.md
wc -l .agents/skills/<name>/SKILL.md

# Preview do frontmatter
head -10 .agents/skills/<name>/SKILL.md
```

---

## 🗺️ Estrutura Esperada

### Skill no Codex (padrão Onion)
```
.agents/skills/<name>/
├── SKILL.md              # < 500 linhas, frontmatter só name + description
├── scripts/              # Paths relativos
│   └── *.py / *.sh
├── references/           # Carregados sob demanda
└── examples/             # Exemplos de output
```

### SKILL.md mínimo
```markdown
---
name: <name>
description: >
  [O que faz — verbos de ação].
  Use quando [contexto explícito], mesmo que o usuário
  não mencione [keyword] diretamente.
---

## Instruções
[Passo a passo concreto]

## Gotchas
- [Erros sistemáticos do domínio]
```

---

## 📤 Output Esperado

```
✅ SKILL {{action}}

━━━━━━━━━━━━━━

📁 Arquivo: .agents/skills/{{skill_name}}/SKILL.md
📏 Linhas: N (< 500)

📋 RESULTADO:
   ∟ description: [preview 80 chars]
   ∟ Features: [dynamic injection, contexto isolado, etc.]
   ∟ Scripts: sim/não
   ∟ References: sim/não

🔍 QUALIDADE:
   ∟ Frontmatter: ✅ válido (só name + description)
   ∟ Description: ✅ imperativa + contexto
   ∟ Lifecycle cost: ✅ < 500 linhas
   ∟ Gotchas: ✅/⚠️ presente/ausente

🚀 PRÓXIMOS PASSOS:
   ∟ Testar: $-{{skill_name}} ou pergunta que bate com description
   ∟ Otimizar trigger: $meta-create-skill optimize {{skill_name}}
   ∟ Avaliar qualidade: $meta-create-skill eval {{skill_name}}

━━━━━━━━━━━━━━
```

---

## 💡 Exemplos de Uso

```bash
# Criar skill no Codex (default)
$meta-create-skill "processar faturas no formato TISS"

# Validar skill existente
$meta-create-skill validate .agents/skills/pdf-processing/

# Otimizar description (trigger accuracy)
$meta-create-skill optimize pdf-processing

# Migrar artefato legacy para skill
$meta-create-skill migrate .agents/skills/deploy/

# Configurar evals de qualidade
$meta-create-skill eval csv-analyzer
```

---

## 🔗 Referências

- **Agente principal**: @agent-skills-specialist
- **KB**: `docs/knowledge-base/tools/agent-skills.md`
- **Docs**: https://agentskills.io/specification (spec aberta)
- **Exemplos reais**: https://github.com/anthropics/skills
- **Relacionado**: `$meta-create-command` (criar skills por categoria)
- **Relacionado**: `$meta-create-agent` (subagents `.codex/agents/`)

## ⚠️ Notas

- **Padrão Onion**: `.agents/skills/`
- **Frontmatter**: apenas `name` + `description` (sem paths/allowed-tools)
- Skill ativado permanece em contexto pelo resto da sessão — cada linha extra é custo recorrente
- Skill gerado sem contexto de domínio real tem valor mínimo — sempre extrair de runbooks/schemas/PRs
- Se o agente já lida bem com o task sem o skill → o skill não agrega valor
