# 🎮 Codex Skills Architecture - Sistema Onion

Este documento explica como funcionam as **Skills do Codex** no Sistema Onion e a diferença crítica entre uma **Skill do Codex** e um comando de terminal.

## ⚡ **CONCEITO FUNDAMENTAL: Skills do Codex**

### 🎯 **O que são Skills do Codex**
Skills do Codex são capacidades personalizadas invocadas diretamente no **chat do Codex**. Cada skill é um arquivo `SKILL.md` (com frontmatter `name` + `description`) descoberto automaticamente em `.agents/skills/<slug>/` e invocado pelo seu `$slug`.

### ✅ **Como Usar (CORRETO)**
```markdown
# No chat do Codex:
$git-init                      # Inicializar Git Flow
$git-feature-start "login"     # Criar feature branch
$engineer-work "implement API" # Iniciar desenvolvimento
$product-task "add dashboard"  # Criar task no ClickUp

# Listar skills disponíveis:
/skills
```

### ❌ **Como NÃO Usar (INCORRETO)**
```bash
# ❌ NO TERMINAL - NÃO FUNCIONA:
$ $git-init                    # Não é um executável de terminal
$ ./git/feature/start          # Arquivo não executável
$ bash git-init                # Não é script bash direto
```

---

## 🏗️ **Arquitetura do Sistema**

### 📁 **Estrutura de Arquivos**
Cada skill vive em sua própria pasta sob `.agents/skills/`, com o slug derivado de `categoria-comando`. O ponto de entrada é sempre um `SKILL.md`:

```
.agents/skills/
├── git-init/
│   └── SKILL.md              # Define a skill $git-init
├── git-help/
│   └── SKILL.md              # Define a skill $git-help
├── git-feature-start/
│   └── SKILL.md              # Define a skill $git-feature-start
├── git-feature-publish/
│   └── SKILL.md              # Define a skill $git-feature-publish
├── git-feature-finish/
│   └── SKILL.md              # Define a skill $git-feature-finish
├── engineer-start/
│   └── SKILL.md              # Define a skill $engineer-start
├── engineer-work/
│   └── SKILL.md              # Define a skill $engineer-work
├── product-task/
│   └── SKILL.md              # Define a skill $product-task
└── product-spec/
    └── SKILL.md              # Define a skill $product-spec
```

Recursos auxiliares de uma skill (templates, prompts modulares) ficam em `references/` dentro da própria pasta da skill — ex.: `.agents/skills/task-manager/references/`.

### 🧾 **Frontmatter do `SKILL.md`**
```markdown
---
name: git-init
description: Inicializa o repositório com GitFlow e convenções padrão.
---

# Workflow da skill (instruções para o Codex executar)
...
```

O Codex usa o `name` para resolver o `$slug` e a `description` para descoberta/seleção da skill. O corpo em Markdown contém o workflow que o Codex interpreta.

### 🔄 **Fluxo de Execução**

| Passo | Camada | Tecnologia | Função |
|-------|--------|------------|--------|
| 1 | **Interface** | Codex Chat | Usuário digita `$git-init` |
| 2 | **Descoberta** | Codex | Resolve o `$slug` em `.agents/skills/git-init/SKILL.md` |
| 3 | **Carregamento** | File System | Lê o `SKILL.md` (frontmatter + workflow) |
| 4 | **Interpretação** | Codex | Analisa o workflow definido |
| 5 | **Execução** | Scripts | Executa bash/python dentro do workflow |
| 6 | **UX** | Modern CLI | `.codex/utils/modern-cli-ux.sh` |
| 7 | **Feedback** | Codex Chat | Resposta rica e educativa |

---

## 🎯 **Exemplo Detalhado: `$git-init`**

### 📝 **1. Usuário Invoca a Skill**
```markdown
# No chat do Codex:
User: $git-init
```

### 📄 **2. Codex Carrega a Definição**
```markdown
# Arquivo: .agents/skills/git-init/SKILL.md
# Define workflow completo de inicialização Git Flow
```

### 🧠 **3. Codex Interpreta o Workflow**
```bash
# Bash scripts embutidos no SKILL.md executam:
# - Detecção master/main
# - Criação develop branch  
# - Configuração Git Flow
# - Validações de segurança
```

### 💬 **4. Resposta Rica no Chat**
```markdown
🔧 GIT FLOW - Modern Initialization Wizard
━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 REPOSITORY ANALYSIS:
   ▶ Primary branch: ✅ main detected
   ▶ Git Flow status: ⚠️ Not initialized
   
❓ Initialize Git Flow in this repository? [Y/n]
```

---

## 🎨 **Vantagens das Skills do Codex**

### 🤖 **AI-Powered Intelligence**
-  **Context Awareness**: o Codex entende arquivos abertos, histórico, projeto
-  **Adaptive Execution**: workflows se adaptam ao contexto atual
-  **Error Recovery**: sugestões inteligentes para problemas
-  **Educational Feedback**: explica o que está fazendo

### 🎯 **Developer Experience**
-  **Natural Interface**: chat natural, invocação por `$slug`
-  **Rich Responses**: feedback visual rico com cores e formatação
-  **Context Preservation**: mantém estado entre invocações
-  **Universal Access**: funciona em qualquer pasta, qualquer projeto

### 🔒 **Enterprise Features**
-  **Safety First**: confirmações para operações críticas
-  **Team Integration**: ClickUp, sessions, project management
-  **Audit Trail**: histórico completo no chat do Codex
-  **Knowledge Sharing**: skills compartilháveis entre equipe

---

## 🛠️ **Para Desenvolvedores do Sistema**

### 📝 **Criando Novas Skills**
```markdown
# 1. Criar a pasta e o ponto de entrada:
.agents/skills/<categoria-comando>/SKILL.md

# 2. Definir o frontmatter (name + description)
# 3. Escrever o workflow em bash/python
# 4. Usar funções UX: cli_header, cli_success_box, etc.
# 5. Testar via chat: $categoria-comando  (ou /skills para listar)
```

### 🎨 **Padrões UX**
```bash
# Usar funções da biblioteca UX:
source "$HOME/.codex/utils/modern-cli-ux.sh"

cli_header "TITLE" "color"          # Headers consistentes
cli_success_box "TITLE" "message"   # Success feedback  
cli_error_box "TITLE" "message"     # Error handling
cli_progress_start "message"        # Progress indicators
```

### 🔗 **Integrações**
```bash
# ClickUp MCP
clickup_get_task_id_from_session    # Detectar task ativa
clickup_add_comment $TASK_ID        # Adicionar comentário
clickup_update_task $TASK_ID        # Atualizar status

# Session Management  
session_create $NAME                # Criar sessão desenvolvimento
session_update $NAME                # Atualizar contexto
```

---

## 📚 **Recursos Adicionais**

### 🔗 **Documentação Relacionada**
- [Sistema Onion Skills Guide](commands-guide.md)
- [Engineering Flows](engineering-flows.md)

### 🎯 **Exemplos Práticos**
- [Practical Examples](practical-examples.md)
- [Tools Reference](tools-reference.md)

### 🚀 **Getting Started**
- [Configuração Inicial](getting-started.md)
- [Primeiro Uso](getting-started.md#primeiro-uso)
- [Troubleshooting](getting-started.md#troubleshooting)

---

## ⚠️ **Avisos Importantes**

### 🔴 **NÃO Confundir Com:**
- ❌ **Bash scripts diretos** (não são executáveis de terminal)
- ❌ **NPM scripts** (não estão no package.json)  
- ❌ **Make targets** (não usam Makefile)
- ❌ **CLI tools globais** (não são instalados via npm/pip)

### ✅ **São Skills do Codex Porque:**
-  **Invocadas no chat** do Codex pelo `$slug`
-  **Definidas em `SKILL.md`** dentro de `.agents/skills/`
-  **Descobertas automaticamente** pelo Codex (frontmatter `name` + `description`)
-  **Interpretadas pelo Codex** com context awareness
-  **Integradas ao ambiente** de desenvolvimento

---

**🎯 Lembre-se sempre: Sistema Onion = Skills do Codex invocadas por `$slug` no chat do Codex!** 🚀
