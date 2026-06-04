---
name: git-release-start
description: Iniciar release branch com versionamento e changelog.
---

# 🚀 Git Flow - Iniciar Release

Iniciar processo de release criando branch de release com versionamento automático, preparação de changelog e validações pré-release. Workflow completo para gestão segura de releases seguindo padrões GitFlow.

## 🎯 Funcionalidades

### Release Workflow e Versionamento
- Criação de release branch a partir de develop branch
- Auto-detecção e bump inteligente de versionamento (semver)
- Preparação automática de changelog baseada em commits
- Validações de estado pré-release (working directory, conflicts)
- Setup de task de release tracking no Task Manager configurado (condicional — somente se `TASK_MANAGER_PROVIDER` != `none`; suporta Jira, ClickUp, Asana, Linear)

### Versionamento Inteligente e Automação
- Detecção automática de package.json e version files
- Bump semântico (major.minor.patch) com validation
- Support para diferentes tipos de projeto e convenções
- Validações de tag conflicts e branch state
- Integration com @gitflow-specialist para release strategy

### Validações e Safety-First
- Verificações de repository state e uncommitted changes
- Primary branch detection (main/master) automática
- Develop branch sync validation antes da release
- Release branch creation com error handling robusto
- Educational guidance durante processo de release

## 🚀 Como Usar

```bash
$git-release-start "v2.1.0"           # Release com versão específica  
$git-release-start "2.1.0"            # Versão sem prefixo v
$git-release-start "patch"            # Auto-bump patch (2.0.1 → 2.0.2)
$git-release-start "minor"            # Auto-bump minor (2.0.1 → 2.1.0) 
$git-release-start "major"            # Auto-bump major (2.0.1 → 3.0.0)
```

**Pré-requisitos**: Working directory limpo, develop branch disponível

### Processo Executado
1. **Validações**: Verifica repository state, versão fornecida, working directory
2. **Branch Detection**: Detecta primary branch (main/master) e develop
3. **Version Processing**: Processa versioning (específica ou auto-bump)
4. **Release Branch**: Cria release/version branch a partir de develop
5. **Task Manager Setup** (condicional): Se `TASK_MANAGER_PROVIDER` != `none`, cria task de release tracking e atualiza status no provider ativo (ex.: ClickUp, Jira, Asana, Linear); caso contrário, etapa é ignorada
6. **Changelog Prep**: Prepara changelog baseado em commits desde última release

### Version Bump Intelligence
Durante execução, processa diferentes tipos de versionamento:
- Versões explícitas: Valida formato semver e disponibilidade
- Auto-bump: Detecta última tag e incrementa conforme tipo
- Project detection: Identifica package.json, version files, etc.
- Conflict prevention: Verifica tags existentes antes de proceder

## 🤝 Integração @gitflow-specialist

*Este comando sempre consulta @gitflow-specialist para release strategy validation, version bump analysis, branch creation guidance e troubleshooting de release workflows complexos.*

## ⚠️ Resolução de Problemas

### Version Required Error
- **Sintoma**: Comando executado sem especificar versão
- **Solução**: Fornecer versão específica ou tipo de bump (patch/minor/major)

### Uncommitted Changes
- **Causa**: Working directory não está limpo antes da release
- **Fix**: `git add . && git commit -m "prepare for release"` antes de iniciar

### Develop Branch Not Found
- **Sintoma**: Develop branch não existe ou não está disponível
- **Solução**: `git checkout -b develop` ou `git fetch origin develop`

### Version Already Exists
- **Causa**: Tag ou branch de release já existe para versão especificada
- **Fix**: Usar versão diferente ou limpar tags/branches conflitantes

### Primary Branch Detection Issues
- **Sintoma**: Não consegue detectar main/master branch
- **Solução**: Comando detecta automaticamente via @gitflow-specialist guidance

### Release Branch Creation Failed
- **Causa**: Problemas durante criação da branch de release
- **Fix**: @gitflow-specialist fornece strategy específica para resolução
