# Skills

## Inventario

O projeto possui 82 skills em `.agents/skills/<slug>/SKILL.md`.

## Regras de Compatibilidade

- Frontmatter com apenas `name` e `description`.
- `name` em kebab-case e alinhado ao nome da pasta.
- Descricoes curtas e acionaveis para invocacao implicita.
- Corpo abaixo de 500 linhas.
- Conteudo complementar em `references/`, `assets/`, `scripts/` ou `docs/onion/shared/`.

## Categorias

- `onion`, `onion-patterns`, `onion-validation`, `language-standards`
- `product-*`
- `engineer-*`
- `git-*`
- `docs-*`
- `meta-*`
- `validate-*`
- `test-*`
- `development-*`
- `quick-*`
- `task-manager`

## Como Validar

Use `$onion-validation` para validar frontmatter, duplicacoes, limites e referencias. A auditoria local pos-migracao nao encontrou colisao de nomes nem campos legados no frontmatter.
