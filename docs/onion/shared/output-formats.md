# Formatos de Saída Padronizados

## 📤 Estrutura Geral

### Header de Comando

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 [NOME DO COMANDO]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Footer de Comando

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Comando executado com sucesso
🚀 Próximo: /category/comando
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ✅ Sucesso

### Simples

```
✅ [Ação] concluída com sucesso
```

### Com Detalhes

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SUCESSO - [Nome da Operação]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Resumo:
∟ Criados: X arquivos
∟ Modificados: Y arquivos
∟ Tempo: Zs

📁 Arquivos:
∟ path/to/new-file.md (criado)
∟ path/to/modified.md (atualizado)

🚀 Próximos Passos:
1. [Ação 1]
2. [Ação 2]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ❌ Erro

### Simples

```
❌ Erro: [Descrição breve]
```

### Com Contexto

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ ERRO - [Nome da Operação]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Causa:
[Descrição do que causou o erro]

💡 Solução:
[Instruções para resolver]

📚 Referência:
- Comando: /category/help
- Docs: docs/troubleshooting.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 📊 Tabelas

### Simples

```markdown
| Coluna 1 | Coluna 2 | Coluna 3 |
|----------|----------|----------|
| Valor 1  | Valor 2  | Valor 3  |
```

### Com Status

```markdown
| Item | Status | Detalhes |
|------|--------|----------|
| Item 1 | ✅ | Concluído |
| Item 2 | 🚧 | Em progresso |
| Item 3 | ⏳ | Pendente |
| Item 4 | ❌ | Erro |
```

---

## 📋 Listas

### Checklist

```markdown
- [x] Item concluído
- [ ] Item pendente
- [~] Item parcial
```

### Hierárquica

```markdown
📋 Principal
├── 🔧 Sub-item 1
│   ├── ✅ Detalhe 1.1
│   └── ✅ Detalhe 1.2
├── 🔧 Sub-item 2
│   └── ⏳ Detalhe 2.1
└── 🔧 Sub-item 3
```

### Progresso

```markdown
📊 Progresso: 3/5 (60%)
▓▓▓▓▓▓░░░░ 60%

✅ Fase 1: Concluída
✅ Fase 2: Concluída  
✅ Fase 3: Concluída
🚧 Fase 4: Em progresso
⏳ Fase 5: Pendente
```

---

## 🔄 Fluxos

### Workflow Vertical

```markdown
┌─────────────┐
│  Início     │
└──────┬──────┘
       ▼
┌─────────────┐
│  Passo 1    │
└──────┬──────┘
       ▼
┌─────────────┐
│  Passo 2    │
└──────┬──────┘
       ▼
┌─────────────┐
│    Fim      │
└─────────────┘
```

### Decisão

```markdown
           ┌───────────────┐
           │   Condição?   │
           └───────┬───────┘
          ┌────────┴────────┐
          ▼                 ▼
     ┌────────┐        ┌────────┐
     │  Sim   │        │  Não   │
     └────────┘        └────────┘
```

---

## 📁 Estrutura de Arquivos

### Árvore

```
project/
├── src/
│   ├── components/
│   │   └── Button.tsx
│   └── utils/
│       └── helpers.ts
├── docs/
│   └── README.md
└── package.json
```

### Lista com Ações

```markdown
📁 Arquivos Criados:
∟ ✅ src/new-file.ts (45 linhas)
∟ ✅ docs/new-doc.md (120 linhas)

📁 Arquivos Modificados:
∟ 📝 src/index.ts (+15, -3 linhas)
∟ 📝 README.md (+5 linhas)

📁 Arquivos Removidos:
∟ 🗑️ src/deprecated.ts
```

---

## 💡 Dicas e Notas

### Tip

```markdown
💡 **Dica**: [Conteúdo da dica]
```

### Warning

```markdown
⚠️ **Atenção**: [Conteúdo do aviso]
```

### Info

```markdown
ℹ️ **Info**: [Conteúdo informativo]
```

### Important

```markdown
🔴 **Importante**: [Conteúdo crítico]
```

