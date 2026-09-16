#!/usr/bin/env bash
# lint-selftest.sh — a bancada: prova que cada guarda REAGE ao defeito que ela alega pegar.
#
# ══ POR QUE UMA GUARDA SEM BANCADA NÃO CONTA ══════════════════════════════════════════════════
# Uma guarda que nunca foi vista reprovando é uma guarda que ninguém sabe se está viva. O padrão
# é o MUTANTE: introduz-se de propósito o defeito num sandbox e exige-se que a guarda reprove.
# Se ela passar, quem está quebrado é a guarda — não o repo.
set -uo pipefail
# ⚠️ `bash lint | grep -q X` NÃO SERVE AQUI, e a 1ª redação desta bancada caiu nisso.
# Sob `pipefail` o status do pipeline vira o do ESCRITOR quando ele falha — e o lint SAI 1 ao
# achar violação, que é justamente o caso que o mutante quer provar. Resultado: os testes que
# esperavam ACHAR reprovavam, e — pior — os que esperavam NÃO achar passavam VAZIOS, pelo motivo
# errado. É a classe `pipefail-epipe-early-closer`: leitor que fecha cedo contamina o veredito.
# Cura: DRENAR a saída para uma variável e só então procurar nela.
_saida() { bash "$1" 2>&1 || true; }
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PASS=0; FAIL=0
ok()   { printf '  ✓ %s\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '  ✗ %s\n' "$1"; FAIL=$((FAIL+1)); }

_sandbox() {  # monta um repo mínimo com a maquinaria, para mutar sem sujar o vivo
  local d; d="$(mktemp -d)"
  mkdir -p "$d/.codex/validation" "$d/.codex/agents" "$d/.agents/skills/exemplo" "$d/docs/knowledge-base"
  cp "${REPO}/.codex/validation/inventory.sh" "${REPO}/.codex/validation/lint-artifacts.sh" "$d/.codex/validation/"
  printf 'name = "x"\nmodel_reasoning_effort = "high"\n' > "$d/.codex/agents/x.toml"
  printf 'name: exemplo\ndescription: x\n' > "$d/.agents/skills/exemplo/SKILL.md"
  : > "$d/.codex/validation/link-baseline.txt"
  printf '%s\n' "$d"
}

echo "=== Bancada de guardas (Codex) ==="

# (a) BASE LIMPA — sem isto, um verde do mutante não prova nada (poderia estar sempre verde)
d="$(_sandbox)"
if bash "$d/.codex/validation/lint-artifacts.sh" >/dev/null 2>&1; then ok "(a) base limpa passa (o verde tem de ser possível)"
else bad "(a) base limpa REPROVOU — a guarda acusa repo são"; fi

# (b) MUTANTE R-MODELO — reintroduz o pin que quebrou o @onion em 2026-09-16
printf 'name = "y"\nmodel = "gpt-5.4"\nmodel_reasoning_effort = "high"\n' > "$d/.codex/agents/y.toml"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-MODELO'; then ok "(b) R-MODELO pega versão fixada"
else bad "(b) R-MODELO NÃO pegou o pin — a guarda está morta"; fi
rm -f "$d/.codex/agents/y.toml"

# (c) R-MODELO NÃO pode pegar o tier — se pegasse, obrigaria a apagar o que deve ficar
printf 'name = "z"\nmodel_reasoning_effort = "medium"\n' > "$d/.codex/agents/z.toml"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-MODELO'; then bad "(c) R-MODELO acusou model_reasoning_effort (falso positivo)"
else ok "(c) R-MODELO ignora model_reasoning_effort (o tier fica)"; fi

# (d) MUTANTE R-CONTAGEM — prosa com total divergente da SSOT
printf 'Temos 999 skills invocáveis aqui.\n' > "$d/docs/knowledge-base/drift.md"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-CONTAGEM'; then ok "(d) R-CONTAGEM pega total divergente"
else bad "(d) R-CONTAGEM NÃO pegou o drift"; fi

# (e) CALIBRAÇÃO — breakdown por categoria NÃO é total. É o falso positivo que a 1ª redação
#     desta guarda cometeu (31 violações, a maioria inócua) e o motivo de ela ter ancoragem.
printf 'A categoria meta tem 4 skills.\n' > "$d/docs/knowledge-base/drift.md"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-CONTAGEM'; then bad "(e) R-CONTAGEM acusou breakdown por categoria (falso positivo)"
else ok "(e) R-CONTAGEM ignora breakdown ('N skills' sem 'invocáveis')"; fi

# (f) FAIL-CLOSED — sem SSOT a guarda tem de DIZER que não sabe, nunca passar em silêncio
rm -f "$d/docs/knowledge-base/drift.md" "$d/.codex/validation/inventory.sh"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'não pode julgar'; then ok "(f) sem SSOT a guarda falha FECHADA (declara que não sabe)"
else bad "(f) sem SSOT a guarda passou em SILÊNCIO — fail-open"; fi

# (g) MUTANTE R-FORMA — SKILL.md sem `name:` (o modo de falha SILENCIOSO do Codex)
printf '# sem frontmatter\n' > "$d/.agents/skills/exemplo/SKILL.md"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-FORMA'; then ok "(g) R-FORMA pega SKILL.md sem name:"
else bad "(g) R-FORMA NÃO pegou skill sem name:"; fi
printf 'name: exemplo\ndescription: x\n' > "$d/.agents/skills/exemplo/SKILL.md"

# (h) MUTANTE R-FORMA — TOML que não parseia (o agente não carrega, e ninguém avisa)
printf 'name = "quebrado\n' > "$d/.codex/agents/ruim.toml"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'TOML INVÁLIDO'; then ok "(h) R-FORMA pega TOML inválido"
else bad "(h) R-FORMA NÃO pegou TOML inválido"; fi
rm -f "$d/.codex/agents/ruim.toml"

# (i) MUTANTE R-LINK — link novo que não resolve, fora do baseline
printf '# doc\nVer [isto](./nao-existe.md).\n' > "$d/docs/knowledge-base/link.md"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-LINK'; then ok "(i) R-LINK pega link novo quebrado"
else bad "(i) R-LINK NÃO pegou link quebrado"; fi

# (j) CATRACA — o MESMO link, agora no baseline, é PASSIVO e não reprova.
#     Sem este caso a catraca seria fé: 'está no baseline' não prova que a guarda o tolera.
"$d/.codex/validation/lint-artifacts.sh" --emit-link-baseline > "$d/.codex/validation/link-baseline.txt" 2>/dev/null
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-LINK: link relativo NOVO'; then bad "(j) catraca não tolera o passivo baselined"
else ok "(j) catraca tolera o passivo e avisa sem reprovar"; fi
rm -f "$d/docs/knowledge-base/link.md"

# (k) FAIL-CLOSED do R-LINK — sem baseline a guarda DECLARA que não pode julgar
rm -f "$d/.codex/validation/link-baseline.txt"
out="$(_saida "$d/.codex/validation/lint-artifacts.sh")"
if printf '%s' "${out}" | grep -q 'R-LINK não pode julgar'; then ok "(k) sem baseline o R-LINK falha FECHADA"
else bad "(k) sem baseline o R-LINK passou em silêncio — fail-open"; fi

rm -rf "$d"

echo "=== Sumário ==="; echo "  Passaram: ${PASS} · Falharam: ${FAIL}"
[ "${FAIL}" -eq 0 ] && { echo "OK ✓ — todas as guardas reagiram."; exit 0; }
exit 1
