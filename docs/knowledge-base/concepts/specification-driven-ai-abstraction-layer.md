# Specification-Driven AI Abstraction Layer

---

## 📋 Metadata

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.0 |
| **Data de Criação** | 2025-11-25 |
| **Última Atualização** | 2025-11-25 |
| **Categoria** | Concepts |
| **Aplicação** | Sistema Onion - Padrões de Desenvolvimento de IA |
| **Tags** | `ai-patterns`, `abstraction-layer`, `spec-as-code`, `codex-development` |

### Fontes

- Task Manager Abstraction (`.agents/skills/task-manager/references/`)
- [Adapter Pattern - GoF](https://refactoring.guru/design-patterns/adapter)
- [Factory Pattern - GoF](https://refactoring.guru/design-patterns/factory-method)
- Práticas do Sistema Onion
- Princípios de Prompt Engineering

---

## 🎯 Visão Geral

O **Specification-Driven AI Abstraction Layer** (SDAAL) é um padrão de desenvolvimento de IA onde **documentação Markdown substitui código executável**, permitindo que LLMs "executem" abstrações complexas baseadas em especificações estruturadas.

### Definição

```
SDAAL = Markdown Estruturado + Interfaces TypeScript + Documentação Executável por IA
```

**Princípio Central**: LLMs não executam código diretamente, mas podem simular comportamentos complexos quando as especificações são precisas, tipadas e bem estruturadas.

### Diferença de Spec-as-Code

| Aspecto | Spec-as-Code | SDAAL |
|---------|--------------|-------|
| **Foco** | Requisitos de negócio | Abstrações técnicas |
| **Saída** | Código gerado | Comportamento simulado |
| **Execução** | Compilação/Runtime | "Runtime mental" da IA |
| **Validação** | Testes automatizados | Consistência de respostas |

---

## 🧠 Fundamentos Teóricos

### Por que Funciona?

LLMs como Claude são excelentes em:

1. **Interpretar tipos TypeScript**: Entendem contratos de interface
2. **Seguir padrões documentados**: Aplicam lógica descrita em Markdown
3. **Mapear conceitos**: Traduzem entre sistemas (ClickUp → Asana)
4. **Manter consistência**: Respeitam comportamentos definidos

```
┌─────────────────────────────────────────────────────────────────┐
│                     MODELO MENTAL DA IA                         │
│                                                                 │
│   interface.md  →  "Entendo o contrato"                         │
│   adapter.md    →  "Sei como mapear para este provedor"         │
│   factory.md    →  "Sei qual adapter usar"                      │
│   detector.md   →  "Sei identificar o contexto"                 │
│                                                                 │
│   RESULTADO: IA "executa" a abstração consistentemente          │
└─────────────────────────────────────────────────────────────────┘
```

### Analogia: Código vs Documentação

```
Código Tradicional          SDAAL
─────────────────           ─────
function add(a, b) {        # Função add
  return a + b;             Recebe dois números `a` e `b`.
}                           Retorna a soma de ambos.
                            
Executado: VM/Runtime       Executado: Cognição do LLM
```

---

## 🏗️ Arquitetura do Padrão

### Componentes Essenciais

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPECIFICATION LAYER                          │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │ interface  │  │   types    │  │  factory   │  │  detector  │ │
│  │    .md     │  │    .md     │  │    .md     │  │    .md     │ │
│  └────────────┘  └────────────┘  └────────────┘  └────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ADAPTER LAYER                              │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │  clickup   │  │   asana    │  │   linear   │  │    none    │ │
│  │    .md     │  │    .md     │  │    .md     │  │  (fallback)│ │
│  └────────────┘  └────────────┘  └────────────┘  └────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    EXECUTION LAYER                              │
│                  (MCP Tools / API Calls)                        │
│                                                                 │
│   mcp_ClickUp_*    mcp_asana_*    linear_api_*    local_store   │
└─────────────────────────────────────────────────────────────────┘
```

### Fluxo de "Execução"

```
1. Comando Onion invoca operação
   │
   ▼
2. IA lê factory.md → detectProvider()
   │
   ▼
3. IA identifica provedor configurado (via env)
   │
   ▼
4. IA lê adapter específico (clickup.md, asana.md)
   │
   ▼
5. IA "executa" o método conforme especificação
   │
   ▼
6. IA chama MCP tool real com parâmetros mapeados
   │
   ▼
7. IA normaliza resposta conforme types.md
   │
   ▼
8. Retorna resultado padronizado
```

---

## 📐 Estrutura de Arquivos

### Template de Abstraction Layer

```
.codex/utils/<abstraction>/
├── README.md           # Visão geral e uso rápido
├── interface.md        # Interface/Contrato principal
├── types.md            # Tipos de entrada e saída
├── factory.md          # Criação de instâncias
├── detector.md         # Detecção de contexto/provedor
└── adapters/
    ├── provider-a.md   # Implementação Provider A
    ├── provider-b.md   # Implementação Provider B
    └── none.md         # Fallback (Null Object Pattern)
```

### Estrutura de Cada Arquivo

#### interface.md

```markdown
# 📐 Interface I<Nome>

## 🎯 Propósito
[O que esta interface define]

## 📋 Interface Completa
\`\`\`typescript
interface I<Nome> {
  // Propriedades
  readonly property: Type;
  
  // Métodos
  method(input: Input): Promise<Output>;
}
\`\`\`

## 📊 Métodos por Categoria
| Categoria | Métodos | Descrição |
|-----------|---------|-----------|
| CRUD | create, get, update, delete | Operações básicas |

## 🧪 Exemplo de Uso
\`\`\`typescript
const instance = getFactory();
await instance.method({ ... });
\`\`\`
```

#### adapter.md

```markdown
# 🔵 <Provider> Adapter

## 🎯 Propósito
Implementação do I<Nome> para <Provider>.

## 📋 Configuração
\`\`\`bash
PROVIDER_API_TOKEN=xxx
PROVIDER_WORKSPACE_ID=xxx
\`\`\`

## 🔧 Implementação
\`\`\`typescript
class <Provider>Adapter implements I<Nome> {
  // Cada método com mapeamento específico
  async method(input): Promise<Output> {
    const result = await mcp_provider_call({
      // Mapear campos de input → provider
    });
    return this.normalize(result);
  }
  
  // Helpers de normalização
  private normalize(raw): Output { ... }
}
\`\`\`

## 📊 Mapeamento de Campos
| Interface | Provider API | Notas |
|-----------|-------------|-------|
| name | title | Direto |
| status | state | Mapeado |
```

---

## 🔑 Padrões de Design Aplicados

### 1. Adapter Pattern (Documental)

Cada provedor tem um adapter documentado que traduz:
- **Input**: Interface genérica → API específica
- **Output**: Resposta específica → Formato normalizado

```markdown
## Mapeamento de Status

| Interface | ClickUp | Asana |
|-----------|---------|-------|
| todo | "to do" | To Do (seção) |
| in_progress | "in progress" | In Progress |
| done | "done" | completed: true |
```

### 2. Factory Pattern (Documental)

A factory "decide" qual adapter usar baseado em configuração:

```typescript
function getTaskManager(): ITaskManager {
  const provider = detectProvider();
  
  switch (provider) {
    case 'clickup': return new ClickUpAdapter();
    case 'asana': return new AsanaAdapter();
    default: return new NoProviderAdapter();
  }
}
```

### 3. Strategy Pattern (Implícito)

Cada adapter implementa a mesma interface com estratégias diferentes:

```
ITaskManager.createTask()
  │
  ├── ClickUpAdapter: mcp_ClickUp_clickup_create_task
  ├── AsanaAdapter: mcp_asana_asana_create_task
  └── NoProviderAdapter: retorna objeto local
```

### 4. Null Object Pattern

O `NoProviderAdapter` permite funcionamento sem provedor:

```typescript
class NoProviderAdapter implements ITaskManager {
  readonly isConfigured = false;
  
  async createTask(input): Promise<TaskOutput> {
    console.warn('⚠️ Modo offline - task local');
    return {
      id: `local-${Date.now()}`,
      provider: 'none',
      ...input
    };
  }
}
```

### 5. Context Injection Pattern

O detector injeta informações sobre o ambiente:

```typescript
function validateProviderMatch(taskId, currentProvider): ValidationResult {
  const detected = detectProviderFromTaskId(taskId);
  
  if (detected !== currentProvider) {
    return {
      valid: false,
      warning: `⚠️ Task ${taskId} é de ${detected}, mas ${currentProvider} está configurado`
    };
  }
  
  return { valid: true };
}
```

---

## 📝 Formato Otimizado para IA

### Elementos que Ajudam a IA

| Elemento | Propósito | Exemplo |
|----------|-----------|---------|
| **Emojis em headers** | Navegação visual | `## 🎯 Propósito` |
| **Separadores ASCII** | Divisões claras | `═══════════════` |
| **Tabelas de mapeamento** | Tradução entre sistemas | Status/Priority |
| **Code blocks TypeScript** | Tipagem precisa | `interface ITask` |
| **Exemplos práticos** | Demonstração de uso | `🧪 Exemplos de Uso` |
| **Referências cruzadas** | Contexto adicional | `[Ver types.md]` |

### Estrutura de Seções Recomendada

```markdown
# 📐 Nome do Componente

## 🎯 Propósito
[1-2 parágrafos explicando o objetivo]

---

## 📋 Definição Principal
[Interface/Classe/Função principal em TypeScript]

---

## 📊 Tabelas de Referência
[Mapeamentos, enums, constantes]

---

## 🔧 Métodos/Funções
[Detalhamento de cada operação]

---

## 🧪 Exemplos de Uso
[Código prático demonstrando uso]

---

## 📚 Referências
[Links para outros arquivos relacionados]
```

---

## ✅ Checklist de Implementação

### Ao Criar Nova Abstraction Layer

- [ ] **README.md**: Visão geral, estrutura de arquivos, uso rápido
- [ ] **interface.md**: Contrato completo com todos os métodos
- [ ] **types.md**: Todos os tipos de entrada e saída
- [ ] **factory.md**: Lógica de criação de instâncias
- [ ] **detector.md**: Lógica de detecção de contexto
- [ ] **adapters/**: Um arquivo por provedor suportado
- [ ] **adapters/none.md**: Fallback para modo offline

### Qualidade de Documentação

- [ ] TypeScript em todos os code blocks de interface/tipos
- [ ] Tabelas de mapeamento para traduções entre sistemas
- [ ] Exemplos práticos de uso em cada arquivo
- [ ] Referências cruzadas entre arquivos
- [ ] Emojis consistentes para navegação
- [ ] Versionamento e data de criação

---

## 🔄 Comparação com Abordagens Tradicionais

### Código Executável vs SDAAL

| Aspecto | Código Tradicional | SDAAL |
|---------|-------------------|-------|
| **Formato** | `.ts`, `.js`, `.py` | `.md` (Markdown) |
| **Execução** | Runtime (Node, Python) | Cognição do LLM |
| **Debugging** | Breakpoints, logs | Verificar resposta da IA |
| **Testes** | Unit tests, integration | Consistência de output |
| **Versionamento** | Git (código) | Git (documentação) |
| **Portabilidade** | Requer ambiente | Funciona em qualquer LLM |
| **Manutenção** | Refatoração | Atualização de docs |

### Quando Usar SDAAL

✅ **Use quando:**
- Sistema opera principalmente via LLM
- Precisa de flexibilidade para trocar provedores
- Deseja documentação e implementação unificadas
- Trabalha com assistentes de código (Codex, Copilot)

❌ **Não use quando:**
- Precisa de performance crítica
- Requer execução determinística
- Sistema não envolve IA
- Complexidade algorítmica alta

---

## 🧪 Exemplo Prático: Task Manager

### Estrutura Implementada

```
.agents/skills/task-manager/references/
├── README.md           # Introdução + uso rápido
├── interface.md        # ITaskManager completo
├── types.md            # CreateTaskInput, TaskOutput, etc
├── factory.md          # getTaskManager(), NoProviderAdapter
├── detector.md         # detectProvider(), detectProviderFromTaskId()
└── adapters/
    ├── clickup.md      # ClickUpAdapter (completo)
    ├── asana.md        # AsanaAdapter (completo)
    └── linear.md       # LinearAdapter (stub)
```

### Fluxo Real de Uso

```markdown
## Comando Onion Executa

1. Usuário: `/engineer/start TASK-123`

2. IA lê factory.md:
   - "Preciso chamar getTaskManager()"
   - "Vou detectar o provedor configurado"

3. IA lê detector.md:
   - "TASK_MANAGER_PROVIDER=clickup no .env"
   - "Provedor é ClickUp"

4. IA lê adapters/clickup.md:
   - "Para getTask, uso mcp_ClickUp_clickup_get_task"
   - "ID deve ter 9 caracteres alfanuméricos"

5. IA executa MCP call:
   - mcp_ClickUp_clickup_get_task({ task_id: "TASK-123" })

6. IA normaliza resposta conforme types.md:
   - Mapeia status "in progress" → "in_progress"
   - Formata datas para ISO 8601

7. Retorna TaskOutput padronizado
```

---

## ⚠️ Anti-Patterns

### 1. Documentação Incompleta

**❌ Problema:**
```markdown
# Adapter X
Faz coisas com o Provider X.
```

**✅ Solução:**
```markdown
# Adapter X

## Configuração
- PROVIDER_X_TOKEN: Token de API (obrigatório)

## Métodos
### createTask(input: CreateTaskInput): Promise<TaskOutput>
Cria task no Provider X.
\`\`\`typescript
await mcp_provider_x_create({
  title: input.name,
  body: input.description
});
\`\`\`
```

### 2. Tipos Vagos

**❌ Problema:**
```typescript
interface ITaskManager {
  createTask(data: any): Promise<any>;
}
```

**✅ Solução:**
```typescript
interface ITaskManager {
  createTask(input: CreateTaskInput): Promise<TaskOutput>;
}

interface CreateTaskInput {
  name: string;           // Obrigatório
  description?: string;   // Opcional
  priority?: TaskPriority;
}
```

### 3. Sem Fallback

**❌ Problema:** Sistema quebra se provedor não configurado

**✅ Solução:** Implementar `NoProviderAdapter` com degradação graciosa

### 4. Mapeamentos Inconsistentes

**❌ Problema:** Cada adapter mapeia diferente sem documentação

**✅ Solução:** Tabelas de mapeamento explícitas em cada adapter

---

## 🔗 Relação com Outros Padrões

### Spec-as-Code

SDAAL é uma aplicação de [Spec-as-Code](spec-as-code-strategy.md) focada em abstrações técnicas ao invés de requisitos de negócio.

### AI Agent Design Patterns

SDAAL complementa [AI Agent Design Patterns](ai-agent-design-patterns.md) fornecendo a camada de infraestrutura que agentes utilizam.

### Task Manager Abstraction

O [Task Manager Abstraction](task-manager-abstraction.md) é a implementação de referência do padrão SDAAL no Sistema Onion.

```
┌─────────────────────────────────────────────────────────────────┐
│                    SISTEMA ONION                                │
│                                                                 │
│   ┌─────────────────┐                                           │
│   │ Spec-as-Code    │ → Requisitos de negócio                   │
│   └────────┬────────┘                                           │
│            │                                                    │
│   ┌────────▼────────┐                                           │
│   │ AI Agent        │ → Comportamento de agentes                │
│   │ Design Patterns │                                           │
│   └────────┬────────┘                                           │
│            │                                                    │
│   ┌────────▼────────┐                                           │
│   │ SDAAL           │ → Abstrações de infraestrutura (ESTE)     │
│   └────────┬────────┘                                           │
│            │                                                    │
│   ┌────────▼────────┐                                           │
│   │ Task Manager    │ → Implementação de referência             │
│   │ Abstraction     │                                           │
│   └─────────────────┘                                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📚 Recursos Adicionais

### Internos (Sistema Onion)
- [Comando /meta/create-abstraction](../../../.agents/skills/meta/create-abstraction.md) - Gerador automático de SDAAL
- [Template de Abstração](../../../docs/onion/shared/abstraction-template.md) - Template base

### Externos
- [Adapter Pattern - Refactoring Guru](https://refactoring.guru/design-patterns/adapter)
- [Factory Method - Refactoring Guru](https://refactoring.guru/design-patterns/factory-method)
- [Null Object Pattern](https://refactoring.guru/design-patterns/null-object)
- [Strategy Pattern](https://refactoring.guru/design-patterns/strategy)
- [Prompt Engineering Guide - Anthropic](https://docs.anthropic.com/claude/docs/prompt-engineering)

---

## 📖 Glossário

| Termo | Definição |
|-------|-----------|
| **SDAAL** | Specification-Driven AI Abstraction Layer |
| **Adapter** | Componente que traduz entre interface genérica e API específica |
| **Factory** | Componente que decide qual adapter instanciar |
| **Detector** | Componente que identifica contexto/provedor |
| **Null Object** | Adapter de fallback que não faz nada (gracefully) |
| **Normalização** | Processo de converter resposta específica em formato padrão |

---

**Próxima Atualização Planejada**: Janeiro 2026
**Responsável**: Sistema Onion


