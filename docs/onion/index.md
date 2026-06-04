# 📚 Índice - Sistema Onion

> **Última atualização**: 2026-06-03 | **Gerado por**: `$docs-build-index onion` | **Revisado**: auditoria manual

Bem-vindo ao índice da documentação do **Sistema Onion**. Este documento organiza os 11 documentos de documentação operacional do sistema em `docs/onion/`.

---

## 🎯 Visão Geral

O **Sistema Onion** é um **framework template em `.codex/`** — instalável em qualquer projeto (novo, legado ou regulado), plataforma única Codex, sem produto npm e sem CLI standalone. Inclui:
- 🤖 **78 skills invocáveis** Codex (`$slug`) em 9 categorias
- 🎯 **49 subagentes de IA especializados** em 9 categorias
- 🧩 **4 skills núcleo** em `.agents/skills/` (`onion`, `onion-patterns`, `onion-validation`, `language-standards`)
- 🧅 **Skill `$onion`** — ponto de entrada inteligente
- 🔗 **Task Manager Abstraction** plugável (Jira, ClickUp, Asana, Linear)
- 🏗️ **Spec as Code Multi-Context** — business, technical e meta-specs

---

## 📊 Estatísticas

- **11 documentos** em `docs/onion/`
- **78 skills invocáveis** Codex em `.agents/skills/`
- **49 subagentes** IA em `.codex/agents/`
- **4 skills núcleo** em `.agents/skills/`

---

## 📖 Documentação Principal

### 🌟 Guias Essenciais

**Comece aqui se você é novo no Sistema Onion:**

1. **[Guia de Skills](commands-guide.md)** - Documentação das skills disponíveis
   - 78 skills invocáveis em 9 categorias
   - Exemplos de uso e workflows
   - Integrações com Task Managers

2. **[Referência de Subagentes](agents-reference.md)** - Lista e descrição dos subagentes especializados
   - 49 subagentes em 9 categorias
   - Quando usar cada subagente
   - Capacidades e especializações

3. **[Fluxos de Engenharia](engineering-flows.md)** - Workflows detalhados para desenvolvimento
   - Feature Development completo
   - Correção de bugs
   - Refatoração e hotfixes
   - Integração com Task Manager por fluxo

4. **[Sistema de Testes e Validação](testing-validation-system.md)** - Framework completo de testes e validação
   - 4 camadas integradas (Knowledge Base, Agentes, Comandos de Teste, Comandos de Validação)
   - White-box, Grey-box, Black-box
   - QA Story Points

### ⚙️ Integrações e Configuração

**Setup e configuração do sistema:**

1. **[Configuração Inicial](getting-started.md)** - Setup completo do sistema
   - Primeiros passos
   - Configuração de integrações
   - Workflows básicos

2. **Task Manager Abstraction** — configure provider (Jira/ClickUp/Asana/Linear) via `.env` e `$meta-setup-integration`. Adapters técnicos em [`.agents/skills/task-manager/references/adapters/`](../../.agents/skills/task-manager/references/adapters/).

3. **Aplicação em projetos-alvo** — ver guias em [`docs/applying/`](../applying/) (greenfield, legado, regulado).

### 🔧 Referências Técnicas

**Documentação técnica e arquitetural:**

1. **[Exemplos Práticos](practical-examples.md)** - Casos de uso reais com exemplos
   - Workflows completos
   - Cenários de uso
   - Melhores práticas

2. **[Referência de Ferramentas](tools-reference.md)** - Todas as ferramentas disponíveis
   - Ferramentas integradas
   - Configuração
   - Uso e exemplos

3. **[Arquitetura de Skills](codex-skills-architecture.md)** - Estrutura interna das skills
   - Padrões de design
   - Estrutura de arquivos
   - Best practices

### 📚 Documentação Avançada

**Para usuários avançados e desenvolvedores do sistema:**

1. **[Testes de Validação E2E](end-to-end-validation-tests.md)** - Testes end-to-end do sistema
   - Suíte de testes completa
   - Validação de funcionalidades
   - Cobertura de testes

2. **[Guia de Engenharia Reversa](sistema-engenharia-reversa-guia-uso.md)** - Engenharia reversa de projetos
   - Metodologia completa
   - Templates adaptativos
   - Casos de uso

---

## 🗺️ Navegação Rápida

### Por Tipo de Documento

| Tipo | Arquivos | Descrição |
|------|----------|-----------|
| **Guias** | 4 | Guias essenciais de uso |
| **Configuração** | 1 | Setup inicial |
| **Referências** | 3 | Documentação técnica |
| **Avançado** | 2 | Para usuários avançados |

### Por Perfil de Usuário

#### 👨‍💻 Desenvolvedores
- Comece com: [Getting Started](getting-started.md)
- Aprenda: [Commands Guide](commands-guide.md)
- Explore: [Engineering Flows](engineering-flows.md)
- Teste: [Testing Validation System](testing-validation-system.md)

#### 📋 Product Owners
- Comece com: [Commands Guide](commands-guide.md) - Seção Produto
- Aprenda: [Practical Examples](practical-examples.md)
- Explore: [Agents Reference](agents-reference.md)

#### 🧪 QA/Test Engineers
- Comece com: [Testing Validation System](testing-validation-system.md)
- Aprenda: [End-to-End Validation Tests](end-to-end-validation-tests.md)
- Explore: [Agents Reference](agents-reference.md) - Seção Testing

#### 🏗️ Arquitetos
- Comece com: [Codex Skills Architecture](codex-skills-architecture.md)
- Explore: [Engineering Flows](engineering-flows.md)

#### 🔧 Administradores
- Comece com: [Getting Started](getting-started.md)
- Aplique em projetos: [`docs/applying/`](../applying/)
- Configure Task Manager: `$meta-setup-integration` (adapters em `.agents/skills/task-manager/references/adapters/`)

---

## 🔗 Links Rápidos

### Documentação Essencial
- [README Principal](../../README.md) - Visão geral do Sistema Onion
- [Índice Central](../INDEX.md) - Hub de navegação completo
- [Guia de Skills](commands-guide.md) - Todas as skills
- [Referência de Subagentes](agents-reference.md) - Todos os subagentes

### Knowledge Bases Relacionadas
- [Task Manager Abstraction](../knowledge-base/concepts/task-manager-abstraction.md)
- [Spec-Driven Development](../knowledge-base/concepts/spec-driven-development.md)
- [AI Agent Design Patterns](../knowledge-base/concepts/ai-agent-design-patterns.md)
- [Framework de Story Points](../knowledge-base/frameworks/framework_story_points.md)

### Configuração
- [Getting Started](getting-started.md)
- [Adapters de Task Manager](../../.agents/skills/task-manager/references/adapters/)

---

## 📅 Histórico de Atualizações

| Data | Mudança |
|------|---------|
| 2026-06-03 | Limpeza: removidos 14 docs obsoletos do v4.0/CLI abandonado; índice realinhado à identidade atual (78 comandos / 49 agentes / 4 skills) |
| 2026-05-15 | Auditoria manual: agente @onion corrigido (agentes fantasmas removidos, 18 novos adicionados) |
| 2025-12-20 | Índice reconstruído |
| 2025-12-02 | Adicionado Spec-Driven Development |

---

## 🔄 Manutenção

Este índice é gerado pelo comando `$docs-build-index onion`.

**Para atualizar:**
```bash
$docs-build-index onion        # Reconstruir este índice
$docs-build-index              # Reconstruir índice principal
```

---

**Sistema Onion** - Multi-Context Development Orchestrator 🧅
</content>
</invoke>
