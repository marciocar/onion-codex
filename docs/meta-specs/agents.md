---
title: Meta-spec — Padrões para Subagentes do Sistema Onion
date: 2026-06-04
version: 1.0.0
level: L0
status: active
gate-keeper: "@metaspec-gate-keeper"
---

# Meta-spec — Padrões para Subagentes do Sistema Onion

## Propósito

Define os padrões imutáveis (L0) que **todos os subagentes** em `.codex/agents/` devem seguir. Esta spec é a constituição normativa do `@metaspec-gate-keeper` para validar conformidade em PRs que criam ou modificam subagentes.

Aplica-se ao **Sistema Onion**, não ao projeto-alvo onde o Onion é instalado.

Referências relacionadas:

- [commands.md](./commands.md) — padrões para skills
- [architecture.md](./architecture.md) — estrutura de diretórios e dependências
- [code-standards.md](./code-standards.md) — padrões de código e idioma
- [integrations.md](./integrations.md) — padrões para integrações com sistemas externos

---

## 1. Estrutura TOML obrigatória

Todo subagente em `.codex/agents/<nome>.toml` (arquivos flat, sem subdiretórios de categoria) deve ser um arquivo TOML contendo no mínimo:

```toml
name = "<kebab-case-slug>"
description = "<descrição em uma linha, voltada a quando invocar o subagente>"
developer_instructions = """
<instruções completas do subagente — corpo que antes era o Markdown do agente>
"""
```

### Campos obrigatórios

| Campo | Tipo | Regra |
|---|---|---|
| `name` | string | kebab-case, único entre todos os subagentes, sem prefixo `@` |
| `description` | string | Uma frase descrevendo **quando** invocar; pode incluir "use para X" e "relacionado: @outro-subagente" |
| `developer_instructions` | string (multilinha) | Corpo de instruções do subagente — substitui o Markdown que ficava abaixo do frontmatter YAML |

### Campos opcionais

| Campo | Tipo | Uso |
|---|---|---|
| `model` | string | Override de modelo (`gpt-5.5`, `gpt-5.4`, `gpt-5.4-mini`). Omitir para herdar do parent |
| `model_reasoning_effort` | enum | `high` / `medium` / `low` — derivado da prioridade antiga (alta→high, média→medium, baixa→low) |
| `sandbox_mode` | string | Política de sandbox da execução do subagente |
| `mcp_servers` | lista | MCP servers (definidos em `.codex/config.toml`) que o subagente pode usar |

> **Mapeamento de modelos** (era YAML `model`): `opus → gpt-5.5`, `sonnet → gpt-5.4`, `haiku → gpt-5.4-mini`.

### Mapeamento da convenção antiga (YAML) → TOML

| YAML (Claude Code) | TOML (Codex) |
|---|---|
| `name:` | `name` |
| `description:` | `description` |
| corpo Markdown do agente | `developer_instructions` |
| `tools:` (lista de tools/MCPs) | `mcp_servers` (apenas MCPs; tools nativas são herdadas) |
| `model:` (`opus`/`sonnet`/`haiku`) | `model` (`gpt-5.5`/`gpt-5.4`/`gpt-5.4-mini`) |
| prioridade (alta/média/baixa) | `model_reasoning_effort` (high/medium/low) |
| `color:` | _(sem equivalente — removido)_ |

### Exemplos

**Subagente bem-formado** (extraído de `.codex/agents/product-agent.toml`):

```toml
name = "product-agent"
description = "Especialista em gestão de projetos e produtos AI que coordena iniciativas e especifica funcionalidades. Use para gerenciamento estratégico de produto e coordenação de equipes. Relacionado: @task-specialist, @clickup-specialist."
model = "gpt-5.4"
model_reasoning_effort = "medium"
developer_instructions = """
# Product Agent

## Propósito
...
"""
```

---

## 2. Agrupamentos de domínio válidos

Os subagentes vivem em arquivos **flat** dentro de `.codex/agents/`, mas continuam organizados conceitualmente em **9 agrupamentos de domínio**. A criação de um novo agrupamento exige proposta com justificativa.

| Agrupamento | Função | Exemplos |
|---|---|---|
| development | Especialistas técnicos verticais (linguagem, framework, infra) | `react-developer`, `nodejs-specialist`, `postgres-specialist` |
| product | Discovery, especificação, decomposição, branding, reuniões | `product-agent`, `task-specialist`, `extract-meeting-specialist` |
| compliance | Frameworks regulatórios, segurança, governança | `iso-27001-specialist`, `soc2-specialist`, `pmbok-specialist` |
| meta | Criação, validação e orquestração de artefatos do próprio Onion | `command-creator-specialist`, `agent-creator-specialist`, `metaspec-gate-keeper`, `onion` |
| git | GitFlow, code review, branch-specific tasks | `gitflow-specialist`, `code-reviewer`, `branch-code-reviewer` |
| testing | Estratégia, planejamento e implementação de testes | `test-agent`, `test-engineer`, `test-planner` |
| review | Code review pós-implementação | `code-reviewer` |
| research | Pesquisa multi-fonte, análise semântica | `research-agent` |
| deployment | Containerização, infraestrutura, deploy | `docker-specialist` |

**Regra**: como os arquivos são flat, o agrupamento é semântico (documentado no corpo do subagente e/ou na `description`), não um diretório. O `name` deve refletir o domínio quando útil (sufixos abaixo).

---

## 3. Convenção de naming

- **Slug** (campo `name` + nome do arquivo): kebab-case sem prefixo (`product-agent`, não `@product-agent` nem `Product-Agent`)
- **Filename**: `<slug>.toml` (corresponde ao `name`)
- **Path completo**: `.codex/agents/<slug>.toml` (flat, sem subdiretório de categoria)
- **Invocação**: usuário invoca com `@<slug>` no chat
- Sufixos comuns aceitos: `-specialist`, `-agent`, `-developer`, `-engineer`, `-reviewer`, `-creator`, `-checker`, `-master`

---

## 4. Limites de tamanho

O limite aplica-se ao conteúdo de `developer_instructions`.

| Limite | Linhas | Tratamento |
|---|---|---|
| Recomendado | até 300 | OK |
| Soft warning | 300 – 400 | Considerar modularização (delegar para subagentes, extrair KBs) |
| Hard limit | > 400 | Refatoração obrigatória antes de merge |

Subagentes que excederem o limite devem extrair partes para:

- Knowledge bases em `docs/knowledge-base/`
- Skills em `.agents/skills/` quando o conhecimento é "cérebro" reutilizável
- Outros subagentes especialistas delegáveis

---

## 5. Padrões de delegação

### Quando criar um especialista novo

Justificativa válida exige **pelo menos um** dos critérios:

- Conhecimento técnico específico não coberto pelos subagentes existentes (linguagem, framework, padrão)
- Framework regulatório específico (ISO, SOC2, PMBOK)
- Integração com sistema externo com formatação/protocolo próprio (Jira ADF, ClickUp Unicode)
- Workflow especializado que justifica contexto próprio (review pré-PR de branch, extração de reuniões)

### Quando estender subagente agnóstico em vez de criar especialista

- Decomposição genérica de tarefas → `@task-specialist`
- Análise de produto sem framework específico → `@product-agent`
- Pesquisa multi-fonte → `@research-agent`

### Regra para o campo `description`

A descrição deve indicar **quando** invocar (gatilho), não apenas **o que** faz. Padrão:

```
<Especialização>. Use para <casos de uso>. Relacionado: @subagente1, @subagente2.
```

---

## 6. Integração com MCPs

Quando um subagente depende de MCP (Model Context Protocol), os servidores são definidos centralmente em `.codex/config.toml` (`[mcp_servers.*]`) e o subagente os declara no campo `mcp_servers`:

```toml
mcp_servers = ["clickup", "atlassian"]
```

**Regras**:

- Listar apenas os MCP servers que o subagente realmente usa (não declarar acesso amplo desnecessário)
- Documentar dependências MCP no `developer_instructions`, sob seção "Dependências"
- Os servidores em si (comando, args, env) vivem em `.codex/config.toml`
- Validar configuração via `$meta-setup-integration`

Referência canônica: [integrations.md](./integrations.md).

---

## 7. Estrutura do corpo (`developer_instructions`)

Dentro de `developer_instructions`, recomenda-se estrutura mínima:

```markdown
# <Nome do Subagente>

## Propósito
<O que este subagente faz e por que existe>

## Quando invocar
<Gatilhos concretos, casos de uso>

## Quando NÃO invocar
<Limites do escopo, subagentes alternativos>

## Workflow
<Passo a passo do que o subagente executa quando invocado>

## Dependências
<KBs, MCPs, outros subagentes, skills>

## Exemplos
<Casos práticos com input/output esperados>
```

---

## 8. Exemplos de conformidade

### Exemplo conforme

Arquivo: `.codex/agents/product-agent.toml`

- Campos `name`, `description` orientado a uso, `developer_instructions` completos
- Agrupamento de domínio válido (product)
- Kebab-case
- Descrição inclui "use para" e "relacionado:"
- Tamanho de `developer_instructions` dentro do limite recomendado

**Veredito**: `@metaspec-gate-keeper` deve aprovar.

### Exemplo quase-conforme

Arquivo hipotético: `.codex/agents/react-developer.toml`

- TOML correto
- Agrupamento válido
- Tamanho de `developer_instructions`: 380 linhas (entre soft warning e hard limit)

**Veredito**: aprovação condicional com nota de "considerar modularização". Não bloqueia merge, mas registra dívida técnica.

### Exemplo não-conforme

Arquivo hipotético: `.codex/agents/MyAgent.toml`

- Filename em PascalCase (deveria ser `my-agent.toml`)
- `name` em PascalCase em vez de kebab-case
- Sem campo `developer_instructions`

**Veredito**: `@metaspec-gate-keeper` deve rejeitar com 3 violações listadas.

---

## 9. Versionamento e mudanças

Mudanças nesta spec exigem:

1. PR específico para `docs/meta-specs/agents.md`
2. Atualização do campo `version` no frontmatter
3. Validação por `@metaspec-gate-keeper` de que subagentes existentes ainda passam (ou plano de migração explícito)
4. Atualização desta spec não pode ser feita em PR que toca em subagentes — separação para evitar mudança normativa "no atacado"
