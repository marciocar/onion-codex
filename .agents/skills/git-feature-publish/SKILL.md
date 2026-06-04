---
name: git-feature-publish
description: Publicar feature branch no remote para colaboração.
---

# 🤝 Git Flow - Publicar Feature

Publicar feature branch para remote repository permitindo colaboração em equipe com setup automático de tracking, validações de readiness e integração com o Task Manager configurado (se houver) para team awareness e code review workflow.

## 🎯 Funcionalidades

### Team Collaboration e Sharing
- Push seguro da feature branch para remote origin
- Setup automático de upstream tracking para colaboração
- Validações de collaboration readiness (tests, commits, documentation)
- Team notification integration via atualização de status no Task Manager configurado (condicional — somente se `TASK_MANAGER_PROVIDER` != `none`)
- Code review preparation automática

### Git Flow Compliance e Automação  
- Publicação seguindo padrão oficial GitFlow (feature → remote)
- Automatic branch tracking configuration
- Atualização de status da task para "In Review" no Task Manager configurado (condicional — somente se `TASK_MANAGER_PROVIDER` != `none`; suporta Jira, ClickUp, Asana, Linear)
- Team guidance para next steps após publicação
- Integration com workflows de code review

### Educational e Team UX
- Context display mostrando impacto da publicação na equipe
- Progress indicators durante operações de remote
- Educational content sobre feature collaboration
- Team guidance e best practices para colaboração

## 🚀 Como Usar

```bash
$git-feature-publish                   # Publica branch atual (se feature)
$git-feature-publish feature-name     # Publica feature específica
```

**Pré-requisitos**: Branch deve existir localmente e ser uma feature branch

### Processo Executado
1. **Validation**: Verifica se é feature branch e se está ready para publicação
2. **Readiness Check**: Valida tests, commits, working directory
3. **Remote Setup**: Configura upstream tracking se necessário
4. **Push**: Executa push seguro para remote origin
5. **Task Manager Update** (condicional): Se `TASK_MANAGER_PROVIDER` != `none`, atualiza status para "In Review" no provider ativo (ex.: ClickUp, Jira, Asana, Linear) e notifica team; caso contrário, etapa é ignorada
6. **Team Guidance**: Fornece next steps para code review workflow

### Team Collaboration Features
Durante execução, facilita colaboração em equipe:
- Automatic remote branch creation se não existir
- Team notification via Task Manager configurado (condicional — somente se `TASK_MANAGER_PROVIDER` != `none`)
- Code review readiness validation
- Next steps guidance para collaboration workflow

## 🤝 Integração @gitflow-specialist

*Este comando sempre consulta @gitflow-specialist para validação de remote operations, configuração de tracking, análise de readiness para team collaboration e guidance para code review preparation.*

## ⚠️ Resolução de Problemas

### Feature Branch Não Encontrada
- **Sintoma**: Branch especificada não existe localmente
- **Solução**: `git checkout -b feature/name` ou usar branch existente

### Not on Feature Branch
- **Causa**: Branch atual não é uma feature branch
- **Fix**: `git checkout feature/name` ou especificar feature-name no comando

### Remote Already Exists
- **Sintoma**: Branch já existe no remote com divergências
- **Solução**: `git pull origin feature/name` para sincronizar antes de publicar

### Tests Failing
- **Sintoma**: Validation detecta testes falhando
- **Solução**: Corrigir testes antes da publicação para manter qualidade da team

### Working Directory Not Clean
- **Causa**: Uncommitted changes impedem publicação segura
- **Fix**: `git add . && git commit -m "changes"` antes de publicar

### Remote Tracking Issues
- **Sintoma**: Problemas de configuração de upstream tracking
- **Solução**: Comando configura automaticamente via @gitflow-specialist
