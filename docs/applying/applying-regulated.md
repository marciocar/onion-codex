# Onion em Projeto Regulado

> Guia passo a passo para aplicar o Sistema Onion em projetos sujeitos a frameworks regulatórios (ISO 27001, ISO 22301, SOC2, PMBOK) ou compliance corporativo formal.

---

## Pré-requisitos

- CLI do `codex` instalada e autenticada (`codex --version`)
- Git instalado
- Acesso ao repositório do Onion (para copiar `.codex/`, `.agents/` e `AGENTS.md`)
- **Clareza sobre o framework regulatório aplicável** (ou disposição para descobrir via discovery)
- Patrocinador interno responsável por compliance (CISO, Compliance Officer, Diretor Jurídico)
- Decisão sobre Task Manager
- Se for projeto novo, ver também [applying-greenfield.md](./applying-greenfield.md). Se legado, [applying-legacy.md](./applying-legacy.md)

---

## Quando este guia se aplica

- Projeto opera em setor regulado (saúde, financeiro, governo, defesa, energia)
- Projeto manipula dados sensíveis (PII, dados financeiros, dados de saúde)
- Empresa busca certificação formal (SOC2 Type II, ISO 27001, ISO 22301)
- Projeto demanda governança de mudança rigorosa (PMBOK)

Mesmo projetos que **podem operar sem compliance** se beneficiam deste guia quando crescem para mercados regulados.

---

## Matriz de decisão — Qual framework aplicar

Use a matriz abaixo como ponto de partida. O `@security-information-master` validará e ajustará durante o discovery.

| Setor / Cenário | Framework primário | Frameworks complementares | Agentes envolvidos |
|---|---|---|---|
| SaaS B2B (segurança de clientes) | SOC2 Type II | ISO 27001 | `@soc2-specialist`, `@iso-27001-specialist` |
| Saúde / health-tech | ISO 27001 + SOC2 | LGPD/HIPAA (cobertura parcial) | `@iso-27001-specialist`, `@soc2-specialist` |
| Financeiro / fintech | ISO 27001 | ISO 22301 (continuidade), SOC2 | `@iso-27001-specialist`, `@iso-22301-specialist` |
| Governo / setor público | PMBOK + ISO 22301 | ISO 27001 | `@pmbok-specialist`, `@iso-22301-specialist` |
| Energia / infraestrutura crítica | ISO 22301 | ISO 27001 | `@iso-22301-specialist`, `@iso-27001-specialist` |
| Anticorrupção / PLD-KYC | Compliance corporativo | ISO 37001 (não coberto) | `@corporate-compliance-specialist` |
| Startup early-stage | Compliance corporativo básico | ISO 27001 quando crescer | `@corporate-compliance-specialist` |

**Decisão final**: orquestrada por `@security-information-master` durante o passo 3.

---

## Passo 1 — Estrutura inicial

Seguir o passo correspondente do guia greenfield ou legacy:

- Greenfield: [applying-greenfield.md §Passo 1 a 4](./applying-greenfield.md)
- Legado: [applying-legacy.md §Passo 1 a 4](./applying-legacy.md)

Adicionalmente, criar pasta `compliance-context/` no projeto-alvo:

```bash
mkdir -p docs/compliance-context
# Copiar README de docs/compliance-context/README.md do Onion
```

---

## Passo 2 — Identificar stakeholders de compliance

Antes de rodar o build, ter mapeados:

- **Responsável legal/jurídico**: aprova políticas, valida termos
- **CISO ou equivalente**: aprova controles de segurança
- **Auditor interno**: valida evidências
- **Auditor externo** (se aplicável): conduz certificação
- **Equipe de TI/SecOps**: implementa controles técnicos

Sem esse mapeamento, a documentação gerada vira "obra-de-arte" sem dono.

---

## Passo 3 — Gerar contexto de compliance

```bash
$docs-build-compliance-docs
```

O comando passa por:

### Fase 3.1 — Detecção de framework aplicável

`@security-information-master` orquestra:

1. Pergunta sobre setor, tamanho, clientes principais, dados manipulados
2. Compara com matriz de aplicabilidade
3. Sugere framework primário + complementares
4. Solicita confirmação do patrocinador interno antes de prosseguir

### Fase 3.2 — Discovery por framework

Para cada framework selecionado, o agente especialista coleta:

**ISO 27001 → `@iso-27001-specialist`**:

- Escopo do SGSI (sistemas, processos, equipes)
- Inventário de ativos
- Riscos identificados e tratamentos
- Controles em vigor (do Anexo A)
- Gaps conhecidos

**ISO 22301 → `@iso-22301-specialist`**:

- Análise de impacto no negócio (BIA)
- Processos críticos e RTOs/RPOs
- Planos de continuidade existentes
- Cenários de teste

**SOC2 → `@soc2-specialist`**:

- Trust Services Criteria aplicáveis (Security obrigatório; Availability, Confidentiality, Processing Integrity, Privacy opcionais)
- Período de auditoria (Type I ou Type II)
- Evidências já coletadas

**PMBOK → `@pmbok-specialist`**:

- Performance domains aplicáveis
- Princípios de gestão adotados
- Stakeholders, riscos, qualidade, mudanças

**Compliance corporativo → `@corporate-compliance-specialist`**:

- Códigos de conduta vigentes
- Políticas anticorrupção
- PLD/KYC quando aplicável
- Canal de denúncias

### Fase 3.3 — Geração estruturada

O comando preenche `docs/compliance-context/` seguindo estrutura em [docs/compliance-context/README.md](../compliance-context/README.md):

```
docs/compliance-context/
├── 01-security/        # ISO 27001
├── 02-continuity/      # ISO 22301
├── 03-soc2/            # SOC2
├── 04-governance/      # PMBOK + Corporate
└── 05-audit/           # Trilhas e evidências
```

Cada camada ativada apenas conforme aplicabilidade do projeto.

---

## Passo 4 — Mapeamento cruzado entre frameworks

Quando múltiplos frameworks aplicam, há controles que se sobrepõem (ex: controle de acesso aparece em ISO 27001, SOC2 Security e Compliance Corporativo).

O `@security-information-master` gera mapa cruzado em `docs/compliance-context/05-audit/cross-framework-map.md`:

| Controle | ISO 27001 | SOC2 | ISO 22301 | PMBOK |
|---|---|---|---|---|
| Controle de Acesso | A.9 | CC6.1 | (continuidade de credenciais) | — |
| Backup e Recuperação | A.12.3 | A1.2 | 8.4.4 | — |
| Gestão de Mudanças | A.12.1.2 | CC8.1 | — | Change Management Performance Domain |

Esse mapa permite **uma única evidência atender múltiplos frameworks** durante auditoria.

---

## Passo 5 — Plano de implementação de gaps

Após o build, comparar o estado atual (`as-is`) com o estado-alvo de cada framework (`to-be`):

```bash
$product-task --source=docs/compliance-context/05-audit/gaps.md
```

Decompõe gaps em tasks executáveis pela equipe técnica e de processos.

---

## Passo 6 — Workflow de coleta de evidências

SOC2 e ISO exigem evidências periódicas (mensais, trimestrais). Configurar:

- **Calendário de compliance**: `docs/compliance-context/05-audit/compliance-calendar.md`
- **Templates por evidência**: incluir em `docs/compliance-context/03-soc2/evidence/templates/`
- **Trilha automatizada**: integrar logs, screenshots, configurações em formato auditável

---

## Passo 7 — Integração com workflows de produto e engenharia

Compliance **não é silo isolado**. Integrar:

### Workflow de Produto + Compliance

```bash
$product-spec       # Spec deve referenciar requisitos de compliance aplicáveis
$product-task       # Tasks de compliance entram no mesmo backlog
$validate-workflow  # Validação inclui critérios de compliance
```

### Workflow de Engenharia + Compliance

```bash
$engineer-plan      # Plano considera controles aplicáveis (ex: logging, criptografia)
$engineer-pre-pr    # Validação pré-PR inclui checklist de compliance
$engineer-pr        # PR description referencia controle implementado
```

### Code review com lente de compliance

`@corporate-compliance-specialist` ou `@iso-27001-specialist` podem ser invocados em PRs que tocam em controles sensíveis (autenticação, criptografia, logs de auditoria).

---

## Passo 8 — Preparação para auditoria

Antes de auditoria externa:

```bash
$docs-validate-docs --scope=compliance
```

Verifica:

- Cobertura de controles aplicáveis
- Evidências disponíveis e datadas
- Trilhas de auditoria completas
- Mapa cruzado atualizado

---

## Troubleshooting

### Discovery não converge no framework correto

- Documentar requisitos de clientes/contratos no input do discovery
- Validar com auditor externo antes de decidir
- Começar com framework mais conservador (ISO 27001 + SOC2) e adaptar

### Volume de documentação esmagador

- Ativar apenas camadas estritamente necessárias inicialmente
- Adicionar camadas incrementalmente conforme certificação avança
- Usar `@security-information-master` para priorizar gaps críticos

### Evidências dispersas em múltiplas ferramentas

- Centralizar índice em `docs/compliance-context/05-audit/`
- Linkar para fontes externas (Drive, SharePoint, sistemas próprios) em vez de duplicar
- Manter cópias locais apenas para artefatos que mudam pouco

---

## Checklist de "Onion regulado pronto para auditoria"

- [ ] Framework aplicável definido e aprovado por patrocinador interno
- [ ] `docs/compliance-context/` populado pelo agente especialista
- [ ] Mapa cruzado de controles gerado
- [ ] Gaps identificados e em backlog de implementação
- [ ] Calendário de compliance ativo
- [ ] Templates de evidência prontos
- [ ] Workflows de produto e engenharia incluem critérios de compliance
- [ ] Auditor interno consultado e validou estrutura
- [ ] Primeiro ciclo de evidências coletado e arquivado

---

## Referências externas

- [ISO 27001:2022](https://www.iso.org/standard/27001) — SGSI
- [ISO 22301:2019](https://www.iso.org/standard/75106.html) — BCMS
- [AICPA SOC2](https://www.aicpa-cima.com/topic/audit-assurance/audit-and-assurance-greater-than-soc-2) — Trust Services Criteria
- [PMBOK 7th Edition](https://www.pmi.org/standards/pmbok) — Project Management

---

**Próximo guia**: [Onion em projeto greenfield](./applying-greenfield.md) | [Onion em projeto legado](./applying-legacy.md)
