---
name: git-help
description: Ajuda contextual para comandos GitFlow do Sistema Onion.
---

# 🆘 Git Flow - Sistema de Ajuda

Fornecer ajuda contextual e interativa para todos os comandos GitFlow do Sistema Onion. Detectar automaticamente o estado atual do repositório e sugerir próximos passos apropriados.

## 🎯 Funcionalidades

### Detecção Inteligente de Contexto
- Verificar se Git Flow está inicializado no repositório atual
- Identificar branch ativa e sugerir workflows apropriados  
- Detectar estado do projeto e recomendar próximos passos
- Integração com @gitflow-specialist para guidance avançada

### Sistema de Ajuda Estruturado
- **Help geral**: Visão completa de todos os comandos disponíveis
- **Help específico**: Documentação detalhada por comando individual
- **Troubleshooting**: Soluções para problemas comuns
- **Quick reference**: Comandos essenciais por situação

## 🚀 Como Usar

```bash
$git-help                    # Help completo interativo
$git-help feature           # Ajuda específica para features
$git-help release           # Ajuda específica para releases  
$git-help hotfix            # Ajuda específica para hotfixes
$git-help init              # Ajuda para inicialização
```

## 🤖 Integração com @gitflow-specialist

Para cada solicitação de ajuda:

1. **Consultar @gitflow-specialist** para análise contextual do repositório
2. **Receber guidance** específica baseada no estado atual
3. **Apresentar recomendações** personalizadas para o desenvolvedor  
4. **Fornecer exemplos práticos** para a situação detectada

## 📋 Comandos Disponíveis

### Setup e Inicialização
- `$git-init` - Configurar Git Flow no repositório
- `$git-help` - Este sistema de ajuda

### Workflow de Features
- `$git-feature-start "nome"` - Iniciar nova feature
- `$git-feature-finish` - Finalizar e mergear feature
- `$git-feature-publish` - Compartilhar feature em desenvolvimento

### Workflow de Releases
- `$git-release-start "versão"` - Iniciar processo de release
- `$git-release-finish` - Finalizar e deployar release

### Workflow de Hotfixes
- `$git-hotfix-start "nome"` - Iniciar correção urgente
- `$git-hotfix-finish` - Finalizar e deployar hotfix

### Sincronização
- `$git-sync [branch]` - Sincronizar após merge de PR

## ⚠️ Troubleshooting Comum

### Repository não inicializado
**Problema**: Git Flow não configurado
**Solução**: Execute `$git-init` para configuração automática

### Branch errada
**Problema**: Não está na branch correta para operação
**Solução**: Use comandos Git Flow que fazem checkout automaticamente  

### Conflitos de merge
**Problema**: Conflitos durante operações GitFlow
**Solução**: Resolva conflitos manualmente e continue com comando finish

### Estado inconsistente
**Problema**: Operação GitFlow interrompida
**Solução**: Consulte @gitflow-specialist para análise e recovery

## 💡 Próximos Passos Sugeridos

O sistema detectará automaticamente sua situação atual e sugerirá:

- **Se Git Flow não inicializado**: `$git-init`
- **Se em develop**: `$git-feature-start "nome-da-feature"`  
- **Se em feature branch**: `$git-feature-finish` ou `$git-feature-publish`
- **Se pronto para release**: `$git-release-start "versão"`
- **Se problema em produção**: `$git-hotfix-start "correção"`

---

*Este comando sempre consulta @gitflow-specialist para fornecer guidance contextual e personalizada.*
