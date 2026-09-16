#!/usr/bin/env bash
# lint-artifacts.sh — guardas determinísticas do porte Codex.
#
# ══ O QUE ESTE ARQUIVO É, e por que ele é o primeiro ═══════════════════════════════════════════
# Até 2026-09-16 este repositório tinha ZERO scripts de guarda (`find . -name '*.sh'` = 0) — não
# por atraso, mas por construção: o porte de 2026-06-04 levou a doutrina (markdown, que ACONSELHA)
# e deixou para trás a maquinaria (shell, que REPROVA). O core mediu a própria massa e concluiu
# que o fosso está na metade que reprova, e ela é AGNÓSTICA: roda em qualquer CI, sem acoplamento.
# Este arquivo é o piloto dessa travessia.
#
# ══ AS DUAS GUARDAS DESTA LEVA, e as duas nasceram de um defeito medido ═══════════════════════
# R-MODELO  Nenhum `model = "<versão>"` fixado em config/agente. Em 2026-09-16 o `@onion` recusou-se
#           a iniciar porque o `gpt-5.4` do porte não existia mais para a conta. A cura tirou 54
#           pins; esta guarda impede que voltem — inclusive pela FÁBRICA (os templates dos agentes
#           que cunham agentes), que era por onde o pin renasceria.
# R-CONTAGEM  Contagem-total em prosa tem de bater com a SSOT gerada. Medido antes da guarda: o
#           subagente `onion` anunciava "94 skills" com 82 no disco.
#
# HARD reprova (exit 1). Uso: lint-artifacts.sh
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HARD=0
violation() { printf 'VIOLATION: %s: %s\n' "$1" "$2"; HARD=$((HARD+1)); }

echo "=== Onion Lint (Codex) — validando ${REPO} ==="

# ── R-MODELO ──────────────────────────────────────────────────────────────────────────────────
# Casa `model = "<qualquer coisa que pareça versão>"` no início de linha, que é a forma do TOML de
# config. NÃO casa `model_reasoning_effort` (tier, e é justamente o que deve ficar) nem exemplo de
# SDK de terceiro em bloco de código (`model: openai('...')`, com dois-pontos e sem começo de linha).
while IFS= read -r _hit; do
  [ -z "${_hit}" ] && continue
  violation "${_hit%%:*}" "R-MODELO: versão de modelo FIXADA ('${_hit#*:}') — versão literal em config é data de validade que ninguém agenda para conferir. Declare só model_reasoning_effort (tier da tarefa); QUAL modelo é da precedência do Codex."
done < <(grep -rn '^[[:space:]]*model[[:space:]]*=[[:space:]]*"' "${REPO}/.codex" 2>/dev/null \
           | grep -v 'model_reasoning_effort' | sed 's/^[^:]*\///' || true)

# ── R-CONTAGEM ────────────────────────────────────────────────────────────────────────────────
_env="$(bash "${REPO}/.codex/validation/inventory.sh" --env 2>/dev/null || true)"
if [ -n "${_env}" ]; then
  _sk="$(printf '%s\n' "${_env}" | grep '^ONION_SKILLS_TOTAL=' | cut -d= -f2)"
  _ag="$(printf '%s\n' "${_env}" | grep '^ONION_AGENTS_TOTAL=' | cut -d= -f2)"
  # ⚠️ ANCORAGEM — e ela é a LIÇÃO do piloto, não detalhe de implementação.
  # A 1ª redação casava 'N skills' cru e devolveu 31 violações, das quais a MAIORIA era falso
  # positivo: '4 skills', '12 skills', '7 skills' são BREAKDOWN POR CATEGORIA, não total. É a
  # classe `guarda-por-lista-falha-pelo-vocabulário`: em guarda de lista o defeito dominante é o
  # VOCABULÁRIO, não a lógica. O core já tinha aprendido isto — a REGRA 16 dele só checa frases
  # de TOTAL canônicas e exige ÂNCORA para a forma curta. Portar o script sem portar a CALIBRAÇÃO
  # entrega uma guarda que grita no caso inócuo, e guarda que grita à toa ensina a ser ignorada.
  # Âncora aqui: o caminho da população (`.agents/skills/`) ou a palavra 'invocáve(l|is)' na
  # MESMA linha — é o que distingue "o repo tem N skills" de "esta categoria tem N skills".
  # A 2ª passada refinou de novo: 'N skills invocáveis' é o marcador de TOTAL (espelha o
  # 'N comandos invocáveis' do core), enquanto 'N skills-base'/'N skills núcleo' é OUTRA
  # POPULAÇÃO — as 4 skills fundacionais — e estava certa o tempo todo. Casar as duas com o
  # mesmo padrão transformaria um acerto em violação. Duas passadas de calibração para uma
  # guarda de 2 regras: é esta a massa que não se vê no `wc -l` do script.
  while IFS= read -r _f; do
    # ISENTA superfície DATADA: docs/analysis/ é snapshot histórico (o core isenta pelo mesmo
    # motivo) — reescrever um número lá seria falsificar o registro do que era verdade no dia.
    case "${_f}" in */.git/*|*/docs/evolution/*|*/docs/analysis/*) continue ;; esac
    while IFS= read -r _n; do
      [ -n "${_n}" ] && [ "${_n}" != "${_sk}" ] && \
        violation "${_f#"${REPO}/"}" "R-CONTAGEM: '${_n} skills' diverge da SSOT gerada (${_sk}) — rode .codex/validation/inventory.sh"
    done < <(grep -oiE '[0-9]+ skills invocáveis' "${_f}" | grep -oE '^[0-9]+' || true)
    while IFS= read -r _n; do
      [ -n "${_n}" ] && [ "${_n}" != "${_ag}" ] && \
        violation "${_f#"${REPO}/"}" "R-CONTAGEM: '${_n} subagentes' diverge da SSOT gerada (${_ag}) — rode .codex/validation/inventory.sh"
    done < <(grep -oiE '[0-9]+ subagentes (especializados|em)' "${_f}" | grep -oE '^[0-9]+' || true)
  done < <(find "${REPO}" -name '*.md' -o -name '*.toml' | grep -v '/.git/')
else
  violation ".codex/validation/inventory.sh" "R-CONTAGEM não pode julgar: a SSOT não respondeu. Guarda que não sabe o esperado não valida — falha FECHADA."
fi

echo "=== Sumário ==="
echo "  Violações HARD : ${HARD}"
[ "${HARD}" -eq 0 ] && { echo "OK ✓ — nenhuma violação HARD."; exit 0; }
echo "FALHOU — ${HARD} violação(ões) HARD."; exit 1
