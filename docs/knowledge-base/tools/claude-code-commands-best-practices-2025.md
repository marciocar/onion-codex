# Codex Commands Best Practices 2025

---

## 📋 Metadata

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.0 |
| **Data de Criação** | 2025-11-24 |
| **Última Atualização** | 2025-11-24 |
| **Categoria** | Tools |
| **Aplicação** | Sistema Onion - Comandos e Agentes |

### Fontes

- [Codex Official Documentation](https://docs.claude.com/en/docs/codex/overview)
- [Codex 1.7 Update - Skywork.ai](https://skywork.ai/blog/cursor-1-7-vibe-coding-workflow-2025/)
- [Codex Best Practices - GitHub](https://github.com/digitalchild/cursor-best-practices)
- [Maximizing Codex Use - Medium](https://extremelysunnyyk.medium.com/)
- [Codex AI Review 2025 - Skywork.ai](https://skywork.ai/blog/cursor-ai-review-2025-agent-refactors-privacy/)

---

## 🎯 Visão Geral

Este documento consolida as melhores práticas para criação e uso de comandos personalizados no Codex em 2025, focando em eficiência, manutenibilidade e integração com sistemas de IA.

---

## 📁 Estrutura de Comandos

### Localização Padrão

```
projeto/
├── .codex/
│   ├── commands/           # Comandos personalizados
│   │   ├── categoria/      # Organização por categoria
│   │   │   └── comando.md  # Arquivo do comando
│   │   └── common/         # Recursos compartilhados
│   │       ├── prompts/    # Prompts reutilizáveis
│   │       └── templates/  # Templates de código
│   ├── agents/             # Agentes especializados
│   ├── rules/              # Regras de comportamento
│   └── sessions/           # Contexto de sessões
```

### Convenções de Nomenclatura

| Elemento | Padrão | Exemplo |
|----------|--------|---------|
| Comando | `kebab-case.md` | `create-task.md` |
| Categoria | `lowercase` | `product/`, `engineer/` |
| Agente | `kebab-case.md` | `code-reviewer.md` |
| Regra | `kebab-case.mdc` | `language-rules.mdc` |

---

## 📝 Anatomia de um Comando

### Estrutura Recomendada

```markdown
# Nome do Comando

Descrição breve do propósito (1-2 linhas).

## 🎯 Objetivo
[Descrição detalhada do que o comando faz]

## 📋 Inputs
[Parâmetros esperados do usuário]

## 🔄 Processo
[Etapas de execução]

## 📤 Outputs
[O que será gerado/retornado]

## ⚠️ Validações
[Regras de validação]

## 💡 Exemplos
[Casos de uso práticos]
```

### Limite de Tamanho

| Classificação | Linhas | Recomendação |
|---------------|--------|--------------|
| **Ideal** | < 300 | ✅ Melhor performance |
| **Aceitável** | 300-500 | ⚠️ Considerar modularização |
| **Problemático** | > 500 | ❌ Deve ser refatorado |

**Motivo**: Comandos longos consomem mais tokens e podem exceder limites de contexto.

---

## 🔧 Funcionalidades do Codex 2025

### 1. Hooks (Beta)

Permitem observar, controlar e estender o loop do Agente.

**Casos de Uso:**
- Auditoria de atividades do Agente
- Bloqueio de comandos arriscados
- Aplicação de lógica personalizada
- Logging de operações

**Exemplo de Hook:**
```yaml
# .codex/hooks/audit-hook.yaml
name: audit-shell-commands
trigger: before_shell_command
action:
  - log: "Comando shell: ${command}"
  - block_if:
      pattern: "rm -rf /"
      message: "Comando perigoso bloqueado"
```

### 2. Deep Links para Prompts

Gera links que abrem prompts diretamente no Codex.

**Benefícios:**
- Reutilização de prompts complexos
- Onboarding de novos membros
- Documentação interativa
- Compartilhamento de workflows

**Formato:**
```
claude://prompt?text=<encoded-prompt>&files=<file-list>
```

### 3. Comandos de Contexto (@Mentions)

| Comando | Descrição | Uso |
|---------|-----------|-----|
| `@Files` | Referencia arquivos específicos | `@arquivo.ts` |
| `@Folders` | Referencia diretórios | `@src/components/` |
| `@Code` | Referencia código selecionado | Seleção automática |
| `@Docs` | Busca em documentação | `@Docs Next.js routing` |
| `@Web` | Busca na web | `@Web latest React patterns` |
| `@Codebase` | Busca semântica no projeto | Contexto amplo |

### 4. MCP (Model Context Protocol) Servers

Fornecem contexto adicional e ferramentas para o modelo.

**Integração:**
```json
{
  "mcpServers": {
    "clickup": {
      "command": "npx",
      "args": ["-y", "@anthropic/clickup-mcp-server"],
      "env": {
        "CLICKUP_API_TOKEN": "${CLICKUP_API_TOKEN}"
      }
    }
  }
}
```

---

## ✨ Boas Práticas de Prompt Engineering

### 1. Especificidade

**❌ Ruim:**
```
Crie um componente
```

**✅ Bom:**
```
Crie um componente React funcional chamado UserCard que:
- Receba props: { name: string, email: string, avatar?: string }
- Use Tailwind CSS para estilização
- Inclua fallback para avatar ausente
- Exporte como default
```

### 2. Princípio MECE (Mutually Exclusive, Collectively Exhaustive)

Divida instruções em partes que não se sobrepõem mas cobrem tudo.

**Exemplo:**
```markdown
## Requisitos do Componente

### Layout (visual)
- Card com bordas arredondadas
- Sombra sutil

### Comportamento (funcional)
- Clicável para expandir detalhes
- Animação de hover

### Dados (props)
- Nome obrigatório
- Email obrigatório
- Avatar opcional
```

### 3. Iteração e Refinamento

Prefira múltiplas interações curtas a uma única longa.

```
Interação 1: "Crie a estrutura base do componente"
Interação 2: "Adicione os estilos Tailwind"
Interação 3: "Implemente a lógica de hover"
Interação 4: "Adicione testes unitários"
```

### 4. Contexto Relevante

Use `@mentions` para fornecer contexto específico:

```
Usando o padrão de @src/components/Button.tsx,
crie um componente similar para Card.
```

---

## 🚀 Patterns de Comandos Eficientes

### Pattern 1: Comando com Delegação

```markdown
# Comando Principal

## Processo
1. Analisar requisitos
2. **Delegar para @agente-especialista** se necessário
3. Validar resultado
4. Retornar output
```

### Pattern 2: Comando com Contexto Externo

```markdown
# Comando com Integração

## Integrações Opcionais
Se disponível, utilize:
- MCP ClickUp para gestão de tasks
- MCP GitHub para PRs

## Fallback
Sem integrações, gere output em formato compatível.
```

### Pattern 3: Comando Modular

```markdown
# Comando Modular

## Prompts Compartilhados
@include common/prompts/validation-rules.md
@include common/prompts/output-formats.md

## Processo
[Lógica específica do comando]
```

### Pattern 4: Comando com Sessão

```markdown
# Comando com Contexto de Sessão

## Verificar Sessão
1. Buscar `.codex/sessions/<feature>/context.md`
2. Carregar contexto existente
3. Atualizar com novas informações

## Auto-Save
Ao finalizar, salvar estado em context.md
```

---

## ⚠️ Anti-Patterns a Evitar

### 1. Comandos Monolíticos

**❌ Problema:** Um comando faz tudo
```markdown
# super-comando.md
[1000+ linhas cobrindo criação, teste, deploy, documentação...]
```

**✅ Solução:** Dividir em comandos menores
```
/criar-componente → /testar-componente → /documentar-componente
```

### 2. Repetição de Instruções

**❌ Problema:** Mesmas regras em múltiplos comandos
```markdown
# comando-a.md
## Regras de Formatação
[50 linhas de regras]

# comando-b.md
## Regras de Formatação
[Mesmas 50 linhas copiadas]
```

**✅ Solução:** Extrair para `common/prompts/`
```markdown
@include common/prompts/formatting-rules.md
```

### 3. Instruções Vagas

**❌ Problema:**
```
Faça o melhor possível com o código
```

**✅ Solução:**
```
Refatore o código para:
- Extrair funções com mais de 20 linhas
- Adicionar tipagem TypeScript
- Documentar funções públicas com JSDoc
```

### 4. Excesso de Condicionais

**❌ Problema:**
```markdown
Se X, faça A.
Se Y e não X, faça B.
Se Z e X mas não Y, faça C.
[...20 condicionais aninhadas...]
```

**✅ Solução:** Criar comandos específicos ou usar tabela de decisão

---

## 📊 Métricas de Qualidade

### Checklist de Comando

- [ ] Objetivo claro em uma linha
- [ ] Inputs bem definidos
- [ ] Processo com etapas numeradas
- [ ] Output esperado documentado
- [ ] Exemplos de uso
- [ ] < 500 linhas
- [ ] Sem repetição de prompts
- [ ] Validações incluídas

### Indicadores de Performance

| Métrica | Meta | Como Medir |
|---------|------|------------|
| Tokens/execução | < 2000 | Observar consumo |
| Tempo resposta | < 30s | Cronometrar |
| Taxa sucesso | > 90% | Registrar falhas |
| Satisfação | > 4/5 | Feedback usuário |

---

## 🔗 Integração com Sistema Onion

### Aplicação Direta

1. **Comandos**: Seguir estrutura e limites definidos
2. **Agentes**: Usar patterns de delegação
3. **Sessions**: Implementar contexto persistente
4. **MCPs**: Integrar como "Integrações Opcionais"

### Template Recomendado para Onion

```markdown
# Nome do Comando

[Descrição breve]

## 🎯 Objetivo
[O que faz]

## 📥 Entrada
[Parâmetros do usuário]

## 🔄 Processo
1. Etapa 1
2. Etapa 2
3. ...

## 📤 Saída
[O que retorna]

## 🔌 Integrações Opcionais
| MCP | Uso |
|-----|-----|
| ClickUp | Gestão de tasks |

## 💡 Exemplos
[Casos de uso]
```

---

## 📚 Recursos Adicionais

- [Codex Documentation](https://docs.claude.com/en/docs/codex/overview)
- [Codex Changelog](https://docs.claude.com/en/release-notes/codex)
- [Community Best Practices](https://github.com/digitalchild/cursor-best-practices)
- [Prompt Engineering Guide](https://www.promptingguide.ai)

---

**Próxima Atualização Planejada**: Janeiro 2026
**Responsável**: Sistema Onion

