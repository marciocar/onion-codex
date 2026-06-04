---
title: Meta-spec — Padrões de Integração do Sistema Onion
date: 2026-06-04
version: 1.0.0
level: L0
status: active
gate-keeper: "@metaspec-gate-keeper"
---

# Meta-spec — Padrões de Integração do Sistema Onion

## Propósito

Define os padrões obrigatórios para integrações com sistemas externos (Task Managers, MCPs, APIs). Usa **Task Manager Abstraction** como referência canônica de design de adapter — toda nova integração deve seguir o mesmo padrão.

Aplica-se ao **Sistema Onion**, não ao projeto-alvo onde o Onion é instalado.

Referências relacionadas:

- [agents.md](./agents.md), [commands.md](./commands.md)
- [architecture.md](./architecture.md), [code-standards.md](./code-standards.md)

Referência técnica: [.agents/skills/task-manager/references/](../../.agents/skills/task-manager/references/).

---

## 1. Task Manager Abstraction como referência canônica

A Task Manager Abstraction é o padrão **SDAAL** (Specification-Driven AI Abstraction Layer) implementado de referência. Vive na skill `task-manager` (`.agents/skills/task-manager/`), com a abstração em `references/`. Estrutura:

```
.agents/skills/task-manager/
├── SKILL.md             # Entrada invocável da skill
└── references/
    ├── factory.md       # Instancia o adapter via TASK_MANAGER_PROVIDER
    ├── interface.md     # Contrato ITaskManager
    ├── types.md         # Tipos e DTOs
    ├── detector.md      # Detecção automática de provider
    └── adapters/
        ├── jira.md      # Adapter Jira (REST v3, ADF)
        ├── clickup.md   # Adapter ClickUp (MCP)
        ├── asana.md     # Adapter Asana (HTML notes)
        └── linear.md    # Adapter Linear (Markdown)
```

Toda nova integração (ex: novo Task Manager, novo serviço de comunicação) deve replicar essa estrutura.

---

## 2. Estrutura obrigatória de adapter

Para cada integração com sistema externo:

```
.agents/skills/<dominio>/references/
├── factory.md           # Roteamento por variável de ambiente
├── interface.md         # Contrato comum (operações independentes de provider)
├── types.md             # Tipos compartilhados
├── detector.md          # Detecção automática (opcional)
└── adapters/
    └── <provider>.md    # Um arquivo por provider suportado
```

### 2.1 Conteúdo de cada arquivo

**factory.md**:

- Lê variável de ambiente do `.env` para decidir provider
- Valida variáveis obrigatórias do provider escolhido
- Retorna instância do adapter ou erro descritivo
- Lida com `none` ou ausência (fallback gracioso)

**interface.md**:

- Lista operações que **todo provider deve suportar**
- Define inputs e outputs em formato neutro
- Não vaza detalhes de provider

**types.md**:

- DTOs comuns
- Enums
- Tipos compartilhados

**detector.md** (opcional):

- Detecção automática quando variável não é declarada explicitamente
- Heurísticas (existência de outras variáveis, presença de arquivos config)

**adapters/<provider>.md**:

- Implementação concreta para o provider
- Lista variáveis específicas necessárias
- Formatação requerida (ADF, Markdown, HTML, Unicode)
- Tratamento de erros específicos do provider
- Limites e cotas conhecidas

---

## 3. Gestão de `.env` e variáveis de ambiente

### 3.1 Convenção de nomes

- Prefixo do domínio em UPPER_SNAKE_CASE: `TASK_MANAGER_PROVIDER`, `JIRA_API_TOKEN`, `CLICKUP_WORKSPACE_ID`
- Sufixo descritivo do que a variável contém (`_TOKEN`, `_HOST`, `_ID`, `_URL`)
- Booleanos como string: `"true"` / `"false"`

### 3.2 Obrigatórias vs opcionais

Cada adapter deve documentar em sua seção:

| Variável | Tipo | Obrigatoriedade | Default | Descrição |
|---|---|---|---|---|
| `JIRA_HOST` | URL | Obrigatória | — | URL base da instância Jira |
| `JIRA_EMAIL` | email | Obrigatória | — | Email do usuário Jira |
| `JIRA_API_TOKEN` | secret | Obrigatória | — | Token gerado em Atlassian |
| `JIRA_PROJECT_KEY` | string | Opcional | — | Filtro default |
| `JIRA_AUTH_TYPE` | enum | Opcional | `basic` | `basic` ou `bearer` |
| `JIRA_API_VERSION` | enum | Opcional | `3` | `2` (Server/DC) ou `3` (Cloud) |

### 3.3 Fallback gracioso

Quando o usuário invoca um comando que requer integração mas a variável obrigatória está ausente:

1. **Não inventar** valor nem assumir provider alternativo
2. Reportar em pt-BR qual variável falta
3. Sugerir skill para configurar: `$meta-setup-integration`
4. Continuar offline quando possível (ex: `@task-specialist` decompõe localmente sem persistir)

Exemplo de mensagem:

```
Não foi possível conectar ao Jira: variável JIRA_API_TOKEN está vazia.
Para configurar, execute: $meta-setup-integration
Para operar offline, defina TASK_MANAGER_PROVIDER=none no .env.
```

### 3.4 `.env.example` versionado

- `.env.example` no root deve conter **todas** as variáveis documentadas com valor placeholder
- Comentários explicando obrigatoriedade e formato
- `.env` no `.gitignore` sempre

---

## 4. MCPs (Model Context Protocol) suportados

### 4.1 MCP servers definidos em `config.toml`, declarados em subagentes

Os MCP servers são definidos centralmente em `.codex/config.toml`:

```toml
[mcp_servers.clickup]
command = "npx"
args = ["-y", "@clickup/mcp-server"]
env = { CLICKUP_API_TOKEN = "${CLICKUP_API_TOKEN}" }
```

E o subagente que depende de um MCP o declara no campo `mcp_servers` (TOML):

```toml
[mcp_servers.clickup]
command = "npx"
args = ["-y", "@clickup/mcp-server"]
```

### 4.2 MCPs comuns no framework atual

| MCP server | Provedor | Usado por |
|---|---|---|
| `clickup` | ClickUp MCP | `@clickup-specialist`, skills `$product-*` quando provider é ClickUp |
| `asana` | Hosted/managed | Provider Asana |
| `linear` | Hosted/managed | Provider Linear |
| `atlassian` | Hosted/managed | Provider Jira |
| `slack` | Hosted/managed | Notificações (opcional) |
| `notion` | Hosted/managed | Documentação externa (opcional) |

### 4.3 Configuração

- **MCP servers** (stdio e hosted) são declarados em `[mcp_servers.*]` no
  `.codex/config.toml`. O framework versiona um template — o projeto-alvo ajusta
  ao provider ativo.
- **NUNCA** colar tokens no `config.toml`: usar interpolação `${VAR}` resolvida do
  `.env`/ambiente.
- Subagentes habilitam os servers de que precisam via `mcp_servers` no próprio TOML
  (escopo mínimo).
- `$meta-setup-integration` guia a configuração de `.env` + `[mcp_servers.*]` quando
  aplicável.

---

## 5. Formatação por provider

Cada provider tem formato preferido para descrições, comentários e payloads. **Adapter é responsável por traduzir** dados internos para formato do provider.

| Provider | Descrições de task | Comments | Estrutura |
|---|---|---|---|
| Jira Cloud (v3) | ADF (Atlassian Document Format) — JSON estruturado | ADF | Bulk via `/issue/bulk` |
| Jira Server/DC (v2) | Wiki markup ou plain text (string) | Wiki markup | Search via `/search` (paginated) |
| ClickUp | Markdown nativo em `markdown_description` | Unicode visual em `commentText` (`━━━`, `∟`, `▶`, `◆`, `✅`) | API REST + MCP |
| Asana | HTML notes (subset) ou plain text | HTML | API REST |
| Linear | Markdown nativo (suporte rico) | Markdown | API GraphQL |

### 5.1 Templates por provider

Templates de formatação para cada provider devem viver em:

```
.agents/skills/<dominio>/references/adapters/<provider>.md
.agents/skills/<dominio>/references/templates/<provider>-<tipo>.md   # quando aplicável
```

Para ClickUp especificamente, existe documento de referência: `.agents/skills/task-manager/references/clickup-formatting.md`.

---

## 6. Bulk operations e performance

### 6.1 Bulk-first

Quando operar em lote (>5 itens), preferir operação bulk do provider:

- Jira: `POST /rest/api/3/issue/bulk` (até 50/req)
- ClickUp: endpoints bulk quando disponíveis
- Evitar loops N+1 em criação/update

### 6.2 Field selection

Ao buscar itens, declarar apenas campos necessários para reduzir payload:

- Jira: `fields=summary,status,assignee`
- Linear: query GraphQL com seleção explícita

### 6.3 Paginação

- Implementar paginação consistente
- Jira Cloud v3: usar `nextPageToken` (o antigo `/search` foi removido em maio/2025)
- ClickUp: usar `page` parameter
- Não iterar todas as páginas quando não necessário

---

## 7. Tratamento de erros

### 7.1 Categorias

| Erro | Resposta esperada do adapter |
|---|---|
| Variável de ambiente ausente | Fallback gracioso (Seção 3.3) |
| Token inválido / expirado | Mensagem clara em pt-BR + sugestão de regeneração |
| Rate limit | Retry com backoff exponencial, máximo 3 tentativas |
| Recurso não encontrado | Reportar ID + provider + sugestão de verificação |
| Erro de validação do provider | Reportar mensagem original do provider + tradução pt-BR |
| Erro de rede transitório | Retry com backoff |
| Erro inesperado | Logar e reportar, não silenciar |

### 7.2 Não silenciar

- Adapter nunca deve "engolir" erro sem reportar
- Skills chamadoras devem propagar erro ao usuário com contexto

---

## 8. Adicionar novo adapter — checklist

Ao adicionar suporte a novo provider:

1. Criar `.agents/skills/<dominio>/references/adapters/<provider>.md` seguindo estrutura de Seção 2.1
2. Atualizar `factory.md` para reconhecer o novo provider
3. Atualizar `detector.md` se houver detecção automática
4. Documentar variáveis de ambiente em `.env.example`
5. Atualizar AGENTS.md com tabela "Provider → Variáveis → Subagente → Adapter"
6. Criar especialista em `.codex/agents/<provider>-specialist.toml` (opcional, mas recomendado)
7. Adicionar a esta meta-spec (Seções 4.2 e 5)
8. Validar com `@metaspec-gate-keeper`

---

## 9. Proibições explícitas

- **Proibido** integração que requer credencial fora de `.env`
- **Proibido** invocar API externa diretamente em skill sem passar pelo adapter
- **Proibido** adapter que vaza tipos específicos do provider para o nível de interface
- **Proibido** assumir provider sem ler `.env` primeiro

---

## 10. Versionamento e mudanças

Mudanças nesta spec exigem:

1. PR específico para `docs/meta-specs/integrations.md`
2. Atualização do campo `version`
3. Migração de adapters existentes quando aplicável
4. Validação por `@metaspec-gate-keeper`
