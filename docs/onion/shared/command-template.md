# Template Padrão para Comandos - Sistema Onion v3.0

---

## 📋 Estrutura YAML Obrigatória

```yaml
---
# ═══════════════════════════════════════════════════════════════════════════════
# HEADER OBRIGATÓRIO
# ═══════════════════════════════════════════════════════════════════════════════

name: nome-do-comando
description: |
  Descrição clara em 1-2 linhas do propósito do comando.
  Use para [caso de uso principal].
model: sonnet                    # sonnet | opus | gpt-4

# ═══════════════════════════════════════════════════════════════════════════════
# PARÂMETROS (opcional)
# ═══════════════════════════════════════════════════════════════════════════════

parameters:
  - name: param1
    description: Descrição do parâmetro
    required: true               # true | false
  - name: param2
    description: Parâmetro opcional
    required: false
    default: valor-padrao

# ═══════════════════════════════════════════════════════════════════════════════
# METADATA
# ═══════════════════════════════════════════════════════════════════════════════

category: engineer               # engineer | product | git | docs | meta | validate
tags:
  - tag1
  - tag2

version: "3.0.0"
updated: "2025-11-24"

# ═══════════════════════════════════════════════════════════════════════════════
# RELACIONAMENTOS (opcional)
# ═══════════════════════════════════════════════════════════════════════════════

related_commands:
  - /category/command1
  - /category/command2

related_agents:
  - agent-name-1
  - agent-name-2

# ═══════════════════════════════════════════════════════════════════════════════
# INCLUDES (para modularização)
# ═══════════════════════════════════════════════════════════════════════════════

# Use @include para referenciar prompts modulares
# Os arquivos ficam em common/prompts/
includes:
  - common/prompts/clickup-patterns.md
  - common/prompts/validation-rules.md
---
```

---

## 📐 Estrutura do Corpo (Máximo ~400 linhas)

### Seções Obrigatórias

```markdown
# Nome do Comando

[Descrição breve - 1-2 frases]

## 🎯 Objetivo

[O que este comando faz e quando usar]

## ⚡ Fluxo de Execução

### Passo 1: [Nome]
[Instruções claras]

### Passo 2: [Nome]
[Instruções claras]

## 📤 Output Esperado

[Formato de saída esperado]
```

### Seções Opcionais

```markdown
## ⚙️ Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| param1 | string | ✅ | Descrição |
| param2 | string | ❌ | Descrição |

## 🔗 Comandos Relacionados

- `/category/cmd1` - Para X
- `/category/cmd2` - Para Y

## ⚠️ Notas Importantes

- Nota 1
- Nota 2
```

---

## 🎨 Convenções de Formatação

### Emojis Padrão por Seção

| Seção | Emoji |
|-------|-------|
| Objetivo | 🎯 |
| Fluxo | ⚡ |
| Output | 📤 |
| Parâmetros | ⚙️ |
| Relacionados | 🔗 |
| Notas | ⚠️ |
| Validação | ✅ |
| Erro | ❌ |
| Exemplo | 💡 |

### Formatação de Código

```markdown
# Comando terminal
`comando --flag`

# Bloco de código
\`\`\`bash
comando multiline
\`\`\`

# Referência a arquivo
`path/to/file.md`

# Referência a agente
@nome-do-agente

# Referência a comando
/category/comando
```

---

## 📏 Limites e Regras

### Tamanho Máximo

| Tipo | Limite | Ação se Exceder |
|------|--------|-----------------|
| Comando simples | ~200 linhas | OK |
| Comando médio | ~300 linhas | OK |
| Comando complexo | ~400 linhas | Modularizar |
| **Máximo absoluto** | **400 linhas** | **Obrigatório modularizar** |

### Estratégias de Modularização

1. **Extrair para prompts/**
   - Seções repetitivas → `common/prompts/`
   - Templates → `common/templates/`

2. **Dividir em sub-comandos**
   - Workflow grande → `/category/main.md` + `/category/sub1.md`

3. **Usar @include**
   ```markdown
   ## Validação
   @include common/prompts/validation-rules.md
   ```

4. **Referenciar agentes**
   ```markdown
   Para detalhes técnicos, use @specialist-agent
   ```

---

## ✅ Checklist de Qualidade

### Header YAML
- [ ] `name` em kebab-case
- [ ] `description` clara em 1-2 linhas
- [ ] `model` definido
- [ ] `category` válida
- [ ] `version` atualizada

### Corpo
- [ ] Objetivo claro
- [ ] Fluxo de execução step-by-step
- [ ] Output esperado definido
- [ ] < 400 linhas total

### Modularização
- [ ] Seções repetitivas extraídas
- [ ] Templates em common/templates/
- [ ] Prompts em common/prompts/

---

## 💡 Exemplo Completo

```yaml
---
name: example-command
description: |
  Comando exemplo demonstrando estrutura padrão v3.0.
  Use como referência para criar novos comandos.
model: sonnet

parameters:
  - name: target
    description: Alvo do comando
    required: true

category: meta
tags:
  - example
  - template

version: "3.0.0"
updated: "2025-11-24"

related_commands:
  - /meta/create-command

related_agents:
  - command-creator-specialist
---

# Example Command

Comando de exemplo para demonstrar a estrutura padrão.

## 🎯 Objetivo

Demonstrar a estrutura correta de um comando Onion v3.0.

## ⚡ Fluxo de Execução

### Passo 1: Validar Input
- Verificar se `{{target}}` foi fornecido
- Validar formato esperado

### Passo 2: Processar
- Executar lógica principal
- Gerar output

### Passo 3: Finalizar
- Apresentar resultado
- Sugerir próximos passos

## 📤 Output Esperado

\`\`\`
✅ Comando executado com sucesso
Target: {{target}}
Próximo: /meta/outro-comando
\`\`\`
```

