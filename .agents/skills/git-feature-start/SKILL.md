---
name: git-feature-start
description: Iniciar feature branch GitFlow com ambiente configurado.
---

# 🌿 Git Flow - Iniciar Feature

Iniciar desenvolvimento de uma nova funcionalidade criando uma branch GitFlow apropriada e configurando ambiente de desenvolvimento. Integração obrigatória com @gitflow-specialist para guidance especializada.

## 🎯 Funcionalidades

### Criação Inteligente de Feature Branch
- Criar branch GitFlow no formato `feature/nome-da-funcionalidade`
- Detectar automaticamente branch base apropriada (develop/main)
- Validar nomenclatura seguindo convenções GitFlow
- Configurar tracking com repositório remoto quando disponível

### Integração com @gitflow-specialist
- Consultar especialista para análise do repositório atual
- Receber estratégia de branching personalizada
- Validar compliance com workflows da equipe
- Guidance contextual para desenvolvimento

### Session Management Automático
- Criar diretório `.codex/sessions/<feature-slug>/` automaticamente
- Gerar `context.md` com metadados da feature
- Criar `plan.md` com template de desenvolvimento
- Integração opcional com ClickUp tasks existentes

## 🚀 Como Usar

```bash
$git-feature-start "nome-da-funcionalidade"
```

### Exemplos de Nomenclatura
```bash
$git-feature-start "implement-oauth-authentication"
$git-feature-start "add-user-dashboard-filters"  
$git-feature-start "fix-payment-validation"
$git-feature-start "update-api-documentation"
```

## 🤖 Integração com @gitflow-specialist

Para cada nova feature:

1. **Consultar @gitflow-specialist** para análise do estado atual do repositório
2. **Receber estratégia** de criação de branch baseada no contexto
3. **Validar nomenclatura** e compliance com padrões da equipe
4. **Executar criação** seguindo as recomendações do especialista
5. **Configurar ambiente** de desenvolvimento otimizado

## 📋 Processo de Criação

### Validações Pré-Criação
- **Parameter check**: Verificar se nome da feature foi fornecido
- **Repository check**: Confirmar que GitFlow está inicializado  
- **Status check**: Garantir working directory limpo
- **Naming validation**: Validar convenções de nomenclatura

### Criação da Branch
- **Base detection**: Identificar branch base apropriada (develop)
- **Branch creation**: Criar `feature/nome` baseada na develop
- **Remote setup**: Configurar tracking se repositório remoto disponível
- **Checkout**: Trocar para a nova branch automaticamente

### Setup do Ambiente
- **Session creation**: Criar estrutura `.codex/sessions/`
- **Context setup**: Gerar arquivos de contexto e planejamento
- **ClickUp integration**: Conectar com tasks existentes se detectadas
- **Development ready**: Ambiente pronto para desenvolvimento

## ⚙️ Estrutura Criada

### Branch GitFlow
```
feature/nome-da-funcionalidade ← nova branch
├── baseada em: develop (branch de desenvolvimento)  
├── tracking: origin/feature/nome (se remoto disponível)
└── estado: pronta para desenvolvimento
```

### Session Directory
```
.codex/sessions/nome-da-funcionalidade/
├── context.md          # Metadados e objetivos da feature
├── plan.md            # Plano de desenvolvimento estruturado  
├── notes.md           # Notas de desenvolvimento
└── (outros arquivos conforme necessário)
```

## ✅ Resultado da Execução

Após execução bem-sucedida:

- ✅ **Feature branch criada** no padrão GitFlow
- ✅ **Branch checkout realizado** automaticamente
- ✅ **Session configurada** com estrutura completa
- ✅ **Ambiente pronto** para desenvolvimento
- ✅ **Próximos passos** fornecidos contextualmente

## 🔄 Fluxo de Desenvolvimento Sugerido

Após criar a feature:

1. **Desenvolvimento**: Implementar funcionalidade na branch criada
2. **Commits frequentes**: Usar conventional commits para histórico limpo
3. **Push regular**: `git push` para backup e colaboração  
4. **Compartilhamento**: `$git-feature-publish` para code review
5. **Finalização**: `$git-feature-finish` quando completo

## ⚠️ Tratamento de Problemas

### GitFlow não inicializado
**Problema**: Repository não tem GitFlow configurado
**Solução**: Execute `$git-init` primeiro para configurar GitFlow

### Nome de feature inválido
**Problema**: Nome não segue convenções ou contém caracteres inválidos
**Solução**: Use nomes descritivos em kebab-case (letras, números, hífen)

### Working directory não limpo
**Problema**: Há mudanças não commitadas no repositório
**Solução**: Commit ou stash mudanças antes de criar nova feature

### Feature branch já existe
**Problema**: Já existe branch com mesmo nome
**Solução**: Use nome diferente ou finalize feature existente primeiro

### Branch develop não encontrada
**Problema**: Branch develop não existe (GitFlow mal configurado)
**Solução**: @gitflow-specialist fornecerá estratégia de resolução

## 💡 Melhores Práticas

### Nomenclatura de Features
- **Descritiva**: Nome deve explicar claramente a funcionalidade
- **Kebab-case**: Use hífens para separar palavras
- **Concisa**: Evite nomes muito longos, máximo 50 caracteres
- **Sem prefixos**: Não usar "feature-" pois já está no path da branch

### Desenvolvimento
- **Commits atômicos**: Commits pequenos e focados
- **Conventional commits**: Seguir padrão (feat:, fix:, docs:, etc.)
- **Push frequente**: Backup regular do trabalho
- **Testes**: Implementar testes conforme desenvolvimento

---

*Este comando sempre consulta @gitflow-specialist para garantir criação otimizada e compliance com padrões da equipe.*
