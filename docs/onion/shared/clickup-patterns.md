# Padrões de Formatação ClickUp

## 📋 Task Descriptions (Markdown)

### Estrutura Padrão

```markdown
## 🎯 Objetivo
[Descrição clara do objetivo em 1-2 parágrafos]

## 📋 Requisitos
- [ ] Requisito 1
- [ ] Requisito 2
- [ ] Requisito 3

## ✅ Critérios de Aceite
- [ ] Critério 1
- [ ] Critério 2

## 🔗 Referências
- [Link 1](url)
- [Link 2](url)
```

### Headers por Tipo de Task

| Tipo | Emoji | Uso |
|------|-------|-----|
| Feature | 🚀 | Nova funcionalidade |
| Bug | 🐛 | Correção de bug |
| Refactor | 🔧 | Refatoração |
| Docs | 📚 | Documentação |
| Test | 🧪 | Testes |
| Chore | 🔨 | Manutenção |

---

## 💬 Task Comments (Unicode Visual)

### Formato de Progresso

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 PROGRESS UPDATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 {TIMESTAMP} | Status: {STATUS}

✅ Concluído:
∟ Item 1
∟ Item 2

🚧 Em Progresso:
∟ Item 3

⏳ Pendente:
∟ Item 4

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Formato de Fase Completada

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ FASE {N} CONCLUÍDA - {NOME}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 {DATA} | Status: DONE

📊 Resumo:
∟ {Métrica 1}: {Valor}
∟ {Métrica 2}: {Valor}

📁 Arquivos Modificados:
∟ path/to/file1.md
∟ path/to/file2.md

🚀 Próxima Fase: {Nome da Próxima}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Símbolos Padrão

| Símbolo | Uso |
|---------|-----|
| ━━━ | Separador de seção |
| ∟ | Item de lista |
| ▶ | Ação/Step |
| ◆ | Ponto importante |
| ✅ | Concluído |
| ❌ | Erro/Bloqueio |
| ⚠️ | Aviso |
| 🚧 | Em progresso |
| ⏳ | Pendente |

---

## 🏷️ Tags Padrão

### Por Prioridade
- `urgent` - Crítico
- `high` - Alta
- `medium` - Média  
- `low` - Baixa

### Por Tipo
- `feature` - Funcionalidade
- `bug` - Bug
- `refactor` - Refatoração
- `docs` - Documentação
- `subtask` - Subtask

### Por Status
- `blocked` - Bloqueado
- `review` - Em revisão
- `testing` - Em teste

---

## 📊 Estimativas

| Tamanho | Horas | Pontos |
|---------|-------|--------|
| XS | 1-2h | 1 |
| S | 2-4h | 2 |
| M | 4-8h | 3 |
| L | 1-2d | 5 |
| XL | 2-5d | 8 |
| XXL | 5d+ | 13 |

---

## 🔄 Status Flow

```
TO DO → IN PROGRESS → REVIEW → DONE
         ↓
      BLOCKED → IN PROGRESS
```

### Transições Automáticas
- PR aberto → `review`
- PR merged → `done`
- Bloqueio detectado → `blocked`

