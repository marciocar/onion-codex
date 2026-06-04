---
title: Meta-spec — Padrões para Skills do Sistema Onion
date: 2026-06-04
version: 1.0.0
level: L0
status: active
gate-keeper: "@metaspec-gate-keeper"
---

# Meta-spec — Padrões para Skills do Sistema Onion

## Propósito

Define os padrões imutáveis (L0) que **todas as skills** em `.agents/skills/` devem seguir. Inclui o conceito **invariante** de workflows faseados retomáveis, mecanismo que distingue o Onion de coleções de skills avulsas.

Aplica-se ao **Sistema Onion**, não ao projeto-alvo onde o Onion é instalado.

Referências relacionadas:

- [agents.md](./agents.md) — padrões para subagentes
- [architecture.md](./architecture.md) — estrutura de diretórios e dependências
- [code-standards.md](./code-standards.md) — padrões de código e idioma
- [integrations.md](./integrations.md) — padrões para integrações

---

## 1. Estrutura obrigatória

Toda skill vive em `.agents/skills/<slug>/SKILL.md` e deve conter:

### 1.1 Frontmatter (apenas `name` + `description`)

```yaml
---
name: <kebab-case-slug — corresponde ao nome da pasta>
description: <descrição em uma linha — orienta quando a skill deve ativar>
---
```

- `name` é obrigatório e deve corresponder ao slug da pasta
- `description` é obrigatório e deve descrever **quando** a skill ativa (gatilhos)
- **Nenhum outro campo** é permitido no frontmatter de uma skill (sem `allowed-tools`, `argument-hint`, `model`, etc.)

### 1.2 Corpo da skill (`SKILL.md`)

Após o frontmatter:

```markdown
# <Título descritivo da skill>

## Objetivo
<O que esta skill entrega>

## Quando usar
<Gatilhos, casos de uso típicos>

## Etapas
<Passo a passo executável>

## Saída esperada
<Artefatos, mudanças, output ao usuário>

## Exemplos
<Invocações reais>
```

Skills curtas (< 50 linhas) podem omitir seções não aplicáveis, mas **devem manter frontmatter + título + propósito**.

### 1.3 Permissões e tools

No Codex, **permissões não vivem no frontmatter da skill**. A política de permissões é centralizada em `.codex/rules/default.rules` (Starlark) e a automação a nível de evento vive em `.codex/hooks.json`.

Diretrizes:

- A skill não declara `allowed-tools`; o escopo de execução é governado por `.codex/rules/default.rules`.
- Para acesso sensível (git, escrita de arquivos, Task Manager), a política Starlark deve permitir explicitamente o necessário, escopado ao mínimo.
- Detecção de provider via `.env` deve ser permitida pela regra de leitura correspondente.
- MCP servers do provider ativo são herdados do subagente delegado (`@clickup-specialist`, etc.) — a skill não precisa enumerá-los.

> Automação a nível de evento (hooks) vive em `.codex/hooks.json`, não no
> frontmatter — ver `architecture.md` e `integrations.md`.

---

## 2. Categorias válidas

As skills são organizadas por **prefixo de domínio** no slug (`<categoria>-<nome>`, invocadas como `$<categoria>-<nome>`). Categorias com asterisco representam **as três dimensões peer do ciclo Onion**.

| Categoria | Função | Volume típico |
|---|---|---|
| `product-*` (*) | Discovery, especificação, decomposição de tarefas, branding, reuniões | 20+ |
| `engineer-*` (*) | Planejamento e implementação faseada de features | 10+ |
| `docs-*` | Geração e validação de documentação (incluindo `$docs-build-compliance-docs` da dimensão compliance) | 10+ |
| `git-*` | GitFlow, feature/release/hotfix, code review | 10+ |
| `meta-*` | Criação de skills/subagentes/KBs, integração | 8+ |
| _shared_ | Templates e prompts compartilhados (em `docs/onion/shared/`, não são skills invocáveis) | 8+ |
| `validate-*` | Validação de testes, QA, workflows colaborativos | 4+ |
| `test-*` | Estratégias de teste (unit, integration, e2e) | 3 |
| `development-*` | Skills de desenvolvimento específicas | 1+ |
| `quick-*` | Análises pontuais rápidas | 1+ |
| (root) | `onion` e `warm-up` — pontos de entrada | 2 |

Variantes de um mesmo subdomínio são expressas no slug (ex: `git-feature-start`, `git-hotfix-start`, `git-release-start`, `validate-test-strategy-analyze`, `validate-qa-points-estimate`).

---

## 3. Workflows faseados — INVARIANTE DO FRAMEWORK

**Princípio**: o Onion implementa workflows faseados como **mecanismo central**. Múltiplas skills cobrindo fases distintas de um mesmo fluxo, com estado retomável persistido em `.codex/sessions/`, são **valor de design**, não duplicação.

### 3.1 Workflows canônicos

Os **dois workflows abaixo são invariantes** do framework. Devem ser preservados intactos como skills separadas. Qualquer proposta de fusão (consolidar fases numa única skill) deve ser rejeitada por `@metaspec-gate-keeper`.

**Workflow de Engenharia** (6 fases):

```
$engineer-plan → $engineer-start → $engineer-work → $engineer-pre-pr → $engineer-pr → $engineer-pr-update
```

- `plan` — analisa requisitos e cria plano estruturado
- `start` — cria sessão de desenvolvimento e analisa tasks
- `work` — retoma sessão e identifica próxima fase
- `pre-pr` — valida padrões e qualidade antes do PR
- `pr` — cria Pull Request com GitFlow e sync
- `pr-update` — atualiza PR existente

**Workflow de Produto** (6 fases):

```
$product-collect → $product-refine → $product-spec → $product-task → $product-estimate → $product-feature
```

- `collect` — coleta ideias de features ou bugs
- `refine` — refina via perguntas de esclarecimento
- `spec` — cria especificação a partir de requisitos
- `task` — decompõe em tasks/subtasks/action items
- `estimate` — aplica framework de story points
- `feature` — cria task no gerenciador configurado

### 3.2 Regras para workflows faseados

1. Cada fase deve ter **input claro** (estado da sessão ou argumentos), **output claro** (próximo estado da sessão) e ser **invocável isoladamente** quando o estado permite
2. Estado entre fases é persistido em `.codex/sessions/<feature>/`
3. Fases nomeadas explicitamente, sem ambiguidade de ordem
4. Novos workflows similares devem seguir o mesmo padrão (sessões persistentes, fases nomeadas, retomável)
5. **Proibido fundir fases** de workflow ativo numa única skill sem justificativa formal aprovada via PR específico para esta meta-spec

### 3.3 Padrão para identificar workflow faseado

Características de uma skill que faz parte de workflow faseado:

- Pertence a categoria que representa dimensão do ciclo (`product-*`, `engineer-*`)
- Lê ou escreve estado em `.codex/sessions/`
- Tem nome que sugere fase explícita (verbo de ação temporal: `start`, `work`, `pre-pr`, `pr-update`)
- Documenta a posição no ciclo no corpo do `SKILL.md`

---

## 4. Convenção de naming

- **Slug** (nome da pasta + campo `name`): kebab-case com prefixo de domínio (`engineer-pre-pr`, `docs-build-tech-docs`)
- **Path completo**: `.agents/skills/<categoria>-<slug>/SKILL.md` (variantes de subdomínio entram no slug: `git-feature-start`)
- **Invocação**: usuário invoca com `$<categoria>-<slug>` ou `$<categoria>-<subdominio>-<slug>`

### 4.1 Política de duplicação de nomes entre categorias

Os nomes abaixo aparecem em múltiplos domínios por razões funcionais legítimas. Como o slug é flat e prefixado, a ambiguidade é resolvida no próprio nome. Esta política torna a regra explícita.

| Nome curto | Skills | Skill canônica | Variantes |
|---|---|---|---|
| `README` | docs de domínio | Não há skill canônica — READMEs viram índices em `docs/onion/shared/` | Cada README descreve seu domínio |
| `warm-up` | `$product-warm-up`, `$engineer-warm-up`, root (`$warm-up`) | root (`$warm-up`) | `$product-warm-up`, `$engineer-warm-up` são especializações contextuais |
| `start` | `$engineer-start`, `$git-feature-start`, `$git-hotfix-start`, `$git-release-start` | `$engineer-start` (sessão de desenvolvimento) | `$git-feature-start`, `$git-hotfix-start`, `$git-release-start` são fluxos GitFlow específicos |
| `finish` | `$git-feature-finish`, `$git-hotfix-finish`, `$git-release-finish` | Específico por subdomínio GitFlow | Sempre invocar com slug completo |
| `help` | `$git-help`, `$docs-help` | Específico por domínio | Ajuda contextual do domínio |
| `estimate` | `$product-estimate`, `$validate-qa-points-estimate` | `$product-estimate` (story points de feature) | `$validate-qa-points-estimate` é QA story points |
| `plan` | `$engineer-plan`, `$product-light-arch` (similar) | `$engineer-plan` (planejamento de implementação) | `$product-light-arch` é design de arquitetura leve |
| `check` | `$product-check`, `$product-task-check` | `$product-check` (verificação contra meta-specs) | `$product-task-check` é verificação de task |

**Regra geral**:

- O prefixo de domínio no slug elimina colisões; cada skill tem `name` único
- Sempre invocar com slug completo (`$<categoria>-<slug>`)
- Renomes para resolver ambiguidade devem manter aliases temporários para não quebrar invocações existentes

---

## 5. Limites de tamanho

| Limite | Linhas | Tratamento |
|---|---|---|
| Recomendado | até 500 | OK |
| Hard limit | ≥ 500 | Refatoração obrigatória antes de merge — toda skill deve ter menos de 500 linhas |

Skills que se aproximarem de 500 linhas devem extrair partes para:

- Templates em `docs/onion/shared/`
- Prompts em `docs/onion/shared/`
- Knowledge bases em `docs/knowledge-base/`
- Skills referenciadas (delegação)

### 5.1 Isenções (não são skills invocáveis)

O limite acima aplica-se a **skills invocáveis** (`$categoria-nome`). São
**isentos** por natureza, seguindo guidance própria:

- **Fragmentos de template** em `docs/onion/shared/` — são
  estruturas de referência (ex.: `business_context_template.md`,
  `technical_context_template.md`), referenciadas por múltiplos subagentes/skills.
  Tamanho é inerente ao template; **não relocar** sem atualizar todas as
  referências.
- **Fragmentos de prompt** em `docs/onion/shared/` — instruções compartilhadas.
- **READMEs de domínio** — são índices; devem ser
  enxutos (apontar para skills/KB), mas não contam como skill.

---

## 6. Modularização

Skills podem reaproveitar:

- **Templates** em `docs/onion/shared/` (estruturas reutilizáveis)
- **Prompts** em `docs/onion/shared/` (instruções compartilhadas)
- **Skill orquestradora** `$onion` (cérebro de orquestração)
- **Subagentes** em `.codex/agents/<slug>.toml` (delegação especializada)

Skill que duplica >50 linhas de outra skill deve refatorar para template ou prompt compartilhado.

---

## 7. Exemplos de conformidade

### Exemplo conforme (workflow faseado)

Arquivo: `.agents/skills/engineer-start/SKILL.md`

- Frontmatter com `name` + `description`
- Pertence ao domínio `engineer-*` (dimensão de engenharia)
- Faz parte do workflow canônico
- Persiste estado em `.codex/sessions/`
- Nome reflete fase explícita

**Veredito**: `@metaspec-gate-keeper` aprova.

### Exemplo conforme (skill atômica)

Arquivo: `.agents/skills/meta-setup-integration/SKILL.md`

- Frontmatter com `name` + `description`
- Pertence ao domínio `meta-*` (categoria válida)
- Não faz parte de workflow faseado — função atômica clara
- Tamanho < 500 linhas

**Veredito**: aprovado.

### Exemplo quase-conforme

Arquivo hipotético: `.agents/skills/validate-test-strategy-analyze/SKILL.md` (620 linhas reais)

- Frontmatter correto
- Categoria válida
- Tamanho acima do hard limit (≥ 500)

**Veredito**: requer refatoração antes de próximo merge tocando este arquivo.

### Exemplo não-conforme

Arquivo hipotético: `.agents/skills/MyCommand/SKILL.md`

- Slug `MyCommand` em PascalCase em vez de kebab-case com prefixo de domínio
- Sem prefixo de domínio válido
- Frontmatter com campos além de `name`/`description` (ou sem frontmatter)

**Veredito**: rejeitado.

---

## 8. Proibições explícitas

- **Proibido** fundir skills de workflow faseado canônico (`$engineer-*` ou `$product-*`) numa única skill sem PR específico para esta meta-spec
- **Proibido** criar categoria (prefixo de domínio) fora da lista válida
- **Proibido** criar skill sem frontmatter ou com campos além de `name`/`description`
- **Proibido** skill com `name` em formato diferente de kebab-case

---

## 9. Versionamento e mudanças

Mudanças nesta spec exigem:

1. PR específico para `docs/meta-specs/commands.md`
2. Atualização do campo `version` no frontmatter
3. Validação por `@metaspec-gate-keeper` em skills existentes
4. Especificamente para mudança em workflows canônicos (Seção 3.1): aprovação registrada em commit message com link para issue de discussão
