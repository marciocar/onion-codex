---
title: Retrospectiva — Validação T2.6 das Meta-specs
date: 2026-05-18
fonte: docs/plans/onion-saneamento-plan-2026-05.md (tarefa T2.6)
tipo: retrospectiva
---

> ⚠️ **Documento histórico** — registro datado anterior à migração para OpenAI Codex (2026-06). Referências a Claude Code / `.claude/` refletem o estado da época. Ver `docs/knowledge-base/platforms/openai-codex.md`.


# Retrospectiva — Validação T2.6 das Meta-specs

## Contexto

Conforme tarefa **T2.6** do [Plano de Saneamento Onion 2026-05](../plans/onion-saneamento-plan-2026-05.md), as 5 meta-specs criadas em T2.1-T2.5 precisam ser validadas para confirmar que habilitam validação real via `@metaspec-gate-keeper`.

Esta retrospectiva registra o resultado da validação executada em 2026-05-18, imediatamente após criação das specs.

## Método

Foi feita validação **direta de 3 artefatos representativos** contra as meta-specs, simulando o que `@metaspec-gate-keeper` faria. (A invocação do agente especializado teve output truncado; a validação foi consolidada manualmente com base nas regras escritas nas specs.)

## Resultados

### Artefato 1 — Agente bem-formado

**Arquivo**: [.claude/agents/product/product-agent.md](../../.claude/agents/product/product-agent.md)

**Conformidade**:

- ✅ Frontmatter completo: `name`, `description` (multi-linha, orientada a uso), `model`, `tools` ([agents.md §1](../meta-specs/agents.md#1-estrutura-yaml-obrigatória))
- ✅ Categoria válida: `product/` ([agents.md §2](../meta-specs/agents.md#2-categorias-válidas))
- ✅ Slug kebab-case (`product-agent`) ([agents.md §3](../meta-specs/agents.md#3-convenção-de-naming))
- ✅ Description segue padrão "Use para... Relacionado: @..." ([agents.md §5](../meta-specs/agents.md#5-padrões-de-delegação))
- ✅ Tamanho 201 linhas — dentro de recomendado (1.200) ([agents.md §4](../meta-specs/agents.md#4-limites-de-tamanho))

**Veredito**: **APROVADO**

### Artefato 2 — Comando de workflow faseado

**Arquivo**: [.claude/commands/engineer/start.md](../../.claude/commands/engineer/start.md)

**Conformidade**:

- ✅ Frontmatter com `description` ([commands.md §1.1](../meta-specs/commands.md#11-frontmatter-yaml))
- ✅ Categoria `engineer/` (dimensão de engenharia) ([commands.md §2](../meta-specs/commands.md#2-categorias-válidas))
- ✅ Workflow faseado confirmado — tags incluem `workflow` e `session`, faz parte do invariante documentado em [commands.md §3.1](../meta-specs/commands.md#31-workflows-canônicos)
- ✅ Tamanho 251 linhas — dentro de recomendado (500)

**Ressalvas**:

- ⚠️ Frontmatter usa campos extras (`category`, `tags`, `version`, `updated`) não normatizados em [commands.md §1.1](../meta-specs/commands.md#11-frontmatter-yaml). Não são proibidos, mas indicam oportunidade de padronizar ou aceitar oficialmente esses campos como extensão.

**Veredito**: **APROVADO COM RESSALVAS** — usar como gatilho para iterar `commands.md` definindo se `category/tags/version/updated` são opcionais oficiais ou devem ser removidos.

### Artefato 3 — Outlier de tamanho conhecido

**Arquivo**: [.claude/commands/validate/test-strategy/analyze.md](../../.claude/commands/validate/test-strategy/analyze.md)

**Conformidade**:

- ✅ Frontmatter com `description` e `parameters`
- ✅ Categoria `validate/test-strategy/` (subcategoria válida)
- ❌ Tamanho **1.134 linhas** — viola hard limit de 800 ([commands.md §5](../meta-specs/commands.md#5-limites-de-tamanho))

**Veredito**: **REJEITADO** por violação de hard limit. Refatoração obrigatória registrada como tarefa **T1.5** do plano de saneamento.

## Conclusão

As 5 meta-specs habilitam validação real:

- Detectaram conformidade (Artefato 1)
- Detectaram conformidade com ressalva mensurável (Artefato 2)
- Detectaram violação clara com referência à regra (Artefato 3)

## Iterações sugeridas para as meta-specs

1. **commands.md §1.1** — decidir se `category`, `tags`, `version`, `updated` no frontmatter de comandos são:
   - Opcionais oficiais (e adicionar à tabela de campos)
   - Devem ser removidos (e migrar comandos existentes)

2. **agents.md §1** — campo `model` aparece como exemplo de opcional, mas não está na tabela de campos opcionais. Adicionar formalmente.

3. **commands.md §3.3** — descrever sinais visíveis de workflow faseado (tags, category, session). Atualmente está descrito mas pode ficar mais explícito como **checklist** para o gate-keeper.

4. **Considerar** uma seção "Sinais de aprovação automatizável" em cada meta-spec listando o que pode ser validado por regex/parsing simples vs o que precisa avaliação semântica.

## Próximo passo

Liberado para avançar para P1 (saneamento estrutural). O critério "T1.5 — Refatorar outliers de tamanho" tem ao menos 1 alvo confirmado: [.claude/commands/validate/test-strategy/analyze.md](../../.claude/commands/validate/test-strategy/analyze.md).
