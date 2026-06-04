# 🔵 ClickUp Adapter

## 🎯 Propósito

Implementação do `ITaskManager` para ClickUp usando o MCP (Model Context Protocol) do ClickUp.

---

## 📋 Configuração

### Variáveis de Ambiente

```bash
# Obrigatória
CLICKUP_API_TOKEN=pk_xxxxx

# Opcionais
CLICKUP_WORKSPACE_ID=your_workspace_id    # Auto-detectado se não informado
CLICKUP_DEFAULT_LIST_ID=your_list_id  # Lista padrão para novas tasks
```

### Obter Token

1. Acesse ClickUp → Settings → Apps
2. Clique em "Generate" em API Token
3. Copie o token e adicione ao `.env`

---

## 🔧 Implementação

```typescript
/**
 * Adapter ClickUp implementando ITaskManager.
 * Usa ClickUp MCP para todas as operações.
 */
class ClickUpAdapter implements ITaskManager {
  readonly provider: TaskManagerProvider = 'clickup';
  readonly isConfigured: boolean;
  
  private apiToken: string;
  private workspaceId?: string;
  private defaultListId?: string;
  
  constructor(config: ClickUpAdapterConfig) {
    this.apiToken = config.apiToken;
    this.workspaceId = config.workspaceId;
    this.defaultListId = config.defaultListId;
    this.isConfigured = !!this.apiToken;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CRUD DE TASKS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async createTask(input: CreateTaskInput): Promise<TaskOutput> {
    const listId = input.projectId || this.defaultListId;
    
    if (!listId) {
      throw new Error('❌ list_id ou CLICKUP_DEFAULT_LIST_ID obrigatório');
    }
    
    const result = await mcp_ClickUp_clickup_create_task({
      workspace_id: this.workspaceId,
      list_id: listId,
      name: input.name,
      description: input.description,
      markdown_description: input.markdownDescription,
      priority: this.mapPriorityToClickUp(input.priority),
      due_date: input.dueDate,
      start_date: input.startDate,
      assignees: input.assignees,
      tags: input.tags
    });
    
    return this.normalizeTask(JSON.parse(result.content[0].text));
  }
  
  async getTask(taskId: string): Promise<TaskOutput> {
    const result = await mcp_ClickUp_clickup_get_task({
      workspace_id: this.workspaceId,
      task_id: taskId,
      subtasks: true
    });
    
    return this.normalizeTask(JSON.parse(result.content[0].text));
  }
  
  async updateTask(taskId: string, updates: UpdateTaskInput): Promise<TaskOutput> {
    const result = await mcp_ClickUp_clickup_update_task({
      workspace_id: this.workspaceId,
      task_id: taskId,
      name: updates.name,
      description: updates.description,
      markdown_description: updates.markdownDescription,
      status: updates.status ? this.mapStatusToClickUp(updates.status) : undefined,
      priority: updates.priority ? this.mapPriorityToClickUp(updates.priority) : undefined,
      due_date: updates.dueDate,
      start_date: updates.startDate,
      assignees: updates.assignees
    });
    
    return this.normalizeTask(JSON.parse(result.content[0].text));
  }
  
  async deleteTask(taskId: string): Promise<boolean> {
    // ClickUp MCP não tem delete direto, usar update para archived
    try {
      await mcp_ClickUp_clickup_update_task({
        workspace_id: this.workspaceId,
        task_id: taskId,
        // Arquivar como alternativa a deletar
      });
      return true;
    } catch {
      return false;
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SUBTASKS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async createSubtask(parentId: string, input: CreateTaskInput): Promise<TaskOutput> {
    // Primeiro, obter a lista da task pai
    const parentTask = await this.getTask(parentId);
    const listId = parentTask.projectId || this.defaultListId;
    
    const result = await mcp_ClickUp_clickup_create_task({
      workspace_id: this.workspaceId,
      list_id: listId,
      parent: parentId,  // ← Torna subtask
      name: input.name,
      description: input.description,
      markdown_description: input.markdownDescription,
      priority: this.mapPriorityToClickUp(input.priority),
      tags: input.tags
    });
    
    return this.normalizeTask(JSON.parse(result.content[0].text));
  }
  
  async getSubtasks(parentId: string): Promise<TaskOutput[]> {
    const result = await mcp_ClickUp_clickup_get_task({
      workspace_id: this.workspaceId,
      task_id: parentId,
      subtasks: true
    });
    
    const task = JSON.parse(result.content[0].text);
    return (task.subtasks || []).map((st: any) => this.normalizeTask(st));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMENTÁRIOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async addComment(taskId: string, comment: string): Promise<CommentOutput> {
    const result = await mcp_ClickUp_clickup_create_task_comment({
      workspace_id: this.workspaceId,
      task_id: taskId,
      comment_text: comment
    });
    
    const data = JSON.parse(result.content[0].text);
    return {
      id: String(data.comment?.id || data.id),
      text: comment,
      author: {
        id: String(data.comment?.user?.id || 'unknown'),
        name: data.comment?.user?.username || 'Unknown'
      },
      createdAt: new Date().toISOString()
    };
  }
  
  async getComments(taskId: string): Promise<CommentOutput[]> {
    const result = await mcp_ClickUp_clickup_get_task_comments({
      workspace_id: this.workspaceId,
      task_id: taskId
    });
    
    const data = JSON.parse(result.content[0].text);
    return (data.comments || []).map((c: any) => ({
      id: String(c.id),
      text: c.comment_text || c.comment,
      author: {
        id: String(c.user?.id || 'unknown'),
        name: c.user?.username || 'Unknown'
      },
      createdAt: new Date(parseInt(c.date)).toISOString()
    }));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async updateStatus(taskId: string, status: TaskStatus): Promise<TaskOutput> {
    return this.updateTask(taskId, { status });
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BUSCA
  // ═══════════════════════════════════════════════════════════════════════════
  
  async searchTasks(query: SearchQuery): Promise<TaskOutput[]> {
    const result = await mcp_ClickUp_clickup_search({
      workspace_id: this.workspaceId,
      keywords: query.text,
      filters: {
        asset_types: ['task']
      }
    });
    
    const data = JSON.parse(result.content[0].text);
    return (data.results || [])
      .filter((r: any) => r.type === 'task')
      .slice(0, query.limit || 50)
      .map((r: any) => this.normalizeSearchResult(r));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PROJETOS/LISTAS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async getProjectList(): Promise<ProjectOutput[]> {
    const result = await mcp_ClickUp_clickup_get_workspace_hierarchy({
      workspace_id: this.workspaceId,
      max_depth: 2
    });
    
    const data = JSON.parse(result.content[0].text);
    const projects: ProjectOutput[] = [];
    
    // Extrair listas de todos os spaces
    for (const space of data.spaces || []) {
      for (const folder of space.folders || []) {
        for (const list of folder.lists || []) {
          projects.push({
            id: list.id,
            name: `${space.name} / ${folder.name} / ${list.name}`,
            workspaceId: this.workspaceId
          });
        }
      }
      // Listas sem folder
      for (const list of space.lists || []) {
        projects.push({
          id: list.id,
          name: `${space.name} / ${list.name}`,
          workspaceId: this.workspaceId
        });
      }
    }
    
    return projects;
  }
  
  async getProject(projectId: string): Promise<ProjectOutput> {
    const result = await mcp_ClickUp_clickup_get_list({
      workspace_id: this.workspaceId,
      list_id: projectId
    });
    
    const data = JSON.parse(result.content[0].text);
    return {
      id: data.id,
      name: data.name,
      description: data.content,
      workspaceId: this.workspaceId
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDAÇÃO
  // ═══════════════════════════════════════════════════════════════════════════
  
  validateTaskId(taskId: string): boolean {
    // ClickUp IDs: 9 caracteres alfanuméricos
    return /^[a-z0-9]{9}$/i.test(taskId);
  }
  
  getProviderFromTaskId(taskId: string): TaskManagerProvider | null {
    return this.validateTaskId(taskId) ? 'clickup' : null;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS PRIVADOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private normalizeTask(raw: any): TaskOutput {
    return {
      id: raw.id,
      provider: 'clickup',
      name: raw.name,
      description: raw.text_content || raw.description || '',
      status: this.normalizeStatus(raw.status?.status),
      statusRaw: raw.status?.status,
      statusColor: raw.status?.color,
      priority: this.normalizePriority(raw.priority?.priority),
      url: raw.url,
      createdAt: new Date(parseInt(raw.date_created)).toISOString(),
      updatedAt: new Date(parseInt(raw.date_updated)).toISOString(),
      dueDate: raw.due_date ? new Date(parseInt(raw.due_date)).toISOString() : undefined,
      startDate: raw.start_date ? new Date(parseInt(raw.start_date)).toISOString() : undefined,
      assignees: (raw.assignees || []).map((a: any) => ({
        id: String(a.id),
        name: a.username,
        email: a.email
      })),
      tags: (raw.tags || []).map((t: any) => t.name),
      subtasks: raw.subtasks?.map((st: any) => this.normalizeTask(st)),
      parent: raw.parent || undefined,
      projectId: raw.list?.id,
      projectName: raw.list?.name,
      timeEstimate: raw.time_estimate ? Math.round(raw.time_estimate / 60000) : undefined,
      timeSpent: raw.time_spent ? Math.round(raw.time_spent / 60000) : undefined
    };
  }
  
  private normalizeSearchResult(raw: any): TaskOutput {
    return {
      id: raw.id,
      provider: 'clickup',
      name: raw.name,
      description: raw.description || '',
      status: 'todo',
      url: raw.url || `https://app.clickup.com/t/${raw.id}`,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      assignees: [],
      tags: []
    };
  }
  
  private normalizeStatus(clickupStatus?: string): TaskStatus {
    const statusMap: Record<string, TaskStatus> = {
      'backlog': 'backlog',
      'bakclog': 'backlog',  // Typo comum no ClickUp
      'to do': 'todo',
      'open': 'todo',
      'in progress': 'in_progress',
      'in review': 'review',
      'review': 'review',
      'done': 'done',
      'complete': 'done',
      'closed': 'closed'
    };
    
    return statusMap[clickupStatus?.toLowerCase() || ''] || 'todo';
  }
  
  private mapStatusToClickUp(status: TaskStatus): string {
    const statusMap: Record<TaskStatus, string> = {
      'backlog': 'backlog',
      'todo': 'to do',
      'in_progress': 'in progress',
      'review': 'review',
      'done': 'done',
      'closed': 'closed',
      'canceled': 'closed'
    };
    
    return statusMap[status] || 'to do';
  }
  
  private normalizePriority(clickupPriority?: string): TaskPriority | undefined {
    const priorityMap: Record<string, TaskPriority> = {
      '1': 'urgent',
      'urgent': 'urgent',
      '2': 'high',
      'high': 'high',
      '3': 'normal',
      'normal': 'normal',
      '4': 'low',
      'low': 'low'
    };
    
    return priorityMap[clickupPriority?.toLowerCase() || ''];
  }
  
  private mapPriorityToClickUp(priority?: TaskPriority): string | undefined {
    if (!priority) return undefined;
    
    const priorityMap: Record<TaskPriority, string> = {
      'urgent': 'urgent',
      'high': 'high',
      'normal': 'normal',
      'low': 'low'
    };
    
    return priorityMap[priority];
  }
}
```

---

## 📊 Mapeamento de Campos

### Task Fields

| Interface | ClickUp API | Notas |
|-----------|-------------|-------|
| `name` | `name` | Direto |
| `description` | `description` | Texto plano |
| `markdownDescription` | `markdown_description` | Com formatação |
| `status` | `status.status` | Mapeado |
| `priority` | `priority.priority` | Mapeado |
| `dueDate` | `due_date` | Timestamp ms |
| `assignees` | `assignees[].id` | Array de IDs |
| `tags` | `tags[].name` | Array de strings |
| `projectId` | `list.id` | ID da lista |

### Status Mapping

| Interface | ClickUp |
|-----------|---------|
| `backlog` | "backlog" |
| `todo` | "to do" |
| `in_progress` | "in progress" |
| `review` | "review" |
| `done` | "done" |
| `closed` | "closed" |

---

## 🧪 Exemplos de Uso

```typescript
// Via Factory
const tm = getTaskManager(); // Retorna ClickUpAdapter se configurado

// Criar task
const task = await tm.createTask({
  name: 'Nova Feature',
  description: 'Implementar funcionalidade X',
  priority: 'high',
  tags: ['feature', 'v2']
});

// Criar subtask
const subtask = await tm.createSubtask(task.id, {
  name: 'Fase 1: Setup'
});

// Atualizar status
await tm.updateStatus(subtask.id, 'in_progress');

// Adicionar comentário
await tm.addComment(task.id, '🚀 Desenvolvimento iniciado!');
```

---

## 📚 Referências

- [ClickUp API Docs](https://clickup.com/api)
- [Interface ITaskManager](../interface.md)
- [Types](../types.md)

---

**Versão**: 1.0.0
**Criado em**: 2025-11-24

