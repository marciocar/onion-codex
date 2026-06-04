---
title: Plano de Execução — Saneamento do Sistema Onion 2026-05
date: 2026-05-18
status: executado-parcialmente
aprovado-em: 2026-05-18
executado-em: 2026-05-18
fonte: docs/analysis/onion-review-2026-05.md
jira-issue: SACOLA-28
ordem-executada: P0 -> P2 -> P1 -> P3
executado-tambem:
  - T1.5 (refatorar outliers) — concluído em 2026-06-02 (plano de V&V)
  - T3.2 (validar build commands em piloto) — concluído em 2026-06-02 via auto-piloto
  - T3.6 (definir piloto) — resolvido via auto-piloto no onion-claude (cenário legacy)
pendencias:
  - build-compliance-docs — pendente de piloto regulado (gap conhecido)
  - gaps do build-tech-docs (convenção de nomes, ramo sem-build, precedência de evidência) — ver retrospectiva T3.2
referencias-vv:
  - docs/analysis/onion-vv-baseline-2026-06.md
  - docs/analysis/t32-pilot-retrospectiva-2026-06.md
---

> ⚠️ **Documento histórico** — registro datado anterior à migração para OpenAI Codex (2026-06). Referências a Claude Code / `.claude/` refletem o estado da época. Ver `docs/knowledge-base/platforms/openai-codex.md`.


# Plano de Execução — Saneamento do Sistema Onion 2026-05

## Contexto

Este plano converte as **19 recomendações** da [Revisão Analítica do Sistema Onion — Maio/2026](../analysis/onion-review-2026-05.md) em **tarefas executáveis e priorizadas**.

Premissas já decididas:

- `.onion/` foi abandonado em 2026-05-18
- Plano v4.0 (FASES 5-9) foi abandonado em 2026-05-18
- `packages/onion-cli/` será removido — a pasta `packages/` será deletada
- Identidade do Onion: framework template em `.claude/`, instalável em qualquer projeto novo, legado ou regulado
- Plataforma única: Claude Code

## Pré-requisitos

Antes de executar qualquer tarefa deste plano:

- [ ] Análise [onion-review-2026-05.md](../analysis/onion-review-2026-05.md) revisada e aprovada
- [ ] Branch dedicado criado (`chore/onion-saneamento-2026-05`)
- [ ] Backup mental ou commit de baseline para reverter caso necessário

---

## Ordem sugerida de execução

```
P0 -> P2 -> P1 -> P3
```

Justificativa:

- **P0 primeiro** porque limpa visões abandonadas e estabelece identidade — todo trabalho subsequente parte de estado limpo
- **P2 antes de P1** porque criar as meta-specs habilita decisões em P1 (workflow faseado, naming, limites de tamanho)
- **P1 depois de P2** porque saneamento estrutural usa meta-specs como referência normativa
- **P3 por último** porque depende de P0+P2 prontos para que guias operacionais reflitam estado consolidado

---

## P0 — Marcação histórica e identidade (estimativa: 1-2 dias)

Objetivo: parar de sangrar contexto. Tornar o estado atual visível e marcar visões abandonadas como históricas.

### T0.1 — Marcar 3 análises de 2025-12-20 como históricas

**Arquivos a editar**:

- [docs/knowledge-base/frameworks/onion-system-critical-analysis-2025.md](../knowledge-base/frameworks/onion-system-critical-analysis-2025.md)
- [docs/knowledge-base/frameworks/onion-complete-cycle-understanding.md](../knowledge-base/frameworks/onion-complete-cycle-understanding.md)
- [docs/knowledge-base/frameworks/onion-multi-context-orchestrator-vision.md](../knowledge-base/frameworks/onion-multi-context-orchestrator-vision.md)

**Ação**:

1. Adicionar ao frontmatter de cada uma:

```yaml
status: historical
replaced-by: docs/analysis/onion-review-2026-05.md
abandoned-on: 2026-05-18
```

2. Inserir banner em destaque logo após o título (H1):

```markdown
> **AVISO**: Este documento descreve visões estratégicas abandonadas em
> 2026-05-18 (`.onion/`, CLI standalone, multi-IDE). Mantido como registro
> histórico. Para o estado atual do Onion, consultar
> [Revisão Analítica de Maio/2026](../../analysis/onion-review-2026-05.md).
```

**Critério de pronto**:
- Frontmatter atualizado nos 3 arquivos
- Banner visível no topo dos 3 arquivos
- Buscar por "status: historical" retorna 3 hits

### T0.2 — Deletar packages/ e referências a .onion/

**Ação**:

1. Listar conteúdo de `packages/` para confirmar escopo
2. Deletar diretório `packages/` integralmente
3. Buscar referências em arquivos relevantes:
   - `grep -r "\.onion/" --include="*.md" .`
   - `grep -r "onion-cli" --include="*.md" .`
   - `grep -r "packages/" --include="*.md" .`
4. Em cada referência, decidir:
   - Em README/CLAUDE.md/INDEX.md → remover ou converter em prosa histórica
   - Em release notes ou arquivos de implementação → converter em prosa histórica (não apagar)
   - Em KBs já marcadas como históricas (T0.1) → manter no documento histórico

**Critério de pronto**:
- `ls packages/` retorna "No such file or directory"
- Busca por `.onion/contexts/` em README, CLAUDE.md e INDEX.md retorna zero
- Busca por `onion-cli` em README, CLAUDE.md e INDEX.md retorna zero

### T0.3 — Atualizar CLAUDE.md e README.md com identidade atual

**Arquivos**: `CLAUDE.md`, `README.md`

**Ação**: substituir descrições que sugerem produto/workspace por descrições alinhadas:

- Onion = framework template em `.claude/`
- Instalável em qualquer projeto novo, legado ou regulado
- Três dimensões: produto, engenharia, compliance
- Workflows faseados retomáveis
- Plataforma única: Claude Code
- Não é produto npm, não é distribuído publicamente, não tem CLI standalone

**Critério de pronto**:
- Leitura do CLAUDE.md e README.md por terceiro forma o mapa mental correto
- Sem menção a `.onion/`, CLI standalone, multi-IDE como direção atual

---

## P2 — Meta-specs completas (estimativa: 3-5 dias)

Objetivo: habilitar `@metaspec-gate-keeper` com base normativa real.

Importante: meta-specs são do Onion, não do projeto-alvo. Cada uma define padrões internos do framework.

### T2.1 — Criar agents.md

**Arquivo**: `docs/meta-specs/agents.md`

**Conteúdo mínimo**:

- Estrutura YAML obrigatória (`name`, `description`, `tools`, opcional `model`)
- Categorias válidas: development, product, compliance, meta, git, testing, review, research, deployment
- Convenção de naming: kebab-case
- Limites de tamanho: recomendado 1.200 linhas, hard 1.500
- Padrões de delegação: quando criar especialista vs estender `@task-specialist`
- Integração com MCPs: como declarar tool MCP

**Critério de pronto**:
- Documento existe com as 6 seções acima preenchidas
- Tem ao menos 3 exemplos concretos (agente bom, agente quase-conforme, agente não-conforme)

### T2.2 — Criar commands.md

**Arquivo**: `docs/meta-specs/commands.md`

**Conteúdo mínimo**:

- Estrutura obrigatória (frontmatter, descrição, etapas, exemplos)
- Categorias válidas
- **Workflows faseados como conceito documentado** com os dois casos canônicos (engineer e product) explícitos
- Convenção de naming + política de duplicação entre categorias
- Limites de tamanho: recomendado 500 linhas, hard 800
- Modularização

**Critério de pronto**:
- Documento existe com as 6 seções acima preenchidas
- Workflows faseados de `engineer/` e `product/` listados como invariantes do framework

### T2.3 — Criar architecture.md

**Arquivo**: `docs/meta-specs/architecture.md`

**Conteúdo mínimo**:

- Estrutura obrigatória de `.claude/` e `docs/`
- Separação `.claude/` (operacional) vs `docs/` (documentação)
- Princípio de framework instalável (sem path absoluto, sem assunção sobre projeto-alvo)
- Dependências permitidas/proibidas entre categorias
- Plataforma: Claude Code

**Critério de pronto**:
- Documento existe
- Inclui diagrama (Mermaid ou ASCII) das dependências permitidas

### T2.4 — Criar code-standards.md

**Arquivo**: `docs/meta-specs/code-standards.md`

**Conteúdo mínimo**:

- pt-BR em docs, comentários, UX
- Inglês em código, vars, commits, branches, logs
- Formatação Markdown padrão
- Padrões de teste (quando aplicável ao framework)

**Critério de pronto**:
- Documento existe
- Referenciado por CLAUDE.md como fonte canônica

### T2.5 — Criar integrations.md

**Arquivo**: `docs/meta-specs/integrations.md`

**Conteúdo mínimo**:

- Task Manager Abstraction como referência canônica de adapter
- Estrutura obrigatória de adapter
- Gestão de `.env` (obrigatórias vs opcionais, fallback)
- MCPs suportados
- Formatação por provider (ADF Jira v3, Markdown ClickUp descriptions, Unicode ClickUp comments)

**Critério de pronto**:
- Documento existe
- Mapeia 4 providers atuais (Jira, ClickUp, Asana, Linear)

### T2.6 — Validar com @metaspec-gate-keeper em PR experimental

**Ação**:

1. Criar branch `experiment/metaspec-validation`
2. Fazer alteração trivial em um agente (ex: ajustar descrição de um agente bem-formado)
3. Abrir PR e invocar `@metaspec-gate-keeper`
4. Confirmar que o agente carrega as 5 meta-specs e detecta conformidade
5. Repetir com PR contendo violação intencional (agente com YAML mal-formado, comando sem header)
6. Confirmar que o agente detecta e reporta a violação

**Critério de pronto**:
- 1 PR conforme aprovado pelo agente
- 1 PR não-conforme rejeitado pelo agente com explicação clara
- Documento de retrospectiva opcional registrando o que faltou nas meta-specs (input para iteração)

---

## P1 — Saneamento estrutural cuidadoso (estimativa: 3-5 dias)

Objetivo: remover dívida estrutural sem destruir workflows faseados.

Princípio: workflows faseados são valor. Antes de fundir ou eliminar, validar intenção.

### T1.1 — Auditar comandos vestigiais

**Comandos suspeitos**:

- Categorias com 1 elemento: `quick/analisys`, `development/runflow-dev`, `global/*`
- 6 comandos sem header YAML (identificar via grep)

**Ação**: para cada comando, responder:

1. Faz parte de workflow faseado ativo? Se sim → manter e documentar em `commands.md`
2. Tem caso de uso defensável em projeto-alvo? Se sim → manter e adicionar exemplo em guia (P3.17)
3. Não atende nenhum dos dois → mover para `.claude/commands/.archive/` ou deletar

**Critério de pronto**:
- Cada comando avaliado tem decisão registrada (commit message)
- Nenhum comando "ativo" sem caso de uso defensável documentado

### T1.2 — Auditar agentes potencialmente sobrepostos

**Pares/trios a investigar**:

- `@code-reviewer` vs `@branch-code-reviewer`
- `@test-engineer` vs `@test-agent` vs `@test-planner`
- Quarteto `@branch-*` em git/

**Ação**: ler YAMLs lado a lado, comparar `description` e `tools`. Decidir:

- Sobreposição real (mesma função, mesmo gatilho) → fundir e marcar redirect
- Diferenciação real → manter ambos e tornar diferença explícita na `description`

**Critério de pronto**:
- 3 decisões registradas (fundir ou manter)
- Caso de manter: descriptions atualizadas para deixar diferença clara

### T1.3 — Documentar workflows faseados em commands.md

Dependência: T2.2 já feita.

**Ação**: adicionar a `commands.md` (ou referenciar em ADR-like dentro de meta-specs):

- **Workflow de Engenharia**: `engineer/plan → start → work → pre-pr → pr → pr-update` — ciclo retomável com sessões persistentes
- **Workflow de Produto**: `product/collect → refine → spec → task → estimate → feature` — ciclo de descoberta a backlog

Tornar invariante: novos workflows similares devem seguir o mesmo padrão (sessões persistentes, retomável, fases nomeadas explicitamente).

**Critério de pronto**:
- `commands.md` referencia os dois workflows como invariantes
- Sem ambiguidade que possa levar a "fusão" futura por engano

### T1.4 — Consolidar política de duplicação de nomes

Dependência: T2.2 já feita.

**Nomes em múltiplas categorias**: `README`, `warm-up`, `start`, `finish`, `help`, `estimate`

**Ação**: para cada nome, decidir e documentar em `commands.md`:

- Opção A: categoria canônica para nome curto (ex: `start` canônico em `engineer/`, demais usam nome explícito como `feature-start`)
- Opção B: manter duplicação documentando contexto de invocação esperado

Decisão pode variar por nome.

**Critério de pronto**:
- `commands.md` tem seção "Naming entre categorias" cobrindo os 6 nomes
- Renomes (se houver) feitos com aliases temporários para não quebrar invocações existentes

### T1.5 — Refatorar outliers de tamanho

Dependência: T2.1 e T2.2 estabelecem limites.

**Outliers conhecidos**:

- `.claude/commands/validate/test-strategy/analyze.md` (1.134 linhas)
- `.claude/agents/meta/command-creator-specialist.md` (1.519 linhas)
- Demais agentes > 1.200 linhas (~3-4 arquivos)

**Ação**: para cada outlier:

- Extrair KBs externas referenciadas
- Modularizar via skills ou sub-comandos
- Manter funcionalidade integral

**Critério de pronto**:
- Cada arquivo refatorado abaixo do limite recomendado
- Funcionalidade preservada (validação manual ou teste simples)

---

## P3 — Documentação operacional (estimativa: 5-7 dias + piloto)

Objetivo: tornar o framework aplicável a projeto-alvo sem necessidade de mantenedor de plantão.

### T3.1 — Validar e completar READMEs dos três contextos

**Arquivos**:

- [docs/business-context/README.md](../business-context/README.md)
- [docs/technical-context/README.md](../technical-context/README.md)
- `docs/compliance-context/README.md` — verificar se existe; criar se necessário

**Conteúdo obrigatório de cada README**:

- Declaração: "este diretório é populado quando o comando `/docs:build-*-docs` correspondente é executado em um projeto de desenvolvimento que tenha instalado o Onion"
- Lista de agentes consumidores
- Link para KB SDAAL
- Link para guia de aplicação correspondente (a ser criado em T3.3)

**Critério de pronto**:
- Os 3 READMEs existem com conteúdo equivalente
- Nenhum operador externo confundiria "vazio por design" com "gap"

### T3.2 — Validar comandos /docs:build-*-docs em projeto externo

Dependência: piloto definido (ver T3.6).

**Ação**: em projeto-alvo piloto, executar:

- `/docs:build-business-docs` — verificar saída em `docs/business-context/` do piloto
- `/docs:build-tech-docs` — verificar saída em `docs/technical-context/` do piloto
- `/docs:build-compliance-docs` — verificar saída em `docs/compliance-context/` do piloto

**Verificações por comando**:

- Invoca os agentes corretos
- Gera estrutura esperada
- Lacunas conhecidas (se houver) registradas como follow-up

**Critério de pronto**:
- Cada comando testado ponta a ponta
- Lacunas documentadas como tarefas adicionais ao plano

### T3.3 — Criar três guias de aplicação

**Arquivos** (em `docs/applying/` ou `docs/onion/`):

- `applying-greenfield.md` — Onion em projeto novo
- `applying-legacy.md` — Onion em projeto legado
- `applying-regulated.md` — Onion em projeto regulado

**Conteúdo de cada guia**:

- Pré-requisitos (Claude Code instalado, providers de Task Manager configurados)
- Passo a passo desde clone/init até primeiro comando útil
- Decisão sobre quais dos três contextos ativar
- Comandos específicos do cenário
- Troubleshooting

**Adicional para `applying-regulated.md`**:

- Matriz de escolha de framework (saúde → SOC2 + ISO 27001; financeiro → ISO 27001; governo → PMBOK + ISO 22301)
- Papel do `@security-information-master` como orquestrador
- Quando ativar `compliance-context/`

**Critério de pronto**:
- 3 guias existentes
- Cada guia testado em projeto real (idealmente o piloto)

### T3.4 — Popular memória IA

**Arquivos a criar** em `/home/marciocar/.claude/projects/-home-marciocar-onion-claude/memory/`:

- `feedback_workflows_faseados.md` — workflows faseados em `product/*` e `engineer/*` são intencionais
- `project_onion_identity.md` — Onion é framework template instalável; `.onion/`, plano v4.0 e `packages/onion-cli/` abandonados em 2026-05-18
- `project_onion_three_dimensions.md` — três dimensões peer do ciclo
- `reference_review_2026_05.md` — análise canônica em `docs/analysis/onion-review-2026-05.md`

**Atualizar** `MEMORY.md` com pointer one-line para cada.

**Critério de pronto**:
- 4 memory files novos existentes
- `MEMORY.md` atualizado

### T3.5 — Atualizar docs/INDEX.md

**Ação**:

- Adicionar entrada para [docs/analysis/onion-review-2026-05.md](../analysis/onion-review-2026-05.md) em "Análises e Planos" → "Análises"
- Adicionar entrada para este plano em "Análises e Planos" → "Planos de Execução"
- Remover ou converter em histórico seções que ainda mencionam `.onion/`, CLI standalone, multi-IDE, FASES 5-9
- Adicionar entradas para os três guias de aplicação (após T3.3)
- Atualizar timestamp do INDEX

**Critério de pronto**:
- INDEX reflete estado atual do framework
- Sem menção a visões abandonadas como direção viva

### T3.6 — Definir projeto-alvo piloto

**Ação não-técnica, mas precede T3.2 e T3.3**.

- Identificar projeto real (novo, legado ou regulado) para piloto de aplicação
- Documentar premissas do piloto (cenário, dimensões a exercitar, providers)
- Comprometer-se com timeline para feedback

**Critério de pronto**:
- Projeto piloto identificado e documentado
- Premissas registradas para validar contra resultado

---

## Dependências entre tarefas

```
T0.1, T0.2, T0.3 (P0)
    |
    v
T2.1 -> T2.2 -> T2.6 (PR validation)
T2.3 -> T2.6
T2.4 -> T2.6
T2.5 -> T2.6
    |
    v
T1.1 (independente)
T1.2 (independente)
T1.3 (precisa de T2.2)
T1.4 (precisa de T2.2)
T1.5 (precisa de T2.1 + T2.2)
    |
    v
T3.6 (definir piloto) --> T3.2, T3.3
T3.1 (independente)
T3.4 (após P0, antes de T3.5)
T3.5 (após P0 + P3.3)
```

## Checkpoints de validação

- **Após P0**: leitura do CLAUDE.md/README.md por terceiro confirma identidade atual
- **Após P2**: `@metaspec-gate-keeper` valida PR experimental conforme + rejeita PR experimental não-conforme
- **Após P1**: zero comandos sem header YAML; zero outliers acima de limite recomendado; workflows faseados invariantes documentados
- **Após P3**: operador externo (não-mantenedor) consegue aplicar o Onion em projeto piloto seguindo os guias

## Riscos da execução

- **Risco**: ao deletar `packages/`, perder configurações ou setups dependentes (mitigação: verificar ausência de referências antes de remover, T0.2)
- **Risco**: meta-specs criadas com escopo excessivo, virando documentação morta (mitigação: limitar tamanho, validar em PR experimental T2.6)
- **Risco**: P1 elimina comando que vira necessário em projeto regulado (mitigação: critério "faz sentido em projeto-alvo", não "uso pessoal")
- **Risco**: P3 sem piloto vira teórico (mitigação: T3.6 antes de T3.2/T3.3)
- **Risco**: pressa pode reintroduzir visões abandonadas em novos documentos (mitigação: meta-specs e memória IA como guardrails)

## Estimativa total

| Bloco | Tarefas | Estimativa |
|---|---|---|
| P0 | T0.1 - T0.3 | 1-2 dias |
| P2 | T2.1 - T2.6 | 3-5 dias |
| P1 | T1.1 - T1.5 | 3-5 dias |
| P3 | T3.1 - T3.6 | 5-7 dias + piloto |
| **Total** | **19 tarefas** | **~2-3 semanas + piloto** |

---

## Aprovação

Este plano está **pendente de aprovação** pelo mantenedor antes da execução.

Aprovação implica:

- Aceitar a ordem sugerida (P0 → P2 → P1 → P3)
- Comprometer-se a definir projeto piloto antes de T3.2/T3.3
- Aceitar os critérios de pronto declarados por tarefa

Após aprovação, atualizar o frontmatter deste documento de `status: pendente-aprovacao` para `status: aprovado` e iniciar execução por T0.1.
