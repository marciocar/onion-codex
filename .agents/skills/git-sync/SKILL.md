---
name: git-sync
description: |
  Sincronização automática de branches com GitFlow e proteção de branches críticas.
  Use após merge de PRs para manter branches atualizadas.
---

# 🔄 Git Sync - Sincronização com GitFlow

Sincronização pós-merge de branches com proteção automática.

## 🎯 Objetivo

Automatizar sincronização após merge de PRs seguindo GitFlow.

## 🛡️ Branches Protegidas

| Branch | Push Direto | Fast-Forward |
|--------|-------------|--------------|
| `main` | ❌ Bloqueado | ✅ Permitido |
| `master` | ❌ Bloqueado | ✅ Permitido |
| `develop` | ❌ Bloqueado | ✅ Permitido |

## ⚡ Fluxo de Execução

### Passo 1: Detectar Contexto

```bash
# Branch atual
CURRENT=$(git branch --show-current)

# Target branch
TARGET="${{branch:-develop}}"

# Verificar se target é protegida
if [[ "$TARGET" =~ ^(main|master|develop)$ ]]; then
  PROTECTED=true
fi
```

### Passo 2: Validar Estado

```bash
# Verificar alterações não commitadas
if [[ -n $(git status --porcelain) ]]; then
  echo "⚠️ Alterações não commitadas"
  echo "Commit ou stash antes de continuar"
  exit 1
fi

# Fetch remoto
git fetch origin --prune
```

### Passo 3: Análise GitFlow

Consultar @gitflow-specialist para estratégia:

| Branch Atual | Target | Estratégia |
|--------------|--------|------------|
| `feature/*` | `develop` | `feature-cleanup` |
| `release/*` | `main` | `release-sync` |
| `hotfix/*` | `main` | `hotfix-sync` |
| `develop` | `main` | `protected-sync` |

Referência: `docs/onion/shared/git-workflow-patterns.md`

### Passo 4: Executar Sync

#### Para Branches Normais

```bash
git checkout $TARGET
git pull origin $TARGET
git checkout $CURRENT
git merge $TARGET --no-edit
```

#### Para Branches Protegidas

```bash
# Apenas fast-forward permitido
git checkout $TARGET
git merge origin/$TARGET --ff-only

# Se falhar, instruir PR workflow
if [[ $? -ne 0 ]]; then
  echo "❌ Fast-forward não possível"
  echo "Use PR workflow: $engineer-pr"
fi
```

### Passo 5: Cleanup (se feature finalizada)

```bash
# Se branch feature foi merged
if git branch -r | grep -q "origin/$CURRENT"; then
  echo "Branch $CURRENT ainda existe no remote"
else
  echo "✅ Branch $CURRENT deletada no remote"
  # Perguntar se quer deletar local
fi
```

### Passo 6: Atualizar ClickUp

SE sessão ativa com task_id:
- Comentário de sync realizado
- Atualizar status se necessário

## 📤 Output Esperado

### Sync Sucesso

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYNC CONCLUÍDO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Resumo:
∟ Branch atual: feature/user-auth
∟ Sincronizado com: develop
∟ Commits atualizados: 5
∟ Conflitos: 0

🚀 Próximo: $engineer-work
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Branch Protegida - Bloqueio

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛡️ BRANCH PROTEGIDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Push direto em 'develop' bloqueado

📋 Workflow Correto:
1. git checkout -b feature/my-changes
2. [fazer alterações]
3. $engineer-pr
4. [merge via GitHub/GitLab]
5. $git-sync develop
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Conflito Detectado

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ CONFLITOS DETECTADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Arquivos em conflito:
∟ src/components/Button.tsx
∟ src/utils/helpers.ts

💡 Resolução:
1. Editar arquivos manualmente
2. git add [arquivos]
3. git commit
4. $git-sync (novamente)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🔗 Referências

- Padrões: `docs/onion/shared/git-workflow-patterns.md`
- Agente: @gitflow-specialist

## ⚠️ Notas

- Sempre fazer `git fetch` antes
- Branches protegidas só aceitam fast-forward
- Em caso de conflito, resolver manualmente
