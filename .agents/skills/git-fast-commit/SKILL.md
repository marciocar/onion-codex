---
name: git-fast-commit
description: |
  Adiciona todas as mudanças e faz commit rápido.
  Use para commits típicos no fluxo do Sistema Onion.
---

> **Input:** use o texto fornecido pelo usuário ao invocar esta skill.

# Fast Commit

Adiciona todas as mudanças e faz commit com mensagem especificada.

## 🎯 Uso

```bash
$git-fast-commit "feat: implement admin dashboard basic flow"
```

## ⚡ Fluxo de Execução

1. `git add .` — adiciona todas as mudanças
2. `git commit -m "<mensagem>"` — commit com a mensagem

## 📋 Convenção de Mensagens

Use [Conventional Commits](https://conventionalcommits.org):

| Tipo | Descrição |
|------|-----------|
| `feat:` | Nova funcionalidade |
| `fix:` | Correção de bug |
| `docs:` | Documentação |
| `refactor:` | Refatoração |
| `chore:` | Manutenção |

## ⚠️ Notas

- SEMPRE revise `git status` antes
- Prefira commits atômicos e descritivos
