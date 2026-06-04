---
name: onion-validation
description: >
  Regras de validação para componentes do Sistema Onion (Codex). Use ao criar, revisar,
  auditar ou debuggar skills e subagentes. Cobre frontmatter de SKILL.md, campos de
  subagente TOML, checklists de qualidade, limites de linhas, detecção de duplicações
  e scoring. Ative ao validar artefatos em `.agents/` ou `.codex/`, mesmo sem o
  usuário mencionar "validação".
---

## Validação de Skills

### Frontmatter obrigatório (SKILL.md)
| Campo | Tipo | Constraint |
|-------|------|------------|
| `name` | string | kebab-case, único, prefixado por categoria |
| `description` | string | imperativa, com cláusula "use quando", < 1024 chars |

> Codex NÃO usa `model`, `category`, `tags`, `version`, `allowed-tools`, `paths`
> ou `includes` em SKILL.md. Se presentes, remover.

### Checklist de qualidade
- [ ] `name` único em kebab-case
- [ ] `description` com verbo imperativo + contexto de uso ("use quando…")
- [ ] < 500 linhas (lifecycle persistente)
- [ ] Sem duplicação de SKILL.md em outras pastas
- [ ] Frontmatter YAML válido (só `name` + `description`)
- [ ] Sem prompts interativos em scripts (agentes não respondem TTY)
- [ ] Conteúdo compartilhado referenciado por path (`docs/onion/shared/`) — não inlinado em excesso

## Validação de Subagentes (TOML)

### Campos obrigatórios (`.codex/agents/<nome>.toml`)
| Campo | Constraint |
|-------|------------|
| `name` | kebab-case, único, não colidir com built-ins (`default`/`worker`/`explorer`) |
| `description` | especialização clara + quando usar |
| `developer_instructions` | corpo de comportamento (multi-line `"""..."""`) |

### Campos opcionais
- `model` (`gpt-5.5`|`gpt-5.4`|`gpt-5.4-mini`)
- `model_reasoning_effort` (`high`|`medium`|`low`|`xhigh`)
- `sandbox_mode` (`workspace-write` se edita arquivos)
- blocos `[mcp_servers.<id>]` quando o subagente definir MCP próprio

### Checklist de qualidade
- [ ] `name` único, não colide com built-ins
- [ ] `description` da especialização clara
- [ ] `developer_instructions` presente e < 300 linhas
- [ ] `model` mapeado corretamente (opus→gpt-5.5, sonnet→gpt-5.4, haiku→gpt-5.4-mini)
- [ ] `sandbox_mode`/`mcp_servers` coerentes com o que o agente faz
- [ ] Sem campos Claude-legados (`tools`, `color`, `priority`, `category`, `expertise`)

## Validações Automatizadas

### Detectar duplicações de nome
```bash
# Skills
grep -rh "^name:" .agents/skills/*/SKILL.md | awk -F: '{print $2}' | sort | uniq -d

# Subagentes
grep -h "^name" .codex/agents/*.toml | awk -F'"' '{print $2}' | sort | uniq -d
```

### Verificar limites de linhas
```bash
# Skills > 500 linhas
find .agents/skills -name "SKILL.md" -exec wc -l {} \; | awk '$1 > 500'

# Subagentes > 300 linhas
find .codex/agents -name "*.toml" -exec wc -l {} \; | awk '$1 > 300'
```

### Verificar frontmatter mínimo de skills
```bash
for field in "name:" "description:"; do
  find .agents/skills -name "SKILL.md" -exec grep -L "^$field" {} \;
done
```

### Detectar subagentes fantasmas referenciados
```bash
# Lista @subagentes referenciados em texto que não existem como arquivos
grep -rho "@[a-z-]\+" .agents/skills docs/ | sort -u | while read ref; do
  name="${ref#@}"
  test -f ".codex/agents/${name}.toml" || echo "FANTASMA: $ref"
done
```

## Score de Qualidade (0-100)

### Skill
| Critério | Pontos |
|----------|--------|
| Frontmatter válido (`name`+`description`) | +25 |
| Description com "use quando" | +20 |
| < 500 linhas | +15 |
| Sem campos Claude-legados | +20 |
| Documentação clara | +20 |

### Subagente
| Critério | Pontos |
|----------|--------|
| Campos obrigatórios presentes | +25 |
| `model` mapeado corretamente | +20 |
| `developer_instructions` < 300 linhas | +15 |
| `sandbox_mode`/`mcp_servers` coerentes | +20 |
| Especialização clara | +20 |

### Thresholds
- **80-100**: ✅ Aprovado
- **60-79**: ⚠️ Precisa melhorias
- **< 60**: ❌ Rejeitado

## Regras de Negócio para Geradores

### Antes de criar skill
1. Verificar se pasta já existe em `.agents/skills/`
2. Confirmar `name` + `description` com "use quando" para auto-trigger
3. Verificar limite de 500 linhas
4. Garantir ausência de campos Claude-legados

### Antes de criar subagente
1. Verificar se nome já existe em `.codex/agents/` e não colide com built-ins
2. Confirmar `developer_instructions` preenchido
3. Mapear `model`/`model_reasoning_effort` corretamente
4. Verificar limite de 300 linhas

## Fallback para falhas de validação

```
Se validação falhar:
1. Informar usuário sobre o problema específico
2. Sugerir correção concreta (não genérica)
3. Perguntar se deseja correção automática
4. Se não, abortar com mensagem clara do que precisa ser corrigido
```

## Integração com .env

### Variáveis críticas
- `TASK_MANAGER_PROVIDER` — obrigatório (`clickup`|`jira`|`asana`|`linear`|`none`)
- Variáveis específicas do provider (ex: `JIRA_HOST`, `JIRA_API_TOKEN`)

### Verificação de configuração
```bash
if [ -z "$TASK_MANAGER_PROVIDER" ]; then
  echo "⚠️ TASK_MANAGER_PROVIDER não configurado"
  echo "Execute \$meta-setup-integration"
fi
```

## Referências

- Subagente: `@metaspec-gate-keeper` (executa essas validações)
- Skill relacionada: `onion-patterns` (estrutura e nomenclatura)
- Skill relacionada: `language-standards` (idioma)
