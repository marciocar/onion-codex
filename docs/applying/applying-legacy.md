# Onion em Projeto Legado

> Guia passo a passo para aplicar o Sistema Onion em um projeto existente com código e (eventualmente) documentação prévia.

---

## Pré-requisitos

- CLI do `codex` instalada e autenticada (`codex --version`)
- Git instalado
- Acesso ao repositório do Onion
- Projeto-alvo já clonado localmente
- Decisão sobre Task Manager
- Se regulado, ver também [applying-regulated.md](./applying-regulated.md)

---

## Quando este guia se aplica

- Projeto **já existe** com código fonte, configurações e (possivelmente) documentação
- Equipe quer adotar o Onion **sem reescrever do zero**
- Há valor preservar conhecimento já documentado e ADRs históricos

Se o projeto **não tem código ainda**, consultar [applying-greenfield.md](./applying-greenfield.md).

---

## Passo 1 — Backup defensivo

Antes de qualquer mudança estrutural:

```bash
git status
git log -1
# Criar branch dedicado para a aplicação
git checkout -b chore/apply-onion
```

---

## Passo 2 — Copiar o Onion respeitando estrutura existente

Copiar do repositório do Onion (modelo de ativação do Codex: `.codex/` + `.agents/` + `AGENTS.md`):

- `.codex/` integral — subagentes, sessions e utils (se já existir `.codex/` no projeto-alvo, **mesclar com cuidado** — não sobrescrever sem revisão)
- `.agents/skills/` integral — skills invocáveis e fragmentos compartilhados (mesma cautela na mesclagem)
- `docs/meta-specs/` (constituição do framework)
- `docs/sdaal/` (KB SDAAL)
- Templates de `docs/business-context/README.md`, `docs/technical-context/README.md`, `docs/compliance-context/README.md`
- `AGENTS.md` (raiz — ponto de entrada lido pelo `codex`) — se já existir, **mesclar** mantendo regras específicas do projeto-alvo

### Mesclagem de AGENTS.md

Estratégia recomendada:

1. Mover `AGENTS.md` existente para `AGENTS.legacy.md`
2. Copiar `AGENTS.md` do Onion como novo
3. Identificar seções únicas do projeto-alvo (regras específicas, gotchas, contexto técnico)
4. Anexar essas seções ao novo `AGENTS.md` em "## Contexto Específico do Projeto"
5. Validar e remover `AGENTS.legacy.md`

---

## Passo 3 — Configurar integrações

```bash
$meta-setup-integration
```

Em projetos legados é comum já haver Task Manager em uso — confirmar qual e configurar `TASK_MANAGER_PROVIDER` de acordo.

---

## Passo 4 — Engenharia reversa estruturada

Esta é a **fase central** de aplicação em projeto legado.

```bash
$docs-reverse-consolidate
```

O comando coordena o `@docs-reverse-engineer` e demais agentes para:

1. **Detectar stack** — linguagens, frameworks, build tools, monorepo ou não
2. **Mapear estrutura** — diretórios, módulos, componentes principais
3. **Extrair decisões implícitas** — convenções de naming, padrões de arquitetura, escolhas tecnológicas
4. **Identificar entry points** — APIs públicas, CLIs, serviços expostos
5. **Documentar gotchas** — comportamentos não-óbvios, dependências críticas, scripts essenciais

Saída: documentação consolidada inicial em `docs/`.

---

## Passo 5 — Gerar contexto técnico baseado em engenharia reversa

```bash
$docs-build-tech-docs
```

Diferentemente do greenfield, em legado o comando:

1. **Descoberta** — usa o output de `$docs-reverse-consolidate` como base de evidência
2. **Discussão** — pergunta sobre decisões **não inferíveis** (por que essa arquitetura? trade-offs aceitos? desafios pendentes?)
3. **Geração** — preenche `docs/technical-context/` com ADRs retroativas (`adr/000-retroactive-*.md`) capturando o estado atual

---

## Passo 6 — Gerar contexto de negócio (opcional)

Se o projeto-alvo já tem documentação de negócio (specs, OKRs, personas), aproveitar:

```bash
$docs-build-business-docs --sources=<paths-de-docs-existentes>
```

Se não tiver, executar sem fontes e o comando perguntará o necessário.

---

## Passo 7 — Migração gradual de workflow

Em projeto legado, **não substituir** processos existentes imediatamente. Estratégia recomendada:

### Etapa A: Adotar workflow de produto

```bash
$product-task   # Para próximas features, usar o workflow Onion
$product-estimate
$product-feature
```

Manter tasks legadas no Task Manager intactas; novas tasks seguem padrão Onion.

### Etapa B: Adotar workflow de engenharia

```bash
$engineer-plan   # Para próximas features
$engineer-start  # Sessões persistentes
$engineer-work
$engineer-pre-pr
$engineer-pr
```

PRs em andamento seguem o processo antigo até serem finalizados.

### Etapa C: Consolidar

Após 2-4 semanas de uso paralelo:

- Migrar tasks legadas ativas para o padrão Onion
- Documentar diferenças nos guias internos do projeto
- Atualizar AGENTS.md com lições aprendidas

---

## Passo 8 — Knowledge bases específicas do projeto

Se houver conhecimento técnico crítico que merece documentação estruturada:

```bash
$meta-create-knowledge-base
```

Cria KB em `docs/knowledge-base/<categoria>/` com estrutura padrão.

---

## Compliance opcional

Se o projeto legado tiver requisitos regulatórios já existentes (auditorias passadas, certificações):

```bash
mkdir -p docs/compliance-context
$docs-build-compliance-docs
```

O comando aproveita evidências de auditorias passadas e gaps documentados. Ver [applying-regulated.md](./applying-regulated.md) para detalhes.

---

## Troubleshooting

### Conflito com estrutura existente em `.codex/` ou `.agents/skills/`

- Comparar arquivo a arquivo antes de sobrescrever
- Preservar customizações específicas do projeto (ex: subagentes ou skills próprias)
- Mover customizações para `.codex/agents/development/<projeto>-specialist.md` em vez de modificar subagentes Onion canônicos

### `$docs-reverse-consolidate` produz output incompleto

- Verificar que o agente tem acesso a todos os diretórios relevantes
- Limitar escopo via parâmetro (ex: `--paths=src/,packages/`)
- Iterar: rodar múltiplas vezes com escopos diferentes e consolidar manualmente

### Documentação existente conflita com gerada

- Manter documentação histórica em `docs/legacy/` por ao menos 1 release
- Gerar nova em `docs/technical-context/` mantendo links cruzados
- Decidir progressivamente o que arquivar

---

## Checklist de "Onion aplicado em legado"

- [ ] `.codex/` e `.agents/skills/` mesclados sem perder customizações do projeto
- [ ] AGENTS.md mesclado, `AGENTS.legacy.md` removido após validação
- [ ] `.env` configurado
- [ ] `$docs-reverse-consolidate` executado e output revisado
- [ ] `$docs-build-tech-docs` gerou ADRs retroativas
- [ ] `$docs-build-business-docs` executado (com ou sem fontes existentes)
- [ ] Workflow de produto adotado para próximas features
- [ ] Workflow de engenharia adotado para próximas features
- [ ] Equipe alinhada sobre uso paralelo durante transição

---

**Próximo guia**: [Onion em projeto greenfield](./applying-greenfield.md) | [Onion em projeto regulado](./applying-regulated.md)
