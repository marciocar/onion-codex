---
name: meta-all-tools
description: Documentação de todas as ferramentas disponíveis no Codex.
---

# Listagem de Todas as Ferramentas

> **TODO Codex:** reescrever inventário de ferramentas para o toolset do Codex (este documento ainda descreve o toolset legado e precisa ser atualizado para refletir as ferramentas reais disponíveis no Codex).

## 🎯 Objetivo
Documentar todas as ferramentas disponíveis no contexto do Codex organizadas por categoria.

## 📋 Instruções

### 1. Estrutura de Arquivos
Crie arquivos separados por categoria em `.codex/docs/tools/`:
- `mcps.md` - Ferramentas MCP (ClickUp, Postman, etc)
- `agents.md` - Agentes especializados (@product-agent, @clickup-specialist, etc)
- `commands.md` - Skills `.agents/skills/` disponíveis
- `rules.md` - Regras e configurações do workspace
- `[categoria].md` - Outras categorias relevantes

### 2. Formato de Cada Item
```typescript
// Assinatura TypeScript
function nome_ferramenta(parametros): ReturnType
// Propósito: Descrição clara e concisa da ferramenta
```

### 3. Estrutura de Cada Arquivo
- **Índice** no início (links internos)
- **Hierarquia** quando aplicável (sub-categorias, grupos)
- **Lista de marcadores** para cada ferramenta
- **Exemplos práticos** quando relevante

### 4. README Principal
Crie `docs/tools/README.md` com:
- Visão geral da documentação de ferramentas
- Índice de todos os arquivos de categoria
- Guia rápido de uso

## ⚙️ Execução
1. Se `docs/tools/README.md` existir, pergunte: **Substituir** ou **Atualizar**?
2. Analise todas as ferramentas disponíveis no contexto
3. Organize por categoria
4. Gere os arquivos markdown
5. Confirme a criação/atualização
