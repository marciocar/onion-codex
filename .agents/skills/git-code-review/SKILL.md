---
name: git-code-review
description: |
  Gerenciador de ChatGPT-CodeReview para setup, validação e otimização.
  Use para configurar code review automático em projetos.
---

# 🤖 ChatGPT Code Review Manager

Gerenciador inteligente de ChatGPT-CodeReview para o Sistema Onion.

## 🎯 Objetivo

Automatizar setup, validação e otimização do code review automático.

## ⚡ Modos de Operação

```bash
$git-code-review           # AUTO: detecta e executa ação apropriada
$git-code-review setup     # Criar/reconfigurar arquivo
$git-code-review validate  # Validar configuração existente  
$git-code-review status    # Mostrar status atual
```

## 🔄 Fluxo de Execução

### Passo 1: Detectar Modo

```bash
# Verificar se code-review.yml existe
test -f .github/workflows/code-review.yml && MODE="validate" || MODE="setup"
```

SE `{{mode}}` fornecido → usar modo especificado
SENÃO → usar detecção automática

### Passo 2: Executar Modo

#### 🆕 SETUP MODE

1. **Detectar Stack**
   ```bash
   # Package manager
   test -f pnpm-lock.yaml && PM="pnpm"
   test -f package-lock.json && PM="npm"
   
   # Monorepo
   test -f nx.json && MONO="nx"
   
   # Backend/Frontend
   grep -q "fastify" package.json && BACKEND="fastify"
   grep -q "react" package.json && FRONTEND="react"
   ```

2. **Gerar Template**
   Criar `.github/workflows/code-review.yml`:
```yaml
   name: ChatGPT Code Review

on:
  pull_request:
       types: [opened, synchronize]

jobs:
     review:
    runs-on: ubuntu-latest
    steps:
         - uses: actions/checkout@v4
         - uses: anc95/ChatGPT-CodeReview@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
   ```

3. **Aplicar Configurações por Stack**
   - TypeScript → adicionar regras de tipos
   - React → regras de hooks
   - NX → regras de monorepo

#### 🔍 VALIDATE MODE

1. **Verificar Arquivo**
   - Existe?
   - YAML válido?
   - Secrets configurados?

2. **Analisar Configuração**
   Usar checklist de `docs/onion/shared/code-review-checklist.md`

3. **Gerar Relatório**
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   📊 CODE REVIEW VALIDATION
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   ✅ Arquivo: .github/workflows/code-review.yml
   ✅ YAML: Válido
   ⚠️ Secrets: OPENAI_API_KEY não detectado
   
   💡 Recomendações:
   ∟ Configurar OPENAI_API_KEY em Settings > Secrets
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

#### 📊 STATUS MODE

Mostrar dashboard:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 CODE REVIEW STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 Configuração:
∟ Arquivo: ✅ Configurado
∟ Stack: TypeScript + React + NX
∟ Última atualização: 2025-11-24

📈 Métricas (últimos 30 dias):
∟ PRs revisados: 45
∟ Issues detectados: 127
∟ Auto-fixes aplicados: 23

🎯 Saúde: 95% ████████████░░░░░
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Passo 3: Atualizar ClickUp

SE há task associada:
- Adicionar comentário com resultado
- Atualizar status se necessário

## 📤 Output Esperado

### Setup Sucesso

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ CODE REVIEW CONFIGURADO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Criado: .github/workflows/code-review.yml

🔧 Stack Detectado:
∟ Package Manager: pnpm
∟ Monorepo: NX
∟ Backend: Fastify
∟ Frontend: React

⚠️ Próximos Passos:
1. Configurar OPENAI_API_KEY em Settings > Secrets
2. Testar com um PR de teste

🚀 Comando: $git-code-review validate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Validação com Issues

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ CODE REVIEW - ISSUES ENCONTRADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 Críticos:
∟ Secret OPENAI_API_KEY não configurado

🟡 Importantes:
∟ Versão do action desatualizada (usar @v1.2.0)

💡 Sugestões:
∟ Adicionar filtro de arquivos .ts/.tsx

🔧 Auto-fix disponível? Sim
Executar auto-fix? (s/n)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🔗 Referências

- Checklist: `docs/onion/shared/code-review-checklist.md`
- Padrões Git: `docs/onion/shared/git-workflow-patterns.md`
- Agente: @code-reviewer para reviews manuais

## ⚠️ Notas

- Requer GitHub Actions habilitado
- Secret `OPENAI_API_KEY` obrigatório
- Funciona com qualquer stack JavaScript/TypeScript
