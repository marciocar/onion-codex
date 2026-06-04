---
name: meta-metaspec-validate
description: |
  Valida um artefato/decisão contra as metaspecs vigentes, aplicando a
  constituição do @metaspec-gate-keeper. Executa as leituras no fluxo principal
  (confiável) e produz relatório com evidência citada.
---

# 🔍 Validação contra Metaspecs

Aplica a constituição do `@metaspec-gate-keeper` para validar um artefato ou
decisão contra as metaspecs vigentes. **Diferença crítica do modo subagente:**
este comando **executa as leituras você mesmo, no fluxo principal** — descobre as
metaspecs, lê os arquivos e coleta evidência real antes de julgar. Nada de
veredito sem evidência.

## 🎯 Objetivo

Produzir um **veredito de conformidade reproduzível** (✅ / ⚠️ / ❌) com cada
critério ancorado em `meta-spec:linha` + `arquivo:linha`/output de comando.

## 📥 Input

```
$meta-metaspec-validate [modo]: [alvo]
```

**Modos** (genéricos, agnósticos de domínio):

| Modo | Alvo | Régua típica |
|---|---|---|
| `agente` | caminho de `.codex/agents/**` | metaspec de agentes + arquitetura |
| `comando` | caminho de `.agents/skills/**` | metaspec de comandos + arquitetura |
| `artefato` | qualquer arquivo (código, doc, ADR, skill, adapter) | metaspec de código/integrações/arquitetura conforme o tipo |
| `decisão` | descrição textual de uma decisão proposta | princípios + limites de escopo |
| `escopo` | descrição de funcionalidade/mudança | limites de escopo (incluído/excluído/condicional) |

> Se `[modo]`/`[alvo]` não vierem, peça ao usuário o que validar antes de prosseguir.

## ⚡ Fluxo de Execução (no fluxo principal — execute de fato)

### Passo 0 — Detectar contexto (L0 vs L1+)
- Alvo em `.codex/**` → **Modo Framework (L0)**: régua = metaspecs do Onion.
- Alvo de domínio/feature/ADR/código do projeto → **Modo Projeto-alvo (L1+)**:
  régua = metaspecs daquele projeto.

### Passo 1 — Descobrir as metaspecs (NÃO assumir nomes)
```bash
ls docs/meta-specs/*.md 2>/dev/null || true
# fallback: procurar convenções alternativas
[ -d .codex/rules ] && ls .codex/rules/*.md 2>/dev/null || true
```
- Use `Glob`/`Read` para listar e **classificar** cada metaspec por título/conteúdo.
- **Se nenhuma metaspec for encontrada → avise o usuário e PARE** (não há régua).
- Liste explicitamente quais metaspecs serão usadas como régua.

### Passo 2 — Ler régua + alvo (obrigatório)
- `Read` nas metaspecs relevantes ao tipo de artefato.
- `Read` no arquivo-alvo inteiro (ou use o texto da decisão/escopo, se for o caso).

### Passo 3 — Coletar evidência concreta
```bash
wc -l <alvo>                                   # tamanho vs limites
grep -nE '^(name|description|tools|model):' <alvo>      # frontmatter de agente
grep -nE '^(name|description):' <alvo>                  # frontmatter de skill
```
- Anote `arquivo:linha` e o output real — nada de números inventados.

### Passo 4 — Julgar e sintetizar
- Para cada critério: cite a regra (`meta-spec:linha`) + a evidência
  (`arquivo:linha` ou output) + veredito (✅/⚠️/❌).
- Aplique a hierarquia de severidade do `@metaspec-gate-keeper`:
  **OBRIGATÓRIO** (bloqueia) · **RECOMENDADO** (alerta) · **CONDICIONAL** (sugere).
- Gere o relatório (formato abaixo).

## 📤 Relatório (saída)

```markdown
# 🔍 RELATÓRIO DE VALIDAÇÃO — [modo]: [alvo]

**Modo de contexto**: Framework (L0) | Projeto-alvo (L1+)
**Régua (descoberta)**: [lista de metaspecs usadas]

## ✅ Conformidade
- ✅ [critério] — regra `<meta-spec>:<linha>` · evidência `<arquivo>:<linha>` / `<output>`

## ⚠️ Atenção (RECOMENDADO)
- ⚠️ [critério] — [desvio + recomendação]

## ❌ Violações (OBRIGATÓRIO — bloqueia)
- ❌ [critério] — regra `<meta-spec>:<linha>` · evidência · impacto

## 💡 Recomendações
1. [ação prioritária]

## ✅ Status final
**Veredito**: ✅ APROVADO | ⚠️ REQUER AJUSTES | ❌ NÃO CONFORME
**Critérios**: [X]/[Total] conformes
```

## 🚫 Regras

- **Nunca** emita veredito sem ter executado o Passo 1-3 (descoberta + leituras +
  evidência). Sem metaspecs descobertas → não há validação.
- **Nunca** invente contagens, conteúdo de frontmatter ou caminhos.
- Não altere o artefato — apenas valide e recomende (a menos que o usuário peça).

## 🔗 Relacionados

- `@metaspec-gate-keeper` — a constituição que este comando aplica.
- `@branch-metaspec-checker` — aplica o mesmo padrão ao diff do branch (pré-PR).
- `$engineer-pre-pr` — usa o branch-checker no fluxo de PR.

## 📋 Exemplos

```bash
# Validar um agente do framework (L0)
$meta-metaspec-validate agente: .codex/agents/research-agent.toml

# Validar um comando
$meta-metaspec-validate comando: .agents/skills/product-task/SKILL.md

# Validar uma decisão de escopo
$meta-metaspec-validate escopo: adicionar um segundo provider de Task Manager
```
