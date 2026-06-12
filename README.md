# FiveM × Claude Code — Ecosystem

Meilleurs outils MCP, skills et agents compatibles Claude Code pour le développement FiveM/Lua/ESX.

---

## TIER 1 — MCP Servers (live server integration)

### mysbryce/5m-mcp ⭐ RECOMMANDÉ
**Repo:** https://github.com/mysbryce/5m-mcp  
**Docs:** https://mysbryce.github.io/5m-mcp/  
**Stars:** 4 | TypeScript | PolyForm Noncommercial

Le plus complet. Installe une resource `agent_api` sur ton serveur FiveM et expose un MCP pour Claude Code.

**Capacités :**
- Read/write/edit de fichiers dans un sandbox, scaffolding de resources
- Invoke de natives client/server en live
- Screenshot + Chrome DevTools Protocol pour NUI/CEF
- Bridges natifs ESX, ox_lib, oxmysql avec introspection de schéma
- Dashboard web + injection de skills custom
- Sécurité : tokens auto, path sandboxing, audit logs

**Installation :**
```bash
# 1. Cloner le repo
git clone https://github.com/mysbryce/5m-mcp.git

# 2. Copier la resource dans ton serveur
cp -r 5m-mcp/agent_api /path/to/fivem-server/resources/[agent]/agent_api/

# 3. Dans la console FiveM :
refresh
ensure agent_api

# 4. Copier la config MCP affichée dans .mcp.json de Claude Code
```

---

### eeharumt/fivem-mcp ⭐ 6 stars
**Repo:** https://github.com/eeharumt/fivem-mcp  
**Stars:** 6 | TypeScript | MIT

Connexion RCON, 13 tools `fivem_*` :
- Resource management (ensure/stop/restart/refresh)
- Exécution de commandes server-side + client-side
- Trigger d'events, gestion joueurs
- Agrégation de logs, métriques de perf

**Config `.mcp.json` :**
```json
{
  "mcpServers": {
    "mcp-fivem": {
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
Ajouter aussi la resource `fivem-plugin/mcp-bridge` + `ensure mcp-bridge` dans `server.cfg`.

---

### ktox-dev/ktx_claude_bridge
**Repo:** https://github.com/ktox-dev/ktx_claude_bridge  
**Stars:** 0 | TypeScript

Bridge HTTP + MCP, interaction temps réel :
- Exécute du Lua arbitraire server/client-side dans les environments de resources
- NUI/CEF via Chrome DevTools Protocol
- Buffer console 1000 lignes persistent
- Inspect player data, entity state, commandes enregistrées
- Read/write dans les répertoires de resources
- SQL read-only via oxmysql
- Profiling CPU (Chrome trace format)

> **⚠️ Dev uniquement** — expose du Lua/JS arbitraire, jamais en prod.

---

### TMHSDigital/cfx-mcp — Lookup natifs sans serveur
**Repo:** https://github.com/TMHSDigital/cfx-mcp  
**Stars:** 0 | TypeScript | CC-BY-NC-ND-4.0

3 tools read-only, aucun serveur requis :
- `cfx_getNative` — 12 000+ natives par nom/partial/hash
- `cfx_queryServer` — inspect n'importe quel serveur FiveM live (`/info.json`, `/players.json`)
- `cfx_searchReleases` — recherche forum cfx.re

**Installation :**
```bash
npm install -g @tmhsdigital/cfx-mcp
```
```json
{ "mcpServers": { "cfx-mcp": { "command": "cfx-mcp" } } }
```

---

### TMHSDigital/CFX-Developer-Tools — Full Toolkit
**Repo:** https://github.com/TMHSDigital/CFX-Developer-Tools  
**Stars:** 2 | Python | CC BY-NC-ND 4.0

Le plus complet all-in-one (orienté Cursor mais MCP-compatible) :
- 9 skills : scaffolding, native lookup, manifest, patterns client-server, détection framework, perf, NUI, oxmysql, State Bags
- 6 rules : conventions Lua/JS/C#, validation fxmanifest, sécurité, anti-patterns perf
- 12 000+ natives, 101 events, 24 snippets, 11 templates
- Supporte ESX, QBCore, Qbox, ox_core, VORP, RSG, standalone + RedM

```bash
git clone https://github.com/TMHSDigital/CFX-Developer-Tools.git
cd mcp-server && pip install -r requirements.txt
```

---

## TIER 2 — Skills Claude Code (injection de contexte)

### germanfndez/fiveai-skills ⭐⭐ RECOMMANDÉ — 6 stars
**Repo:** https://github.com/germanfndez/fiveai-skills  
**Stars:** 6 | Python

Paquets de connaissance pour le FiveM ecosystem (Claude manque de données spécifiques FiveM par défaut) :

| Skill | Contenu |
|---|---|
| `lua-basics` | Lua fondamentaux |
| `fivem-basics` | APIs FiveM spécifiques |
| `fivem-nui` | NUI/CEF/HTML |
| `fivem-security` | Sécurité, exploits |
| `esx-framework` | ESX complet |
| `qbcore-framework` | QBCore complet |
| `oxlib` | ox_lib |
| `oxmysql` | oxmysql |
| `fivemanage` | FiveManage |

```bash
npx skills add germanfndez/fiveai-skills
```

---

### HeyyCzer/fivem-natives-skill — 1 star
**Repo:** https://github.com/HeyyCzer/fivem-natives-skill  
**Stars:** 1 | TypeScript

Auto-updated toutes les 3 jours via GitHub Actions. Référence complète de tous les natives FiveM, 40+ namespaces (PED, VEHICLE, NETWORK, CFX, HUD, GRAPHICS…), types inclus.

```bash
bunx skills add heyyczer/fivem-natives-skill
```

---

### melihbozkurt10/fivem-dev-plugin — 6 stars
**Repo:** https://github.com/melihbozkurt10/fivem-dev-plugin  
**Stars:** 6 | MIT

Plugin multi-tool avec fetch dynamique de docs. Supporte QBox, QBCore, ESX + NUI (JS/TS), PlebMasters Forge.

```bash
git clone https://github.com/melihbozkurt10/fivem-dev-plugin.git ~/.claude/skills/fivem-dev
# ou
npm install -g claude-fivem-dev
```

---

### matiaspalmac/fivem-audit-skill — Security
**Repo:** https://github.com/matiaspalmac/fivem-audit-skill  
**Stars:** 0 | JavaScript

Audit sécurité de resources FiveM. Phases :
1. SQL injection / event exploitation / duplication / NUI XSS
2. Détection malware/backdoor (Cipher, Blum, FiveHub, token grabbers, obfuscation)
3. Analyse performance
4. Compatibilité framework (ESX, QBCore, QBox, ox_lib, ND_Core)

Score 0–100 avec tags CRITICAL/HIGH/MEDIUM/LOW.

```bash
npx fivem-audit
# Dans Claude Code :
/fivem-audit
```

---

### ostend972/fivem-lua-plugin
**Repo:** https://github.com/ostend972/fivem-lua-plugin  
**Stars:** 0 | Shell

Plugin ESX/QBCore/QBOX avec process de dev structuré et quality enforcement.

---

## TIER 3 — MCP officiels essentiels (dev général)

| Serveur | Install | Usage FiveM |
|---|---|---|
| **Filesystem** | `npx @modelcontextprotocol/server-filesystem /fivem/resources` | Accès sécurisé aux répertoires de resources |
| **Git** | `npx @modelcontextprotocol/server-git` | Diff, search, historique version control resources |
| **GitHub** | `npx @modelcontextprotocol/server-github` | Issues, PRs, search GitHub (GITHUB_TOKEN requis) |
| **SQLite** | `npx @modelcontextprotocol/server-sqlite` | Query BDD locale, test schémas oxmysql |
| **Fetch** | `npx @modelcontextprotocol/server-fetch` | Fetch docs cfx.re, GitHub raw files |

Tous les serveurs officiels : https://github.com/modelcontextprotocol/servers

---

## Stack recommandé

### Dev actif contre un serveur local
1. `mysbryce/5m-mcp` — intégration live la plus complète
2. `germanfndez/fiveai-skills` — injection de connaissance ESX/QBCore
3. `HeyyCzer/fivem-natives-skill` — natives toujours à jour
4. Filesystem MCP — accès direct aux répertoires resources
5. Git MCP — awareness du version control

### Review / audit sécurité
- `matiaspalmac/fivem-audit-skill` — commande `/fivem-audit`

### Lookup natifs sans serveur
- `TMHSDigital/cfx-mcp` — npm installable, no server needed

---

## Config .mcp.json exemple complet

> Un fichier `mcp.json.example` est disponible à la racine de ce repo — copie-le et adapte les chemins.

```bash
cp mcp.json.example /path/to/your/project/.mcp.json
```

Config alignée avec le stack recommandé "Dev actif" :

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
    "5m-mcp": {
      "command": "node",
      "args": ["/path/to/5m-mcp/build/index.js"],
      "env": {
        "AGENT_API_URL": "http://localhost:30120/agent_api",
        "AGENT_API_TOKEN": "your_token"
      }
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

> `fiveai-skills` et `fivem-natives-skill` sont des skills Claude Code, pas des MCP — ils s'installent via `npx skills add` et n'apparaissent pas dans `.mcp.json`.

---

## Notes

- L'écosystème est **jeune** (late 2025 / early 2026) — aucun outil dominant, max 6 stars.
- `mysbryce/5m-mcp` et `eeharumt/fivem-mcp` = MCPs les plus sérieux techniquement.
- `germanfndez/fiveai-skills` + `melihbozkurt10/fivem-dev-plugin` = skills les plus étoilés.
- Pour une stack stable aujourd'hui : `cfx-mcp` + Filesystem/Git MCPs + `fiveai-skills`.

### Outils archivés / dépréciés

| Outil | Statut |
|-------|--------|
| [adrianmejias/fivem-mcp](https://github.com/adrianmejias/fivem-mcp) | Archivé juin 2026 — stack PHP/Laravel, ne pas utiliser |
# fivem-claude-code-expert
