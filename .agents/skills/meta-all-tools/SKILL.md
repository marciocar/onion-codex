---
name: meta-all-tools
description: Documenta o toolset disponível no Codex. Use quando precisar inventariar ferramentas locais, skills, subagentes, MCPs, regras, hooks ou recursos do workspace.
---

# Inventário de Ferramentas Codex

## Objetivo

Gerar ou atualizar documentação do toolset real disponível no Codex para este workspace, sem assumir ferramentas legadas de outros agentes.

## Fontes de Verdade

Use estas fontes, nesta ordem:

1. `AGENTS.md` para regras operacionais do projeto.
2. `.codex/config.toml` para features, subagentes, MCPs comentados ou ativos e limites.
3. `.codex/hooks.json` para automações de ciclo de vida.
4. `.codex/rules/default.rules` para permissões de execução.
5. `.codex/agents/*.toml` para subagentes Codex.
6. `.agents/skills/*/SKILL.md` para skills Agent Skills.
7. `.agents/skills/task-manager/references/` para adapters de Task Manager.
8. `docs/knowledge-base/platforms/openai-codex.md` para conceitos de plataforma.

## Categorias

Documente o inventário em `docs/tools/`:

- `README.md` - visão geral, data da auditoria e links para categorias.
- `codex-config.md` - `config.toml`, features, sandbox, approvals, project docs e agents config.
- `skills.md` - skills em `.agents/skills/`, com nome, descrição e caminho.
- `subagents.md` - subagentes em `.codex/agents/`, com modelo, sandbox, MCPs e referência detalhada quando existir.
- `mcp-servers.md` - MCPs ativos ou templates comentados, variáveis necessárias e provider relacionado.
- `rules-hooks.md` - regras de execução e hooks locais.
- `task-manager.md` - provider detection, adapters e formatação por provider.

## Formato de Saída

Cada arquivo deve conter:

- escopo da categoria;
- tabela objetiva de itens;
- caminhos locais clicáveis em Markdown quando possível;
- observações de compatibilidade Codex;
- pendências runtime separadas de problemas estruturais.

## Procedimento

1. Verifique se `docs/tools/` existe.
2. Atualize arquivos existentes sem apagar conteúdo útil.
3. Se a pasta não existir, crie a estrutura mínima acima.
4. Não invente MCP ativo: se `.env` estiver ausente ou o bloco estiver comentado em `.codex/config.toml`, marque como "template/inativo".
5. Ao final, informe contagens reais de skills, subagentes, hooks, rules e MCPs.

## Critério de Conclusão

- Nenhum texto deve depender de `.claude/` como estrutura viva.
- O inventário deve refletir apenas Codex: `.codex/`, `.agents/skills/`, `AGENTS.md`, hooks, rules, MCPs e recursos do ambiente atual.
- Pendências que exigem `codex` CLI autenticado ou credenciais externas devem ficar marcadas como runtime, não como falha local.
