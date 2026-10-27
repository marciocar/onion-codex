#!/usr/bin/env bash
# inventory.sh — SSOT GERADA da população deste repo (porte Codex).
#
# ══ POR QUE ISTO EXISTE, e por que veio do core ════════════════════════════════════════════════
# Contagem escrita à mão em prosa é a classe de defeito mais barata de criar e mais cara de achar:
# ninguém agenda conferir um número. No core isso virou REGRA 16 (Contagem de inventário-TOTAL
# divergente da SSOT), e a SSOT que ela consulta é gerada do filesystem — nunca digitada.
#
# Medido neste repo em 2026-09-16, antes desta guarda existir: o subagente `onion` anunciava
# "49 agentes e 94 skills" enquanto o disco tinha 82 skills. O número não era mentira de origem;
# era verdade de 2026-06-04 que ninguém re-mediu.
#
# Uso: inventory.sh [--env | --markdown]
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# A população do porte vive em DOIS lugares, e a diferença é do substrato, não nossa:
#   · invocáveis  → .agents/skills/<slug>/SKILL.md   (o Codex chama por `$slug`)
#   · subagentes  → .codex/agents/*.toml
_skills=0; _agents=0; _kbs=0
[ -d "${REPO}/.agents/skills" ] && _skills="$(find "${REPO}/.agents/skills" -mindepth 2 -maxdepth 2 -name 'SKILL.md' | wc -l)"
[ -d "${REPO}/.codex/agents" ] && _agents="$(find "${REPO}/.codex/agents" -maxdepth 1 -name '*.toml' | wc -l)"
[ -d "${REPO}/docs/knowledge-base" ] && _kbs="$(find "${REPO}/docs/knowledge-base" -name '*.md' ! -name 'index.md' | wc -l)"

case "${1:---env}" in
  --env)
    printf 'ONION_SKILLS_TOTAL=%s\n' "${_skills}"
    printf 'ONION_AGENTS_TOTAL=%s\n' "${_agents}"
    printf 'ONION_KBS_TOTAL=%s\n' "${_kbs}"
    ;;
  --markdown)
    printf '# Inventário do Onion (Codex) — SSOT GERADA\n\n'
    printf '> ⚠️ **Gerado por `.codex/validation/inventory.sh`. Nunca edite os números à mão.**\n'
    printf '> A guarda de contagem compara a prosa deste repo contra este arquivo.\n\n'
    printf '| Recurso | Total |\n|---|---|\n'
    printf '| Skills invocáveis (`$slug`) | %s |\n' "${_skills}"
    printf '| Subagentes (`.codex/agents/*.toml`) | %s |\n' "${_agents}"
    printf '| Knowledge Bases | %s |\n' "${_kbs}"
    ;;
  *) echo "uso: inventory.sh [--env|--markdown]" >&2; exit 2 ;;
esac
