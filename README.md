<div align="center">

# 🧅 Onion

### Organize produto, engenharia e governança no mesmo ritmo — nativo do **OpenAI Codex**.

[![Licença: MIT](https://img.shields.io/github/license/marciocar/onion-codex?color=success)](LICENSE)
![Plataforma](https://img.shields.io/badge/plataforma-OpenAI_Codex-10A37F)
![Metodologia](https://img.shields.io/badge/metodologia-Spec--as--Code_%2B_SDD-blue)
[![Família Onion](https://img.shields.io/badge/família-Onion-8A2BE2)](https://github.com/marciocar/onion)

**[O que é](#-o-que-é) · [Início rápido](#-início-rápido) · [Família Onion](#-família-onion) · [Documentação](#-documentação) · [Contribuir](#-contribuir)**

</div>

---

> [!NOTE]
> Esta é a porta **OpenAI Codex** da família Onion — a mesma metodologia, expressa no primitivo nativo da plataforma. Conheça as outras 5 portas no hub: **[github.com/marciocar/onion](https://github.com/marciocar/onion)**.

## 🎯 O que é

O Onion é um **framework template em `.codex/` + `.agents/`** que se instala em qualquer projeto — novo, legado ou regulado — para orquestrar o ciclo completo de desenvolvimento com Codex. Separa **decisão de negócio**, **execução técnica** e **governança/compliance** em contextos distintos, conectados por fluxos e padrões repetíveis. Skills, agentes especializados e documentação passam a conversar entre si em vez de competir por atenção no chat ou em arquivos soltos.

O Onion **não é produto npm**, **não é distribuído publicamente** e **não tem CLI standalone próprio** — roda sobre o `codex` CLI. Plataforma única: OpenAI Codex.

## ⚡ Início rápido

O Onion roda sobre o **Codex CLI** — sem toolchain de build; é interpretado em runtime a partir de `AGENTS.md` + `.codex/` + `.agents/skills/`.

```bash
# 1. Instalar o Codex CLI
npm install -g @openai/codex
# Alternativas: curl -fsSL https://codex.openai.com/install.sh | sh   (macOS/Linux) ou Homebrew

# 2. Clonar um projeto que já tenha o Onion instalado
git clone <seu-repo-com-onion>
cd <seu-repo>

# 3. Abrir o Codex e autenticar (conta ChatGPT ou OpenAI API key)
codex
```

O framework é **ativado** automaticamente pela presença de `AGENTS.md` + `.codex/` + `.agents/skills/` na raiz. Comece com **`$onion`** (orientação) ou **`$warm-up`** (contexto do projeto).

**Como invocar:**

| Primitivo | Sintaxe | Exemplo |
|---|---|---|
| Skill (comando) | `$slug` | `$onion`, `$engineer-start`, `$product-task` |
| Subagente | `@agente` | `@gitflow-specialist` |
| Listar skills | `/skills` | — |

## 🧩 O que muda no dia a dia

- Menos retrabalho por decisões perdidas ou mal comunicadas.
- **Contexto explícito** antes de cada ação: todo mundo sabe em qual dimensão está trabalhando (produto, engenharia ou compliance).
- **Workflows faseados retomáveis** com sessões persistentes (`.codex/sessions/`) que permitem pausar e continuar.
- Documentação e fluxo de trabalho **mais próximos do que o time realmente faz**.
- Práticas de **configuração e segurança** integradas (credenciais fora do repositório, templates seguros).

## 🌐 Família Onion

| Porta | Plataforma | Repositório |
|---|---|---|
| 🌐 onion (hub) | a história de todas | [onion](https://github.com/marciocar/onion) |
| 🟠 claude | Claude Code | [onion-claude](https://github.com/marciocar/onion-claude) |
| 🔵 cursor | Cursor | [onion-cursor](https://github.com/marciocar/onion-cursor) |
| 🟣 antigravity | Google Antigravity | [onion-antigravity](https://github.com/marciocar/onion-antigravity) |
| ⚡ zed | Zed | [onion-zed](https://github.com/marciocar/onion-zed) |
| 🟢 **codex** | **OpenAI Codex** | **◀ você está aqui** |
| 🐙 copilot | GitHub Copilot + VS Code | [onion-copilot](https://github.com/marciocar/onion-copilot) |

## 📚 Documentação

- **[Índice geral de docs](docs/INDEX.md)** · **[Guia Onion](docs/onion/)** — conceitos e referências operacionais.
- **[Migração Claude Code → Codex](docs/knowledge-base/platforms/openai-codex.md)** — fonte de verdade da adaptação.

<details>
<summary><b>Inventário e como funciona em três passos</b></summary>

<br>

**Inventário:**

- **~82 skills** em `.agents/skills/` (categorias `product`, `git`, `engineer`, `docs`, `meta`, `validate`, `test`, `development`, `quick`).
- **49 subagentes** em `.codex/agents/*.toml`.
- **4 skills-base**: `onion` (orquestrador), `onion-patterns`, `onion-validation`, `language-standards`.
- **Task Manager Abstraction** plugável (Jira, ClickUp, Asana, Linear) em `.agents/skills/task-manager/references/`.

**Para quem é** — squads de produto, engenharia e compliance; times sem contexto compartilhado; organizações que querem padrão sem burocracia; projetos novos, legados ou regulados (ISO 27001, ISO 22301, SOC2, PMBOK).

**Como funciona em três passos**

1. **Definir a intenção** no contexto certo — produto, engenharia ou compliance.
2. **Executar com apoio** de skills padronizadas e agentes, em ciclos faseados retomáveis (`product-collect→feature` e `engineer-plan→pr-update`).
3. **Validar e registrar** — qualidade, segurança e conhecimento ficam sincronizados para o próximo ciclo.

</details>

## 🤝 Contribuir

Veja **[CONTRIBUTING.md](CONTRIBUTING.md)**.

## 📄 Licença

Distribuído sob a licença **MIT** — veja **[LICENSE](LICENSE)**.

O Onion se inspira em ideias de **interface unificada** para orquestração com IA; referência conceitual: [Esperanto, de Luis Novo](https://github.com/lfnovo/esperanto).

<div align="center"><sub>🧅 Onion — contexto certo, decisão melhor, entrega contínua.</sub></div>
