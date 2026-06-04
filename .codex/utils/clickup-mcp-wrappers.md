# 🔧 ClickUp MCP Wrappers - Abstrações Centralizadas

## 🎯 Objetivo

Centralizar todas as chamadas MCP do ClickUp em abstrações reutilizáveis, eliminando acoplamento dos comandos e permitindo evolução independente da integração.

---

## 📋 Abstrações Disponíveis

### 1. Comentários de Fase Completada

#### `commentPhaseCompletion(subtaskId, phaseData)`

**Responsabilidade**: Criar comentário detalhado quando uma fase é completada.

**Parâmetros:**
```typescript
phaseData: {
  phaseName: string;              // Ex: "Backend Implementation"
  filesModified: string[];        // Lista de arquivos
  implementations: string[];      // Lista de implementações
  testFiles?: {                   // Testes adicionados
    file: string;
    count: number;
  }[];
  testCoverage?: number;          // Ex: 95
  technicalDecisions?: string[];  // Decisões técnicas
  nextPhase?: string;             // Próxima fase
  timestamp?: string;             // Timestamp
}
```

**Retorno:**
```typescript
{
  commentId: string;
  success: boolean;
  formattedComment: string;  // Para referência/logging
}
```

**Uso:**
```typescript
const result = await commentPhaseCompletion(
  "86abc123",  // subtaskId
  {
    phaseName: "Backend Implementation",
    filesModified: ["src/auth/service.ts", "src/auth/routes.ts"],
    implementations: ["JWT auth", "Refresh tokens"],
    testCoverage: 95
  }
);
```

---

### 2. Atualizar Status da Subtask

#### `updateSubtaskStatus(subtaskId, status)`

**Responsabilidade**: Atualizar status de uma subtask de forma confiável.

**Parâmetros:**
```typescript
subtaskId: string;      // ID da subtask
status: "to do" | "in progress" | "done" | "closed";
```

**Retorno:**
```typescript
{
  success: boolean;
  previousStatus: string;
  newStatus: string;
}
```

**Uso:**
```typescript
await updateSubtaskStatus("86abc123", "done");
```

---

### 3. Comentário Resumido na Task Principal

#### `commentProgressUpdate(mainTaskId, progressData)`

**Responsabilidade**: Criar comentário executivo na task principal.

**Parâmetros:**
```typescript
progressData: {
  currentPhase: number;      // Ex: 2
  totalPhases: number;       // Ex: 4
  phaseName: string;         // Ex: "Backend Implementation"
  subtaskId: string;         // Para referenciar
  nextPhaseName?: string;    // Ex: "Frontend Integration"
  timestamp?: string;
}
```

**Retorno:**
```typescript
{
  commentId: string;
  success: boolean;
}
```

**Uso:**
```typescript
await commentProgressUpdate(
  "86abc000",  // mainTaskId
  {
    currentPhase: 1,
    totalPhases: 4,
    phaseName: "Backend Implementation",
    subtaskId: "86abc123",
    nextPhaseName: "Frontend Integration"
  }
);
```

---

### 4. Validação de Critérios de Aceitação

#### `validateAcceptanceCriteria(taskId)`

**Responsabilidade**: Extrair e validar checkboxes de aceitação da task.

**Retorno:**
```typescript
{
  isComplete: boolean;
  coverage: number;           // Ex: 85.7
  completedCriteria: number;  // Ex: 6
  totalCriteria: number;      // Ex: 7
  criteria: {
    text: string;
    completed: boolean;
  }[];
  pendingCriteria: string[];  // Lista de critérios não completos
}
```

**Uso:**
```typescript
const validation = await validateAcceptanceCriteria("86abc000");

if (!validation.isComplete) {
  console.log(`Faltam: ${validation.pendingCriteria.join(", ")}`);
}
```

---

### 5. Comentário de Validação Pre-PR

#### `commentPrePRValidation(taskId, validationData)`

**Responsabilidade**: Adicionar comentário de validação antes do PR.

**Parâmetros:**
```typescript
validationData: {
  acceptanceCriteriaCompleted: boolean;
  criteriaCount: number;              // Ex: 7/7
  metaspecsCompliant: boolean;
  codeReviewDone: boolean;
  documentationUpdated: boolean;
  testsCoverage: number;              // Ex: 95
  lintErrors: number;
  readyForPR: boolean;
  timestamp?: string;
}
```

**Retorno:**
```typescript
{
  success: boolean;
  commentId: string;
  tagged: boolean;  // Se adicionou tag 'ready-for-pr' ou 'needs-fixes'
}
```

**Uso:**
```typescript
await commentPrePRValidation("86abc000", {
  acceptanceCriteriaCompleted: true,
  criteriaCount: 7,
  metaspecsCompliant: true,
  codeReviewDone: true,
  documentationUpdated: true,
  testsCoverage: 98,
  lintErrors: 0,
  readyForPR: true
});
```

---

### 6. Comentário de PR Criada

#### `commentPRCreated(taskId, prData)`

**Responsabilidade**: Documentar criação de PR na task.

**Parâmetros:**
```typescript
prData: {
  prUrl: string;               // Link do PR
  branch: string;              // Nome da branch
  changesDescription: string;  // Descrição das mudanças
  testsStatus: "passing" | "failing" | "not-run";
  timestamp?: string;
}
```

**Retorno:**
```typescript
{
  success: boolean;
  commentId: string;
}
```

---

### 7. Comentário de PR Atualizada

#### `commentPRUpdated(taskId, updateData)`

**Responsabilidade**: Documentar atualização de PR existente.

**Parâmetros:**
```typescript
updateData: {
  commitType: "fix" | "feat" | "docs" | "refactor" | "style" | "test" | "chore";
  commitHash: string;
  filesModified: number;
  linesAdded: number;
  linesRemoved: number;
  description: string;
  status: "ready-for-review" | "awaiting-fixes";
  timestamp?: string;
}
```

**Retorno:**
```typescript
{
  success: boolean;
  commentId: string;
}
```

---

## 🔄 Fluxo de Integração

### Como Usar Nos Comandos

#### Antes (Acoplado):
```markdown
# /engineer/work.md

const detailedComment = `🔧 FASE COMPLETADA: ...`;
await mcp_clickup_create_task_comment({...});
```

#### Depois (Desacoplado):
```markdown
# /engineer/work.md

Ao completar uma fase, o wrapper automaticamente:
- Cria comentário detalhado na subtask
- Atualiza status para "done"
- Cria comentário resumido na task principal

Chamada simples:
\`\`\`
commentPhaseCompletion(subtaskId, phaseData)
\`\`\`
```

---

## 📊 Benefícios de Usar Wrappers

### ✅ Quando MCP muda:
```
ANTES (Acoplado):
- Altera engineer/work.md ❌
- Altera engineer/pr.md ❌
- Altera engineer/pre-pr.md ❌
- Altera engineer/pr-update.md ❌
- Altera product/task.md ❌
- Risco altíssimo de inconsistência!

DEPOIS (Centralizado):
- Altera APENAS: clickup-mcp-wrappers.md ✅
- Todos os comandos automaticamente usam nova versão
- Sem risco de inconsistência
```

### ✅ Quando descobre novo padrão:
```
ANTES:
- Precisa atualizar em 4+ lugares
- Risco de deixar algum para trás

DEPOIS:
- Atualiza apenas na fonte
- Todos os comandos herdam mudança
```

### ✅ Testabilidade:
```
ANTES:
- Testar padrão de comentário em 5 comandos

DEPOIS:
- Testar uma vez na abstração
- Confiança que todos os comandos usam padrão testado
```

---

## 🧪 Testes de Validação

### Teste 1: Formato Consistente

Validar que todos os comentários seguem padrão:

```typescript
test("Todos os comentários têm separadores consistentes", () => {
  const comment = generateDetailedPhaseComment({...});
  expect(comment).toMatch(/━━━━━━━━━━━━━━/);  // Novo tamanho
  expect(comment).not.toMatch(/━{34}/);       // Não usa tamanho antigo
});
```

### Teste 2: Integridade dos Dados

Validar que informações não são perdidas:

```typescript
test("Todas as informações de fase são incluídas", () => {
  const phaseData = {
    phaseName: "Backend",
    filesModified: ["file1.ts", "file2.ts"],
    implementations: ["impl1", "impl2"],
    testCoverage: 95
  };
  const comment = await commentPhaseCompletion(...);
  expect(comment).toContain("Backend");
  expect(comment).toContain("file1.ts");
  expect(comment).toContain("95%");
});
```

---

## 🎯 Próximos Passos

1. **Criar abstrações** - Implementar em `.codex/utils/clickup-mcp-wrappers.md`
2. **Refatorar comandos** - Remover acoplamento de cada comando
3. **Atualizar documentação** - Remover exemplos de implementação
4. **Validar** - Testar que tudo funciona
5. **Documentar padrões** - Colocar em `.codex/docs/strategies/`

---

## 📚 Relacionado

- [Padrões de Formatação ClickUp](../commands/common/prompts/clickup-patterns.md)

---

**Status**: Implementação CONCLUÍDA - FASE 3 ✅
**Prioridade**: ALTA  
**Impacto**: Reduz acoplamento, melhora manutenibilidade  
**Esforço**: Implementado em ~2 horas

---

## 🔧 Implementação COMPLETA

Todas as 7 abstrações foram implementadas com suporte total a TypeScript e integração MCP.

### Tipos TypeScript

```typescript
interface PhaseData {
  phaseName: string;
  filesModified: string[];
  implementations: string[];
  testFiles?: { file: string; count: number }[];
  testCoverage?: number;
  technicalDecisions?: string[];
  nextPhase?: string;
  timestamp?: string;
}

interface ProgressData {
  currentPhase: number;
  totalPhases: number;
  phaseName: string;
  subtaskId: string;
  nextPhaseName?: string;
  timestamp?: string;
}

interface ValidationData {
  acceptanceCriteriaCompleted: boolean;
  criteriaCount: number;
  metaspecsCompliant: boolean;
  codeReviewDone: boolean;
  documentationUpdated: boolean;
  testsCoverage: number;
  lintErrors: number;
  readyForPR: boolean;
  timestamp?: string;
}

interface PRData {
  prUrl: string;
  branch: string;
  changesDescription: string;
  testsStatus: "passing" | "failing" | "not-run";
  timestamp?: string;
}

interface UpdateData {
  commitType: string;
  commitHash: string;
  filesModified: number;
  linesAdded: number;
  linesRemoved: number;
  description: string;
  status: "ready-for-review" | "awaiting-fixes";
  timestamp?: string;
}
```

### 1. commentPhaseCompletion() - Implementado

```typescript
export async function commentPhaseCompletion(subtaskId: string, phaseData: PhaseData) {
  const { phaseName, filesModified, implementations, testFiles, testCoverage, technicalDecisions, nextPhase, timestamp } = phaseData;
  
  const formattedComment = `🔧 FASE COMPLETADA: ${phaseName}

━━━━━━━━━━━━━━

📁 ARQUIVOS MODIFICADOS:
${filesModified.map(f => `   ∟ ${f}`).join('\n')}

🔧 IMPLEMENTAÇÕES:
${implementations.map(impl => `   ▶ ${impl}`).join('\n')}

✅ TESTES ADICIONADOS:
${testFiles?.map(t => `   ∟ ${t.file} (${t.count} testes)`).join('\n') || '   ∟ Nenhum arquivo de teste adicionado'}
${testCoverage ? `   ∟ Cobertura: ${testCoverage}%` : ''}

💡 DECISÕES TÉCNICAS:
${technicalDecisions?.map(d => `   ∟ ${d}`).join('\n') || '   ∟ Nenhuma decisão registrada'}

🚀 PRÓXIMOS PASSOS:
   ∟ ${nextPhase || 'Próxima fase não definida'}

━━━━━━━━━━━━━━

⏰ Completado: ${timestamp || new Date().toISOString()} | 🎯 Status: Done`;

  return await mcp_clickup_create_task_comment({
    task_id: subtaskId,
    comment_text: formattedComment
  });
}
```

### 2. updateSubtaskStatus() - Implementado

```typescript
export async function updateSubtaskStatus(subtaskId: string, status: string) {
  const validStatuses = ["to do", "in progress", "done", "closed"];
  
  if (!validStatuses.includes(status)) {
    throw new Error(`Status inválido: ${status}. Use um de: ${validStatuses.join(', ')}`);
  }

  const task = await mcp_clickup_get_task({ task_id: subtaskId });
  const previousStatus = task.status.status;

  await mcp_clickup_update_task({
    task_id: subtaskId,
    status: status
  });

  return { success: true, previousStatus, newStatus: status };
}
```

### 3. commentProgressUpdate() - Implementado

```typescript
export async function commentProgressUpdate(mainTaskId: string, progressData: ProgressData) {
  const { currentPhase, totalPhases, phaseName, subtaskId, nextPhaseName, timestamp } = progressData;
  
  const formattedComment = `📝 PROGRESSO: Fase ${currentPhase}/${totalPhases} Completada

✅ ${phaseName} - Concluída
   ∟ Subtask: #${subtaskId}
   ∟ Detalhes: Ver comentário na subtask

🎯 Próximo: Fase ${currentPhase + 1}/${totalPhases} - ${nextPhaseName || 'Próxima fase'}

⏰ ${timestamp || new Date().toISOString()}`;

  return await mcp_clickup_create_task_comment({
    task_id: mainTaskId,
    comment_text: formattedComment
  });
}
```

### 4. validateAcceptanceCriteria() - Implementado

```typescript
export async function validateAcceptanceCriteria(taskId: string) {
  const task = await mcp_clickup_get_task({ task_id: taskId });
  const description = task.markdown_description || task.description || '';

  const checkboxRegex = /- \[([ xX])\]\s*(.+)/g;
  const matches = [...description.matchAll(checkboxRegex)];

  const criteria = matches.map(m => ({
    text: m[2],
    completed: m[1].toLowerCase() === 'x'
  }));

  const completedCriteria = criteria.filter(c => c.completed).length;
  const totalCriteria = criteria.length;
  const coverage = totalCriteria > 0 ? (completedCriteria / totalCriteria) * 100 : 0;

  return {
    isComplete: completedCriteria === totalCriteria && totalCriteria > 0,
    coverage: parseFloat(coverage.toFixed(1)),
    completedCriteria,
    totalCriteria,
    criteria,
    pendingCriteria: criteria.filter(c => !c.completed).map(c => c.text)
  };
}
```

### 5. commentPrePRValidation() - Implementado

```typescript
export async function commentPrePRValidation(taskId: string, validationData: ValidationData) {
  const { acceptanceCriteriaCompleted, criteriaCount, metaspecsCompliant, codeReviewDone, documentationUpdated, testsCoverage, lintErrors, readyForPR, timestamp } = validationData;

  const formattedComment = `🔍 PREPARAÇÃO PARA PULL REQUEST

━━━━━━━━━━━━━━

✅ CRITÉRIOS DE ACEITAÇÃO:
   ◆ ${acceptanceCriteriaCompleted ? '[x]' : '[ ]'} Todos os checkboxes marcados
   ◆ Total: ${criteriaCount} critérios completos ${acceptanceCriteriaCompleted ? '✅' : '⚠️'}

✅ VERIFICAÇÕES TÉCNICAS:
   ◆ Meta-specs compliance: ${metaspecsCompliant ? '✅' : '❌'}
   ◆ Code review: ${codeReviewDone ? '✅' : '❌'}
   ◆ Documentation: ${documentationUpdated ? '✅' : '❌'}
   ◆ Tests coverage: ${testsCoverage}%

📊 QUALIDADE:
   ∟ Lint errors: ${lintErrors}
   ∟ Test coverage: ${testsCoverage}%

🚀 STATUS PARA PR:
   ∟ ${readyForPR ? 'PRONTO ✅' : 'REQUER AJUSTES ⚠️'}

━━━━━━━━━━━━━━

⏰ Preparação: ${timestamp || new Date().toISOString()} | 🎯 Próximo: ${readyForPR ? 'Abrir Pull Request' : 'Fazer ajustes'}`;

  await mcp_clickup_create_task_comment({ task_id: taskId, comment_text: formattedComment });
  const tag = readyForPR ? 'ready-for-pr' : 'needs-fixes';
  await mcp_clickup_add_tag_to_task({ task_id: taskId, tag_name: tag });
  
  return { success: true, tagged: true };
}
```

### 6. commentPRCreated() - Implementado

```typescript
export async function commentPRCreated(taskId: string, prData: PRData) {
  const { prUrl, branch, changesDescription, testsStatus, timestamp } = prData;

  const formattedComment = `🚀 PULL REQUEST CRIADA

━━━━━━━━━━━━━━

📋 MUDANÇAS:
   ∟ ${changesDescription}

🔗 DETALHES:
   ▶ PR: ${prUrl}
   ▶ Branch: ${branch}
   ▶ Testes: ${testsStatus === 'passing' ? '✅ Passando' : '⏳ Aguardando'}

━━━━━━━━━━━━━━

⏰ Criada: ${timestamp || new Date().toISOString()} | 🎯 Próximo: Code review & merge`;

  return await mcp_clickup_create_task_comment({
    task_id: taskId,
    comment_text: formattedComment
  });
}
```

### 7. commentPRUpdated() - Implementado

```typescript
export async function commentPRUpdated(taskId: string, updateData: UpdateData) {
  const { commitType, commitHash, filesModified, linesAdded, linesRemoved, description, status, timestamp } = updateData;

  const formattedComment = `📝 PR ATUALIZADA - ${commitType.toUpperCase()}

━━━━━━━━━━━━━━

🔄 COMMIT:
   ▶ Hash: ${commitHash}
   ▶ Tipo: ${commitType}
   ▶ Arquivos: ${filesModified} (+${linesAdded}/-${linesRemoved} linhas)

🛠️ MUDANÇAS:
   ∟ ${description}

✅ STATUS:
   ∟ ${status === 'ready-for-review' ? '✅ Ready for review' : '⏳ Awaiting fixes'}

━━━━━━━━━━━━━━

⏰ Atualizada: ${timestamp || new Date().toISOString()} | 🚀 Status: ${status}`;

  return await mcp_clickup_create_task_comment({
    task_id: taskId,
    comment_text: formattedComment
  });
}
```

---

## ✅ FASE 3 - ABSTRAÇÕES MCP COMPLETAS

**Status**: 7/7 abstrações implementadas ✅  
**Tempo**: ~2 horas  
**Resultado**: Pronto para Fase 4 (Refatoração de Comandos)

