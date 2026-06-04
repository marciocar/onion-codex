# Context Window Optimization

---

## 📋 Metadata

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.0 |
| **Data de Criação** | 2025-11-24 |
| **Última Atualização** | 2025-11-24 |
| **Categoria** | Concepts |
| **Aplicação** | Sistema Onion - Otimização de Tokens |

### Fontes

- [Anthropic Claude Documentation](https://docs.anthropic.com/)
- [OpenAI Token Best Practices](https://platform.openai.com/docs/)
- [Codex Optimization](https://docs.claude.com/en/docs/codex/overview)
- Práticas do Sistema Onion
- Experiência prática com LLMs

---

## 🎯 Visão Geral

**Context Window Optimization** é o conjunto de técnicas para maximizar a eficiência do uso do contexto disponível em modelos de linguagem, reduzindo custos e melhorando a qualidade das respostas.

### Por Que Otimizar?

| Fator | Impacto |
|-------|---------|
| **Custo** | Tokens = dinheiro (API billing) |
| **Velocidade** | Menos tokens = resposta mais rápida |
| **Qualidade** | Contexto focado = respostas melhores |
| **Limites** | Context windows têm tamanho máximo |

### Context Windows por Modelo (2025)

| Modelo | Context Window | ~Linhas de Código |
|--------|----------------|-------------------|
| GPT-4o | 128K tokens | ~50K linhas |
| Claude Sonnet | 200K tokens | ~80K linhas |
| Claude Opus | 200K tokens | ~80K linhas |
| Gemini 1.5 Pro | 1M tokens | ~400K linhas |

**Nota**: 1 token ≈ 4 caracteres em inglês, ~3 em código.

---

## 📊 Métricas de Otimização

### Token Budget

```
┌─────────────────────────────────────────────────────────┐
│                   CONTEXT WINDOW                        │
├──────────────┬──────────────┬──────────────────────────┤
│   SYSTEM     │    USER      │       RESPONSE           │
│   PROMPT     │   CONTEXT    │       SPACE              │
│   (15-20%)   │   (50-60%)   │       (20-30%)           │
└──────────────┴──────────────┴──────────────────────────┘
```

### Distribuição Recomendada (128K tokens)

| Componente | % | Tokens | Uso |
|------------|---|--------|-----|
| System Prompt | 15% | ~19K | Instruções, identidade |
| User Context | 55% | ~70K | Arquivos, código, docs |
| Response Space | 30% | ~38K | Output do modelo |

### KPIs de Eficiência

| Métrica | Meta | Como Medir |
|---------|------|------------|
| Tokens/Execução | < 10K | Observar consumo |
| Relevance Score | > 80% | % contexto usado na resposta |
| Response Quality | > 4/5 | Avaliação humana |
| First-Try Success | > 70% | Tasks completadas sem retry |

---

## 🛠️ Técnicas de Otimização

### 1. Chunking Strategies

**Princípio:** Dividir conteúdo em partes gerenciáveis.

#### Chunking por Semântica

```
┌────────────────────────────────────────┐
│           ARQUIVO GRANDE               │
│  ┌─────────────────────────────────┐   │
│  │ Chunk 1: Imports + Types        │   │
│  ├─────────────────────────────────┤   │
│  │ Chunk 2: Class/Component        │   │
│  ├─────────────────────────────────┤   │
│  │ Chunk 3: Helper Functions       │   │
│  ├─────────────────────────────────┤   │
│  │ Chunk 4: Exports                │   │
│  └─────────────────────────────────┘   │
└────────────────────────────────────────┘
```

#### Tamanhos Recomendados

| Tipo de Conteúdo | Tamanho Chunk | Motivo |
|------------------|---------------|--------|
| Código | 100-300 linhas | Função/classe completa |
| Documentação | 500-1000 palavras | Seção coesa |
| Logs | 50-100 linhas | Contexto de erro |

### 2. Relevance Filtering

**Princípio:** Incluir apenas o que é necessário.

#### Filtros por Tipo

```yaml
relevance_filters:
  always_include:
    - Arquivo sendo editado
    - Imports diretos
    - Types/Interfaces usados
    
  conditionally_include:
    - Arquivos relacionados (se referenciados)
    - Testes (se revisando código)
    - Docs (se documentando)
    
  always_exclude:
    - node_modules/
    - build/, dist/
    - Arquivos binários
    - Logs antigos
```

#### Filtro por Distância

```
Distância 0: Arquivo atual
Distância 1: Imports diretos
Distância 2: Imports dos imports
Distância 3+: Raramente necessário
```

### 3. Prompt Compression

**Princípio:** Dizer mais com menos tokens.

#### Antes vs Depois

**❌ Prolixo (45 tokens):**
```
Por favor, eu gostaria muito que você pudesse me ajudar 
a criar um componente React que seja responsivo e que 
funcione bem em dispositivos móveis e também em desktop.
```

**✅ Comprimido (15 tokens):**
```
Crie componente React responsivo (mobile + desktop).
```

#### Técnicas de Compressão

| Técnica | Exemplo |
|---------|---------|
| Abreviações | "Create component" → "Create comp" |
| Remoção de fluff | "Por favor" → (remover) |
| Bullet points | Parágrafos → listas |
| Código como spec | Descrição → TypeScript interface |

### 4. Progressive Loading

**Princípio:** Carregar contexto sob demanda.

```
ETAPA 1: Prompt inicial (mínimo)
    │
    ├── Se precisa de mais contexto:
    │       ETAPA 2: Carregar arquivos específicos
    │           │
    │           ├── Se ainda insuficiente:
    │           │       ETAPA 3: Expandir para pasta
    │           │           │
    │           │           └── ETAPA 4: Busca semântica
    │           │
    │           └── Suficiente → Executar
    │
    └── Suficiente → Executar
```

### 5. Caching de Contexto

**Princípio:** Reutilizar contexto entre chamadas.

```
┌─────────────────────────────────────────────┐
│           SESSÃO DE TRABALHO                │
├─────────────────────────────────────────────┤
│  CACHE (persistente entre chamadas):        │
│  - Arquitetura do projeto                   │
│  - Padrões de código                        │
│  - Entidades do domínio                     │
├─────────────────────────────────────────────┤
│  VARIÁVEL (muda por chamada):               │
│  - Arquivo atual                            │
│  - Tarefa específica                        │
│  - Erros recentes                           │
└─────────────────────────────────────────────┘
```

---

## 📁 Otimização por Tipo de Conteúdo

### Código-fonte

| Estratégia | Quando Usar |
|------------|-------------|
| Arquivo completo | < 300 linhas |
| Função específica | Edição pontual |
| Assinaturas apenas | Contexto de API |
| Skeleton | Visão geral de estrutura |

**Skeleton Example:**
```typescript
// Skeleton de UserService (reduzido de 500 para 50 linhas)
class UserService {
  // Dependências
  constructor(private db: Database, private cache: Cache) {}
  
  // Métodos públicos
  async getUser(id: string): Promise<User> { /* ... */ }
  async createUser(data: CreateUserDto): Promise<User> { /* ... */ }
  async updateUser(id: string, data: UpdateUserDto): Promise<User> { /* ... */ }
  async deleteUser(id: string): Promise<void> { /* ... */ }
  
  // Métodos privados (omitidos)
  // - validateUser
  // - hashPassword
  // - sendWelcomeEmail
}
```

### Documentação

| Estratégia | Quando Usar |
|------------|-------------|
| TOC + Seção relevante | Docs grandes |
| Sumário executivo | Visão geral |
| Exemplos apenas | Implementação rápida |

### Logs e Erros

| Estratégia | Quando Usar |
|------------|-------------|
| Stack trace completo | Debug |
| Últimas N linhas | Monitoramento |
| Padrão de erro | Categorização |

---

## 🔧 Configuração no Sistema Onion

### .gitignore

```gitignore
# Arquivos grandes/binários
*.pdf
*.zip
*.png
*.jpg

# Build artifacts
node_modules/
dist/
build/
.next/

# Dependências
vendor/
packages/*/node_modules/

# Logs
*.log
logs/

# Temporários
.cache/
.tmp/
```

### Estrutura de Comandos Otimizada

```markdown
# Template de Comando Otimizado

## 🎯 Objetivo (1-2 linhas)
[Descrição concisa]

## 📥 Entrada (lista)
- Parâmetro 1
- Parâmetro 2

## 🔄 Processo (numerado)
1. Etapa 1
2. Etapa 2

## 📤 Saída (formato)
[Especificação do output]

<!-- Evitar: histórico, explicações longas, exemplos redundantes -->
```

### Limite de Tamanho para Comandos

| Classificação | Linhas | Tokens (~) | Recomendação |
|---------------|--------|------------|--------------|
| Ideal | < 200 | < 2K | ✅ |
| Aceitável | 200-400 | 2-4K | ⚠️ |
| Limite | 400-500 | 4-5K | ⚠️ Revisar |
| Problemático | > 500 | > 5K | ❌ Refatorar |

### Modularização de Prompts

```
.agents/skills/
└── common/
    └── prompts/
        ├── validation-rules.md    # Regras reutilizáveis
        ├── output-formats.md      # Formatos de saída
        ├── clickup-patterns.md    # Padrões ClickUp
        └── technical.md           # Contexto técnico
```

**Uso em Comando:**
```markdown
## Validações
@include common/prompts/validation-rules.md

## Formato de Saída
@include common/prompts/output-formats.md
```

---

## 📈 Estratégias Avançadas

### 1. Semantic Compression

```typescript
// ANTES: 50 tokens
interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
  updatedAt: Date;
}

// DEPOIS: 15 tokens
// User: { id, email, name, createdAt, updatedAt }
```

### 2. Reference Instead of Include

```markdown
## Contexto

Em vez de incluir o arquivo completo, referencie:
- Padrões: ver @docs/standards.md
- Exemplos: ver @src/components/Button.tsx
- Testes: rodar `npm test -- User`
```

### 3. Hierarchical Context

```
Level 1: Sumário do projeto (sempre)
Level 2: Módulo relevante (sob demanda)
Level 3: Arquivo específico (quando necessário)
Level 4: Função específica (para edição pontual)
```

### 4. Context Budgeting

```yaml
budget:
  total: 10000  # tokens disponíveis
  
  allocation:
    system_prompt: 1500   # 15%
    project_context: 2000 # 20%
    current_task: 4000    # 40%
    response_space: 2500  # 25%
    
  overflow_strategy: "truncate_oldest"
```

---

## ⚠️ Anti-Patterns

### 1. Context Dump

**❌ Problema:** Carregar todo o projeto
```
@codebase  // 100K tokens
```

**✅ Solução:** Seleção específica
```
@src/services/UserService.ts
@src/types/user.ts
```

### 2. Redundant Context

**❌ Problema:** Repetir informações
```markdown
O projeto usa React.
Este é um projeto React.
Estamos trabalhando com React.
```

**✅ Solução:** Mencionar uma vez

### 3. Stale Context

**❌ Problema:** Contexto desatualizado
```
// Código de 3 conversas atrás
```

**✅ Solução:** Sempre usar @file atual

### 4. Over-Engineering Prompts

**❌ Problema:** Instruções excessivas
```markdown
## Regras Importantes (500 linhas)
[...]
## Mais Regras (300 linhas)
[...]
```

**✅ Solução:** Essencial apenas

---

## 📊 Checklist de Otimização

### Comando/Prompt

- [ ] < 500 linhas totais
- [ ] Objetivo em 1-2 linhas
- [ ] Processo em etapas numeradas
- [ ] Sem repetição de instruções
- [ ] Prompts comuns em `common/prompts/`

### Contexto de Sessão

- [ ] `.gitignore` configurado
- [ ] Apenas arquivos relevantes carregados
- [ ] Referências em vez de cópias
- [ ] Progressive loading implementado

### Arquivos

- [ ] Arquivos grandes chunkeados
- [ ] Binários excluídos
- [ ] Build artifacts ignorados
- [ ] Logs rotacionados

---

## 📚 Recursos Adicionais

- [Anthropic Context Guide](https://docs.anthropic.com/)
- [OpenAI Token Counter](https://platform.openai.com/tokenizer)
- [Codex Performance Tips](https://docs.claude.com/en/docs/codex/overview)
- [Tiktoken Library](https://github.com/openai/tiktoken)

---

**Próxima Atualização Planejada**: Janeiro 2026
**Responsável**: Sistema Onion

