# Padrões de Workflow Git

## 🌳 Branch Strategy (GitFlow)

### Branches Principais

```
main ─────────────────────────────────► (produção)
  │
develop ──────────────────────────────► (integração)
  │
  ├── feature/xxx ────────────────────► (desenvolvimento)
  ├── release/x.x.x ──────────────────► (preparação release)
  └── hotfix/xxx ─────────────────────► (correção urgente)
```

### Nomenclatura

| Tipo | Formato | Exemplo |
|------|---------|---------|
| Feature | `feature/nome-descritivo` | `feature/user-auth` |
| Release | `release/x.x.x` | `release/1.2.0` |
| Hotfix | `hotfix/nome-descritivo` | `hotfix/login-fix` |
| Bugfix | `bugfix/nome-descritivo` | `bugfix/form-validation` |

---

## 📝 Commit Patterns

### Conventional Commits

```
<type>(<scope>): <description>

[body]

[footer]
```

### Types

| Type | Uso | Emoji |
|------|-----|-------|
| `feat` | Nova feature | ✨ |
| `fix` | Bug fix | 🐛 |
| `docs` | Documentação | 📚 |
| `style` | Formatação | 🎨 |
| `refactor` | Refatoração | ♻️ |
| `perf` | Performance | ⚡ |
| `test` | Testes | 🧪 |
| `chore` | Manutenção | 🔧 |
| `ci` | CI/CD | 👷 |

### Exemplos

```bash
# Feature
feat(auth): add OAuth2 login support

# Fix
fix(form): resolve validation on empty fields

# Docs
docs(readme): update installation instructions

# Breaking change
feat(api)!: change response format

BREAKING CHANGE: API response now uses camelCase
```

---

## 🔄 Workflows Comuns

### Feature Development

```bash
# 1. Criar branch
git checkout develop
git pull origin develop
git checkout -b feature/my-feature

# 2. Desenvolver com commits atômicos
git add .
git commit -m "feat(scope): description"

# 3. Manter atualizado
git fetch origin develop
git rebase origin/develop

# 4. Push e PR
git push origin feature/my-feature
```

### Release

```bash
# 1. Criar release branch
git checkout develop
git checkout -b release/1.2.0

# 2. Preparar release
# - Bump version
# - Update changelog
# - Final fixes

# 3. Merge para main
git checkout main
git merge release/1.2.0 --no-ff

# 4. Tag
git tag -a v1.2.0 -m "Release 1.2.0"
git push origin v1.2.0

# 5. Merge back para develop
git checkout develop
git merge release/1.2.0 --no-ff
```

### Hotfix

```bash
# 1. Criar de main
git checkout main
git checkout -b hotfix/critical-fix

# 2. Fix rápido
git commit -m "fix(scope): critical bug description"

# 3. Merge para main
git checkout main
git merge hotfix/critical-fix --no-ff
git tag -a v1.2.1 -m "Hotfix 1.2.1"

# 4. Merge para develop
git checkout develop
git merge hotfix/critical-fix --no-ff
```

---

## 🔀 Merge Strategies

### Feature → Develop

```bash
# Squash merge (preferido para features)
git merge feature/xxx --squash
git commit -m "feat(scope): feature description (#PR)"

# Ou merge regular para histórico completo
git merge feature/xxx --no-ff
```

### Develop → Main

```bash
# Sempre no-ff para preservar histórico
git merge develop --no-ff -m "Release v1.2.0"
```

---

## 📋 PR Template

```markdown
## 📝 Descrição
[O que esta PR faz]

## 🎯 Tipo de Mudança
- [ ] 🐛 Bug fix
- [ ] ✨ Nova feature
- [ ] 💥 Breaking change
- [ ] 📚 Documentação
- [ ] ♻️ Refatoração

## ✅ Checklist
- [ ] Código segue padrões do projeto
- [ ] Testes adicionados/atualizados
- [ ] Documentação atualizada
- [ ] Self-review realizado

## 🔗 Issues Relacionadas
Closes #[número]

## 📸 Screenshots (se aplicável)
[Imagens]
```

---

## 🏷️ Versionamento

### Semver

```
MAJOR.MINOR.PATCH

1.0.0 → 1.0.1 (patch: bug fix)
1.0.1 → 1.1.0 (minor: nova feature)
1.1.0 → 2.0.0 (major: breaking change)
```

### Pre-release

```
1.0.0-alpha.1
1.0.0-beta.1
1.0.0-rc.1
1.0.0
```

---

## 🚨 Comandos de Emergência

```bash
# Desfazer último commit (mantém alterações)
git reset --soft HEAD~1

# Desfazer alterações em arquivo
git checkout -- path/to/file

# Cancelar merge em andamento
git merge --abort

# Cancelar rebase em andamento
git rebase --abort

# Recuperar commit perdido
git reflog
git checkout <commit-hash>
```

