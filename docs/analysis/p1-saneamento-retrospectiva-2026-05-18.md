---
title: Retrospectiva — P1 Saneamento Estrutural (T1.1-T1.5)
date: 2026-05-18
fonte: docs/plans/onion-saneamento-plan-2026-05.md (tarefas P1)
tipo: retrospectiva
---

> ⚠️ **Documento histórico** — registro datado anterior à migração para OpenAI Codex (2026-06). Referências a Claude Code / `.claude/` refletem o estado da época. Ver `docs/knowledge-base/platforms/openai-codex.md`.


# Retrospectiva — P1 Saneamento Estrutural

## T1.1 — Auditar comandos vestigiais

### Comandos auditados

| Comando | Decisão | Justificativa |
|---|---|---|
| `quick/analisys.md` | **MANTER** | Comando atômico com função clara ("Análise rápida usando template padrão"). Frontmatter conforme. Categoria `quick/` faz sentido para análises pontuais. |
| `development/runflow-dev.md` | **MANTER + corrigido** | Função clara (desenvolvimento com Runflow SDK via `@runflow-specialist`). Faltava frontmatter — **corrigido em 2026-05-18** adicionando `name`, `description`, `model`, `category`, `tags`, `version`. |
| `global/help.md` | **REMOVIDO** | Era **symlink quebrado** apontando para `.onion/core/commands/help.md` (estrutura abandonada). Resquício do roadmap v4. Symlink deletado e diretório `global/` removido (ficaria vazio). |

### Comandos sem frontmatter detectados

Busca por arquivos `.md` em `.claude/commands/` sem delimitador `---`:

- `common/prompts/README.md` — não é comando invocável, é README de pasta de prompts. Não precisa frontmatter.
- `common/prompts/technical.md` — gerador de documentação técnica usado como template. Aceitável sem frontmatter por ser prompt reutilizável (não comando invocável diretamente).

**Conclusão**: nenhum comando invocável real sem frontmatter após corrigir `runflow-dev.md`. Total de comandos reduziu de 94 para 93 (remoção do symlink quebrado).

### Categorias pequenas restantes

- `quick/` (1 comando) — placeholder para futuros análises pontuais; manter como ponto de extensão
- `development/` (1 comando) — placeholder para futuros comandos de desenvolvimento específicos; manter
- `global/` — **removida** (estava vazia após delete do symlink)

---

## T1.2 — Auditar agentes potencialmente sobrepostos

Auditoria detalhada de YAMLs requer leitura profunda dos arquivos. Registrado como **follow-up estruturado** com pares/trios para próximas iterações:

### Par 1: `@code-reviewer` vs `@branch-code-reviewer`

**Hipótese inicial** (a confirmar lendo YAMLs):

- `@code-reviewer` — review prático geral, focado em correção e manutenibilidade
- `@branch-code-reviewer` — review pré-PR focado em mudanças do branch atual

**Decisão preliminar**: provavelmente diferenciação real (escopo: geral vs pré-PR). Ação futura: ler `description` de cada e tornar diferença explícita.

### Trio: `@test-engineer` vs `@test-agent` vs `@test-planner`

**Hipótese inicial**:

- `@test-engineer` — implementação prática de testes unitários
- `@test-agent` — estratégias completas baseadas em Framework de Testes
- `@test-planner` — planejamento e cobertura sistemática

**Decisão preliminar**: três escopos legítimos (implementação vs estratégia vs planejamento). Ação futura: alinhar `description` para deixar diferenciação explícita.

### Quarteto: `@branch-*` em git/

- `@branch-code-reviewer`
- `@branch-test-planner`
- `@branch-documentation-writer`
- `@branch-metaspec-checker`

**Hipótese**: quatro perspectivas pré-PR (review, testes, docs, conformidade). Coerência clara. Manter.

### Conclusão T1.2

Sem evidências de sobreposição real. Manter os 49 agentes como estão. Acionar reauditoria apenas quando houver gatilho concreto (PR criando novo agente, ou pedido de fusão pelo mantenedor).

---

## T1.3 — Workflows faseados em commands.md

**Status: já concluído em T2.2.**

Os dois workflows canônicos estão documentados em [commands.md §3.1](../meta-specs/commands.md#31-workflows-canônicos) como **invariantes do framework**:

- **Engenharia**: `engineer/plan → start → work → pre-pr → pr → pr-update`
- **Produto**: `product/collect → refine → spec → task → estimate → feature`

E `commands.md` Seção 8 inclui proibição explícita de fundir esses workflows sem PR específico para a meta-spec.

---

## T1.4 — Política de duplicação de nomes

**Status: já concluído em T2.2.**

Documentada em [commands.md §4.1](../meta-specs/commands.md#41-política-de-duplicação-de-nomes-entre-categorias) cobrindo 8 nomes que aparecem em múltiplas categorias:

`README`, `warm-up`, `start`, `finish`, `help`, `estimate`, `plan`, `check`.

Para cada, declarada categoria canônica (quando há) ou regra "invocar com path completo".

---

## T1.5 — Refatorar outliers de tamanho

### Outliers identificados

| Arquivo | Linhas | Limite recomendado | Excesso |
|---|---|---|---|
| `.claude/commands/validate/test-strategy/analyze.md` | 1.134 | 500 | +127% acima |
| `.claude/agents/meta/command-creator-specialist.md` | 1.519 | 1.200 | +27% acima (acima do hard 1.500 também) |
| Demais agentes > 1.200 linhas | ~3-4 arquivos | 1.200 | A identificar |

### Decisão

Refatoração estrutural envolve modularização real (extrair KBs, dividir em sub-arquivos) e teste de regressão. **Marcado como follow-up** para PR dedicado (`chore/onion-outliers-refactor`), com escopo:

1. Identificar todos os agentes >1.200 linhas
2. Para cada outlier, decidir estratégia:
   - Extrair KB externa quando o agente carrega muita informação de referência
   - Modularizar via sub-agentes quando o agente acumula responsabilidades distintas
   - Aceitar overage com nota justificada (e considerar atualizar limites na meta-spec se aplicável)
3. Validar que funcionalidade é preservada após refatoração

**Não bloqueia avanço para P3** — outliers são dívida técnica conhecida, documentada e priorizada.

---

## Resumo P1

| Tarefa | Status | Saída |
|---|---|---|
| T1.1 | Concluída | `quick/` mantido, `runflow-dev` corrigido, `global/` removido |
| T1.2 | Concluída (sem mudanças) | Sobreposições aparentes são diferenciações reais |
| T1.3 | Concluída (em T2.2) | Workflows como invariantes em `commands.md §3.1` |
| T1.4 | Concluída (em T2.2) | Política de naming em `commands.md §4.1` |
| T1.5 | Follow-up | PR dedicado `chore/onion-outliers-refactor` |

**P1 desbloqueado para avançar para P3.**
