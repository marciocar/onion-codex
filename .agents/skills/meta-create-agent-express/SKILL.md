---
name: meta-create-agent-express
description: Criar agente de forma rápida e simplificada.
---

# Comando Criar Agente

> **Input:** use o texto fornecido pelo usuário ao invocar esta skill.

Você tem a tarefa de criar um novo sub-agente do Codex baseado nos requisitos do usuário. Siga esta abordagem sistemática para construir um agente bem estruturado.

## Requisitos do Usuário
{argumentos do usuário}

## Processo

### 1. Entender o Propósito do Agente
Primeiro, analise o que o usuário quer que este agente faça:
- Qual é a responsabilidade principal do agente?
- Que tarefas ele executará?
- O que torna este agente especializado?

### 2. Definir Configuração do Agente
Com base nos requisitos, determine:
- **Nome**: Crie um identificador em minúsculas, separado por hífens
- **Descrição**: Escreva uma descrição clara e concisa do propósito do agente
- **Ferramentas**: Selecione as ferramentas apropriadas do conjunto disponível

### 3. Seleção de Ferramentas
Liste todas as ferramentas disponíveis e pergunte ao usuário quais o sub-agente deve ter acesso:

Ferramentas disponíveis:
- **Operações de Arquivo**: Read, Write, Edit, MultiEdit, NotebookRead, NotebookEdit
- **Pesquisa e Navegação**: Glob, Grep, LS
- **Execução**: Bash, Task
- **Web**: WebFetch, WebSearch
- **Desenvolvimento**: ExitPlanMode, TodoWrite
- **Ferramentas MCP**: Várias ferramentas com prefixo mcp__ para integrações específicas

Apresente essas ferramentas organizadas por categoria e peça ao usuário para selecionar quais são apropriadas para o propósito do agente. Por padrão, use acesso mínimo às ferramentas por segurança.

### 4. Projetar o Prompt do Sistema (developer_instructions)
Crie um prompt do sistema detalhado que:
- Define claramente o papel e expertise do agente
- Fornece instruções passo a passo para completar suas tarefas
- Inclui qualquer restrição ou diretriz
- Especifica requisitos de formato de saída
- Contém exemplos se úteis

### 5. Criar o Arquivo do Agente
Gere o arquivo `.toml` com os campos do subagent Codex:
```toml
name = "[nome-do-agente]"
description = "[descrição clara do propósito do agente]"
developer_instructions = """
[Prompt do sistema detalhado com instruções claras]
"""
# Opcionais:
# model = "gpt-5.4"               # gpt-5.5 | gpt-5.4 | gpt-5.4-mini
# model_reasoning_effort = "medium"
# sandbox_mode = "workspace-write"
# mcp_servers = []
```
IMPORTANTE: a extensão do arquivo deve ser `.toml`, não `.yaml` nem `.md`.

> **Mapeamento de modelo**: opus → `gpt-5.5`, sonnet → `gpt-5.4`, haiku → `gpt-5.4-mini`.

### 6. Implementação
- Crie o arquivo em `.codex/agents/[name-agent].toml`
- Torne o `developer_instructions` abrangente mas focado

### 7. Confirmar Criação
Após criar o agente, confirme que o arquivo foi criado com sucesso

## Melhores Práticas
- Mantenha agentes focados em uma única responsabilidade
- Escreva instruções claras e acionáveis
- Limite o acesso às ferramentas ao que é necessário
- Inclua exemplos em prompts complexos
- Considere tratamento de erros e casos extremos
- Torne os formatos de saída explícitos

Agora, analise os requisitos e comece a criar o agente seguindo este processo.
