---
name: meta-create-command
description: |
  Criação de novas skills Codex com análise de contexto.
  Use para criar skills que seguem padrões do Sistema Onion.
---

# 📝 Criar Skill Codex

Facilitador para criação de skills seguindo padrões Onion v3.0.

## 🎯 Objetivo

Criar skills que se integram ao ecossistema existente.

## ⚡ Fluxo de Execução

### Passo 1: Análise de Contexto

```bash
# Listar skills existentes
ls .agents/skills/*/SKILL.md | wc -l

# Verificar duplicação
grep -l "name: {{command_name}}" .agents/skills/*/SKILL.md
```

### Passo 2: Determinar Categoria

SE `{{category}}` fornecido → usar diretamente
SENÃO → inferir do propósito:

| Propósito | Categoria |
|-----------|-----------|
| Desenvolvimento, código | `engineer` |
| Tasks, specs, features | `product` |
| Git, branches, PRs | `git` |
| Documentação | `docs` |
| Comandos, agentes | `meta` |
| Validações | `validate` |

A categoria é prefixada no slug da skill (ex: `engineer-deploy`).

### Passo 3: Gerar Estrutura

Usar template de `docs/onion/shared/command-template.md`. Frontmatter da skill deve conter **apenas** `name` + `description`:

```markdown
---
name: {{category}}-{{command_name}}
description: |
  [Descrição em 2 linhas]
  Use para [caso de uso principal].
---

# [Título do Comando]

[Descrição breve]

## 🎯 Objetivo

[O que esta skill faz]

## ⚡ Fluxo de Execução

### Passo 1: [Nome]
[Instruções]

### Passo 2: [Nome]
[Instruções]

## 📤 Output Esperado

[Formato de saída]

## 🔗 Referências

- [Referências relevantes]

## ⚠️ Notas

- [Notas importantes]
```

### Passo 4: Validações Obrigatórias

**CRÍTICO**: Executar TODAS as validações antes de criar:

```bash
# 1. DUPLICAÇÃO - Verificar nome único
if grep -r "^name: {{command_name}}$" .agents/skills/ 2>/dev/null; then
  echo "❌ ERRO: Skill '{{command_name}}' já existe!"
  exit 1
fi

# 2. FORMATO - Verificar kebab-case
if [[ ! "{{command_name}}" =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]; then
  echo "❌ ERRO: Nome deve ser kebab-case (ex: my-command)"
  exit 1
fi

# 3. CATEGORIA - Verificar categoria válida
VALID_CATEGORIES="engineer product git docs meta validate quick general"
if [[ ! " $VALID_CATEGORIES " =~ " {{category}} " ]]; then
  echo "❌ ERRO: Categoria '{{category}}' inválida!"
  echo "Válidas: $VALID_CATEGORIES"
  exit 1
fi
```

**Checklist de Validação:**
- [ ] Nome único (não existe em `.agents/skills/`)
- [ ] Nome em kebab-case válido
- [ ] Categoria válida (engineer|product|git|docs|meta|validate|quick|general)
- [ ] Frontmatter apenas com `name` + `description`
- [ ] < 400 linhas
- [ ] Seções obrigatórias (Objetivo, Fluxo, Output)

### Passo 5: Criar Arquivo

```bash
write .agents/skills/{{category}}-{{command_name}}/SKILL.md
```

## 📤 Output Esperado

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SKILL CRIADA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Arquivo: .agents/skills/{{category}}-{{command_name}}/SKILL.md

📋 Detalhes:
∟ Nome: {{category}}-{{command_name}}
∟ Categoria: {{category}}
∟ Linhas: ~150

🚀 Para usar: $-{{category}}-{{command_name}}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🔗 Referências

- Template: `docs/onion/shared/command-template.md`
- Agente: @command-creator-specialist

## ⚠️ Notas

- Máximo 400 linhas por skill
- Usar prompts modulares de `docs/onion/shared/`
- Sempre validar duplicação antes de criar
- Frontmatter da skill deve conter apenas `name` + `description`
