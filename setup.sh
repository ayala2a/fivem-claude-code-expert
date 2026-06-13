#!/usr/bin/env bash
set -euo pipefail

REFS_DIR="$(cd "$(dirname "$0")" && pwd)/refs"

declare -A REPOS=(
    [esx_core]="https://github.com/esx-framework/esx_core.git"
    [qb-core]="https://github.com/qbcore-framework/qb-core.git"
    [qbx_core]="https://github.com/Qbox-project/qbx_core.git"
    [ox_core]="https://github.com/overextended/ox_core.git"
    [ox_lib]="https://github.com/overextended/ox_lib.git"
    [ox_inventory]="https://github.com/overextended/ox_inventory.git"
    [ox_target]="https://github.com/overextended/ox_target.git"
    [ox_doorlock]="https://github.com/overextended/ox_doorlock.git"
    [ox_fuel]="https://github.com/overextended/ox_fuel.git"
    [ox_mdt]="https://github.com/overextended/ox_mdt.git"
    [npwd]="https://github.com/project-error/npwd.git"
    [pma-voice]="https://github.com/AvarianKnight/pma-voice.git"
)

echo "==> Creation du dossier refs/"
mkdir -p "$REFS_DIR"

for name in "${!REPOS[@]}"; do
    url="${REPOS[$name]}"
    dest="$REFS_DIR/$name"

    if [ -d "$dest" ]; then
        echo "[skip] $name (deja present)"
    else
        echo "[clone] $name"
        git clone --depth 1 --single-branch "$url" "$dest"
    fi
done

echo ""
echo "==> Done. $(ls -1 "$REFS_DIR" | wc -l | tr -d ' ') refs installees dans $REFS_DIR"
