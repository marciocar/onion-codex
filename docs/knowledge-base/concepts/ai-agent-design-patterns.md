# AI Agent Design Patterns

---

## 📋 Metadata

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.0 |
| **Data de Criação** | 2025-11-24 |
| **Última Atualização** | 2025-11-24 |
| **Categoria** | Concepts |
| **Aplicação** | Sistema Onion - Design de Agentes |

### Fontes

- [LangChain Agent Documentation](https://python.langchain.com/docs/modules/agents/)
- [CrewAI Framework](https://www.crewai.com/)
- [AutoGen Multi-Agent Framework](https://microsoft.github.io/autogen/)
- [Anthropic Claude Agent Patterns](https://docs.anthropic.com/)
- Práticas do Sistema Onion

---

## 🎯 Visão Geral

Este documento define patterns de design para agentes de IA, focando em arquitetura, especialização, delegação e orquestração para sistemas multi-agente eficientes.

### Definição de Agente

```
Agente = Identidade + Especialização + Ferramentas + Protocolo de Ação
```

**Componentes Essenciais:**
- **Identidade**: Nome, descrição, propósito único
- **Especialização**: Área de expertise bem definida
- **Ferramentas**: Capacidades disponíveis (read, write, search, etc.)
- **Protocolo**: Como o agente opera e se comunica

---

## 🏗️ Arquitetura de Agentes

### Pattern 1: Single Agent (Agente Único)

```
┌─────────────────────────────────────┐
│           SINGLE AGENT              │
│  ┌─────────────────────────────┐    │
│  │  Identidade + Ferramentas   │    │
│  │  + Todo o conhecimento      │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
              ▼
         [OUTPUT]
```

**Quando usar:**
- Tarefas simples e bem definidas
- Domínio único e específico
- Contexto limitado

**Exemplo:** Agente de revisão de código para uma linguagem.

### Pattern 2: Orchestrator-Worker (Orquestrador-Trabalhador)

```
                    ┌─────────────────┐
                    │   ORCHESTRATOR  │
                    │   (Coordena)    │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
    ┌──────────┐      ┌──────────┐      ┌──────────┐
    │ Worker A │      │ Worker B │      │ Worker C │
    │(Pesquisa)│      │ (Código) │      │ (Teste)  │
    └──────────┘      └──────────┘      └──────────┘
```

**Quando usar:**
- Tarefas complexas com múltiplas especialidades
- Necessidade de coordenação
- Resultados precisam ser consolidados

**Exemplo:** Orquestrador de documentação delegando para especialistas.

### Pattern 3: Pipeline (Sequencial)

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Agent A  │───▶│ Agent B  │───▶│ Agent C  │───▶│  Output  │
│(Análise) │    │ (Design) │    │ (Impl.)  │    │ (Final)  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
```

**Quando usar:**
- Processo com etapas bem definidas
- Output de um agente é input do próximo
- Ordem de execução importante

**Exemplo:** Análise → Design → Implementação → Review.

### Pattern 4: Peer Review (Revisão por Pares)

```
┌──────────────────────────────────────┐
│           TASK                       │
└──────────────────┬───────────────────┘
                   │
    ┌──────────────┴──────────────┐
    ▼                             ▼
┌──────────┐               ┌──────────┐
│ Agent A  │◀─────────────▶│ Agent B  │
│(Executor)│   Feedback    │(Reviewer)│
└──────────┘               └──────────┘
    │                             │
    └──────────────┬──────────────┘
                   ▼
          ┌──────────────┐
          │   OUTPUT     │
          │  (Refinado)  │
          └──────────────┘
```

**Quando usar:**
- Qualidade crítica
- Necessidade de segunda opinião
- Redução de erros e alucinações

**Exemplo:** Code-reviewer revisando output de developer.

---

## 📐 Patterns de Especialização

### Pattern: Single Responsibility Agent

**Princípio:** Cada agente deve ter uma única responsabilidade bem definida.

**❌ Anti-pattern:**
```yaml
name: super-agent
description: Faz tudo - código, testes, docs, deploy, reviews...
```

**✅ Pattern correto:**
```yaml
name: code-reviewer
description: Revisa código para qualidade, segurança e padrões.
expertise: ["code-review", "security", "best-practices"]
```

### Pattern: Expert Agent

**Princípio:** Agente com conhecimento profundo em domínio específico.

```yaml
name: react-developer
description: Especialista em desenvolvimento React e ecossistema.
expertise:
  - React hooks e patterns
  - Estado com Zustand/Redux
  - Testes com Testing Library
  - Performance optimization
tools:
  - read_file
  - write
  - codebase_search
```

### Pattern: Meta Agent

**Princípio:** Agente que cria ou gerencia outros agentes.

```yaml
name: agent-creator-specialist
description: Meta-agente especializado em criar agentes.
expertise:
  - Design de agentes
  - Prompt engineering
  - Estruturação de conhecimento
tools:
  - read_file
  - write
  - codebase_search
related_agents:
  - command-creator-specialist
```

---

## 🔄 Patterns de Delegação

### Pattern: Explicit Delegation

**Princípio:** Delegação explícita com instruções claras.

```markdown
## Processo
1. Analisar requisitos
2. **DELEGAR para @code-reviewer**:
   - Fornecer: código gerado
   - Solicitar: review de qualidade
   - Esperar: feedback e sugestões
3. Aplicar feedback
4. Retornar resultado
```

### Pattern: Conditional Delegation

**Princípio:** Delegar baseado em condições.

```markdown
## Delegação Condicional

SE tarefa envolve código TypeScript:
  DELEGAR para @typescript-specialist

SE tarefa envolve testes:
  DELEGAR para @test-engineer

SE tarefa envolve segurança:
  DELEGAR para @security-specialist

SENÃO:
  Executar internamente
```

### Pattern: Cascade Delegation

**Princípio:** Delegação em cascata para refinamento progressivo.

```
Request → @product-agent (estratégia)
                 │
                 ▼
         @task-specialist (decomposição)
                 │
                 ▼
         @code-reviewer (validação)
                 │
                 ▼
         @test-engineer (testes)
```

---

## 🎯 Patterns de Contexto

### Pattern: Context Injection

**Princípio:** Injetar contexto relevante no prompt do agente.

```markdown
## Contexto Automático

Ao invocar este agente, incluir:
1. Sessão atual: @.codex/sessions/<feature>/context.md
2. Padrões do projeto: @.codex/rules/
3. Última atividade: últimos 5 arquivos modificados
```

### Pattern: Progressive Context

**Princípio:** Expandir contexto progressivamente conforme necessidade.

```
Nível 1: Arquivo atual
    ↓ (se insuficiente)
Nível 2: Arquivos relacionados (@imports)
    ↓ (se insuficiente)
Nível 3: Módulo/pasta inteira
    ↓ (se insuficiente)
Nível 4: Projeto completo (@codebase)
```

### Pattern: Context Boundary

**Princípio:** Definir limites claros do que entra no contexto.

```yaml
context:
  include:
    - ".codex/sessions/current/*"
    - "src/components/<component>/*"
  exclude:
    - "node_modules/"
    - "*.test.ts"
    - "*.spec.ts"
  max_files: 10
  max_tokens: 8000
```

---

## 🛠️ Patterns de Ferramentas

### Pattern: Tool Selection by Task

**Princípio:** Agentes devem ter apenas ferramentas necessárias.

| Tipo de Agente | Ferramentas Recomendadas |
|----------------|--------------------------|
| **Pesquisa** | `codebase_search`, `web_search`, `grep`, `read_file` |
| **Desenvolvimento** | `read_file`, `write`, `search_replace`, `run_terminal_cmd` |
| **Review** | `read_file`, `codebase_search`, `grep` |
| **Documentação** | `read_file`, `write`, `codebase_search` |
| **Teste** | `read_file`, `write`, `run_terminal_cmd` |

### Pattern: Agnostic Tools

**Princípio:** Ferramentas genéricas permitem agentes portáveis.

**✅ Agente Agnóstico:**
```yaml
tools:
  - read_file
  - write
  - codebase_search
  - grep
  - web_search
# Sem MCPs específicos - portável para qualquer projeto
```

**⚠️ Agente Especializado:**
```yaml
tools:
  - read_file
  - write
  - mcp_ClickUp_*      # Acoplado ao ClickUp
# Útil, mas menos portável
```

### Pattern: Tool Fallback

**Princípio:** Comportamento alternativo quando ferramenta indisponível.

```markdown
## Integração ClickUp

SE mcp_ClickUp disponível:
  → Usar para criar/atualizar tasks
SENÃO:
  → Gerar output em formato Markdown compatível
  → Usuário pode copiar manualmente
```

---

## 📝 Patterns de Prompt Engineering

### Pattern: Structured Identity

**Princípio:** Identidade clara no início do prompt.

```markdown
# Identidade

Você é o **@code-reviewer**, especialista em:
- Revisão de código TypeScript/JavaScript
- Identificação de problemas de segurança
- Aplicação de padrões e boas práticas

## Sua Missão
Revisar código para qualidade, mantendo padrões do projeto.

## Suas Regras
- Seja específico nas sugestões
- Cite linhas de código
- Priorize issues críticas
```

### Pattern: Action Protocol

**Princípio:** Definir protocolo claro de ação.

```markdown
## Protocolo de Operação

### Fase 1: Análise (sem output)
- Ler código completo
- Identificar padrões usados
- Mapear dependências

### Fase 2: Avaliação (notas internas)
- Listar issues encontradas
- Classificar por severidade
- Identificar melhorias

### Fase 3: Output (para usuário)
- Apresentar sumário
- Detalhar issues críticas
- Sugerir melhorias
```

### Pattern: Output Format

**Princípio:** Definir formato de saída esperado.

```markdown
## Formato de Saída

### Estrutura Obrigatória
```
## 📊 Sumário
- Issues críticas: X
- Melhorias sugeridas: Y
- Aprovado: Sim/Não

## 🚨 Issues Críticas
1. [SECURITY] Descrição - linha X
2. [BUG] Descrição - linha Y

## 💡 Melhorias
1. Descrição - linha Z

## ✅ Pontos Positivos
- Item 1
- Item 2
```
```

---

## 🔗 Aplicação no Sistema Onion

### Hierarquia de Agentes

```
                    ┌─────────────────┐
                    │    @onion       │
                    │  (Orquestrador) │
                    └────────┬────────┘
                             │
     ┌───────────────────────┼───────────────────────┐
     │                       │                       │
     ▼                       ▼                       ▼
┌──────────┐          ┌──────────┐          ┌──────────┐
│ product/ │          │ develop- │          │  meta/   │
│ agents   │          │  ment/   │          │ agents   │
└──────────┘          └──────────┘          └──────────┘
```

### Patterns Implementados

| Pattern | Implementação Onion |
|---------|---------------------|
| Orchestrator-Worker | `@onion` coordena especialistas |
| Expert Agent | `@clickup-specialist`, `@react-developer` |
| Meta Agent | `@agent-creator-specialist` |
| Peer Review | `@code-reviewer` + desenvolvedor |
| Context Injection | Sessions em `.codex/sessions/` |

### Template de Agente Onion

```yaml
---
name: agent-name
description: |
  Descrição clara em 1-2 linhas.
model: sonnet
tools: [read_file, write, codebase_search, grep]

color: purple
priority: alta
category: development

expertise: ["area-1", "area-2"]
related_agents: ["agente-1", "agente-2"]
related_commands: ["/categoria/comando"]

version: "1.0.0"
updated: "2025-11-24"
---

# Nome do Agente

## 🎯 Identidade e Propósito
[Quem é e o que faz]

## 📋 Protocolo de Operação
### Fase 1: [Nome]
### Fase 2: [Nome]
### Fase 3: [Nome]

## 🔌 Integrações Opcionais
| MCP | Uso |
|-----|-----|
| ClickUp | Se disponível, gerenciar tasks |

## 💡 Guidelines
[Regras e melhores práticas]
```

---

## ⚠️ Anti-Patterns

### 1. God Agent

**❌ Problema:** Um agente faz tudo
```yaml
name: do-everything-agent
expertise: [tudo]
```

**✅ Solução:** Especialização + delegação

### 2. Context Overload

**❌ Problema:** Carregar todo o projeto no contexto
```
@codebase (100.000 linhas)
```

**✅ Solução:** Context boundary + progressive loading

### 3. Vague Identity

**❌ Problema:** Identidade genérica
```
Você é um assistente útil.
```

**✅ Solução:** Identidade específica e expertise clara

### 4. Missing Protocol

**❌ Problema:** Sem processo definido
```
Faça o que achar melhor.
```

**✅ Solução:** Protocolo com fases claras

---

## 📚 Recursos Adicionais

### Internos (Sistema Onion)
- [Specification-Driven AI Abstraction Layer](specification-driven-ai-abstraction-layer.md) - Padrão para abstrações documentais
- [Task Manager Abstraction](task-manager-abstraction.md) - Implementação de referência do SDAAL
- [Spec-as-Code Strategy](spec-as-code-strategy.md) - Metodologia de especificações

### Externos
- [LangChain Agents](https://python.langchain.com/docs/modules/agents/)
- [CrewAI Documentation](https://docs.crewai.com/)
- [AutoGen](https://microsoft.github.io/autogen/)
- [Anthropic Prompting Guide](https://docs.anthropic.com/claude/docs/prompt-engineering)
- [OpenAI Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)

---

**Próxima Atualização Planejada**: Janeiro 2026
**Responsável**: Sistema Onion

