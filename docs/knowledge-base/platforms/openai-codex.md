# OpenAI Codex — Knowledge Base

---

## 📋 Metadata

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.0 |
| **Data de Criação** | 2026-06-04 |
| **Última Atualização** | 2026-06-04 |
| **Categoria** | platforms |
| **Fontes Principais** | [1] https://developers.openai.com/codex · [2] https://developers.openai.com/codex/learn/best-practices · [3] https://developers.openai.com/codex/config-advanced |

---

## 📋 Visão Geral

**Codex** é o agente de codificação da OpenAI, integrado ao ChatGPT e posicionado como _"one agent for everywhere you code"_. Disponível nos planos ChatGPT Plus, Pro, Business, Edu e Enterprise, é o equivalente da OpenAI ao Claude Code (Anthropic).

### Capacidades centrais

| Capacidade | Descrição |
|-----------|-----------|
| **Geração de código** | Cria código a partir de descrições em linguagem natural, adaptando-se à estrutura do projeto |
| **Compreensão de codebase** | Lê e explica sistemas complexos/legados; mapeia fluxos de request |
| **Code review** | Identifica bugs, erros de lógica e edge cases |
| **Debug** | Rastreia falhas e sugere correções pontuais |
| **Automação de workflows** | Refactoring, testes, migrações, setup — delegáveis como tarefas autônomas |

### Interfaces disponíveis

| Interface | Plataforma | Como acessar |
|-----------|-----------|-------------|
| **Desktop App** | macOS / Windows | Download direto |
| **IDE Extension** | VS Code, Cursor, Windsurf | Marketplace da IDE |
| **CLI** | macOS / Linux / Windows | `curl` installer, `npm`, Homebrew |
| **Cloud (Web)** | Qualquer browser | chatgpt.com/codex — conecta repositório GitHub |

---

## 🎯 Casos de Uso

### Quando usar Codex

- **Engenharia**: compreender codebase legada, refactoring seguro, migração de stack, escrita de testes
- **Revisão de código**: PR review automatizado com diff view antes de criar pull request
- **Segurança**: scanning de vulnerabilidades (repositório autorizado), remediação com evidência de regressão
- **Front-end**: screenshot → código responsivo; Figma → implementação; prototipagem rápida
- **DevOps**: deploy de web apps com preview ao vivo; automação de triage de bugs
- **Dados**: query em CSVs/planilhas, análise e visualização de datasets
- **Domínios especializados**: life sciences, financial analysis, game development (browser)

### Quando NÃO usar Codex

- Tarefas que exigem acesso a sistemas internos sem MCP configurado
- Edição paralela massiva de código sem supervisão (risco de conflitos em write-heavy workflows)
- Ambientes sem repositório Git (Cloud interface exige GitHub)
- Automações antes de o workflow manual estar estável e validado
- Regiões EEA/UK/Suíça para o recurso Memories (indisponível no lançamento)

---

## ⚡ Quick Start

### CLI (mais flexível)

```bash
# Instalar via npm
npm install -g @openai/codex

# Ou via curl (macOS/Linux)
curl -fsSL https://codex.openai.com/install.sh | sh

# Autenticar e iniciar
codex
# → autenticar com conta ChatGPT ou OpenAI API key

# Primeiras tarefas úteis
codex "Tell me about this project"
codex "Find and fix bugs with minimal, high-confidence changes"
codex "Explain how the transform module works"
```

### IDE Extension

1. Instalar extensão "Codex" no VS Code / Cursor / Windsurf
2. Fazer login com conta ChatGPT
3. Criar checkpoint Git antes de iniciar tarefas (`git commit`)
4. Usar Agent Mode por padrão

### Cloud (chatgpt.com/codex)

1. Conectar repositório GitHub
2. Enviar task em linguagem natural
3. Revisar diff antes de criar PR
4. Criar PR diretamente pela interface

---

## 🔧 Configuração e Uso

### Sistema de configuração em camadas

Precedência (maior → menor):

```
CLI flags / --config
  ↓ Project config (.codex/config.toml)
  ↓ Profile (~/.codex/profile-name.config.toml)
  ↓ User config (~/.codex/config.toml)
  ↓ System config (/etc/codex/config.toml)
  ↓ Built-in defaults
```

### config.toml — opções principais

```toml
# ~/.codex/config.toml

model = "gpt-5.4"                    # Modelo padrão
model_reasoning_effort = "high"      # low | medium | high | xhigh
approval_policy = "untrusted"        # on-request | untrusted | never | granular
sandbox_mode = "workspace-write"     # workspace-write | danger-full-access
web_search = "cached"                # cached | live | disabled
personality = "pragmatic"            # friendly | pragmatic | none

[features]
memories = true                      # Memória persistente entre sessões
multi_agent = true                   # Habilitar subagentes

[agents]
max_threads = 6                      # Threads concorrentes de subagentes
max_depth = 1                        # Profundidade de aninhamento (0 = root)

[shell_environment_policy]
inherit = "core"                     # Filtra vars AWS_*, AZURE_*, KEY, SECRET, TOKEN
```

### AGENTS.md — instruções persistentes de projeto

Equivalente ao `CLAUDE.md` do Claude Code. Localizado na raiz do repositório:

```markdown
# AGENTS.md

## Estrutura do projeto
- /src — código-fonte principal
- /tests — testes unitários com pytest

## Comandos de build
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Convenções
- TypeScript strict mode obrigatório
- Commits em inglês, comentários em pt-BR
- Não usar `any` sem justificativa
```

**Hierarquia de precedência**: arquivos mais próximos do diretório de trabalho têm prioridade.  
**Auto-update**: pode ser atualizado via tag `@codex` em pull requests.

### Rules — controle de permissões de shell

Arquivo: `~/.codex/rules/default.rules` (sintaxe Starlark)

```python
# Permite git read-only
prefix_rule(pattern=["git", ["log", "diff", "status", "show"]], decision="allow")

# Bloqueia força bruta
prefix_rule(pattern=["git", "push", "--force"], decision="forbidden",
            justification="Force push proibido sem revisão")

# Solicita aprovação para npm scripts
prefix_rule(pattern=["npm", "run"], decision="prompt")
```

**Hierarquia de decisão**: `forbidden` > `prompt` > `allow`  
**Validar**: `codex execpolicy check <comando>`

---

## 💡 Best Practices

### Estrutura de prompts (framework GCCD)

| Elemento | Descrição | Exemplo |
|---------|-----------|---------|
| **Goal** | O que construir/mudar | "Add `--json` flag to CLI" |
| **Context** | Arquivos, docs, exemplos relevantes | "See src/cli.ts line 42" |
| **Constraints** | Padrões, arquitetura, restrições | "Strict TypeScript, no `any`" |
| **Done-when** | Critério verificável de conclusão | "All tests pass, lint clean" |

### Configuração e governança

- **Iniciar com permissões restritivas** — afrouxar sandbox apenas em repos confiáveis
- **Incluir comandos de validação no AGENTS.md** — build, test, lint — para que o Codex saiba verificar seu próprio trabalho
- **Um thread por unidade coerente de trabalho** — não um thread por projeto
- **Converter workflows repetíveis em Skills** — evita reescrita de instruções complexas
- **MCPs para contexto externo** — Figma, Linear, GitHub — em vez de copiar/colar manualmente

### Raciocínio e modelos

| Nível | Quando usar | Modelo sugerido |
|-------|------------|-----------------|
| `low` | Tarefas rápidas, simples | `gpt-5.4-mini` |
| `medium` | Trabalho balanceado (padrão) | `gpt-5.4` |
| `high` | Raciocínio lógico complexo | `gpt-5.4` |
| `xhigh` | Projetos agentic pesados | `gpt-5.5` |

---

## 🧠 Conceitos-chave

### Skills

Workflows reutilizáveis em formato `SKILL.md`. Equivalente às Skills do Claude Code (`.claude/skills/`):

```
.agents/skills/
  my-skill/
    SKILL.md          # frontmatter + instruções (obrigatório)
    scripts/          # scripts executáveis (opcional)
    references/       # documentação de apoio (opcional)
    assets/           # templates (opcional)
    agents/openai.yaml # configuração de UI e dependências (opcional)
```

```markdown
---
name: pr-review
description: Performs PR review checking for regressions and edge cases
---

1. Fetch the diff with `git diff main...HEAD`
2. Identify changed files and their responsibilities
3. Check for missing tests on new logic
4. Report findings as inline comments
```

**Escopo de descoberta**: repo-local → repo-root → user (`$HOME/.agents/skills`) → sistema

### Memories

Persistência de contexto entre threads. **Desabilitado por padrão.**

```toml
[features]
memories = true

[memories]
generate_memories = true    # Novos threads viram input de memória
use_memories = true         # Memórias existentes injetadas em sessões futuras
disable_on_external_context = true  # Desativa para threads com MCP/web
```

- Armazenamento: `~/.codex/memories/` (arquivos Markdown não criptografados)
- Secrets são redatados automaticamente; revisar antes de compartilhar `~/.codex`
- Comando `/memories` controla comportamento por thread

### Chronicle (preview)

Augmenta Memories com contexto de tela via screen capture. **Apenas macOS, ChatGPT Pro.**

- Captura screenshots → OCR → gera memórias periodicamente
- Screen captures: `$TMPDIR/chronicle/screen_recording/` (apagados após 6h)
- Memórias geradas: `~/.codex/memories_extensions/chronicle/`

### Subagents

Agentes especializados spawned para execução paralela:

```toml
# .codex/agents/explorer.toml
name = "explorer"
description = "Read-heavy codebase exploration, no writes"
developer_instructions = "Explore and summarize. Never modify files."
model = "gpt-5.4-mini"
model_reasoning_effort = "medium"
sandbox_mode = "workspace-write"
```

**Invocar explicitamente**: `"Spawn two agents to review this code in parallel"`

**Batch processing via CSV** (experimental): `spawn_agents_on_csv` para tarefas massivamente paralelas.

### Sites (preview)

Hosting integrado ao Codex para web apps/jogos. **Business e Enterprise.**

- Output: Cloudflare Worker-compatible ES module
- Storage: D1 (SQL) + R2 (objects)
- Configuração: `.openai/hosting.json`
- Secrets: configurados no painel Sites — **nunca no código-fonte**
- Fluxo: _Save version_ → revisão → _Deploy_ → URL de produção

### Migração de outros agentes

`Settings → General → Import other agent setup` importa:
- `AGENTS.md` / `settings.json` → AGENTS.md e config
- Slash commands / skills → Skills
- MCP servers → MCP config
- Hooks → Hooks
- Últimas 30 sessões de threads

**Atenção**: revisar permissões de tools e autenticação de MCPs após importar.

---

## ⚠️ Limitações e Gotchas

| Limitação | Detalhe |
|-----------|---------|
| **Write paralelo** | Subagentes editando código em paralelo causam conflitos — preferir read-heavy delegation |
| **Memories indisponível** | EEA, UK e Suíça excluídos no lançamento |
| **Chronicle macOS-only** | Computer Use limitado a macOS |
| **Cloud requer GitHub** | Interface web exige repositório GitHub conectado |
| **max_depth = 1 default** | Subagentes não podem spawnar subagentes por padrão — aumentar eleva latência e tokens |
| **Secrets em memória** | `~/.codex/` não é criptografado — não compartilhar sem revisar |
| **Sites preview** | Requer RBAC habilitado por admin Enterprise; apenas Cloudflare Workers |
| **Automação prematura** | Não automatizar workflow antes de validá-lo manualmente — risco de loops defeituosos |
| **Thread bloated** | Um thread por projeto (em vez de por tarefa) degrada o raciocínio do modelo |

---

## 🔗 Integração com o Sistema Onion

O Sistema Onion é conceitualmente análogo ao Codex — ambos são frameworks de orquestração para agentes de codificação. Pontos de correspondência:

| Conceito Codex | Equivalente Onion |
|---------------|-------------------|
| `AGENTS.md` | `CLAUDE.md` |
| `config.toml` | `.claude/settings.json` |
| Skills (`SKILL.md`) | Skills (`.claude/skills/*.md`) |
| Rules (`.rules`) | Permissions em `settings.json` |
| Memories (`~/.codex/memories/`) | Memory (`~/.claude/projects/.../memory/`) |
| Subagents (`.codex/agents/*.toml`) | Agentes especializados (`.claude/agents/`) |
| MCP servers | MCP servers (mesma especificação) |
| Chronicle | [sem equivalente direto] |
| Sites | [sem equivalente — deploy externo] |

**Casos de uso estratégicos para o Onion**:
- Estudo comparativo de arquitetura de frameworks de agentes
- Inspiração para novos recursos (batch CSV processing, Chronicle)
- Referência para documentação de Skills e AGENTS.md em projetos que usam tanto Claude Code quanto Codex
- Avaliação de migração: `/migrate` do Codex usa o mesmo padrão de leitura de CLAUDE.md/settings

**KBs relacionadas**:
- [Runflow](./runflow.md) — outra plataforma de agentes analisada
- [AI Agent Design Patterns](../concepts/ai-agent-design-patterns.md) — padrões que se aplicam a Codex e Claude Code
- [Specification Driven AI Abstraction Layer](../concepts/specification-driven-ai-abstraction-layer.md)

---

## 🔗 Referências

| Fonte | URL |
|-------|-----|
| Documentação oficial (developer) | https://developers.openai.com/codex |
| Best practices | https://developers.openai.com/codex/learn/best-practices |
| Quickstart | https://developers.openai.com/codex/quickstart |
| Use cases | https://developers.openai.com/codex/use-cases |
| Prompting guide | https://developers.openai.com/codex/prompting |
| Customization (AGENTS.md) | https://developers.openai.com/codex/concepts/customization |
| Memories | https://developers.openai.com/codex/memories |
| Chronicle | https://developers.openai.com/codex/memories/chronicle |
| Subagents (conceito) | https://developers.openai.com/codex/concepts/subagents |
| Subagents (configuração) | https://developers.openai.com/codex/subagents |
| Workflows | https://developers.openai.com/codex/workflows |
| Config básico | https://developers.openai.com/codex/config-basic |
| Config avançado | https://developers.openai.com/codex/config-advanced |
| Rules | https://developers.openai.com/codex/rules |
| Skills | https://developers.openai.com/codex/skills |
| Sites | https://developers.openai.com/codex/sites |
| Migration | https://developers.openai.com/codex/migrate |
| Codex for Work | https://openai.com/codex/for-work/ |

---

**Última atualização**: 2026-06-04  
**Fonte principal**: https://developers.openai.com/codex
