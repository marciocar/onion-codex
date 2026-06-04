# 🟠 Asana Adapter

## 🎯 Propósito

Implementação do `ITaskManager` para Asana usando o MCP (Model Context Protocol) do Asana.

---

## 📋 Configuração

### Variáveis de Ambiente

```bash
# Obrigatória
ASANA_ACCESS_TOKEN=1/xxxxx

# Opcionais
ASANA_WORKSPACE_ID=1234567890123456      # Workspace padrão
ASANA_DEFAULT_PROJECT_ID=1234567890123456  # Projeto padrão
```

### Obter Token

1. Acesse Asana → My Settings → Apps → Developer Apps
2. Clique em "Create new app" ou use existente
3. Gere um Personal Access Token
4. Copie o token e adicione ao `.env`

---

## 🔧 Implementação

```typescript
/**
 * Adapter Asana implementando ITaskManager.
 * Usa Asana MCP para todas as operações.
 */
class AsanaAdapter implements ITaskManager {
  readonly provider: TaskManagerProvider = 'asana';
  readonly isConfigured: boolean;
  
  private accessToken: string;
  private workspaceId?: string;
  private defaultProjectId?: string;
  
  constructor(config: AsanaAdapterConfig) {
    this.accessToken = config.accessToken;
    this.workspaceId = config.workspaceId;
    this.defaultProjectId = config.defaultProjectId;
    this.isConfigured = !!this.accessToken;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CRUD DE TASKS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async createTask(input: CreateTaskInput): Promise<TaskOutput> {
    const projectId = input.projectId || this.defaultProjectId;
    
    const result = await mcp_asana_asana_create_task({
      name: input.name,
      notes: input.description,
      html_notes: input.markdownDescription,
      project_id: projectId,
      workspace: this.workspaceId,
      due_on: input.dueDate,
      start_on: input.startDate,
      assignee: input.assignees?.[0]  // Asana suporta apenas 1 assignee
    });
    
    const data = JSON.parse(result.content[0].text);
    return this.normalizeTask(data.data || data);
  }
  
  async getTask(taskId: string): Promise<TaskOutput> {
    const result = await mcp_asana_asana_get_task({
      task_id: taskId,
      opt_fields: 'name,notes,completed,due_on,start_on,assignee,tags,parent,projects,subtasks,created_at,modified_at,permalink_url'
    });
    
    const data = JSON.parse(result.content[0].text);
    return this.normalizeTask(data.data || data);
  }
  
  async updateTask(taskId: string, updates: UpdateTaskInput): Promise<TaskOutput> {
    const updateParams: any = {
      task_id: taskId
    };
    
    if (updates.name) updateParams.name = updates.name;
    if (updates.description) updateParams.notes = updates.description;
    if (updates.status === 'done' || updates.status === 'closed') {
      updateParams.completed = true;
    } else if (updates.status) {
      updateParams.completed = false;
    }
    if (updates.dueDate !== undefined) updateParams.due_on = updates.dueDate;
    if (updates.startDate !== undefined) updateParams.start_on = updates.startDate;
    if (updates.assignees?.length) updateParams.assignee = updates.assignees[0];
    
    const result = await mcp_asana_asana_update_task(updateParams);
    
    const data = JSON.parse(result.content[0].text);
    return this.normalizeTask(data.data || data);
  }
  
  async deleteTask(taskId: string): Promise<boolean> {
    try {
      await mcp_asana_asana_delete_task({ task_id: taskId });
      return true;
    } catch {
      return false;
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SUBTASKS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async createSubtask(parentId: string, input: CreateTaskInput): Promise<TaskOutput> {
    const result = await mcp_asana_asana_create_task({
      name: input.name,
      notes: input.description,
      parent: parentId,  // ← Torna subtask
      workspace: this.workspaceId
    });
    
    const data = JSON.parse(result.content[0].text);
    return this.normalizeTask(data.data || data);
  }
  
  async getSubtasks(parentId: string): Promise<TaskOutput[]> {
    const result = await mcp_asana_asana_get_tasks({
      parent: parentId,
      opt_fields: 'name,notes,completed,due_on,assignee,permalink_url'
    });
    
    const data = JSON.parse(result.content[0].text);
    return (data.data || []).map((t: any) => this.normalizeTask(t));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMENTÁRIOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async addComment(taskId: string, comment: string): Promise<CommentOutput> {
    const result = await mcp_asana_asana_create_task_story({
      task_id: taskId,
      text: comment
    });
    
    const data = JSON.parse(result.content[0].text);
    const story = data.data || data;
    
    return {
      id: story.gid,
      text: comment,
      author: {
        id: story.created_by?.gid || 'unknown',
        name: story.created_by?.name || 'Unknown'
      },
      createdAt: story.created_at || new Date().toISOString()
    };
  }
  
  async getComments(taskId: string): Promise<CommentOutput[]> {
    const result = await mcp_asana_asana_get_stories_for_task({
      task_id: taskId,
      opt_fields: 'text,created_by,created_at,type'
    });
    
    const data = JSON.parse(result.content[0].text);
    return (data.data || [])
      .filter((s: any) => s.type === 'comment')
      .map((s: any) => ({
        id: s.gid,
        text: s.text,
        author: {
          id: s.created_by?.gid || 'unknown',
          name: s.created_by?.name || 'Unknown'
        },
        createdAt: s.created_at
      }));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async updateStatus(taskId: string, status: TaskStatus): Promise<TaskOutput> {
    // Asana usa completed: true/false para status
    const completed = status === 'done' || status === 'closed';
    return this.updateTask(taskId, { status });
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BUSCA
  // ═══════════════════════════════════════════════════════════════════════════
  
  async searchTasks(query: SearchQuery): Promise<TaskOutput[]> {
    const searchParams: any = {
      workspace: this.workspaceId,
      opt_fields: 'name,notes,completed,due_on,assignee,permalink_url'
    };
    
    if (query.text) searchParams.text = query.text;
    if (query.projectId) searchParams.projects_any = query.projectId;
    if (query.assignee) searchParams.assignee_any = query.assignee;
    if (query.status?.includes('done')) searchParams.completed = true;
    if (query.status?.includes('todo')) searchParams.completed = false;
    
    const result = await mcp_asana_asana_search_tasks(searchParams);
    
    const data = JSON.parse(result.content[0].text);
    return (data.data || [])
      .slice(0, query.limit || 50)
      .map((t: any) => this.normalizeTask(t));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PROJETOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  async getProjectList(): Promise<ProjectOutput[]> {
    const result = await mcp_asana_asana_get_projects({
      workspace: this.workspaceId,
      opt_fields: 'name,notes,permalink_url,archived'
    });
    
    const data = JSON.parse(result.content[0].text);
    return (data.data || []).map((p: any) => ({
      id: p.gid,
      name: p.name,
      description: p.notes,
      url: p.permalink_url,
      archived: p.archived,
      workspaceId: this.workspaceId
    }));
  }
  
  async getProject(projectId: string): Promise<ProjectOutput> {
    const result = await mcp_asana_asana_get_project({
      project_id: projectId,
      opt_fields: 'name,notes,permalink_url,archived'
    });
    
    const data = JSON.parse(result.content[0].text);
    const project = data.data || data;
    
    return {
      id: project.gid,
      name: project.name,
      description: project.notes,
      url: project.permalink_url,
      archived: project.archived,
      workspaceId: this.workspaceId
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDAÇÃO
  // ═══════════════════════════════════════════════════════════════════════════
  
  validateTaskId(taskId: string): boolean {
    // Asana IDs: 15+ dígitos numéricos
    return /^\d{15,}$/.test(taskId);
  }
  
  getProviderFromTaskId(taskId: string): TaskManagerProvider | null {
    return this.validateTaskId(taskId) ? 'asana' : null;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS PRIVADOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private normalizeTask(raw: any): TaskOutput {
    return {
      id: raw.gid,
      provider: 'asana',
      name: raw.name,
      description: raw.notes || '',
      status: raw.completed ? 'done' : 'todo',
      statusRaw: raw.completed ? 'Completed' : 'Not Completed',
      url: raw.permalink_url || `https://app.asana.com/0/0/${raw.gid}`,
      createdAt: raw.created_at || new Date().toISOString(),
      updatedAt: raw.modified_at || new Date().toISOString(),
      dueDate: raw.due_on,
      startDate: raw.start_on,
      assignees: raw.assignee ? [{
        id: raw.assignee.gid,
        name: raw.assignee.name,
        email: raw.assignee.email
      }] : [],
      tags: (raw.tags || []).map((t: any) => t.name),
      parent: raw.parent?.gid,
      projectId: raw.projects?.[0]?.gid,
      projectName: raw.projects?.[0]?.name
    };
  }
}
```

---

## 📊 Mapeamento de Campos

### Task Fields

| Interface | Asana API | Notas |
|-----------|-----------|-------|
| `name` | `name` | Direto |
| `description` | `notes` | Texto plano |
| `markdownDescription` | `html_notes` | Com HTML |
| `status` | `completed` | Boolean |
| `priority` | - | Não suportado nativamente |
| `dueDate` | `due_on` | YYYY-MM-DD |
| `assignees` | `assignee` | Apenas 1 no Asana |
| `tags` | `tags[].name` | Array |
| `projectId` | `projects[0].gid` | GID do projeto |

### Status Mapping

| Interface | Asana |
|-----------|-------|
| `todo`, `backlog`, `in_progress`, `review` | `completed: false` |
| `done`, `closed` | `completed: true` |

---

## ⚠️ Limitações do Asana

1. **Apenas 1 assignee** por task (vs múltiplos no ClickUp)
2. **Sem prioridade nativa** - usar custom fields ou tags
3. **Status binário** - completed ou não (usar seções para workflow)
4. **IDs numéricos longos** - 16+ dígitos

---

## 🧪 Exemplos de Uso

```typescript
// Via Factory (com TASK_MANAGER_PROVIDER=asana)
const tm = getTaskManager();

// Criar task
const task = await tm.createTask({
  name: 'Nova Feature',
  description: 'Implementar funcionalidade X',
  projectId: '1234567890123456'
});

// Criar subtask
const subtask = await tm.createSubtask(task.id, {
  name: 'Fase 1: Setup'
});

// Marcar como concluída
await tm.updateStatus(subtask.id, 'done');

// Adicionar comentário
await tm.addComment(task.id, '🚀 Desenvolvimento iniciado!');
```

---

## 📚 Referências

- [Asana API Docs](https://developers.asana.com/)
- [Interface ITaskManager](../interface.md)
- [Types](../types.md)

---

**Versão**: 1.0.0
**Criado em**: 2025-11-24

