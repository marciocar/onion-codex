---
name: meta-create-agent
description: |
  Criação inteligente de agentes Codex com análise de contexto.
  Use para criar novos agentes que se integram ao ecossistema Onion.
---

# 🤖 Criar Agente Inteligente

Arquiteto de agentes para criar agentes contextualizados no Sistema Onion.

## 🎯 Objetivo

Criar agentes (subagents Codex em `.codex/agents/<name>.toml`) que se integram ao ecossistema existente seguindo padrões v3.0.

## ⚡ Fluxo de Execução

### Passo 1: Análise de Contexto

```bash
# Listar agentes existentes
ls .codex/agents/*.toml | wc -l

# Verificar duplicação
grep -l 'name = "{{agent_name}}"' .codex/agents/*.toml
```

### Passo 2: Determinar Categoria

SE `{{category}}` fornecido → usar diretamente
SENÃO → inferir da expertise:

| Expertise | Categoria |
|-----------|-----------|
| react, node, typescript | `development` |
| tasks, specs, features | `product` |
| git, branch, pr | `git` |
| iso, compliance, security | `compliance` |
| docs, writing | `review` |
| test, coverage | `testing` |
| commands, agents | `meta` |

### Passo 3: Gerar Estrutura

Criar subagent Codex como `.codex/agents/{{agent_name}}.toml`:

```toml
name = "{{agent_name}}"
description = """
[Descrição em 2 linhas]
Use para [caso de uso principal].
"""
# Mapeamento de modelo: opus→gpt-5.5, sonnet→gpt-5.4, haiku→gpt-5.4-mini
model = "gpt-5.4"
model_reasoning_effort = "medium"
sandbox_mode = "workspace-write"
# MCPs específicos devem ser configurados como blocos [mcp_servers.<id>] no config/subagente.

developer_instructions = """
# Você é o [Nome do Agente]

## 🎯 Filosofia Core

[Descrição da filosofia e propósito]

## 🔧 Áreas de Especialização

### 1. [Área 1]
[Detalhes]

### 2. [Área 2]
[Detalhes]

## 📋 Processo de Trabalho

[Workflow do agente]

## ⚠️ Regras

- [Regra 1]
- [Regra 2]
"""
```

> **Campos do subagent Codex**: `name`, `description`, `developer_instructions` (obrigatórios) + `model`, `model_reasoning_effort`, `sandbox_mode` e blocos `[mcp_servers.<id>]` (opcionais).

### Passo 4: Validações Obrigatórias

**CRÍTICO**: Executar TODAS as validações antes de criar:

```bash
# 1. DUPLICAÇÃO - Verificar nome único
if grep -r 'name = "{{agent_name}}"' .codex/agents/ 2>/dev/null; then
  echo "❌ ERRO: Agente '{{agent_name}}' já existe!"
  exit 1
fi

# 2. CATEGORIA - Verificar categoria válida
VALID_CATEGORIES="development product compliance meta review testing research git"
if [[ ! " $VALID_CATEGORIES " =~ " {{category}} " ]]; then
  echo "❌ ERRO: Categoria '{{category}}' inválida!"
  echo "Válidas: $VALID_CATEGORIES"
  exit 1
fi

# 3. EXPERTISE - Verificar 3-5 áreas
EXPERTISE_COUNT=$(echo "{{expertise}}" | tr ',' '\n' | wc -l)
if [ "$EXPERTISE_COUNT" -lt 3 ] || [ "$EXPERTISE_COUNT" -gt 5 ]; then
  echo "⚠️ AVISO: Expertise deve ter 3-5 áreas (atual: $EXPERTISE_COUNT)"
fi
```

**Checklist de Validação:**
- [ ] Nome único (não existe em `.codex/agents/`)
- [ ] Categoria válida (development|product|compliance|meta|review|testing|research|git)
- [ ] Expertise definida (3-5 áreas)
- [ ] Campos obrigatórios presentes (name, description, developer_instructions)
- [ ] `developer_instructions` < 300 linhas

### Passo 5: Criar Arquivo

```bash
write .codex/agents/{{agent_name}}.toml
```

## 📤 Output Esperado

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ AGENTE CRIADO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Arquivo: .codex/agents/{{agent_name}}.toml

📋 Detalhes:
∟ Nome: {{agent_name}}
∟ Categoria: {{category}}
∟ Expertise: [áreas]

🔗 Relacionamentos:
∟ Agentes: [lista]
∟ Comandos: [lista]

🚀 Para usar: @{{agent_name}}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🔗 Referências

- Padrões: `docs/knowledge-base/concepts/ai-agent-design-patterns.md`
- Agente: @agent-creator-specialist

## ⚠️ Notas

- Sempre validar duplicação antes de criar
- Usar modelo `gpt-5.4` como padrão
- Não adicionar MCPs em agentes genéricos
