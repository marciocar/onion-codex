---
status: historical
replaced-by: docs/analysis/onion-review-2026-05.md
abandoned-on: 2026-05-18
---

> ⚠️ **Documento histórico** — descreve direções anteriores à migração para OpenAI Codex (2026-06). Mantido como referência. Ver `docs/knowledge-base/platforms/openai-codex.md`.

# Sistema Onion - Entendimento Completo do Ciclo de Desenvolvimento

> **AVISO**: Este documento descreve visões estratégicas abandonadas em 2026-05-18 (`.onion/`, CLI standalone, multi-IDE, plano v4.0 FASES 5-9). Mantido como registro histórico do pensamento de 2025-12-20. Para o estado atual do Onion, consultar a [Revisão Analítica de Maio/2026](../../analysis/onion-review-2026-05.md).

> **Versão**: 1.0.0 | **Última atualização**: 2025-12-20 | **Categoria**: Frameworks  
> Reflexão completa sobre o Ciclo do Onion: KB → Agentes → Comandos → Regras → Gestão de Contexto

---

## 📋 Metadata

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.0 |
| **Data de Criação** | 2025-12-20 |
| **Última Atualização** | 2025-12-20 |
| **Categoria** | Frameworks |
| **Aplicação** | Complete Development Cycle Understanding |
| **Status** | Em Discussão |

### Contexto

Este documento consolida as reflexões sobre o **verdadeiro propósito e arquitetura do Sistema Onion**, corrigindo análises anteriores que tratavam o sistema como "coleção de comandos" quando na verdade é uma **metodologia completa de desenvolvimento com 5 camadas inter-relacionadas**.

---

## 🎯 O Grande Insight

### O Que Foi Perdido nas Análises Anteriores

As análises comparativas trataram o Sistema Onion como:
- ❌ "Ferramenta SDD com muitos comandos"
- ❌ "Competidor de OpenSpec/Kiro/Spec-Kit"
- ❌ "Sistema complexo que precisa simplificar"

### A Verdade Revelada

O Sistema Onion é:
- ✅ **Metodologia completa de desenvolvimento**
- ✅ **Ciclo de 5 camadas inter-relacionadas**
- ✅ **Framework de orquestração multi-contexto**
- ✅ **Sistema autogerador (meta-comandos)**
- ✅ **Único no mercado que faz isso**

**Não existe concorrente direto porque não existe nada parecido.**

---

## 🔄 O CICLO DO ONION (5 Camadas)

### Visão Geral

```
┌─────────────────────────────────────────────────────────────────┐
│                    CICLO COMPLETO DO ONION                       │
└─────────────────────────────────────────────────────────────────┘

1️⃣ KNOWLEDGE BASE (Camada de Conhecimento)
   📚 Documentação estruturada para IA consumir
   ├── Conceitos (concepts/)
   ├── Frameworks (frameworks/)
   ├── Tools (tools/)
   └── Learnings (learnings/) ← feedback de sessions
   
   ↓ Alimenta ↓

2️⃣ AGENTES (Camada de Inteligência)
   🤖 Especialistas que consomem KBs
   ├── Leem KBs relevantes
   ├── Executam raciocínio especializado
   ├── Tomam decisões contextuais
   └── Geram artefatos
   
   ↓ São invocados por ↓

3️⃣ COMANDOS (Camada de Execução)
   ⚡ Workflows estruturados
   ├── Invocam agentes apropriados
   ├── Executam operações
   ├── Geram documentação
   └── Atualizam task managers
   
   ↓ São validados por ↓

4️⃣ REGRAS (Camada de Conformidade)
   ✅ Padrões e validações
   ├── Nomenclatura (kebab-case, etc)
   ├── Estruturas obrigatórias (YAML headers)
   ├── Limites (< 400 linhas, etc)
   └── Quality gates automáticos
   
   ↓ Geram ↓

5️⃣ GESTÃO DE CONTEXTO (Camada de Rastreabilidade)
   📋 Sessions por feature/contexto
   ├── context.md (IDs, metadata)
   ├── architecture.md (decisões arquiteturais)
   ├── plan.md (fases e tarefas)
   └── notes.md (progresso e learnings)
   
   ↓ Alimenta (loop fechado) ↓

1️⃣ KNOWLEDGE BASE (atualização contínua)
   └── Novos learnings viram novas KBs
```

### Exemplo Completo do Ciclo

**Cenário**: Implementar autenticação OAuth2

```bash
# ═══════════════════════════════════════════════════════════════
# 1️⃣ KNOWLEDGE BASE (ponto de partida)
# ═══════════════════════════════════════════════════════════════
docs/knowledge-base/concepts/authentication-patterns.md
# → Documenta OAuth2, JWT, sessions, best practices

# ═══════════════════════════════════════════════════════════════
# 2️⃣ AGENTES (consomem KB)
# ═══════════════════════════════════════════════════════════════
@product-agent
# → Lê authentication-patterns.md
# → Entende contexto de OAuth2
# → Sabe perguntas certas a fazer

# ═══════════════════════════════════════════════════════════════
# 3️⃣ COMANDOS (invocam agentes)
# ═══════════════════════════════════════════════════════════════
/business/spec "feature-auth"
# → Invoca @product-agent
# → Agente pergunta: Google, GitHub, ou ambos?
# → Agente cria spec baseada em KB + respostas
# → Salva: docs/business-context/features/auth-oauth2.md

/technical/light-arch "feature-auth"
# → Invoca @architecture-specialist
# → Lê spec de business + KB técnica
# → Analisa codebase existente
# → Propõe: passport.js, rotas, middleware, testes
# → Salva: .onion/contexts/technical/sessions/feature-auth/architecture.md

# ═══════════════════════════════════════════════════════════════
# 4️⃣ REGRAS (validam conformidade)
# ═══════════════════════════════════════════════════════════════
Sistema valida automaticamente:
✅ Nome em kebab-case: feature-auth
✅ YAML header completo
✅ Spec < 400 linhas
✅ Arquitetura documenta trade-offs
✅ Session criada corretamente

# ═══════════════════════════════════════════════════════════════
# 5️⃣ GESTÃO DE CONTEXTO (rastreabilidade)
# ═══════════════════════════════════════════════════════════════
.onion/contexts/technical/sessions/feature-auth/
├── context.md
│   # Task ID: AUTH-123
│   # Assignee: dev-team
│   # Story Points: 8 → 13 (validado por technical)
│   # Started: 2025-12-20
├── architecture.md
│   # Decisão: passport.js (maduro, comunidade)
│   # Alternativa: next-auth (considerado, descartado por X)
│   # Trade-off: performance vs simplicidade
├── plan.md
│   # FASE 1: Setup passport.js
│   # FASE 2: Integração Google OAuth
│   # FASE 3: Integração GitHub OAuth
│   # FASE 4: Testes e2e
└── notes.md
    # 2025-12-20: Problema com redirect_uri resolvido
    # 2025-12-21: GitHub exige verificação de email
    # 2025-12-22: Implementado refresh token rotation

# ═══════════════════════════════════════════════════════════════
# LOOP: Atualiza KB (aprendizado contínuo)
# ═══════════════════════════════════════════════════════════════
/meta/create-knowledge-base "OAuth2 Learnings 2025"
# → Extrai de notes.md
# → Cria: docs/knowledge-base/learnings/oauth2-implementation-2025.md
# → Próxima feature OAuth2 usa este learning
```

**Resultado**: Ciclo completo documentado, rastreável, e que alimenta futuras implementações.

---

## 🔧 META-COMANDOS: O Sistema Autogerador

### Descoberta Crítica: `/meta/create-abstraction`

O Sistema Onion não apenas **usa** abstrações - ele tem **geradores de abstrações**.

#### Análise do Comando

**Arquivo**: `.claude/commands/meta/create-abstraction.md`

**O que faz**:
1. Cria estrutura completa de abstração SDAAL
2. Gera interface TypeScript
3. Gera tipos compartilhados
4. Gera factory pattern
5. Gera detector de provedor
6. Gera adapters para cada provedor
7. Gera adapter fallback (Null Object Pattern)

**Estrutura gerada**:
```
.claude/utils/<abstraction-name>/
├── README.md           # Visão geral e quick start
├── interface.md        # Contrato TypeScript
├── types.md            # Tipos compartilhados
├── factory.md          # Factory para instanciar adapters
├── detector.md         # Detecção de provedor via .env
└── adapters/
    ├── provider-a.md   # Implementação provider A
    ├── provider-b.md   # Implementação provider B
    └── none.md         # Fallback (modo offline)
```

#### Significado

**Task Manager Abstraction NÃO é over-engineering** - é uma **implementação de referência** de um padrão **replicável**.

#### Uso Multi-Context

Cada contexto pode criar suas próprias abstrações:

```bash
# Business context: Notification abstraction
/meta/create-abstraction notification-manager \
  --providers=slack,discord,email \
  --context=business

# Technical context: Storage abstraction
/meta/create-abstraction storage-manager \
  --providers=s3,gcs,local \
  --context=technical

# Customer Success context: Transcription abstraction
/meta/create-abstraction transcription-service \
  --providers=whisper-local,assemblyai,none \
  --context=customer-success

# Compliance context: Audit Trail abstraction
/meta/create-abstraction audit-logger \
  --providers=cloudwatch,splunk,local \
  --context=compliance
```

**Cada contexto escolhe seus provedores via `.context-config.yml`**:

```yaml
# .onion/contexts/business/.context-config.yml
integrations:
  task_manager:
    provider: clickup
  notification:
    provider: slack
  
# .onion/contexts/technical/.context-config.yml
integrations:
  task_manager:
    provider: linear
  storage:
    provider: s3
    
# .onion/contexts/customer-success/.context-config.yml
integrations:
  task_manager:
    provider: asana
  transcription:
    provider: whisper-local  # Local first para privacidade
```

### Outros Meta-Comandos

O Onion tem **geradores para tudo**:

```bash
# Criar Knowledge Base
/meta/create-knowledge-base "OAuth2 Best Practices"
# → Gera: docs/knowledge-base/concepts/oauth2-best-practices.md

# Criar Agente especializado
/meta/create-agent oauth2-specialist \
  --expertise=oauth2,jwt,authentication
# → Gera: .onion/contexts/technical/agents/oauth2-specialist.md

# Criar Comando personalizado
/meta/create-command oauth2-setup \
  --category=technical
# → Gera: .onion/contexts/technical/commands/oauth2-setup.md

# Criar Regra de validação
/meta/create-rule oauth2-security-check
# → Gera: .onion/core/rules/oauth2-security-check.mdc
```

**Isso é PODEROSO**: O sistema não apenas executa - ele **se expande** conforme necessário.

---

## 📊 STORY POINTS: Ciclo Cross-Context

### Análise Anterior (Incorreta)

> "Story Points é feature de business context apenas"

### Análise Corrigida

**Story Points é um CICLO DE FEEDBACK entre contextos**:

```bash
# ═══════════════════════════════════════════════════════════════
# FASE 1: Estimativa Inicial (Business Context)
# ═══════════════════════════════════════════════════════════════
/business/estimate "feature-auth"
# Input: Descrição funcional, acceptance criteria
# Agente: @story-points-specialist (business)
# Output: 8 story points (estimativa de produto)
# Rationale: "OAuth2 é padrão, 2 provedores, fluxo conhecido"

# ═══════════════════════════════════════════════════════════════
# FASE 2: Validação Técnica (Technical Context)
# ═══════════════════════════════════════════════════════════════
/technical/validate-estimate "feature-auth"
# Input: Spec de business + codebase analysis
# Agente: @architecture-specialist (technical)
# Output: 13 story points (complexidade técnica identificada)
# Rationale: 
#   - Precisa migrar auth existente (não documentado)
#   - Integração com 3 serviços diferentes
#   - Testes e2e complexos (simulação OAuth flow)
#   - Divergência: +5 story points

# Sistema automaticamente:
# → Atualiza task no ClickUp/Linear com divergência
# → Cria comment explicando diferença
# → Notifica business context

# ═══════════════════════════════════════════════════════════════
# FASE 3: Reavaliação e Decisão (Business Context)
# ═══════════════════════════════════════════════════════════════
/business/refine "feature-auth"
# Input: Divergência técnica (8 → 13 SP)
# Agente: @product-agent (business)
# Opções apresentadas:
#   A) Simplificar: só Google OAuth (6 SP)
#   B) Aceitar complexidade: ambos provedores (13 SP)
#   C) Fases: Google agora, GitHub depois (8 + 5 SP)
# Decisão: Opção C (faseamento)
# Output: 8 story points (fase 1 apenas)

# ═══════════════════════════════════════════════════════════════
# FASE 4: Aferição Real (Durante Desenvolvimento)
# ═══════════════════════════════════════════════════════════════
/technical/work "feature-auth"
# Durante implementação:
# → Sistema rastreia tempo real
# → Fase 1 (Google OAuth): 10 horas
# → Story point aferido: 10 SP real vs 8 SP estimado
# → Divergência: +25% (dentro do aceitável)

# Sistema automaticamente:
# → Atualiza histórico de estimativas
# → Alimenta machine learning para futuras estimativas
# → Cria learning: "OAuth2 primeira vez: adicionar 2-3 SP"

# ═══════════════════════════════════════════════════════════════
# LOOP: Próxima Feature OAuth2
# ═══════════════════════════════════════════════════════════════
/business/estimate "feature-github-oauth"
# Sistema automaticamente:
# → Lê histórico: feature-auth levou +25%
# → Lê learning: primeira implementação OAuth2 +2-3 SP
# → Sugere: 5 story points (não 3) para GitHub OAuth
# → Justifica: baseado em learning de feature-auth
```

**Resultado**: Story Points não é uma feature isolada - é um **sistema de aprendizado contínuo cross-context**.

---

## 🏗️ ARQUITETURA REVISITADA (Agnóstica de IDE)

### Problema Identificado

> ".claude poderia ser .claude, .windsurf e outros e mesmo assim iria funcionar"

**Crítico**: A estrutura atual depende de `.claude/` - específico do Claude Code.

### Proposta: `.onion/` (Universal)

```
.onion/                              # ✅ Agnóstico de IDE
├── core/                            # Núcleo universal
│   ├── kb/                          # 📚 CAMADA 1: Knowledge Base
│   │   ├── concepts/                # Conceitos fundamentais
│   │   ├── frameworks/              # Análises de frameworks
│   │   ├── tools/                   # Documentação de tools
│   │   └── learnings/               # 🆕 Learnings de sessions
│   │
│   ├── agents/                      # 🤖 CAMADA 2: Agentes Core
│   │   ├── onion.md                 # Orquestrador master
│   │   ├── kb-manager.md            # 🆕 Gerencia KBs
│   │   └── context-router.md        # Roteador de contextos
│   │
│   ├── commands/                    # ⚡ CAMADA 3: Comandos Core
│   │   ├── meta/                    # 🔧 Meta-comandos (autogeração)
│   │   │   ├── create-knowledge-base.md
│   │   │   ├── create-agent.md
│   │   │   ├── create-command.md
│   │   │   ├── create-abstraction.md
│   │   │   └── create-rule.md       # 🆕
│   │   ├── warm-up.md               # Preparar contexto
│   │   ├── sync.md                  # Sincronização
│   │   └── help.md                  # Ajuda universal
│   │
│   ├── rules/                       # ✅ CAMADA 4: Regras
│   │   ├── onion-patterns.mdc       # Padrões de nomenclatura
│   │   ├── validation-rules.mdc     # Validações automáticas
│   │   └── context-validation.mdc   # 🆕 Validação por contexto
│   │
│   └── utils/                       # Utilities e abstractions
│       ├── task-manager/            # TMA (abstraction reference)
│       ├── transcription-service/   # 🆕 Transcrição
│       ├── notification-manager/    # 🆕 Notificações
│       └── storage-manager/         # 🆕 Storage
│
├── contexts/                        # Contextos específicos
│   ├── business/
│   │   ├── .context-config.yml      # Configuração do contexto
│   │   │   # task_manager: clickup
│   │   │   # notification: slack
│   │   │   # transcription: whisper-local
│   │   │
│   │   ├── kb/                      # KBs específicas business
│   │   │   ├── product-strategy.md
│   │   │   ├── market-analysis.md
│   │   │   └── customer-insights.md
│   │   │
│   │   ├── agents/                  # Agentes business
│   │   │   ├── product-agent.md
│   │   │   ├── strategy-analyst.md
│   │   │   └── story-points-specialist.md
│   │   │
│   │   ├── commands/
│   │   │   ├── starter/             # 🆕 5 comandos essenciais
│   │   │   │   ├── spec.md          # Criar spec
│   │   │   │   ├── refine.md        # Refinar spec
│   │   │   │   ├── estimate.md      # Estimar SP
│   │   │   │   ├── task.md          # Criar task
│   │   │   │   └── help.md          # Ajuda contexto
│   │   │   ├── intermediate/        # 🆕 10 comandos adicionais
│   │   │   │   ├── collect.md
│   │   │   │   ├── light-arch.md
│   │   │   │   ├── extract-meeting.md
│   │   │   │   └── ...
│   │   │   └── advanced/            # 🆕 Todos os comandos
│   │   │       └── ...
│   │   │
│   │   └── sessions/                # 🆕 CAMADA 5: Gestão de Contexto
│   │       └── <feature-slug>/
│   │           ├── context.md       # Task IDs, metadata
│   │           ├── architecture.md  # Decisões arquiteturais
│   │           ├── plan.md          # Fases e tarefas
│   │           └── notes.md         # Progresso e learnings
│   │
│   ├── technical/
│   │   ├── .context-config.yml
│   │   │   # task_manager: linear
│   │   │   # storage: s3
│   │   │   # transcription: none
│   │   ├── kb/
│   │   │   ├── architecture-patterns.md
│   │   │   ├── coding-standards.md
│   │   │   └── deployment-strategies.md
│   │   ├── agents/
│   │   │   ├── react-developer.md
│   │   │   ├── python-developer.md
│   │   │   ├── architecture-specialist.md
│   │   │   └── gitflow-specialist.md
│   │   ├── commands/
│   │   │   ├── starter/
│   │   │   │   ├── plan.md
│   │   │   │   ├── work.md
│   │   │   │   ├── pr.md
│   │   │   │   ├── sync.md
│   │   │   │   └── help.md
│   │   │   ├── intermediate/
│   │   │   └── advanced/
│   │   └── sessions/
│   │
│   ├── customer-success/
│   │   ├── .context-config.yml
│   │   │   # task_manager: asana
│   │   │   # transcription: assemblyai
│   │   │   # notification: email
│   │   ├── kb/
│   │   ├── agents/
│   │   ├── commands/
│   │   └── sessions/
│   │
│   ├── compliance/
│   │   ├── .context-config.yml
│   │   │   # task_manager: jira
│   │   │   # audit_logger: cloudwatch
│   │   ├── kb/
│   │   ├── agents/
│   │   ├── commands/
│   │   └── sessions/
│   │
│   ├── sales/
│   │   └── ...
│   │
│   └── marketing/
│       └── ...
│
├── docs/                            # Documentação estruturada
│   ├── onion/                       # Docs do framework Onion
│   │   ├── complete-cycle.md        # Este documento
│   │   ├── multi-context-orchestrator.md
│   │   └── getting-started-by-context.md
│   ├── business-context/            # Docs gerados por business
│   │   ├── features/
│   │   ├── decisions/
│   │   └── strategy/
│   ├── technical-context/           # Docs gerados por technical
│   │   ├── architecture/
│   │   ├── decisions/
│   │   └── plans/
│   ├── customer-success-context/
│   ├── compliance-context/
│   └── [outros contextos]/
│
└── .ide/                            # 🆕 IDE-specific configs
    ├── claude/                      # Configs Claude Code
    │   └── settings.json
    ├── claude/                      # Configs Claude Desktop
    │   └── settings.json
    └── windsurf/                    # Configs Windsurf IDE
        └── settings.json
```

### Benefícios da Nova Estrutura

| Aspecto | Antes (`.claude/`) | Depois (`.onion/`) |
|---------|-------------------|-------------------|
| **Portabilidade** | ❌ Claude Code-only | ✅ Qualquer IDE |
| **Separação Contextos** | ⚠️ Misturado | ✅ Clara (.onion/contexts/) |
| **Gestão de Contexto** | ⚠️ Implícita | ✅ Explícita (sessions/) |
| **Meta-comandos** | ⚠️ Dispersos | ✅ Organizados (core/commands/meta/) |
| **Ciclo Completo** | ❌ Não visível | ✅ Arquitetura reflete 5 camadas |

---

## 🎯 SISTEMA DE NÍVEIS (Starter/Intermediate/Advanced)

### Problema: "E os comandos que ficam de fora?"

**Solução**: Sistema de níveis progressivos com descoberta natural.

### Níveis Propostos

```bash
# ═══════════════════════════════════════════════════════════════
# STARTER (5 comandos essenciais - 80% dos casos)
# ═══════════════════════════════════════════════════════════════

# Business Starter Kit
/business/spec       # Criar especificação
/business/refine     # Refinar especificação
/business/estimate   # Estimar story points
/business/task       # Criar task
/business/help       # Ajuda do contexto

# Technical Starter Kit
/technical/plan      # Planejar implementação
/technical/work      # Desenvolver
/technical/pr        # Criar PR
/technical/sync      # Git sync
/technical/help      # Ajuda do contexto

# Customer Success Starter Kit
/customer-success/ticket    # Criar ticket
/customer-success/guide     # Criar guia
/customer-success/onboard   # Onboard cliente
/customer-success/report    # Gerar relatório
/customer-success/help      # Ajuda do contexto

# ═══════════════════════════════════════════════════════════════
# INTERMEDIATE (10-15 comandos adicionais - 15% dos casos)
# ═══════════════════════════════════════════════════════════════

# Business Intermediate
/business/collect          # Coletar requisitos
/business/light-arch       # Arquitetura leve
/business/extract-meeting  # Extrair reunião
/business/consolidate      # Consolidar documentos
/business/convert-to-tasks # Converter em tasks
...

# Technical Intermediate
/technical/validate-estimate  # Validar estimativa técnica
/technical/review            # Code review
/technical/test              # Executar testes
/technical/deploy            # Deploy
...

# ═══════════════════════════════════════════════════════════════
# ADVANCED (todos os comandos - 5% dos casos)
# ═══════════════════════════════════════════════════════════════

# Business Advanced
/business/whisper              # Transcrição áudio
/business/create-agent         # Criar agente business
/business/create-knowledge-base # Criar KB business
/business/create-abstraction   # Criar abstraction business
...

# Technical Advanced
/technical/create-architecture-decision # Criar ADR
/technical/generate-docs               # Gerar documentação
/technical/analyze-performance         # Análise performance
...
```

### Como Descobrir Comandos

```bash
# ═══════════════════════════════════════════════════════════════
# Comando Help Inteligente
# ═══════════════════════════════════════════════════════════════

/business/help

# Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 BUSINESS CONTEXT - COMANDOS DISPONÍVEIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟢 STARTER (5 comandos essenciais - cobre 80% dos casos):
∟ /business/spec        - Criar especificação de feature
∟ /business/refine      - Refinar especificação existente
∟ /business/estimate    - Estimar story points
∟ /business/task        - Criar task no ClickUp
∟ /business/help        - Mostrar esta ajuda

💡 Use STARTER para começar. Quando precisar de mais:

🟡 INTERMEDIATE (10 comandos adicionais):
∟ /business/collect     - Coletar requisitos estruturados
∟ /business/light-arch  - Arquitetura leve pré-implementação
∟ /business/extract-meeting - Extrair conhecimento de reuniões
... [ver todos: /business/help --level=intermediate]

🔴 ADVANCED (todos os 25 comandos):
∟ /business/whisper     - Transcrição de áudio
∟ /business/create-*    - Meta-comandos (criar agentes, KBs)
... [ver todos: /business/help --level=advanced]

📊 Estatísticas de Uso (seu histórico):
∟ Você usa 5 comandos STARTER: 85% do tempo
∟ Você usa 3 comandos INTERMEDIATE: 10% do tempo
∟ Você usa 2 comandos ADVANCED: 5% do tempo

🚀 Próximos Passos Sugeridos:
∟ Ainda não usou: /business/light-arch
  → Útil quando feature é complexa e precisa análise prévia
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Descoberta Natural Progressiva

**Princípio**: Comandos são descobertos quando necessários, não upfront.

**Exemplo**:

```bash
# Usuário começa com STARTER
/business/spec "feature-checkout"

# Sistema detecta: feature complexa (muitos requisitos)
# Output inclui sugestão:
💡 Dica: Esta feature parece complexa.
   Considere usar /business/light-arch primeiro
   para análise arquitetural prévia.
   [Este é um comando INTERMEDIATE]

# Usuário descobre comando intermediate organicamente
/business/light-arch "feature-checkout"

# Durante light-arch, sistema detecta: reunião aconteceu
# Output inclui sugestão:
💡 Dica: Houve reunião sobre checkout?
   Use /business/extract-meeting para extrair decisões
   e não perder contexto importante.
   [Este é um comando INTERMEDIATE]
```

**Resultado**: Usuário aprende comandos **progressivamente, no contexto certo**, não todos de uma vez.

---

## 🔧 WHISPER E TRANSCRIÇÃO (Local First)

### Reflexão

> "Não precisa ser Whisper, quanto mais fácil e local melhor"

**Concordo totalmente**. Transcrição deve ser:
1. ✅ **Local first** (privacidade)
2. ✅ **Pluggável** (múltiplas opções)
3. ✅ **Por contexto** (business precisa, technical raramente)

### Proposta: Abstraction de Transcrição

```bash
# Criar abstraction
/meta/create-abstraction transcription-service \
  --providers=whisper-local,whisper-api,assemblyai,deepgram,none
```

**Estrutura gerada**:
```
.onion/core/utils/transcription-service/
├── README.md
├── interface.md         # ITranscriptionService
├── types.md             # TranscriptionInput/Output
├── factory.md           # getTranscriptionService()
├── detector.md          # Detecta provedor via .env
└── adapters/
    ├── whisper-local.md    # OpenAI Whisper (local, CPU/GPU)
    ├── whisper-api.md      # OpenAI Whisper API
    ├── assemblyai.md       # AssemblyAI API
    ├── deepgram.md         # Deepgram API
    └── none.md             # Fallback (sem transcrição)
```

### Configuração por Contexto

```yaml
# .onion/contexts/business/.context-config.yml
integrations:
  transcription:
    provider: whisper-local  # Local para privacidade
    model: medium            # balance speed/accuracy
    language: pt-BR
    
# .onion/contexts/customer-success/.context-config.yml
integrations:
  transcription:
    provider: assemblyai  # API integrada com CRM
    api_key_env: ASSEMBLYAI_API_KEY
    
# .onion/contexts/technical/.context-config.yml
integrations:
  transcription:
    provider: none  # Raramente precisa
```

### Uso nos Comandos

```bash
# Business context - transcrição configurada
/business/extract-meeting audio=reuniao-produto.m4a
# → Usa whisper-local automaticamente
# → Transcreve localmente (privacidade)
# → Extrai decisões de produto

# CS context - transcrição configurada diferente
/customer-success/extract-call audio=call-cliente-x.m4a
# → Usa assemblyai automaticamente
# → Transcreve via API (integração CRM)
# → Extrai action items para ticket

# Technical context - sem transcrição
/technical/extract-meeting audio=reuniao-tech.m4a
# → Detecta: provider = none
# → Avisa: "⚠️ Transcrição não configurada neste contexto"
# → Pede: fornecer transcrição manual ou configurar provider
```

---

## 📊 COMPARAÇÃO FINAL REVISITADA

### Sistema Onion vs "Concorrentes"

| Aspecto | OpenSpec | Kiro | Spec-Kit | go-zero | Sistema Onion |
|---------|----------|------|----------|---------|---------------|
| **Categoria** | SDD Tool | SDD Tool | SDD Tool | Code Gen | **Metodologia Completa** |
| **KB → Agentes → Comandos** | ❌ | ❌ | ❌ | ❌ | ✅ **Único** |
| **Meta-comandos (autogeração)** | ❌ | ❌ | ❌ | ✅ (Go only) | ✅ **Universal** |
| **Multi-Context Orchestration** | ❌ | ❌ | ❌ | ❌ | ✅ **Único** |
| **Gestão de Contexto (Sessions)** | ⚠️ Básico | ❌ | ⚠️ Básico | ❌ | ✅ **Completo** |
| **Story Points Cross-Context** | ❌ | ❌ | ❌ | ❌ | ✅ **Único** |
| **Abstractions Pluggáveis** | ❌ | ❌ | ❌ | ❌ | ✅ **Único** |
| **Sistema de Níveis** | ❌ | ❌ | ❌ | ❌ | ✅ **Unique** |
| **Aprendizado Contínuo** | ❌ | ❌ | ❌ | ❌ | ✅ **Loop fechado** |

**Conclusão**: Não existe concorrente direto porque **não existe nada parecido no mercado**.

---

## 🎯 PRÓXIMAS AÇÕES (Prioridades)

### FASE 1: Documentar o Ciclo Completo (URGENTE)

**Por quê**: Ninguém entende o sistema sem entender o ciclo.

**Ações**:
1. [ ] Criar `docs/knowledge-base/concepts/onion-development-cycle.md`
   - Documentar 5 camadas
   - Exemplos completos de ciclo
   - Fluxos cross-context
   
2. [ ] Atualizar `README.md` com nova visão
   - Não é "ferramenta SDD com muitos comandos"
   - É "metodologia completa de desenvolvimento"
   
3. [ ] Criar `docs/onion/getting-started-by-context.md`
   - Onboarding por contexto (business, technical, CS)
   - Sistema de níveis explicado
   - 15-30 minutos por contexto

**Output esperado**: Qualquer pessoa lendo entende que Onion é **metodologia completa**, não "ferramenta complexa".

---

### FASE 2: Reestruturar Arquitetura (CRÍTICO)

**Por quê**: `.claude/` é vendor lock-in. Estrutura atual não reflete contextos.

**Ações**:
1. [ ] Migrar `.claude/` → `.onion/`
   ```bash
   /meta/migrate-to-onion
   # → Cria estrutura .onion/
   # → Migra comandos, agentes, KBs, rules
   # → Mantém .claude/ como symlink (compatibilidade)
   ```

2. [ ] Criar estrutura de contextos
   ```
   .onion/contexts/
   ├── business/
   ├── technical/
   ├── customer-success/
   └── compliance/
   ```

3. [ ] Implementar `.context-config.yml`
   - Task manager por contexto
   - Abstractions por contexto
   - Comandos starter/intermediate/advanced

4. [ ] Criar `.ide/` para configs IDE-specific
   - Claude Code, Claude, Windsurf configs separados
   - Agnóstico de IDE

**Output esperado**: Estrutura reflete visão multi-context. Portável entre IDEs.

---

### FASE 3: Sistema de Níveis (IMPORTANTE)

**Por quê**: Reduzir onboarding de 4-8 horas para 15-30 minutos.

**Ações**:
1. [ ] Separar comandos por nível
   ```
   .onion/contexts/<context>/commands/
   ├── starter/      # 5 comandos (80%)
   ├── intermediate/ # 10 comandos (15%)
   └── advanced/     # Todos (5%)
   ```

2. [ ] Implementar `/help` inteligente
   - Mostra níveis
   - Estatísticas de uso pessoal
   - Sugestões de comandos próximos

3. [ ] Descoberta progressiva
   - Comandos sugerem outros comandos no contexto certo
   - "💡 Para features complexas, considere /light-arch"

**Output esperado**: Onboarding business context = 30 minutos (5 comandos starter).

---

### FASE 4: Abstractions por Contexto (ESTRATÉGICO)

**Por quê**: TMA é implementação de referência. Outros contextos precisam de outras abstractions.

**Ações**:
1. [ ] Documentar `/meta/create-abstraction` como padrão
   
2. [ ] Criar abstractions essenciais:
   ```bash
   /meta/create-abstraction transcription-service \
     --providers=whisper-local,assemblyai,none
     
   /meta/create-abstraction notification-manager \
     --providers=slack,discord,email,none
     
   /meta/create-abstraction storage-manager \
     --providers=s3,gcs,local,none
     
   /meta/create-abstraction audit-logger \
     --providers=cloudwatch,splunk,local,none
   ```

3. [ ] Configurar por contexto via `.context-config.yml`

**Output esperado**: Cada contexto pode escolher provedores independentemente.

---

### FASE 5: Story Points Cross-Context (INOVADOR)

**Por quê**: Aprendizado contínuo e feedback entre business e technical.

**Ações**:
1. [ ] Implementar ciclo completo:
   - Business estima
   - Technical valida
   - Business reavalia
   - Technical afera (tempo real)
   
2. [ ] Histórico de estimativas
   - Banco de dados de estimativas passadas
   - Machine learning para sugestões
   
3. [ ] Learnings automáticos
   - Extrai patterns de sessions
   - Cria KBs automaticamente

**Output esperado**: Estimativas melhoram ao longo do tempo automaticamente.

---

### FASE 6: CLI Standalone (FUTURO)

**Por quê**: Independência total de IDE.

**Ações**:
1. [ ] Criar package NPM `@onion/cli`
2. [ ] CLI funciona standalone (sem IDE)
3. [ ] IDE integration usa CLI (enhanced experience)

**Output esperado**: 
```bash
npm install -g @onion/cli
onion business spec create feature-auth
onion technical plan feature-auth
```

**Nota**: Esta fase fica para o final, quando tudo estiver funcionando.

---

## ⚠️ AVISOS E CONSIDERAÇÕES

### 1. Simplicidade vs Completude

**Desafio**: Como manter simplicidade com 5 camadas inter-relacionadas?

**Solução**:
- ✅ **Sistema de níveis** (starter oculta complexidade)
- ✅ **Descoberta progressiva** (aprende no contexto certo)
- ✅ **Documentação por contexto** (foco no seu uso case)
- ✅ **Onboarding 15-30 min** (não 4-8 horas)

### 2. Complexidade Justificada

**O sistema TEM complexidade, mas ela é JUSTIFICADA porque**:
- ✅ Resolve problemas reais de colaboração multi-contexto
- ✅ Cada camada tem propósito claro
- ✅ Ciclo completo cria valor único
- ✅ Não existe substituto no mercado

**Não é "complexidade por complexidade" - é "metodologia completa".**

### 3. Onboarding É Crítico

**Se onboarding falhar, sistema falha.**

**Estratégias**:
- ✅ Getting started por contexto (não geral)
- ✅ Starter kit com 5 comandos (80% dos casos)
- ✅ Vídeos/demos por contexto
- ✅ Templates e exemplos reais

### 4. Documentação da Visão

**Esta visão é NOVA**. Emergiu da análise SDD + multi-context.

**Crítico**:
- ✅ Documentar visão ANTES de reestruturar
- ✅ Validar com usuários reais
- ✅ Iterar baseado em feedback

---

## 🚀 CONCLUSÃO

### O Que Descobrimos

1. **Sistema Onion não é ferramenta - é METODOLOGIA COMPLETA**
   - 5 camadas inter-relacionadas
   - Ciclo fechado com aprendizado contínuo
   - Multi-context orchestration único no mercado

2. **"Complexidade extrema" era análise incorreta**
   - Não é complexidade desnecessária
   - É metodologia completa mal estruturada
   - Solução: sistema de níveis + descoberta progressiva

3. **TMA não é over-engineering**
   - É implementação de referência de padrão replicável
   - `/meta/create-abstraction` permite criar outras
   - Cada contexto escolhe seus provedores

4. **Story Points é ciclo cross-context**
   - Business estima → Technical valida → Business reavalia → Technical afera
   - Aprendizado contínuo alimenta futuras estimativas
   - Único sistema que faz isso

5. **Estrutura deve ser agnóstica de IDE**
   - `.onion/` ao invés de `.claude/`
   - Suporte a Claude Code, Claude, Windsurf
   - Portabilidade total

### O Potencial Real

**Sistema Onion pode ser único no mercado se**:
1. ✅ Documentar o ciclo completo claramente
2. ✅ Reestruturar para refletir contextos
3. ✅ Implementar sistema de níveis (onboarding 15-30 min)
4. ✅ Demonstrar workflows cross-context com exemplos reais
5. ✅ Abstractions pluggáveis documentadas

**Não existe concorrente fazendo isso porque não existe nada parecido.**

### Próximo Passo Crítico

**DECISÃO**: Vamos avançar com esta visão?

Se sim, ordem recomendada:
1. **Documentar visão** (FASE 1)
2. **Reestruturar arquitetura** (FASE 2)
3. **Sistema de níveis** (FASE 3)
4. **Abstractions** (FASE 4)
5. **Story Points** (FASE 5)
6. **CLI** (FASE 6 - futuro)

---

**Última atualização**: 2025-12-20  
**Versão**: 1.0.0  
**Mantido por**: Reflexão Completa sobre Ciclo do Onion  
**Status**: Para Discussão

---

## 📚 Documentos Relacionados

- [Análise Crítica Original](./onion-system-critical-analysis-2025.md)
- [Visão Multi-Context Orchestrator](./onion-multi-context-orchestrator-vision.md)
- [Spec-Driven Development Tools 2025](./spec-driven-development-tools-2025.md)
- Sistema Onion Documentation (`docs/onion/`)

---

## 💬 Questões para Discussão

1. **Arquitetura**: Concordas com `.onion/` ao invés de `.claude/`?
2. **Sistema de Níveis**: Faz sentido starter/intermediate/advanced?
3. **Prioridades**: Ordem das fases está correta?
4. **Story Points**: Ciclo cross-context é viável?
5. **Abstractions**: Quais outras abstractions são essenciais?
6. **Onboarding**: 15-30 minutos é realista?
7. **Documentação**: Que exemplos são mais importantes?
8. **CLI Standalone**: Realmente deixar para o final?

**Vamos discutir?** 🧅✨

