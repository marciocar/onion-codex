# Onion em Projeto Novo (Greenfield)

> Guia passo a passo para aplicar o Sistema Onion em um projeto sem código nem documentação prévia.

---

## Pré-requisitos

- CLI do `codex` instalada e autenticada (`codex --version`)
- Git instalado
- Acesso ao repositório do Onion (para copiar `.codex/`, `.agents/` e estrutura `docs/`)
- Decisão sobre Task Manager: Jira, ClickUp, Asana, Linear ou `none` (operação offline)
- Decisão sobre se o projeto exige compliance regulatório (se sim, ver também [applying-regulated.md](./applying-regulated.md))

---

## Quando este guia se aplica

- Projeto que **ainda não existe** ou **acabou de ser inicializado** (`git init` recente)
- Sem README, sem código fonte, sem arquitetura prévia
- Equipe quer começar com Onion desde o dia zero

Se o projeto **já tem código**, consultar [applying-legacy.md](./applying-legacy.md).

---

## Passo 1 — Estrutura inicial do projeto-alvo

```bash
# No diretório do projeto-alvo
mkdir meu-projeto && cd meu-projeto
git init
```

---

## Passo 2 — Copiar o Onion

Copiar do repositório do Onion para o projeto-alvo (modelo de ativação do Codex: `.codex/` + `.agents/` + `AGENTS.md`):

- `.codex/` integral (subagentes em `.codex/agents/`, sessions em `.codex/sessions/`, utils em `.codex/utils/`)
- `.agents/skills/` integral (skills invocáveis e fragmentos compartilhados, incluindo `task-manager/references/`)
- `docs/meta-specs/` (constituição do framework — pode ser referenciada via symlink ou cópia)
- `docs/sdaal/` (KB do padrão SDAAL)
- Templates de `docs/business-context/README.md`, `docs/technical-context/README.md`, `docs/compliance-context/README.md`
- `AGENTS.md` (raiz — ponto de entrada lido pelo `codex`; ajustar conforme passo 4)
- `.env.example` (renomear para `.env` e configurar)

Estrutura resultante mínima no projeto-alvo:

```
meu-projeto/
├── .codex/                 # Subagentes, sessions, utils do Onion
├── .agents/
│   └── skills/             # Skills invocáveis + fragmentos compartilhados
├── docs/
│   ├── business-context/   # Vazio inicialmente (será populado)
│   ├── technical-context/  # Vazio inicialmente
│   ├── compliance-context/ # Vazio (criar apenas se regulado)
│   ├── meta-specs/         # Constituição (cópia ou referência)
│   ├── sdaal/              # Referência do padrão SDAAL
│   └── knowledge-base/     # Vazio inicialmente
├── AGENTS.md               # Ponto de entrada do Codex
└── .env (não commitado)
```

---

## Passo 3 — Configurar integrações

```bash
$meta-setup-integration
```

O comando guiará a configuração de:

- `TASK_MANAGER_PROVIDER` (jira | clickup | asana | linear | none)
- Variáveis específicas do provider escolhido
- MCPs aplicáveis

Se for operar offline (sem Task Manager): definir `TASK_MANAGER_PROVIDER=none`. As skills `$product-*` continuarão funcionando mas não persistirão em Task Manager externo.

---

## Passo 4 — Adaptar AGENTS.md ao projeto-alvo

O AGENTS.md do Onion é genérico. Para o projeto-alvo, ajustar:

1. Substituir descrição "Sistema Onion" pela descrição do projeto-alvo
2. Manter as seções de Task Manager Abstraction (são úteis)
3. Adicionar contexto específico do projeto (stack pretendida, equipe, restrições)
4. Manter referência às meta-specs do Onion como guia normativo

---

## Passo 5 — Gerar contexto de negócio inicial

```bash
$docs-build-business-docs
```

O comando passará por:

1. **Descoberta** — analisa o que existe (README inicial, materiais externos se fornecidos)
2. **Discussão** — pergunta visão, personas, público-alvo, modelo de negócio
3. **Geração** — preenche `docs/business-context/` seguindo a estrutura em [docs/business-context/README.md](../business-context/README.md)

Em greenfield, este passo define a base estratégica antes de qualquer código.

---

## Passo 6 — Gerar contexto técnico inicial

```bash
$docs-build-tech-docs
```

O comando passará por:

1. **Descoberta** — escaneia o pouco que existe (arquivos de config, decisões inicialmente declaradas)
2. **Discussão** — pergunta sobre stack pretendida, padrões arquiteturais, restrições, trade-offs
3. **Geração** — preenche `docs/technical-context/` com ADRs iniciais, charter, AI development guide

Em greenfield, este passo define a arquitetura intencional antes da implementação.

---

## Passo 7 — Iniciar primeiro ciclo de desenvolvimento

### Camada Produto

```bash
$product-collect    # Coletar ideias iniciais de features
$product-refine     # Refinar via perguntas
$product-spec       # Criar spec da primeira feature
$product-task       # Decompor em tasks
$product-estimate   # Estimar story points
$product-feature    # Criar no Task Manager (se configurado)
```

### Camada Engenharia

```bash
$engineer-plan      # Planejar implementação
$engineer-start     # Criar sessão de desenvolvimento
$engineer-work      # Executar fase atual
# ... iterar work até pronto
$engineer-pre-pr    # Validação pré-PR
$engineer-pr        # Abrir Pull Request
```

---

## Passo 8 — Manter contextos atualizados

A cada mudança significativa de produto ou arquitetura:

```bash
$docs-build-business-docs   # Atualizar business context
$docs-build-tech-docs       # Atualizar technical context
$docs-build-index           # Reconstruir INDEX
```

---

## Compliance opcional

Se durante a evolução do projeto surgir requisito regulatório:

```bash
mkdir -p docs/compliance-context
# Copiar README de docs/compliance-context/README.md do Onion
$docs-build-compliance-docs
```

Detalhes em [applying-regulated.md](./applying-regulated.md).

---

## Troubleshooting

### Skill não é reconhecida

- Verificar que `.agents/skills/` foi copiado integralmente
- Confirmar que o `codex` está rodando no diretório correto do projeto-alvo (onde fica o `AGENTS.md`)
- Reiniciar a sessão do `codex`

### Task Manager não responde

- Verificar variáveis em `.env`
- Rodar `$meta-setup-integration` novamente
- Validar token/credenciais com o provider

### Subagente não encontrado

- Verificar que `.codex/agents/` foi copiado
- Confirmar que o subagente está na categoria correta (`.codex/agents/<categoria>/<nome>.md`)

---

## Checklist de "primeira skill útil"

Considera-se Onion operacional no projeto-alvo quando:

- [ ] `.codex/` e `.agents/skills/` copiados integralmente
- [ ] `AGENTS.md` presente na raiz do projeto-alvo
- [ ] `.env` configurado com `TASK_MANAGER_PROVIDER`
- [ ] `$meta-setup-integration` executado sem erros
- [ ] `$docs-build-business-docs` gerou `business-context/` populado
- [ ] `$docs-build-tech-docs` gerou `technical-context/` populado
- [ ] Primeiro `$product-task` criou task com sucesso (ou foi processado offline)
- [ ] Primeiro `$engineer-start` criou sessão em `.codex/sessions/`

---

**Próximo guia**: [Onion em projeto legado](./applying-legacy.md) | [Onion em projeto regulado](./applying-regulated.md)
