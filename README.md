# fivem-claude-code-expert

[![Check Refs](https://github.com/ayala2a/fivem-claude-code-expert/actions/workflows/check-refs.yml/badge.svg)](https://github.com/ayala2a/fivem-claude-code-expert/actions/workflows/check-refs.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Transforme Claude Code en expert FiveM. APIs completes, patterns de securite, performance, et code source reel des frameworks — tout ce qu'il faut pour que Claude genere du code FiveM correct sans halluciner.

## Ce que ca fait

Claude Code n'a pas de connaissances fiables sur FiveM (ESX, QBCore, QBox, ox_lib...). Ce repo lui donne :

1. **Un CLAUDE.md expert** — Reference complete de toutes les APIs (ESX, QBCore, QBox, ox_core, ox_lib, ox_inventory, ox_target, oxmysql), patterns de securite, performance, NUI, StateBags, anti-patterns
2. **Le code source reel** des 12 frameworks majeurs (`refs/`) — Claude les lit pour verifier les vraies signatures
3. **Une config MCP** pour connecter Claude a un serveur FiveM live (optionnel)

**Resultat :** Claude genere du code FiveM correct, securise, performant, sans inventer d'APIs.

## Frameworks supportes

| Framework | Type | Couverture |
|-----------|------|-----------|
| ESX | Core | API complete server/client |
| QBCore | Core | API complete server/client |
| QBox (qbx_core) | Core | API + multi-job/gang + QB bridge |
| ox_core | Core | API complete (Overextended) |
| ox_lib | Utility | UI, callbacks, zones, cache, commands, keybinds |
| ox_inventory | Inventaire | Exports server/client, stashes, shops, hooks |
| ox_target | Interaction | Zones, entites, modeles |
| oxmysql | Database | Query, transactions, prepared statements |
| pma-voice | VOIP | Radio, channels, integration |
| npwd | Phone | NUI, events |

## Installation rapide

```bash
git clone git@github.com:ayala2a/fivem-claude-code-expert.git
cd fivem-claude-code-expert
./install.sh
```

Le script :
1. Clone les 12 repos de reference en shallow (rapide, ~30MB)
2. Installe les skills Claude Code (natives + knowledge packs)
3. Configure ton `~/.claude/CLAUDE.md`

## Installation manuelle

### 1. Cloner

```bash
git clone git@github.com:ayala2a/fivem-claude-code-expert.git
cd fivem-claude-code-expert
```

### 2. Installer les refs

```bash
./setup.sh
```

### 3. Utiliser le CLAUDE.md dans ton projet FiveM

**Option A — Copier dans ton projet :**
```bash
mkdir -p /path/to/ton-projet-fivem/.claude
cp CLAUDE.md /path/to/ton-projet-fivem/.claude/CLAUDE.md
```

**Option B — Copier dans ta config globale :**
```bash
cp CLAUDE.md ~/.claude/CLAUDE.md
```

### 4. Installer les skills (recommande)

```bash
bunx skills add heyyczer/fivem-natives-skill
npx skills add germanfndez/fiveai-skills
```

## Usage

### Au quotidien

Ouvre Claude Code dans ton projet FiveM et code normalement. Claude va :
- Detecter automatiquement ton framework (ESX/QBCore/QBox/ox_core)
- Utiliser les bonnes APIs sans halluciner
- Appliquer les patterns de securite (rate limiting, validation, distance check)
- Optimiser la performance (pattern adaptatif, cache, cleanup)

### Mettre a jour les refs

```bash
./update.sh
```

### Workflow

```
Toi: "Cree un systeme de shop avec ox_inventory"
     |
     v
Claude lit CLAUDE.md -> connait les APIs exactes
Claude lit refs/ox_inventory/ -> verifie les exports reels
Claude lit refs/ox_lib/ -> utilise les bons patterns UI
     |
     v
Code genere = correct, securise, performant
```

## Contenu du repo

```
fivem-claude-code-expert/
├── CLAUDE.md            # LE CERVEAU — reference complete APIs + patterns
├── README.md            # Ce fichier
├── .gitignore           # Exclut refs/ du versionning
├── mcp.json.example     # Config MCP template (serveur live)
├── install.sh           # Installation automatique complete
├── setup.sh             # Clone les refs en shallow
├── update.sh            # Met a jour toutes les refs
└── refs/                # (genere par setup.sh, pas versionne)
    ├── esx_core/
    ├── qb-core/
    ├── qbx_core/
    ├── ox_core/
    ├── ox_lib/
    ├── ox_inventory/
    ├── ox_target/
    ├── ox_doorlock/
    ├── ox_fuel/
    ├── ox_mdt/
    ├── npwd/
    └── pma-voice/
```

## Ce que contient CLAUDE.md

Le fichier `CLAUDE.md` est la piece maitresse. Il contient :

- **Regle zero hallucination** — force Claude a verifier avant d'inventer
- **Detection auto du framework** — pattern universel
- **Template fxmanifest.lua** — structure de resource standard
- **API complete ESX** — server/client, argent, job, inventaire, armes, callbacks
- **API complete QBCore** — server/client, player functions, callbacks, events
- **API complete QBox** — exports, multi-job, QB bridge
- **API complete ox_core** — Player, Account, Vehicle
- **API complete ox_lib** — UI, callbacks, zones, cache, keybinds, commands
- **API complete ox_inventory** — items, stashes, shops, hooks
- **API complete ox_target** — zones, entites, modeles
- **API complete oxmysql** — query, transactions, prepared
- **StateBags** — sync d'etat server/client
- **Communication Client/Server** — events, exports, securite
- **Securite** — rate limiting, validation, mutex, distance check
- **Performance** — pattern adaptatif, threads conditionnels, cleanup
- **NUI** — Lua/JS communication, patterns React
- **pma-voice** — integration radio
- **Routing Buckets** — instances
- **Lua 5.4** — features avancees FiveM
- **Anti-patterns** — table complete de ce qu'il ne faut jamais faire
- **server.cfg hardening** — securisation serveur

## Config MCP (optionnel — serveur live)

Si tu as un serveur FiveM local et que tu veux que Claude interagisse en live :

```bash
cp mcp.json.example ~/.claude/.mcp.json
# Editer les chemins et le mot de passe RCON
```

## Skills Claude Code complementaires

| Skill | Ce que ca ajoute | Install |
|-------|------------------|---------|
| fivem-natives-skill | 12k+ natives FiveM, MAJ auto /3j | `bunx skills add heyyczer/fivem-natives-skill` |
| fiveai-skills | Knowledge packs ESX/QBCore/ox_lib | `npx skills add germanfndez/fiveai-skills` |
| fivem-dev-plugin | Orchestrateur multi-framework | `npm i -g claude-fivem-dev` |
| fivem-audit-skill | Audit securite/perf (score 0-100) | `/fivem-audit` dans Claude Code |

## FAQ

**Q: Est-ce que je dois avoir un serveur FiveM pour utiliser ca ?**
Non. Le CLAUDE.md + les refs suffisent. Le MCP est un bonus pour l'interaction live.

**Q: Ca marche avec quel framework ?**
ESX, QBCore, QBox, ox_core — tous sont couverts. Claude detecte automatiquement lequel tu utilises.

**Q: Comment ca empeche les hallucinations ?**
Le CLAUDE.md contient les vraies signatures d'API + une regle qui force Claude a lire refs/ quand il doute.

**Q: Je peux contribuer ?**
Oui — PR bienvenues pour ajouter des frameworks, corriger des APIs, ou ajouter des patterns.

## Permissions Claude Code (optionnel)

Pour eviter les prompts de permission a chaque lecture des refs :

```bash
cp settings.json.example /path/to/ton-projet/.claude/settings.json
```

## Mise a jour

```bash
cd fivem-claude-code-expert
git pull              # MAJ du CLAUDE.md et scripts
./update.sh           # MAJ des refs (code source frameworks)
```

## Auteur

Cree par **Mario Caballero** ([@ayala2a](https://github.com/ayala2a))

## License

MIT — voir [LICENSE](LICENSE).
