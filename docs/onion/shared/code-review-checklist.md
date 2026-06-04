# Checklist de Code Review

## 🔍 Análise de Código

### 1. Correção Funcional
- [ ] Código faz o que deveria fazer?
- [ ] Casos extremos tratados?
- [ ] Validação de inputs adequada?
- [ ] Tratamento de erros apropriado?

### 2. Qualidade de Código
- [ ] Código legível e auto-documentado?
- [ ] Nomes de variáveis/funções descritivos?
- [ ] Funções com responsabilidade única?
- [ ] Sem código duplicado (DRY)?
- [ ] Sem código morto/comentado?

### 3. Performance
- [ ] Algoritmos eficientes?
- [ ] Sem loops desnecessários?
- [ ] Queries otimizadas?
- [ ] Recursos liberados corretamente?

### 4. Segurança
- [ ] Sem dados sensíveis hardcoded?
- [ ] Inputs sanitizados?
- [ ] Autenticação/autorização corretas?
- [ ] Sem vulnerabilidades conhecidas?

### 5. Testes
- [ ] Testes unitários para nova lógica?
- [ ] Testes de integração se necessário?
- [ ] Cobertura adequada?
- [ ] Testes passando?

### 6. Documentação
- [ ] Funções complexas documentadas?
- [ ] README atualizado se necessário?
- [ ] Comentários onde não óbvio?
- [ ] Changelog atualizado?

---

## 📝 Template de Feedback

### Crítico (Bloqueia PR)

```markdown
🔴 **CRÍTICO** - [Arquivo:Linha]

**Problema**: [Descrição]
**Impacto**: [Por que é crítico]
**Sugestão**: 
\`\`\`[linguagem]
// código sugerido
\`\`\`
```

### Importante (Deve corrigir)

```markdown
🟡 **IMPORTANTE** - [Arquivo:Linha]

**Problema**: [Descrição]
**Sugestão**: [Como melhorar]
```

### Sugestão (Nice-to-have)

```markdown
💡 **SUGESTÃO** - [Arquivo:Linha]

**Ideia**: [Melhoria opcional]
```

### Elogio

```markdown
✨ **ÓTIMO** - [Arquivo:Linha]

[O que foi bem feito]
```

---

## 📊 Categorias de Issues

| Categoria | Emoji | Severidade |
|-----------|-------|------------|
| Bug | 🐛 | Crítico |
| Security | 🔐 | Crítico |
| Performance | ⚡ | Importante |
| Maintainability | 🔧 | Importante |
| Style | 🎨 | Sugestão |
| Docs | 📚 | Sugestão |
| Test | 🧪 | Importante |

---

## ✅ Resumo de Review

```markdown
## 📋 Code Review Summary

**PR**: #[número] - [título]
**Autor**: @[autor]
**Reviewer**: @[reviewer]
**Status**: [APPROVED | CHANGES_REQUESTED | COMMENT]

### 📊 Estatísticas
- Arquivos: X modificados
- Linhas: +Y / -Z
- Issues: A críticos, B importantes, C sugestões

### 🔴 Issues Críticos
1. [Descrição breve] - arquivo:linha

### 🟡 Issues Importantes  
1. [Descrição breve] - arquivo:linha

### 💡 Sugestões
1. [Descrição breve]

### ✨ Pontos Positivos
- [O que foi bem feito]

### 🎯 Veredicto
[Resumo e recomendação final]
```

---

## 🔄 Fluxo de Review

```
1. Leitura Inicial
   ↓
2. Análise de Arquitetura
   ↓
3. Revisão Linha-a-Linha
   ↓
4. Verificação de Testes
   ↓
5. Teste Local (se necessário)
   ↓
6. Feedback Estruturado
   ↓
7. Discussão/Aprovação
```

---

## ⚡ Quick Checks

```bash
# Lint
npm run lint

# Testes
npm test

# Build
npm run build

# Type check
npm run type-check
```

