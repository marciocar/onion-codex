# Onion

**Um jeito de organizar produto, engenharia e governança no mesmo ritmo: menos ruído, mais clareza e entregas previsíveis.**

---

## O que é

O Onion é um **framework template em `.codex/` + `.agents/`** que se instala em qualquer projeto — novo, legado ou regulado — para orquestrar o ciclo completo de desenvolvimento com Codex. Separa **decisão de negócio**, **execução técnica** e **governança/compliance** em contextos distintos, conectados por fluxos e padrões repetíveis. Skills, agentes especializados e documentação passam a conversar entre si em vez de competir por atenção no chat ou em arquivos soltos.

O Onion **não é produto npm**, **não é distribuído publicamente** e **não tem CLI standalone próprio** — roda sobre o `codex` CLI. Plataforma única: OpenAI Codex.

---

## Para quem é

- Squads de **produto, engenharia e compliance** que precisam alinhar prioridade, implementação, qualidade e conformidade.
- Times que sentem **falta de contexto compartilhado** entre quem define o quê, quem entrega o como e quem responde por governança.
- Organizações que querem **padrão sem burocracia** — menos improviso, mais previsibilidade.
- Projetos **novos** (greenfield), **legados** (com engenharia reversa) e **regulados** (ISO 27001, ISO 22301, SOC2, PMBOK).

---

## O que muda no dia a dia

- Menos retrabalho por decisões perdidas ou mal comunicadas.
- **Contexto explícito** antes de cada ação: todo mundo sabe em qual dimensão está trabalhando (produto, engenharia ou compliance).
- **Workflows faseados retomáveis** para especificar, desenvolver, validar e documentar — com sessões persistentes (`.codex/sessions/`) que permitem pausar e continuar.
- Documentação e fluxo de trabalho **mais próximos do que o time realmente faz**.
- Práticas de **configuração e segurança** integradas ao processo (credenciais fora do repositório, templates seguros).

---

## Como funciona em três passos

1. **Definir a intenção** no contexto certo — produto (descoberta e spec), engenharia (implementação e entrega) ou compliance (governança e conformidade).
2. **Executar com apoio** de skills padronizadas e agentes especializados, em ciclos faseados retomáveis (`product-collect→feature` e `engineer-plan→pr-update`).
3. **Validar e registrar** — qualidade, segurança e conhecimento ficam sincronizados para o próximo ciclo.

---

## Instalação e primeiros passos

O Onion roda sobre o **Codex CLI**. Não há toolchain de build: o framework é interpretado em runtime pelo Codex a partir de `AGENTS.md` + `.codex/` + `.agents/skills/`.

```bash
# 1. Instalar o Codex CLI
npm install -g @openai/codex
# Alternativas: curl -fsSL https://codex.openai.com/install.sh | sh   (macOS/Linux)
#               ou via Homebrew

# 2. Clonar um projeto que já tenha o Onion instalado
git clone <seu-repo-com-onion>
cd <seu-repo>

# 3. Abrir o Codex e autenticar
codex
# → autenticar com conta ChatGPT ou OpenAI API key
```

O framework é **ativado** automaticamente pela presença de `AGENTS.md` + `.codex/` + `.agents/skills/` na raiz do repositório.

### Como invocar

- **Skills** via `$slug` — ex.: `$onion` (orquestrador), `$engineer-start`, `$product-task`.
- **Subagentes** via menção — ex.: `@gitflow-specialist`.
- **`/skills`** lista todas as skills disponíveis.

Para começar: rode `$onion` para orientação ou `$warm-up` para carregar o contexto do projeto.

### Inventário

- **~82 skills** em `.agents/skills/` (categorias `product`, `git`, `engineer`, `docs`, `meta`, `validate`, `test`, `development`, `quick`).
- **49 subagentes** em `.codex/agents/*.toml`.
- **4 skills-base**: `onion` (orquestrador), `onion-patterns`, `onion-validation`, `language-standards`.
- **Task Manager Abstraction** plugável (Jira, ClickUp, Asana, Linear) em `.agents/skills/task-manager/references/`.

> Fonte de verdade da migração Claude Code → Codex: [`docs/knowledge-base/platforms/openai-codex.md`](docs/knowledge-base/platforms/openai-codex.md).

---

## Próximo passo

Explore a documentação do projeto:

- **[Documentação geral](docs/)** — visão geral e materiais de apoio.
- **[Guia Onion](docs/onion/)** — instalação, conceitos e referências operacionais.

Quer contribuir? Veja **[CONTRIBUTING.md](CONTRIBUTING.md)**.

---

## Créditos

O Onion se inspira em ideias de **interface unificada** para orquestração com IA; referência conceitual: [Esperanto, de Luis Novo](https://github.com/lfnovo/esperanto).

---

## Licença

Distribuído sob a licença MIT. Veja [LICENSE](LICENSE).

---

**Onion — contexto certo, decisão melhor, entrega contínua.**
