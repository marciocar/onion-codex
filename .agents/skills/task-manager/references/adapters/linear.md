# 🟣 Linear Adapter (Stub)

## 🎯 Propósito

Stub documentado para implementação futura do `ITaskManager` para Linear.

> ⚠️ **STUB**: Este adapter contém apenas a estrutura e documentação. A implementação completa requer desenvolvimento adicional.

---

## 📋 Configuração

### Variáveis de Ambiente

```bash
# Obrigatória
LINEAR_API_KEY=lin_api_xxxxx

# Opcionais
LINEAR_TEAM_ID=xxxxx-xxxxx-xxxxx  # Team padrão
```

### Obter Token

1. Acesse Linear → Settings → API → Personal API Keys
2. Clique em "Create key"
3. Copie o token e adicione ao `.env`

---

## 📊 API do Linear

### Endpoint

```
https://api.linear.app/graphql
```

### Autenticação

```bash
Authorization: Bearer {LINEAR_API_KEY}
Content-Type: application/json
```

---

## 🔧 Implementação (Stub)

```typescript
/**
 * Adapter Linear implementando ITaskManager.
 * 
 * ⚠️ STUB: Métodos retornam notImplemented() por padrão.
 * Para implementação completa, usar Linear GraphQL API.
 */
class LinearAdapter implements ITaskManager {
  readonly provider: TaskManagerProvider = 'linear';
  readonly isConfigured: boolean;
  
  private apiKey: string;
  private teamId?: string;
  
  constructor(config: LinearAdapterConfig) {
    this.apiKey = config.apiKey;
    this.teamId = config.teamId;
    this.isConfigured = !!this.apiKey;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CRUD DE TASKS (ISSUES)
  // ═══════════════════════════════════════════════════════════════════════════
  
  async createTask(input: CreateTaskInput): Promise<TaskOutput> {
    return this.notImplemented('createTask');
    
    // TODO: Implementar usando GraphQL mutation
    // mutation IssueCreate($input: IssueCreateInput!) {
    //   issueCreate(input: $input) {
    //     success
    //     issue {
    //       id
    //       identifier
    //       title
    //       url
    //     }
    //   }
    // }
  }
  
  async getTask(taskId: string): Promise<TaskOutput> {
    return this.notImplemented('getTask');
    
    // TODO: Implementar usando GraphQL query
    // query Issue($id: String!) {
    //   issue(id: $id) {
    //     id
    //     identifier
    //     title
    //     description
    //     state { name }
    //     priority
    //     url
    //   }
    // }
  }
  
  async updateTask(taskId: string, updates: UpdateTaskInput): Promise<TaskOutput> {
    return this.notImplemented('updateTask');
    
    // TODO: Implementar usando GraphQL mutation
    // mutation IssueUpdate($id: String!, $input: IssueUpdateInput!) {
    //   issueUpdate(id: $id, input: $input) {
    //     success
    //     issue { id title }
    //   }
    // }
  }
  
  async deleteTask(taskId: string): Promise<boolean> {
    console.warn('⚠️ Linear.deleteTask() não implementado');
    return false;
    
    // TODO: Linear usa archive ao invés de delete
    // mutation IssueArchive($id: String!) {
    //   issueArchive(id: $id) { success }
    // }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SUBTASKS (SUB-ISSUES)
  // ═══════════════════════════════════════════════════════════════════════════
  
  async createSubtask(parentId: string, input: CreateTaskInput): Promise<TaskOutput> {
    return this.notImplemented('createSubtask');
    
    // TODO: Usar parentId no mutation
    // mutation IssueCreate($input: IssueCreateInput!) {
    //   issueCreate(input: { ...input, parentId: $parentId }) { ... }
    // }
  }
  
  async getSubtasks(parentId: string): Promise<TaskOutput[]> {
    console.warn('⚠️ Linear.getSubtasks() não implementado');
    return [];
    
    // TODO: Query children
    // query Issue($id: String!) {
    //   issue(id: $id) {
    //     children { nodes { id title } }
    //   }
    // }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMENTÁRIOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async addComment(taskId: string, comment: string): Promise<CommentOutput> {
    return this.notImplemented('addComment');
    
    // TODO: Mutation CommentCreate
    // mutation CommentCreate($input: CommentCreateInput!) {
    //   commentCreate(input: { issueId: $taskId, body: $comment }) {
    //     success
    //     comment { id body }
    //   }
    // }
  }
  
  async getComments(taskId: string): Promise<CommentOutput[]> {
    console.warn('⚠️ Linear.getComments() não implementado');
    return [];
    
    // TODO: Query comments
    // query Issue($id: String!) {
    //   issue(id: $id) {
    //     comments { nodes { id body user { name } } }
    //   }
    // }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async updateStatus(taskId: string, status: TaskStatus): Promise<TaskOutput> {
    return this.notImplemented('updateStatus');
    
    // TODO: Mapear status para stateId do Linear
    // mutation IssueUpdate($id: String!, $input: IssueUpdateInput!) {
    //   issueUpdate(id: $id, input: { stateId: $stateId }) { ... }
    // }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BUSCA
  // ═══════════════════════════════════════════════════════════════════════════
  
  async searchTasks(query: SearchQuery): Promise<TaskOutput[]> {
    console.warn('⚠️ Linear.searchTasks() não implementado');
    return [];
    
    // TODO: Query issues com filtro
    // query Issues($filter: IssueFilter) {
    //   issues(filter: $filter) {
    //     nodes { id identifier title }
    //   }
    // }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PROJETOS (TEAMS/PROJECTS)
  // ═══════════════════════════════════════════════════════════════════════════
  
  async getProjectList(): Promise<ProjectOutput[]> {
    console.warn('⚠️ Linear.getProjectList() não implementado');
    return [];
    
    // TODO: Query teams ou projects
    // query Teams {
    //   teams { nodes { id name } }
    // }
  }
  
  async getProject(projectId: string): Promise<ProjectOutput> {
    return this.notImplemented('getProject');
    
    // TODO: Query team ou project
    // query Team($id: String!) {
    //   team(id: $id) { id name description }
    // }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDAÇÃO
  // ═══════════════════════════════════════════════════════════════════════════
  
  validateTaskId(taskId: string): boolean {
    // Linear IDs: 
    // - Identifier format: ABC-123
    // - UUID format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    return /^[A-Z]+-\d+$/.test(taskId) || 
           /^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/i.test(taskId);
  }
  
  getProviderFromTaskId(taskId: string): TaskManagerProvider | null {
    return this.validateTaskId(taskId) ? 'linear' : null;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private notImplemented(method: string): never {
    throw new Error(
      `❌ Linear.${method}() não implementado.\n` +
      `💡 Este é um adapter STUB. Para implementação completa:\n` +
      `   1. Consulte a documentação: https://developers.linear.app/\n` +
      `   2. Implemente o método usando GraphQL API\n` +
      `   3. Teste com sua conta Linear`
    );
  }
  
  /**
   * Helper para fazer requisições GraphQL ao Linear.
   * Use este método ao implementar os métodos acima.
   */
  private async graphql<T>(query: string, variables?: Record<string, any>): Promise<T> {
    const response = await fetch('https://api.linear.app/graphql', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ query, variables })
    });
    
    if (!response.ok) {
      throw new Error(`Linear API error: ${response.statusText}`);
    }
    
    const result = await response.json();
    
    if (result.errors) {
      throw new Error(`Linear GraphQL error: ${result.errors[0].message}`);
    }
    
    return result.data;
  }
}
```

---

## 📊 Mapeamento de Conceitos

| Interface | Linear |
|-----------|--------|
| `project` | Team ou Project |
| `task` | Issue |
| `subtask` | Sub-issue (child) |
| `status` | State (workflow) |
| `comment` | Comment |

---

## 🔄 Status Mapping (Exemplo)

| Interface | Linear State |
|-----------|--------------|
| `backlog` | Backlog |
| `todo` | Todo |
| `in_progress` | In Progress |
| `review` | In Review |
| `done` | Done |
| `canceled` | Canceled |

> ⚠️ Os estados do Linear são customizáveis por team. O mapeamento real depende da configuração do workspace.

---

## 📚 Referências para Implementação

### GraphQL Queries Úteis

#### Listar Issues

```graphql
query Issues($teamId: String!, $first: Int) {
  team(id: $teamId) {
    issues(first: $first) {
      nodes {
        id
        identifier
        title
        description
        state { name color }
        priority
        url
        createdAt
        updatedAt
      }
    }
  }
}
```

#### Criar Issue

```graphql
mutation IssueCreate($input: IssueCreateInput!) {
  issueCreate(input: $input) {
    success
    issue {
      id
      identifier
      title
      url
    }
  }
}
```

#### Atualizar Issue

```graphql
mutation IssueUpdate($id: String!, $input: IssueUpdateInput!) {
  issueUpdate(id: $id, input: $input) {
    success
    issue {
      id
      title
      state { name }
    }
  }
}
```

---

## 🚀 Como Implementar

1. **Configurar ambiente**
   ```bash
   LINEAR_API_KEY=lin_api_xxxxx
   LINEAR_TEAM_ID=xxxxx
   ```

2. **Testar conexão**
   ```typescript
   const adapter = new LinearAdapter({ apiKey: process.env.LINEAR_API_KEY });
   const teams = await adapter.graphql(`query { teams { nodes { id name } } }`);
   ```

3. **Implementar métodos**
   - Começar por `createTask` e `getTask`
   - Adicionar `updateTask` e `updateStatus`
   - Implementar `addComment` e `getComments`
   - Por último, `searchTasks` e `getProjectList`

4. **Testar com comandos**
   ```bash
   TASK_MANAGER_PROVIDER=linear
   ```

---

## 📚 Referências

- [Linear API Docs](https://developers.linear.app/)
- [Linear GraphQL Explorer](https://linear.app/graphql)
- [Interface ITaskManager](../interface.md)
- [Types](../types.md)

---

**Versão**: 1.0.0 (Stub)
**Criado em**: 2025-11-24
**Status**: 📝 Documentado, aguardando implementação

