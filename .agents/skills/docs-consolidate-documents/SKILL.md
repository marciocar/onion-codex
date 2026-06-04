---
name: docs-consolidate-documents
description: |
  Consolida múltiplos documentos usando análise profunda, identificando divergências, convergências e insights estratégicos.
  Aceita pasta ou arquivos individuais para criar conhecimento consolidado e unificado.
  Use para transformar múltiplos documentos em conhecimento estratégico consolidado.
---

# 📚 Consolidar Documentos

Comando para consolidar múltiplos documentos relacionados, identificando padrões, divergências, convergências e insights estratégicos.

## 🎯 Objetivo

Transformar múltiplos documentos em conhecimento estratégico consolidado, identificando:
- **Divergências**: Conflitos e desalinhamentos entre documentos
- **Convergências**: Pontos de alinhamento e consistência
- **Insights Estratégicos**: Padrões não explícitos e conexões importantes
- **Gaps de Informação**: Informações faltantes ou incompletas
- **Estrutura Otimizada**: Organização ideal do conhecimento consolidado
- **Inconsistências**: Dados ou informações contraditórias

## ⚡ Fluxo de Execução

### Passo 1: Detectar Tipo de Entrada

Analisar o parâmetro `source` fornecido:

```bash
# Verificar se é pasta ou arquivo(s)
if [ -d "$source" ]; then
  # É uma pasta
  echo "📁 Pasta detectada: $source"
elif [ -f "$source" ]; then
  # É um arquivo único
  echo "📄 Arquivo detectado: $source"
else
  # Múltiplos arquivos (separados por espaço)
  echo "📄 Múltiplos arquivos detectados"
fi
```

**Se for pasta:**
- Listar arquivos de documentos na pasta
- Filtrar por extensões relevantes (.md, .txt, .json, .yaml, etc)
- Ordenar por data de modificação ou nome
- Identificar documentos relacionados por tema

**Se for arquivo(s):**
- Processar arquivo(s) diretamente
- Validar que são documentos válidos
- Identificar tipo e categoria de cada documento

### Passo 2: Coletar Arquivos de Documentos

**Cenário A: Pasta Fornecida**

```markdown
1. Listar arquivos na pasta (recursivo se necessário)
2. Filtrar arquivos de documentos:
   - Extensões: .md, .txt, .json, .yaml, .yml, .rst, .adoc
   - Padrões de nome: *docs*, *documentation*, *spec*, *guide*
3. Ordenar por:
   - Data de modificação (mais recente primeiro)
   - Ou por nome alfabético
4. Validar que são documentos válidos
5. Identificar documentos relacionados por:
   - Tema comum (análise de conteúdo)
   - Categoria (business-context, tech-docs, etc)
   - Tipo (spec, guide, reference, etc)
6. Coletar lista de arquivos para processar
```

**Cenário B: Arquivo(s) Fornecido(s)**

```markdown
1. Validar que arquivo(s) existe(m)
2. Verificar se são documentos válidos
3. Identificar tipo e categoria de cada documento
4. Coletar lista de arquivos para processar
```

### Passo 3: Preparar Contexto para Consolidação

Antes de processar, preparar contexto estruturado:

```markdown
## Contexto da Consolidação

### Arquivos a Consolidar
{{lista_de_arquivos_com_paths}}

### Foco da Análise
{{focus}} (all|divergences|convergences|insights|gaps|structure)

### Informações dos Documentos
{{metadados_dos_documentos}}
```

**Metadados a Coletar:**
- Nome do arquivo e caminho completo
- Data de modificação
- Tamanho do arquivo
- Tipo de documento (identificado por conteúdo ou nome)
- Categoria (business-context, tech-docs, meet, etc)
- Tema principal (extraído do conteúdo)
- Estrutura do documento (seções principais)
- Referências cruzadas (links para outros documentos)

### Passo 4: Analisar e Consolidar Documentos

Processar documentos para criar consolidação:

```markdown
Analisar os seguintes documentos:

**Arquivos a Consolidar:**
{{lista_de_arquivos_com_paths}}

**Foco da Análise:**
{{focus}}

**Metadados:**
{{metadados_estruturados}}

Por favor, execute consolidação completa incluindo:

1. **Análise de Conteúdo**:
   - Identificar tema principal e temas secundários
   - Extrair informações-chave de cada documento
   - Mapear estrutura e organização

2. **Identificação de Divergências**:
   - Conflitos de informação entre documentos
   - Dados contraditórios
   - Desalinhamentos conceituais
   - Versões diferentes da mesma informação

3. **Identificação de Convergências**:
   - Pontos de alinhamento entre documentos
   - Informações consistentes
   - Padrões recorrentes
   - Consenso identificado

4. **Geração de Insights Estratégicos**:
   - Padrões não explícitos
   - Conexões importantes entre documentos
   - Oportunidades de melhoria
   - Gaps de conhecimento identificados

5. **Identificação de Gaps**:
   - Informações faltantes
   - Documentos incompletos
   - Referências quebradas
   - Áreas não cobertas

6. **Estrutura Otimizada**:
   - Organização ideal do conhecimento consolidado
   - Hierarquia de informações
   - Relacionamentos entre conceitos
   - Fluxo lógico de leitura

7. **Principais Pontos de Atenção**:
   - Inconsistências críticas
   - Informações desatualizadas
   - Conflitos que precisam resolução
   - Priorização por criticidade

8. **Recomendações Estratégicas**:
   - Ações para resolver divergências
   - Oportunidades de consolidação
   - Melhorias sugeridas
   - Próximos passos

Gere output completo e estruturado conforme template de consolidação.
```

**Se foco específico for fornecido:**

```markdown
{{foco_especifico}} dos seguintes documentos:

**Arquivos:**
{{lista_de_arquivos}}

**Foco:**
- Se "divergences": Identificar apenas divergências e conflitos
- Se "convergences": Identificar apenas convergências e alinhamentos
- Se "insights": Gerar apenas insights estratégicos
- Se "gaps": Identificar apenas gaps de informação
- Se "structure": Focar em estrutura e organização otimizada
```

### Passo 5: Validar Output da Consolidação

Verificar se a consolidação criada contém:

- ✅ **Análise de Conteúdo**: Tema principal e informações-chave extraídas
- ✅ **Divergências**: Conflitos e desalinhamentos identificados
- ✅ **Convergências**: Pontos de alinhamento identificados
- ✅ **Insights Estratégicos**: Padrões e conexões revelados
- ✅ **Gaps de Informação**: Informações faltantes identificadas
- ✅ **Estrutura Otimizada**: Organização proposta
- ✅ **Principais Pontos de Atenção**: Priorizados por criticidade
- ✅ **Recomendações Estratégicas**: Ações sugeridas

### Passo 6: Salvar Consolidação

Salvar a consolidação criada em arquivo estruturado:

```markdown
# Determinar caminho de saída
if [ -n "$output_path" ]; then
  OUTPUT_PATH="$output_path"
else
  # Padrão: docs/consolidated/
  OUTPUT_PATH="docs/consolidated/"
fi

# Criar nome do arquivo
TEMA=$(extrair_tema_principal)
DATA=$(date +%Y-%m-%d)
FILENAME="consolidation-${DATA}-${TEMA}.md"

# Salvar em: ${OUTPUT_PATH}${FILENAME}

# Consolidação de Documentos: [Tema Principal]

**Data da Consolidação**: {{data_atual}}
**Documentos Consolidados**: {{numero}} documentos
**Arquivos Originais**: {{lista_arquivos}}
**Período**: {{data_modificacao_mais_antiga}} - {{data_modificacao_mais_recente}}

{{conteudo_da_consolidacao}}
```

## 📤 Output Esperado

O comando deve produzir:

1. **Consolidação Completa** seguindo template estruturado
2. **Análise de Conteúdo** com tema principal identificado
3. **Divergências Identificadas** com recomendações de resolução
4. **Convergências Identificadas** para capitalizar consistência
5. **Insights Estratégicos** não explícitos
6. **Gaps de Informação** identificados
7. **Estrutura Otimizada** proposta
8. **Principais Pontos de Atenção** priorizados
9. **Recomendações Estratégicas** acionáveis
10. **Documento Consolidado** salvo em local apropriado

## 🔗 Referências

- **Comando Relacionado**: $product-consolidate-meetings (consolidação de reuniões)
- **Comandos de Documentação**: $docs-build-tech-docs, $docs-build-business-docs
- **Validação**: $docs-validate-docs

## ⚠️ Notas Importantes

### Regras Críticas

1. **Sempre validar arquivos** antes de processar
2. **Sempre coletar metadados** quando disponíveis
3. **Sempre identificar foco** se especificado
4. **Sempre salvar output** em local apropriado
5. **Sempre preservar referências** aos documentos originais
6. **Sempre identificar divergências** críticas
7. **Sempre propor estrutura** otimizada

### Quando Usar Este Comando

Use `$docs-consolidate-documents` quando:

- Há múltiplos documentos sobre o mesmo tema
- Necessita identificar padrões entre documentos
- Quer descobrir divergências ou convergências
- Precisa de insights estratégicos não explícitos
- Quer identificar gaps de informação
- Necessita visão consolidada de múltiplos documentos
- Quer criar documento unificado a partir de múltiplas fontes
- Precisa identificar inconsistências entre documentos

### Exemplos de Uso

```bash
# Consolidar todos os documentos de uma pasta
$docs-consolidate-documents "docs/business-context/"

# Consolidar arquivos específicos
$docs-consolidate-documents "docs/business-context/CUSTOMER_JOURNEY.md docs/business-context/CUSTOMER_PERSONAS.md docs/business-context/CUSTOMER_COMMUNICATION.md"

# Foco em divergências
$docs-consolidate-documents "docs/business-context/" --focus="divergences"

# Foco em insights estratégicos
$docs-consolidate-documents "docs/gamification/" --focus="insights"

# Foco em gaps de informação
$docs-consolidate-documents "docs/meet/gamification-meetings/" --focus="gaps"

# Foco em estrutura otimizada
$docs-consolidate-documents "docs/business-context/" --focus="structure"

# Especificar caminho de saída
$docs-consolidate-documents "docs/business-context/" --output_path="docs/consolidated/business-context/"
```

### Focos Disponíveis

| Foco | Descrição |
|------|-----------|
| `all` | Consolidação completa (padrão) |
| `divergences` | Apenas divergências e conflitos |
| `convergences` | Apenas convergências e alinhamentos |
| `insights` | Apenas insights estratégicos |
| `gaps` | Apenas gaps de informação |
| `structure` | Apenas estrutura e organização otimizada |

### Estrutura do Documento Consolidado

O documento consolidado deve seguir esta estrutura:

```markdown
# Consolidação de Documentos: [Tema Principal]

**Data da Consolidação**: [data]
**Documentos Consolidados**: [número] documentos
**Arquivos Originais**: [lista]
**Período**: [data mais antiga] - [data mais recente]

## 📋 Índice
1. [Análise de Conteúdo](#analise-conteudo)
2. [Divergências Identificadas](#divergencias)
3. [Convergências Identificadas](#convergencias)
4. [Insights Estratégicos](#insights)
5. [Gaps de Informação](#gaps)
6. [Estrutura Otimizada](#estrutura)
7. [Principais Pontos de Atenção](#pontos-atencao)
8. [Recomendações Estratégicas](#recomendacoes)

## 📊 Análise de Conteúdo
[Tema principal e informações-chave]

## ⚠️ Divergências Identificadas
[Conflitos e desalinhamentos]

## ✅ Convergências Identificadas
[Pontos de alinhamento]

## 💡 Insights Estratégicos
[Padrões e conexões]

## 🔍 Gaps de Informação
[Informações faltantes]

## 📐 Estrutura Otimizada
[Organização proposta]

## 🎯 Principais Pontos de Atenção
[Priorizados por criticidade]

## 💡 Recomendações Estratégicas
[Ações sugeridas]
```

## 🎯 Checklist de Validação

Antes de considerar a consolidação completa, verificar:

- [ ] Arquivos de documentos identificados e validados
- [ ] Metadados coletados quando disponíveis
- [ ] Análise de conteúdo realizada
- [ ] Divergências identificadas
- [ ] Convergências identificadas
- [ ] Insights estratégicos gerados
- [ ] Gaps de informação identificados
- [ ] Estrutura otimizada proposta
- [ ] Principais pontos de atenção priorizados
- [ ] Recomendações estratégicas fornecidas
- [ ] Output salvo em local apropriado
- [ ] Referências aos documentos originais preservadas

---

**Última Atualização**: 2025-12-01  
**Versão**: 3.0.0  
**Baseado em**: $product-consolidate-meetings
