#!/usr/bin/env bash
set -euo pipefail

REFS_DIR="$(cd "$(dirname "$0")" && pwd)/refs"

if [ ! -d "$REFS_DIR" ]; then
    echo "Erreur: refs/ n'existe pas. Lance d'abord ./setup.sh"
    exit 1
fi

echo "==> Mise a jour des refs..."

for dir in "$REFS_DIR"/*/; do
    name=$(basename "$dir")
    echo -n "[$name] "
    if (cd "$dir" && git pull --depth 1 2>/dev/null); then
        :
    else
        echo "WARN: pull echoue, tentative de re-fetch..."
        (cd "$dir" && git fetch --depth 1 origin && git reset --hard origin/HEAD)
    fi
done

echo ""
echo "==> Toutes les refs sont a jour."
