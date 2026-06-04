---
name: docs-build-index
description: Gerenciar e atualizar índices de documentação.
---

> **Input:** use o texto fornecido pelo usuário ao invocar esta skill.

Este comando gerencia os índices de documentação do projeto, mantendo a estrutura organizada e navegável.

**Estrutura de Documentação do projeto**:
```
docs/
├── INDEX.md                    # Índice principal (hub central)
├── business-context/           # Contexto de negócio (15 arquivos)
│   └── index.md
├── technical-context/          # Contexto técnico (15 arquivos)
│   └── index.md
├── compliance/                 # Compliance e Governança (18 arquivos) ✨ NOVO
│   ├── index.md
│   ├── security/               # ISO 27001 (3 arquivos)
│   ├── business-continuity/    # ISO 22301 (5 arquivos)
│   ├── soc2/                   # SOC2 Type II (4 arquivos)
│   ├── ai-governance/          # AI Governance (1 arquivo)
│   ├── privacy/                # LGPD (1 arquivo)
│   └── due-diligence/          # Due Diligence (4 arquivos)
├── onion/                      # Sistema Onion (22 arquivos)
├── guidelines/                 # Guidelines de desenvolvimento (4 arquivos)
└── files/                      # Recursos diversos

.codex/
├── commands/                   # 59 comandos organizados por categoria
│   ├── docs/                   # Comandos de documentação
│   ├── engineer/               # Workflows de desenvolvimento
│   ├── collect/                # Coleta de informações
│   └── check/                  # Validações e compliance
└── agents/                     # 27 agentes especializados de IA
    ├── *.md                    # 12 agentes gerais
    ├── development/            # 10 agentes especializados dev
    └── compliance/             # 5 agentes compliance ✨ NOVO
```

## Usage

### $docs-build-index

**Sem argumentos**: Reconstrói o arquivo `INDEX.md` principal na pasta `@/docs/`.

Este índice central fornece:
- Visão geral do projeto
- Links para todas as seções de documentação
- Descrição de cada seção
- Estatísticas da documentação (80 arquivos, 59 comandos, 27 agentes)
- Guias de navegação por perfil (dev, PM, vendas, arquitetos, CISO/Compliance)
- Mapa de navegação rápida
- Referência completa aos 27 agentes especializados em `.codex/agents/`
- Métricas de maturidade de compliance (ISO 27001, ISO 22301, SOC2, LGPD)

**Comportamento**:
1. Escaneia todas as pastas em `@/docs/`
2. Lê os arquivos `index.md` de cada seção
3. Escaneia `.agents/skills/` e `.codex/agents/` para contar recursos
4. Extrai informações relevantes (título, descrição, arquivos principais)
5. Gera/atualiza `docs/INDEX.md` com estrutura completa
6. Mantém estatísticas atualizadas:
   - 80 arquivos markdown (+2 README.md landing pages)
   - 59 comandos Codex
   - 27 agentes IA (12 gerais + 10 development + 5 compliance)
   - 15 arquivos business-context
   - 16 arquivos technical-context
   - 19 arquivos compliance ✨ NOVO
   - 22 arquivos onion
   - 4 arquivos guidelines
7. Gera métricas de maturidade de compliance:
   - ISO 27001:2022 (84% implementado)
   - ISO 22301:2019 (100% implementado)
   - SOC2 Type II (93% readiness)
   - LGPD (95% compliant)
   - AI Governance (100% documentado)

### $docs-build-index <section-name>

**Com argumento**: Reconstrói o índice de uma seção específica da documentação.

**Seções disponíveis**:
- `business-context` - Documentação de negócio
- `technical-context` - Documentação técnica
- `compliance` - Compliance e Governança (ISO 27001, ISO 22301, SOC2, LGPD) ✨ NOVO
- `onion` - Sistema Onion (comandos e agentes)
- `guidelines` - Guidelines de desenvolvimento

**Comportamento**:
1. Percorre a estrutura de arquivos da seção especificada
2. Identifica arquivos principais e subpastas
3. Gera/atualiza o `index.md` da seção
4. Mantém links relativos corretos
5. Preserva estrutura e organização

**Exemplo**:
```bash
$docs-build-index business-context
# Reconstrói docs/business-context/index.md

$docs-build-index technical-context
# Reconstrói docs/technical-context/index.md

$docs-build-index compliance
# Reconstrói docs/compliance-context/index.md
```

Argumentos fornecidos: {argumentos do usuário}
