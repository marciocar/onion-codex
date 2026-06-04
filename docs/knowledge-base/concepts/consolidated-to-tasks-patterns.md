---
titulo: Padrões de Transformação de Consolidados em Tasks
categoria: concepts
versao: "1.0.0"
criado: "2026-06-02"
atualizado: "2026-06-02"
tags:
  - knowledge-transformation
  - task-generation
  - consolidated-processing
  - product-workflow
relacionado:
  - /product/transform-consolidated
  - /product/consolidate-meetings
  - /docs/consolidate-documents
  - /product/collect
  - /product/task
---

# Padrões de Transformação de Consolidados em Tasks

Frameworks reutilizáveis para transformar **conhecimento consolidado** (output de
`$product-consolidate-meetings` ou `$docs-consolidate-documents`) em **contexto
estruturado e tasks acionáveis**. Consumido pelo comando `$product-transform-consolidated`.

Preenche o gap entre conhecimento consolidado e tasks acionáveis:

```
Consolidar → [Documento rico] → ❓ Gap → Criar Task        (antes)
Consolidar → Transformar → [Contexto estruturado] → Task   (depois)
```

---

## 🔍 Framework de Extração Acionável (Análise Automática)

Prompt padrão para `@product-agent` extrair, de forma sistemática, todos os
elementos acionáveis do documento consolidado. Sempre executado, independente do modo.

```markdown
@product-agent

Analise o seguinte documento consolidado e extraia TODOS os elementos acionáveis:

**1. Tarefas Identificadas:**
- Lista COMPLETA de tarefas mencionadas
- Owner (ou "TBD"), Deadline (ou "TBD")
- Prioridade sugerida (alta/média/baixa baseada em contexto)
- Dependências identificadas e contexto completo de cada tarefa

**2. Decisões que Requerem Ação:**
- Decisões para implementar (com rationale)
- Decisões para comunicar (com stakeholders)
- Decisões para validar (com critérios)
- Nível de confiança de cada decisão

**3. Gaps e Ambiguidades:**
- Pontos que precisam esclarecimento (com impacto estimado)
- Informações faltantes que bloqueiam progresso (com criticidade)
- Contradições que precisam resolução (com partes envolvidas)
- Sugestão de priorização baseada em impacto

**4. Insights Acionáveis:**
- Oportunidades identificadas (com potencial de valor)
- Melhorias sugeridas (com esforço estimado)
- Próximos passos recomendados (com justificativa)
- Priorização sugerida baseada em valor/esforço

**5. Dependências e Conexões:**
- Mapeamento de dependências entre elementos
- Conexões entre tarefas/decisões/gaps e bloqueadores identificados

**Documento:**
{{conteudo_do_documento_consolidado}}

**Output Esperado:**
Estruture a resposta em YAML para facilitar validação posterior.
```

O resultado é salvo em `.codex/sessions/consolidated-transform/analysis-<timestamp>.yaml`.

---

## 📊 Template de Validação Interativa

Apresentado no modo `interactive` para o usuário validar e refinar a análise.
Cada bloco lista os elementos e fecha com perguntas de validação.

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 ANÁLISE AUTOMÁTICA CONCLUÍDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 Documento: {{nome_arquivo}}   📅 Data: {{data}}
📊 Tipo: {{tipo_consolidacao}}   🔍 Elementos: {{total_elementos}}

━━━ 📋 TAREFAS IDENTIFICADAS ({{total}}) ━━━
{{lista_tarefas_completa_com_detalhes}}
✅ VALIDAR:
1. Quais tarefas criar como tasks? (IDs)   2. Ajustar prioridade?
3. Confirmar/ajustar owners?   4. Confirmar/ajustar deadlines?
5. Validar dependências?   6. Quebrar alguma em subtasks?
Resposta: aprovados [1,3,5]; ajustes {ID:3, prioridade:alta}; quebrar {ID:5,subtasks:[5.1,5.2]}

━━━ ✅ DECISÕES QUE REQUEREM AÇÃO ({{total}}) ━━━
{{lista_decisoes_completa}}
✅ VALIDAR:
1. Quais precisam tasks de implementação? (IDs)
2. Quais só comunicação/documentação?   3. Quais precisam validação?
4. Ajustar nível de confiança?
Resposta: implementar [1,2]; comunicar [3]; validar [4]

━━━ ⚠️ GAPS E AMBIGUIDADES ({{total}}) ━━━
{{lista_gaps_completa}}
✅ VALIDAR:
1. Quais bloqueiam progresso e precisam tasks? (IDs)
2. Quais resolver em refinamento futuro?   3. Quais precisam reunião?
4. Ajustar criticidade?
Resposta: tasks [1,3]; futuro [2,4]; reunião [5]

━━━ 💡 INSIGHTS ACIONÁVEIS ({{total}}) ━━━
{{lista_insights_completa}}
✅ VALIDAR:
1. Quais viram features/tasks? (IDs)   2. Quais são oportunidade estratégica?
3. Ajustar priorização?   4. Quais apenas documentar?
Resposta: tasks [1,2,4]; estratégico [1]; documentar [3]

━━━ 🔗 DEPENDÊNCIAS IDENTIFICADAS ━━━
{{mapeamento_dependencias}}
✅ VALIDAR: confirmar dependências? adicionar não identificadas? ajustar ordem?

━━━ ✅ CONFIRMAÇÃO FINAL ━━━
Será criado: {{total_tasks}} tasks, {{total_decisoes}} decisões,
{{total_gaps}} gaps, {{total_insights}} insights.
Confirma para prosseguir? (sim/não)
```

---

## 🔀 Modos de Processamento

| Modo | Análise (Fase 2) | Validação (Fase 3) | Geração (Fase 5) | Uso |
|------|------------------|--------------------|--------------------|-----|
| `interactive` (padrão) | ✅ | ✅ completa | ✅ | 1ª vez / docs complexos; máximo controle |
| `auto` | ✅ | ⏭️ pulada (heurísticas) | ✅ | Lote / docs simples |
| `tasks-only` | ✅ só tarefas | ✅ só tarefas | ✅ tasks | Rápido e direto |
| `context-only` | ✅ | ✅ | ✅ só contexto | Documentação/referência (sem tasks) |

**Heurísticas do modo `auto`:** todas as tarefas viram tasks; apenas decisões de
implementação, gaps de alta criticidade e insights de alto valor viram tasks.

---

## 📤 Templates de Output

### Contexto Estruturado (`context`)

```markdown
# Contexto para Tasks: {{tema}}
**Gerado em:** {{data}}  **Origem:** {{arquivo}}  **Tipo:** {{tipo}}  **Análise:** {{timestamp}}

## 📋 Tarefas Aprovadas para Criar
{{lista_tarefas_aprovadas}}
## ✅ Decisões para Implementar
{{lista_decisoes_acionaveis}}
## ⚠️ Gaps para Resolver
{{lista_gaps_priorizados}}
## 💡 Insights para Explorar
{{lista_insights_priorizados}}
## 🔗 Dependências Validadas
{{mapeamento_dependencias}}
## 📊 Priorização Final
{{matriz_prioridade}}
```

### Lista de Tasks (`tasks`)

```yaml
tasks_to_create:
  - title: "{{titulo}}"
    description: "{{descricao}}"
    priority: "{{prioridade}}"
    owner: "{{owner}}"
    deadline: "{{deadline}}"
    dependencies: ["{{dep1}}", "{{dep2}}"]
    tags: ["{{tag1}}", "{{tag2}}"]
    source: "{{referencia_consolidado}}"
    context: "{{contexto_completo}}"
```

Para cada tarefa aprovada, gerar invocação de `$product-collect` ou `$product-task`
com título, descrição (contexto completo), prioridade, owner, deadline, dependências,
tags e referência ao documento de origem.

### Comandos Prontos (`tasks`)

```bash
/product/collect "{{task_1}}" --priority=high --owner={{owner}}
/product/task "{{task_2}}" --deadline={{deadline}}
```

### Persistência

Salvar em `.codex/sessions/consolidated-transform/`:
- `analysis-<ts>.yaml` (sempre) · `context-<ts>.md` (se `!= tasks`)
- `tasks-<ts>.yaml` e `commands-<ts>.sh` (se `!= context`)

---

## 💡 Boas Práticas

1. Revisar a consolidação antes de transformar.
2. Usar `interactive` na primeira vez; `auto` apenas em lotes conhecidos.
3. Preservar o contexto original nas tasks criadas (rastreabilidade).
4. Validar dependências antes de criar tasks; priorizar gaps que bloqueiam progresso.
5. Tasks criadas são sincronizadas automaticamente com o Task Manager configurado.
