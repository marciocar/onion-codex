---
name: engineer-pre-pr
description: Validação completa antes do PR. Verifica padrões e qualidade.
---

# Pre-PR - Validação Completa Antes do Pull Request

Estamos nos aproximando de finalizar o trabalho nesta branch e nos preparar para um pull request. Agora, é hora de fazer verificações finais e limpezas para garantir que estamos alinhados com nossos padrões e objetivos.

## 🔄 **Auto-Update do Task Manager**

Este comando **automaticamente atualiza** a task no **Task Manager configurado** durante preparação para PR. Antes de operar, carregue o `.env` e leia `TASK_MANAGER_PROVIDER` (`jira` | `clickup` | `asana` | `linear` | `none`) para rotear ao provider e adapter corretos. Se `none`, gere o relatório de validação localmente sem persistir.

### **✅ Updates Automáticos SEMPRE:**
- **Validação de critérios de aceitação** - Verifica todos os checkboxes
- **Comentário de preparação** com checklist completo
- **Tag 'ready-for-pr'** quando todas verificações passam
- **Tag 'needs-fixes'** se verificações falham
- **Progresso estimado** para 90% (quase pronto)

### **💬 Formato do Comentário de Pre-PR:**

O comentário de validação deve conter: resultado da validação de critérios de aceitação (completo? cobertura? critérios pendentes?), checks técnicos (meta specs, code review, testes) e indicador `readyForPR`.

**Roteamento por provider** (carregar `.env` → ler `TASK_MANAGER_PROVIDER` → seguir o adapter):

- **`clickup`** → comentário em formatação Unicode via `@clickup-specialist`. Adapter: `.agents/skills/task-manager/references/adapters/clickup.md`. Padrões: `docs/onion/shared/clickup-patterns.md`. Abstrações MCP de referência: `validateAcceptanceCriteria()` (linhas 534-600) e `commentPrePRValidation()` (linhas 603-629) em `.codex/utils/clickup-mcp-wrappers.md`.
- **`jira`** → comentário em ADF via `@jira-specialist`. Adapter: `.agents/skills/task-manager/references/adapters/jira.md`.
- **`asana`** → comentário (story) via `@task-specialist`. Adapter: `.agents/skills/task-manager/references/adapters/asana.md`.
- **`linear`** → comentário em Markdown via `@task-specialist`. Adapter: `.agents/skills/task-manager/references/adapters/linear.md`.
- **`none`** → gerar relatório localmente, sem persistir.

### **📋 Identificação da Task:**
1. **Context.md**: Lê task-id da sessão ativa
2. **Branch atual**: Detecta automaticamente pela branch git

## Checklist de Preparação:

### ✅ Validação de Critérios de Aceitação:
1. **Extrair critérios** - Ler checkboxes da description da task/subtask
2. **Validar cobertura** - Confirmar que TODOS os checkboxes estão marcados `[x]`
3. **Gerar relatório** - Criar lista de critérios validados
4. **Bloquear se incompleto** - Se algum critério não estiver marcado, indicar no comentário

### 🔧 Validações Técnicas:
1. Invoque o agente `branch-metaspec-checker` para verificar se a branch está alinhada com as meta specs do projeto.
2. Invoque o agente `branch-code-reviewer` para revisar o código e garantir que está bom para lançar.
3. Invoque o agente `branch-documentation-writer` para atualizar a documentação do projeto.
4. Invoque o agente `branch-test-planner` para finalizar a escrita de testes para a branch.

### 📋 AUTO-UPDATE:
5. **Validar critérios de aceitação** - Verificar todos os checkboxes
6. **Adicionar comentário de preparação** no Task Manager configurado automaticamente (conforme `TASK_MANAGER_PROVIDER`)
7. **Aplicar tags** (ready-for-pr ou needs-fixes)
8. **Atualizar progresso** para 90%

Você também precisará lidar com todo o feedback que esses agentes fornecerem e fazer mudanças e correções conforme necessário.

Uma vez terminado E todos os critérios de aceitação validados, me avise e peça minha permissão para abrir o Pull Request.
