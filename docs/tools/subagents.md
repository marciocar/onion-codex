# Subagentes

## Inventario

O projeto possui 49 subagentes Codex em `.codex/agents/*.toml`.

## Regras de Compatibilidade

- Campos obrigatorios: `name`, `description`, `developer_instructions`.
- `name` em kebab-case, sem colisao com built-ins (`default`, `worker`, `explorer`).
- `developer_instructions` abaixo de 300 linhas.
- Campos Codex permitidos: `model`, `model_reasoning_effort`, `sandbox_mode`, `mcp_servers`.
- Sem campos legados de Claude, como `tools`, `color`, `priority`, `category` ou `expertise`.

## Playbooks Detalhados

Para reduzir carga inicial de contexto, 31 subagentes longos foram compactados. O comportamento detalhado foi preservado em `docs/knowledge-base/agents/<subagente>.md`.

Ao executar tarefas complexas, o subagente deve ler seu playbook correspondente antes de agir.

## Estado da Auditoria

- 49 arquivos TOML parseiam corretamente.
- Nenhum subagente excede o limite de 300 linhas em `developer_instructions`.
- Nenhuma duplicacao de `name` foi encontrada.
