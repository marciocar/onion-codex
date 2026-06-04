# 🔌 Task Manager Abstraction Layer

## 🎯 Propósito

Camada de abstração que permite trocar o gerenciador de tarefas (ClickUp, Asana, Jira, Linear) sem modificar os comandos do Sistema Onion.

## 📁 Estrutura

```
task-manager/
├── README.md          # Este arquivo
├── interface.md       # Interface ITaskManager
├── types.md           # Tipos compartilhados
├── detector.md        # Detecção de provedor
├── factory.md         # Factory para adapters
└── adapters/
    ├── clickup.md     # Adapter ClickUp
    ├── asana.md       # Adapter Asana
    ├── jira.md        # Adapter Jira
    └── linear.md      # Adapter Linear (stub)
```

## ⚡ Uso Rápido

### 1. Configurar Provedor

No `.env`:
```bash
TASK_MANAGER_PROVIDER=clickup  # clickup | asana | jira | linear | none
```

### 2. Usar nos Comandos

```typescript
// Importar factory
import { getTaskManager } from '.agents/skills/task-manager/references/factory';

// Obter adapter configurado
const taskManager = getTaskManager();

// Usar interface comum
const task = await taskManager.createTask({
  name: 'Minha Task',
  description: 'Descrição da task'
});
```

## 🔧 Provedores Suportados

| Provedor | Status | Notas |
|----------|--------|-------|
| ClickUp | ✅ Completo | Via MCP |
| Asana | ✅ Completo | Via MCP |
| Jira | ✅ Completo | Via REST API v3 (Cloud) / v2 (Server/DC) |
| Linear | 📝 Stub | Documentado para implementação |
| None | ✅ Funcional | Modo offline |

## 📊 Fluxo de Execução

```
Comando Onion
     │
     ▼
┌─────────────┐
│   Factory   │ → detectProvider() → TASK_MANAGER_PROVIDER
└─────────────┘
     │
     ▼
┌─────────────┐
│  Adapter    │ → ClickUp | Asana | Jira | Linear | None
└─────────────┘
     │
     ▼
┌─────────────┐
│   API/MCP   │ → Executa operação
└─────────────┘
```

## 🔗 Referências

- [Interface ITaskManager](./interface.md)
- [Tipos Compartilhados](./types.md)
- [Detector de Provedor](./detector.md)
- [Factory](./factory.md)

## 📚 Documentação Relacionada

- `docs/knowledge-base/task-manager-abstraction.md` - Knowledge Base completa
- `docs/onion/getting-started.md` - Setup inicial
- `.env.example` - Variáveis de ambiente

---

**Versão**: 1.0.0
**Criado em**: 2025-11-24

