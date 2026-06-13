# fivem-claude-code-expert

Kit complet pour transformer Claude Code en expert FiveM. Fournit les sources de reference des principaux frameworks, une config MCP prete a l'emploi, et un catalogue d'outils communautaires.

## A quoi ca sert

Claude Code n'a pas de connaissances fiables sur les APIs FiveM (ESX, QBCore, QBox, ox_lib, etc.). Ce repo resout le probleme en lui donnant acces au **vrai code source** des frameworks — il lit ces fichiers au lieu d'inventer des APIs.

## Contenu du repo

```
fivem-claude-code-expert/
├── README.md            # Ce fichier
├── .gitignore           # Exclut refs/ du versionning
├── mcp.json.example     # Config MCP template
├── setup.sh             # Clone toutes les refs en shallow (rapide, leger)
├── update.sh            # Met a jour toutes les refs en une commande
└── refs/                # (genere par setup.sh, pas versionne)
    ├── esx_core/        # Framework ESX
    ├── qb-core/         # Framework QBCore
    ├── qbx_core/        # Framework QBox (QBCore next-gen)
    ├── ox_core/         # Framework Overextended
    ├── ox_lib/          # ox_lib (zones, callbacks, UI, cache, commands)
    ├── ox_inventory/    # Systeme d'inventaire
    ├── ox_target/       # Systeme de ciblage
    ├── ox_doorlock/     # Systeme de portes
    ├── ox_fuel/         # Systeme de carburant
    ├── ox_mdt/          # MDT police/EMS
    ├── npwd/            # Telephone in-game
    └── pma-voice/       # Systeme VOIP
```

## Installation

### 1. Cloner le repo

```bash
git clone git@github.com:ayala2a/fivem-claude-code-expert.git
cd fivem-claude-code-expert
```

### 2. Installer les refs

```bash
./setup.sh
```

Ca clone les 12 repos en shallow (sans historique) — rapide et leger (~30MB au lieu de 52MB).

### 3. Configurer Claude Code

Ajouter dans ton `~/.claude/CLAUDE.md` :

```markdown
Refs locales (sources reelles) :
~/path/to/fivem-claude-code-expert/refs/
  esx_core/    qb-core/     qbx_core/    ox_core/
  ox_lib/      ox_inventory/ ox_target/   ox_doorlock/
  ox_fuel/     ox_mdt/      npwd/        pma-voice/

Regle : Quand tu ne connais pas une API, lis le code source dans refs/ avant de repondre.
```

### 4. Configurer les MCP Servers (optionnel)

Si tu as un serveur FiveM local :

```bash
cp mcp.json.example ~/.claude/.mcp.json
```

Editer les chemins (`/CHANGE/PATH/TO/...`) et le mot de passe RCON.

### 5. Installer les skills Claude Code (recommande)

```bash
# Natives FiveM (40+ namespaces, auto-updated)
bunx skills add heyyczer/fivem-natives-skill

# Knowledge packs ESX/QBCore/ox_lib/oxmysql
npx skills add germanfndez/fiveai-skills
```

## Usage au quotidien

```bash
# Mettre a jour toutes les refs d'un coup
./update.sh
```

Claude Code lira automatiquement les fichiers dans `refs/` quand il a besoin de verifier une API. Exemple : quand tu lui demandes d'utiliser `ox_inventory`, il ira lire `refs/ox_inventory/` pour trouver les vrais exports, signatures et parametres.

## Comment ca marche

```
Toi: "Ajoute un systeme de shop avec ox_inventory"
     │
     ▼
Claude Code lit refs/ox_inventory/ pour verifier les exports reels
     │
     ▼
Claude Code lit refs/ox_lib/ pour les UI (context menu, input dialog)
     │
     ▼
Code genere = APIs correctes, pas d'hallucination
```

---

## Catalogue d'outils communautaires

### MCP Servers (integration serveur live)

| Outil | Description | Install |
|-------|-------------|---------|
| [mysbryce/5m-mcp](https://github.com/mysbryce/5m-mcp) | Sandbox fichiers, invoke natives, screenshots NUI, bridges ESX/ox_lib/oxmysql | resource `agent_api` |
| [eeharumt/fivem-mcp](https://github.com/eeharumt/fivem-mcp) | RCON : resource management, commandes, events, logs | node + RCON |
| [ktox-dev/ktx_claude_bridge](https://github.com/ktox-dev/ktx_claude_bridge) | Lua arbitraire, DevTools NUI, profiling CPU (**dev only**) | node |
| [TMHSDigital/cfx-mcp](https://github.com/TMHSDigital/cfx-mcp) | Lookup 12k+ natives sans serveur | `npm i -g @tmhsdigital/cfx-mcp` |

### Skills Claude Code

| Skill | Description | Install |
|-------|-------------|---------|
| [fiveai-skills](https://github.com/germanfndez/fiveai-skills) | Knowledge ESX, QBCore, ox_lib, oxmysql, securite | `npx skills add germanfndez/fiveai-skills` |
| [fivem-natives-skill](https://github.com/HeyyCzer/fivem-natives-skill) | 12k+ natives, 40+ namespaces, MAJ auto /3j | `bunx skills add heyyczer/fivem-natives-skill` |
| [fivem-dev-plugin](https://github.com/melihbozkurt10/fivem-dev-plugin) | Orchestrateur QBox/QBCore/ESX + NUI | `npm i -g claude-fivem-dev` |
| [fivem-audit-skill](https://github.com/matiaspalmac/fivem-audit-skill) | Audit secu/perf/malware, score 0-100 | `/fivem-audit` dans Claude Code |

### MCP officiels utiles

| Serveur | Usage |
|---------|-------|
| `@modelcontextprotocol/server-filesystem` | Acces securise aux dossiers de resources |
| `@modelcontextprotocol/server-git` | Historique, diff, search |
| `@modelcontextprotocol/server-github` | Issues, PRs (GITHUB_TOKEN requis) |

## Config MCP complete

> Le fichier `mcp.json.example` est a la racine — copier et adapter les chemins.

```json
{
  "mcpServers": {
    "cfx-mcp": {
      "command": "cfx-mcp"
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/resources"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git", "--repository", "/path/to/fivem-server"]
    },
    "mcp-fivem-rcon": {
      "command": "node",
      "args": ["/path/to/fivem-mcp/build/index.js"],
      "env": {
        "RCON_ADDRESS": "localhost",
        "RCON_PORT": "30120",
        "RCON_PASSWORD": "your_password",
        "FIVEM_LOGS_DIR": "/path/to/txData/default/logs"
      }
    }
  }
}
```

## Stack recommande

| Contexte | Setup |
|----------|-------|
| **Dev actif (serveur local)** | Ce repo + `5m-mcp` + skills |
| **Dev sans serveur** | Ce repo + `cfx-mcp` + skills |
| **Audit securite** | `/fivem-audit` dans Claude Code |
| **Minimum viable** | Ce repo seul (refs + CLAUDE.md) |

## Notes

- L'ecosysteme MCP FiveM est jeune (2025-2026) — aucun outil dominant
- Les refs sont la piece maitresse : c'est ce qui empeche Claude d'halluciner
- `./update.sh` avant chaque session de dev garantit des refs fraiches
- `refs/` n'est pas versionne — chaque utilisateur clone via `./setup.sh`
