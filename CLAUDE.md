# Claude Code — FiveM Expert Configuration

Expert senior FiveM. Maitrise complete : Lua 5.4, ESX, QBCore, QBox, ox_core, ox_lib, ox_inventory, ox_target, oxmysql, NUI, securite, performance, anti-cheat.
Zero hallucination. Toujours verifier avant d'ecrire.

---

## REGLE ABSOLUE — Zero Hallucination

**Jamais inventer/deviner** un native, API framework, parametre ou event.

| Inconnu | Action |
|---------|--------|
| Native | Lire les docs natives installees OU WebFetch `https://docs.fivem.net/natives/` |
| ox_core | Lire `refs/ox_core/lib/` OU WebFetch `https://overextended.dev/ox_core` |
| ox_lib | Lire `refs/ox_lib/` OU WebFetch `https://overextended.dev/ox_lib` |
| ox_inventory | Lire `refs/ox_inventory/` OU WebFetch `https://overextended.dev/ox_inventory` |
| ox_target | Lire `refs/ox_target/` OU WebFetch `https://overextended.dev/ox_target` |
| QBox/qbx_core | Lire `refs/qbx_core/` OU WebFetch `https://docs.qbox.re/` |
| QBCore | Lire `refs/qb-core/` OU WebFetch `https://docs.qbcore.org/` |
| ESX | Lire `refs/esx_core/` OU WebFetch `https://docs.esx-framework.org/` |
| oxmysql | WebFetch `https://overextended.dev/oxmysql` |
| pma-voice | Lire `refs/pma-voice/README.md` |
| Assets/props | Guider vers `https://forge.plebmasters.de/` |

---

## Detection automatique du framework

**Toujours detecter en premier avant d'ecrire du code.**

```lua
-- Lire fxmanifest.lua du projet pour identifier :
-- 'qbx_core'    -> QBox (qbx_core)
-- 'qb-core'     -> QBCore
-- 'es_extended' -> ESX
-- 'ox_core'     -> ox_core (Overextended)

local Framework, FrameworkType = nil, nil

if GetResourceState('qbx_core') ~= 'missing' then
    Framework = exports.qbx_core:GetCoreObject()
    FrameworkType = 'qbox'
elseif GetResourceState('qb-core') ~= 'missing' then
    Framework = exports['qb-core']:GetCoreObject()
    FrameworkType = 'qbcore'
elseif GetResourceState('es_extended') ~= 'missing' then
    Framework = exports.es_extended:getSharedObject()
    FrameworkType = 'esx'
elseif GetResourceState('ox_core') ~= 'missing' then
    FrameworkType = 'ox_core'
end
```

---

## fxmanifest.lua — Template

```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Ton Nom'
description 'Description de ta resource'
version '1.0.0'

dependencies {
    'ox_lib',
    'ox_inventory',
    '/server:5104',
    '/onesync'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/modules/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/modules/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'locales/*.json'
}

exports { 'GetData' }
server_exports { 'GetServerData' }
```

Structure resource :
```
resource/
├── fxmanifest.lua
├── shared/config.lua
├── client/main.lua
├── server/main.lua
└── html/          (NUI si besoin)
```

---

## ESX — API complete

```lua
local ESX = exports.es_extended:getSharedObject()

-- SERVER SIDE
local xPlayer = ESX.GetPlayerFromId(source)
if not xPlayer then return end

-- Argent
xPlayer.getMoney()
xPlayer.addMoney(amount, reason)
xPlayer.removeMoney(amount, reason)
xPlayer.setMoney(amount, reason)
xPlayer.getAccount('bank').money
xPlayer.getAccount('black_money').money
xPlayer.addAccountMoney('bank', amount, reason)
xPlayer.removeAccountMoney('bank', amount, reason)
xPlayer.setAccountMoney('bank', amount, reason)

-- Job
xPlayer.getJob()          -- { name, label, grade, grade_name, grade_salary }
xPlayer.setJob(name, grade)

-- Inventaire
xPlayer.getInventory()
xPlayer.getInventoryItem('item_name')
xPlayer.addInventoryItem('item_name', count)
xPlayer.removeInventoryItem('item_name', count)
xPlayer.canCarryItem('item_name', count)

-- Armes
xPlayer.addWeapon('WEAPON_PISTOL', 50)
xPlayer.removeWeapon('WEAPON_PISTOL')
xPlayer.addWeaponComponent('WEAPON_PISTOL', 'COMPONENT_PISTOL_CLIP_02')
xPlayer.addWeaponAmmo('WEAPON_PISTOL', 50)
xPlayer.hasWeapon('WEAPON_PISTOL')

-- Infos
xPlayer.getName()
xPlayer.getIdentifier()
xPlayer.getGroup()
xPlayer.kick(reason)
xPlayer.getCoords(useVector)

-- Utilite serveur
ESX.GetPlayers()
ESX.GetExtendedPlayers(key, val)
ESX.GetPlayerFromIdentifier(identifier)
ESX.RegisterUsableItem('bandage', function(source) end)
ESX.OneSync.GetPlayersInArea(coords, radius)
ESX.OneSync.GetClosestPlayer(coords)

-- Callbacks
ESX.RegisterServerCallback('res:name', function(source, cb, arg1, arg2)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb({ data = 'value' })
end)

-- CLIENT SIDE
local PlayerData = ESX.GetPlayerData()

-- Events
'esx:playerLoaded'
'esx:setJob'              -- function(job, lastJob)
'esx:setAccountMoney'     -- function(account)
'esx:onPlayerDeath'
'esx:playerDropped'       -- server: function(playerId, reason)

-- UI
ESX.ShowNotification('Message')
ESX.ShowAdvancedNotification('Title', 'Sub', 'Msg', 'CHAR_BANK_MAZE', 1)
ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to interact')
ESX.TextUI('Press [E] to open') | ESX.HideUI()
```

---

## QBCore — API complete

```lua
local QBCore = exports['qb-core']:GetCoreObject()

-- SERVER SIDE
local Player = QBCore.Functions.GetPlayer(source)
if not Player then return end

-- Lookup
QBCore.Functions.GetPlayerByCitizenId(citizenid)
QBCore.Functions.GetPlayerByPhone(number)
QBCore.Functions.GetPlayerByAccount(account)
QBCore.Functions.GetOfflinePlayerByCitizenId(citizenid)
QBCore.Functions.GetPlayers()
QBCore.Functions.GetQBPlayers()
QBCore.Functions.GetDutyCount('police')

-- Argent
Player.Functions.GetMoney('cash' | 'bank' | 'crypto')
Player.Functions.AddMoney('cash', amount, 'reason')
Player.Functions.RemoveMoney('cash', amount, 'reason')
Player.Functions.SetMoney('cash', amount, 'reason')

-- Job/Gang
Player.Functions.GetJob()
Player.Functions.SetJob('police', 0)
Player.Functions.GetGang()
Player.Functions.SetGang('ballas', 0)

-- Inventaire
Player.Functions.GetItemByName('item_name')
Player.Functions.GetItemsByName('item_name')
Player.Functions.HasItem('item_name', amount)
Player.Functions.AddItem('item_name', count, slot, info)
Player.Functions.RemoveItem('item_name', count, slot)

-- Metadata
Player.Functions.GetMetaData('hunger')
Player.Functions.SetMetaData('hunger', 100)

-- Callbacks
QBCore.Functions.CreateCallback('res:name', function(source, cb, arg)
    local Player = QBCore.Functions.GetPlayer(source)
    cb({ result = true })
end)

-- Items utilisables
QBCore.Functions.CreateUseableItem('bandage', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem('bandage', 1) then
        TriggerClientEvent('hospital:client:HealPlayer', source)
    end
end)

-- CLIENT SIDE
local PlayerData = QBCore.Functions.GetPlayerData()

-- Events
'QBCore:Client:OnPlayerLoaded'
'QBCore:Client:OnPlayerUnload'
'QBCore:Client:OnJobUpdate'       -- function(job)
'QBCore:Client:OnGangUpdate'      -- function(gang)
'QBCore:Client:OnMoneyChange'     -- function(moneyType, amount, action)
'QBCore:Server:OnPlayerLoaded'
'QBCore:Server:PlayerDropped'     -- function(Player, Reason)

-- Notifications
QBCore.Functions.Notify('Message', 'success'|'error'|'warning'|'info'|'primary', 5000)
TriggerClientEvent('QBCore:Notify', source, 'Message', 'success', 5000)
```

---

## QBox (qbx_core) — API complete

QBox = QBCore + ox_lib + ox_inventory natifs + multi-job/gang + QB bridge retrocompat.

```lua
local Player = exports.qbx_core:GetPlayer(source)
if not Player then return end

exports.qbx_core:GetPlayer(source)
exports.qbx_core:GetPlayerByCitizenId(citizenid)
exports.qbx_core:GetPlayerByUserId(userId)
exports.qbx_core:GetPlayerByPhone(number)
exports.qbx_core:GetQBPlayers()
exports.qbx_core:GetOfflinePlayer(citizenid)
exports.qbx_core:GetSource(identifier)

-- Multi-job/gang (specifique QBox)
exports.qbx_core:GetDutyCountJob(job)
exports.qbx_core:GetDutyCountType(type)

-- Routing buckets
exports.qbx_core:GetBucketObjects()

-- Login/Auth
exports.qbx_core:Login(source, citizenid, newData)

-- ConVars QBox
GetConvarInt('qbx:max_jobs_per_player', 1)
GetConvarInt('qbx:max_gangs_per_player', 1)
GetConvar('qbx:setjob_replaces', 'true')

-- Events QBox (identiques QBCore)
'QBCore:Client:OnPlayerLoaded' | 'QBCore:Server:PlayerDropped' | etc.

-- QB Bridge — les scripts QB classiques fonctionnent sans modif
-- exports['qb-core']:GetCoreObject() -> redirige vers qbx_core
```

---

## ox_core — API complete (Overextended)

```lua
local Ox = require '@ox_core/lib/init'
local Ox = require '@ox_core/lib/server/init'

-- PLAYER
local player = Ox.GetPlayer(source)
Ox.GetPlayerFromUserId(userId)
Ox.GetPlayerFromCharId(charId)
Ox.GetPlayers(filter)
Ox.GetPlayerFromFilter(filter)

player:getCoords()
player:getState()
player:getGroup(filter)
player:getGroupByType(type)
player:getAccount()

-- ACCOUNT
local account = Ox.GetAccount(accountId)
Ox.GetCharacterAccount(charId)
Ox.GetGroupAccount(groupName)
Ox.CreateAccount(owner, label)

account:getBalance()
account:addBalance(amount)
account:removeBalance(amount)
account:transferBalance(targetAccountId, amount)

-- VEHICLE
local vehicle = Ox.GetVehicle(entity)

-- fxmanifest.lua pour un resource ox_core
shared_scripts { '@ox_core/lib/init.lua', '@ox_lib/init.lua' }
```

---

## ox_lib — API complete

```lua
-- fxmanifest: shared_scripts { '@ox_lib/init.lua' }

-- UI
lib.notify({ title='T', description='D', type='success'|'error'|'warning'|'info', duration=3000 })

lib.alertDialog({ header='Titre', content='Message', centered=true, cancel=true })

local input = lib.inputDialog('Titre', {
    { label='Nom', type='input', required=true, min=2, max=32 },
    { label='Age', type='number', required=true, min=18, max=120 },
    { label='Sexe', type='select', options={{ value='m', label='Homme' }, { value='f', label='Femme' }} },
    { label='Accepter', type='checkbox', checked=false }
})
if not input then return end

lib.progressBar({ duration=5000, label='En cours...', useWhileDead=false, canCancel=true,
    disable={ move=true, car=true, combat=true },
    anim={ dict='anim@amb@casino@games@poker@chip_flip_a', clip='dealer_chip_flip_a' }
})

lib.textUI('Appuie sur [E] pour interagir', { position='right-center', icon='hand' })
lib.hideTextUI()

-- Context menu
lib.registerContext({ id='menu_id', title='Titre', options={
    { label='Option 1', description='desc', icon='fa-solid fa-car',
      onSelect=function() end, disabled=false, arrow=true },
    { label='Sous-menu', arrow=true, menu='other_menu_id' }
}})
lib.showContext('menu_id')

-- Radial menu
lib.addRadialItem({ id='item_id', label='Label', icon='car', onSelect=function() end })
lib.removeRadialItem('item_id')

-- CALLBACKS
-- Server:
lib.callback.register('res:name', function(source, param1, param2)
    return { data = 'value' }, true
end)

-- Client (await):
local result = lib.callback.await('res:name', false, param1)

-- COMMANDES
lib.addCommand('cmdname', {
    help = 'Description de la commande',
    params = {
        { name = 'target', type = 'playerId', help = 'Joueur cible' },
        { name = 'amount', type = 'number', help = 'Montant', optional = true }
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    local target = args.target
    local amount = args.amount or 100
end)

-- ZONES
local zone = lib.zones.sphere({
    coords = vec3(x, y, z),
    radius = 2.5,
    debug = false,
    onEnter = function(self) lib.notify({ description='Entre dans la zone' }) end,
    onExit = function(self) end,
    inside = function(self) end
})
zone:remove()
zone:contains(coords)

lib.zones.box({
    coords = vec3(x, y, z),
    size = vec3(2, 2, 2),
    rotation = 0.0,
    onEnter = function(self) end,
    onExit = function(self) end
})

lib.zones.poly({
    points = { vec2(x1,y1), vec2(x2,y2), vec2(x3,y3) },
    thickness = 2.0,
    onEnter = function(self) end
})

-- CACHE
cache.ped
cache.coords
cache.vehicle
cache.seat
cache.weapon
cache.resource

-- KEYBINDS
lib.addKeybind({
    name = 'openMenu',
    description = 'Ouvre le menu',
    defaultKey = 'F5',
    defaultMapper = 'keyboard',
    onPressed = function(self) openMenu() end
})

-- SKILL CHECK
local passed = lib.skillCheck({'easy','easy','medium'}, {'w','a','s','d'})

-- UTILS
lib.requestModel(modelHash, 5000)
lib.requestAnimDict('dict')
lib.requestStreamedTextureDict('dict')
lib.requestNamedPtfxAsset('asset')
```

---

## ox_inventory — API complete

```lua
-- SERVER SIDE
exports.ox_inventory:AddItem(source, 'item_name', count, metadata)
exports.ox_inventory:RemoveItem(source, 'item_name', count, metadata)
exports.ox_inventory:GetItem(source, 'item_name', metadata, returnsCount)
exports.ox_inventory:GetSlotWithItem(source, 'item_name')
exports.ox_inventory:CanCarryItem(source, 'item_name', count)
exports.ox_inventory:CanCarryWeight(source, weight)
exports.ox_inventory:GetCurrentWeapon(source)
exports.ox_inventory:SetDurability(source, slot, durability)

-- Stashes
exports.ox_inventory:RegisterStash('stash_id', label, slots, maxWeight, owner, groups, coords)
exports.ox_inventory:GetContainerFromSlot(source, slot)
exports.ox_inventory:OpenInventory(source, 'stash_id')

-- Shops
exports.ox_inventory:RegisterShop('shop_id', {
    name = 'Shop Name',
    inventory = {
        { name='item', price=100, count=10 }
    }
})

-- Items
exports.ox_inventory:Items()
exports.ox_inventory:ItemMetadata()

-- CLIENT SIDE
exports.ox_inventory:openInventory()
exports.ox_inventory:closeInventory()

-- Item utilisable (hook)
exports.ox_inventory:registerHook('useItem', function(payload)
    local source = payload.source
    local item = payload.item
    if item.name == 'bandage' then
        TriggerClientEvent('hospital:heal', source)
        return true
    end
end)
```

---

## ox_target — API complete

```lua
-- ZONES
exports.ox_target:addBoxZone({
    coords = vec3(x, y, z),
    size = vec3(1, 1, 2),
    rotation = 0.0,
    debug = false,
    options = {{
        name = 'unique_option_id',
        icon = 'fa-solid fa-hand',
        label = 'Interagir',
        distance = 2.0,
        groups = { police = 0 },
        items = { 'lockpick' },
        onSelect = function(data) end,
        canInteract = function(entity, distance, coords, name, bone) return true end
    }}
})

exports.ox_target:addSphereZone({
    coords = vec3(x, y, z),
    radius = 1.5,
    options = {{ name='id', label='Label', onSelect=function() end }}
})

-- ENTITES
exports.ox_target:addLocalEntity(entity, options)
exports.ox_target:addGlobalPed(options)
exports.ox_target:addGlobalVehicle(options)
exports.ox_target:addGlobalObject(options)
exports.ox_target:addGlobalPlayer(options)

-- MODELES
exports.ox_target:addModel('prop_atm_01', options)
exports.ox_target:addModel({'prop_atm_01','prop_atm_02'}, options)

-- NETTOYAGE
exports.ox_target:removeBoxZone('zone_name')
exports.ox_target:removeZone('zone_name')
exports.ox_target:removeLocalEntity(entity, 'option_name')
exports.ox_target:removeModel('prop_atm_01', {'option_name'})
```

---

## oxmysql — API complete

```lua
-- fxmanifest: server_script '@oxmysql/lib/MySQL.lua'
-- TOUJOURS placeholders ? — jamais de concatenation SQL

-- SELECT multiple rows
local rows = MySQL.query.await('SELECT * FROM players WHERE job = ?', { 'police' })

-- SELECT une seule ligne
local player = MySQL.single.await('SELECT * FROM players WHERE identifier = ? LIMIT 1', { id })
if not player then return end

-- SELECT une valeur
local count = MySQL.scalar.await('SELECT COUNT(*) FROM players', {})

-- INSERT -> retourne insertId
local insertId = MySQL.insert.await('INSERT INTO logs (type, msg, date) VALUES (?, ?, ?)',
    { 'info', 'message', os.time() })

-- UPDATE -> retourne affectedRows
local affected = MySQL.update.await('UPDATE players SET money = ? WHERE identifier = ?',
    { amount, identifier })

-- Prepared statement (plus rapide pour requetes repetees)
local result = MySQL.prepare.await('SELECT * FROM items WHERE name = ?', { 'bandage' })

-- Execute brut (DDL)
MySQL.rawExecute.await('ALTER TABLE players ADD COLUMN test INT DEFAULT 0', {})

-- Transaction atomique
local success = MySQL.transaction.await({
    { query = 'UPDATE accounts SET money = money - ? WHERE id = ?', values = { amount, from_id } },
    { query = 'UPDATE accounts SET money = money + ? WHERE id = ?', values = { amount, to_id } },
    { query = 'INSERT INTO transactions (from_id,to_id,amount) VALUES (?,?,?)',
      values = { from_id, to_id, amount } }
})
if not success then return end
```

---

## StateBags — Synchronisation d'etat

```lua
-- SERVER -> tous les clients (replique)
Player(source).state:set('onDuty', true, true)
Entity(vehicle).state:set('locked', false, true)
Entity(vehicle).state:set('owner', source, true)
GlobalState:set('weatherType', 'RAIN', true)
GlobalState:set('serverTime', os.time(), true)

-- Lecture (toutes sides)
LocalPlayer.state.onDuty
Player(source).state.onDuty
Entity(vehicle).state.locked
GlobalState.weatherType

-- Watcher
AddStateBagChangeHandler('onDuty', nil, function(bagName, key, value, reserved, replicated)
    if bagName:find('player:') then
        local playerId = tonumber(bagName:match('player:(%d+)'))
        print('Player', playerId, 'duty =', value)
    end
end)
```

---

## Communication Client <-> Server

```lua
-- EVENTS
TriggerServerEvent('res:server:action', data)
TriggerClientEvent('res:client:update', source, data)
TriggerClientEvent('res:client:update', -1, data)       -- tous

-- Latent events (gros payloads)
TriggerLatentClientEvent('res:sync', source, 50000, bigData)

-- NAMING CONVENTION
-- 'resourceName:server:actionName'  -> client -> server
-- 'resourceName:client:actionName'  -> server -> client
-- 'resourceName:event:stateName'    -> local/shared

-- EXPORTS cross-resource
exports['resource_name']:FunctionName(params)
exports.resource_name:FunctionName(params)

-- SECURITE cote server (pattern complet)
RegisterNetEvent('res:server:buyItem', function(itemId, quantity)
    local src = source   -- CAPTURER IMMEDIATEMENT

    -- 1. Validate types
    if type(itemId) ~= 'string' or type(quantity) ~= 'number' then return end
    -- 2. Validate ranges
    if quantity < 1 or quantity > 100 then return end
    -- 3. Validate item exists
    local item = Config.Items[itemId]
    if not item then return end
    -- 4. Validate player exists
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    -- 5. Validate distance
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if #(playerCoords - Config.ShopCoords) > 5.0 then return end
    -- 6. Validate can afford
    if Player.Functions.GetMoney('cash') < item.price * quantity then
        return TriggerClientEvent('ox_lib:notify', src, { type='error', description='Pas assez d\'argent' })
    end
    -- 7. Process
    Player.Functions.RemoveMoney('cash', item.price * quantity, 'shop')
    exports.ox_inventory:AddItem(src, itemId, quantity)
end)
```

---

## Securite — Patterns complets

```lua
-- RATE LIMITING
local cooldowns = {}
local COOLDOWN_MS = 2000

RegisterNetEvent('res:action', function()
    local src = source
    local now = GetGameTimer()
    if cooldowns[src] and now - cooldowns[src] < COOLDOWN_MS then
        return print(('[AC] Rate limit: %s'):format(src))
    end
    cooldowns[src] = now
end)

AddEventHandler('playerDropped', function()
    cooldowns[source] = nil
end)

-- ACE PERMISSIONS
if not IsPlayerAceAllowed(source, 'group.admin') then
    return DropPlayer(tostring(source), 'Unauthorized')
end

-- ANTI-DUPLICATION (mutex par joueur)
local processing = {}
RegisterNetEvent('res:withdrawMoney', function(amount)
    local src = source
    if processing[src] then return end
    processing[src] = true
    -- operation async...
    processing[src] = nil
end)

-- DISTANCE VALIDATION
local function isNearCoords(source, targetCoords, maxDist)
    local ped = GetPlayerPed(source)
    if not DoesEntityExist(ped) then return false end
    return #(GetEntityCoords(ped) - targetCoords) <= maxDist
end

-- VALIDATION INPUT
local function validateNumber(val, min, max)
    return type(val) == 'number' and val >= min and val <= max
end

local function validateString(val, minLen, maxLen)
    return type(val) == 'string' and #val >= (minLen or 1) and #val <= (maxLen or 255)
end

-- REGLES D'OR
-- 1. Le serveur est la verite. Le client demande, ne decide jamais.
-- 2. Capturer 'source' IMMEDIATEMENT au debut du handler.
-- 3. Valider TOUT : type, range, existence, distance, permission.
-- 4. Rate-limiter toutes les actions economiques et de combat.
-- 5. Nettoyer cooldowns/processing a playerDropped.
-- 6. Jamais de donnees client non-validees en DB.
```

---

## Performance — Patterns optimaux

```lua
-- PATTERN ADAPTATIF (STANDARD)
CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(cache.ped)

        for _, point in ipairs(Config.Points) do
            local dist = #(coords - point.coords)
            if dist < 3.0 then
                sleep = 0
                handleInteraction(point)
            elseif dist < 50.0 then
                sleep = math.min(sleep, 250)
            end
        end
        Wait(sleep)
    end
end)

-- THREAD CONDITIONNEL
local menuOpen = false

local function startMenuThread()
    if menuOpen then return end
    menuOpen = true
    CreateThread(function()
        while menuOpen do
            Wait(0)
        end
    end)
end

local function closeMenu()
    menuOpen = false
end

-- KEYBINDS > IsControlJustPressed
RegisterKeyMapping('myaction', 'Description', 'keyboard', 'e')
RegisterCommand('myaction', function() doAction() end, false)

-- NETTOYAGE A L'ARRET
local spawnedEntities = {}

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, ent in ipairs(spawnedEntities) do
        if DoesEntityExist(ent) then DeleteEntity(ent) end
    end
end)

-- MODELES — toujours liberer
local function spawnObject(modelHash, coords)
    lib.requestModel(modelHash, 5000)
    local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, false)
    SetModelAsNoLongerNeeded(modelHash)
    return obj
end

-- VALEURS DE WAIT
-- Wait(0)    : chaque frame (UI active, animations)
-- Wait(100)  : 10x/sec (proximite, inputs)
-- Wait(500)  : 2x/sec (updates secondaires)
-- Wait(1000) : 1x/sec (taches periodiques)
-- Wait(5000) : toutes les 5s (sync background)
```

---

## NUI — Patterns complets

```lua
-- LUA CLIENT -> NUI
SetNuiFocus(true, true)
SendNUIMessage({ action = 'open', data = { money = 500, items = {} } })

-- NUI -> LUA (callback)
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('buyItem', function(data, cb)
    TriggerServerEvent('shop:server:buy', data.itemId, data.quantity)
    cb({ success = true })
end)
```

```javascript
// JS SIDE — Recevoir depuis Lua
window.addEventListener('message', (event) => {
    if (event.data.action === 'open') {
        // init UI avec event.data.data
    }
})

// Envoyer vers Lua
fetch(`https://${GetParentResourceName()}/close`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ reason: 'user_close' })
})
```

---

## pma-voice — Integration

```lua
-- ConVars serveur (server.cfg)
-- setr voice_useSendingRangeOnly 1
-- setr voice_defaultVoiceMode 2      (1=whisper, 2=normal, 3=shout)
-- setr voice_enableRadios 1
-- setr voice_enableCalls 1

-- Integration radio
exports['pma-voice']:addPlayerToChannel(source, channelId)
exports['pma-voice']:removePlayerFromChannel(source, channelId)
```

---

## Routing Buckets (Instances)

```lua
-- Chaque bucket = instance de monde isolee (0 = public)
SetPlayerRoutingBucket(source, bucketId)
SetEntityRoutingBucket(entity, bucketId)
GetPlayerRoutingBucket(source)
GetEntityRoutingBucket(entity)
```

---

## Lua 5.4 — Features FiveM

```lua
-- lua54 'yes' dans fxmanifest.lua

local MAX_PLAYERS <const> = 64
local RESOURCE_NAME <const> = GetCurrentResourceName()

-- Division entiere
local pages = 100 // 3  -- 33

-- Tables pre-allouees
local t = table.create(100, 0)

-- Bitwise
local flag = 0b0101
local masked = flag & 0b0011
local shifted = flag >> 1
```

---

## Anti-patterns

| NE JAMAIS | TOUJOURS |
|-----------|----------|
| Inventer un native | Verifier dans refs/ ou docs |
| `while true do Wait(0)` pour distance | Pattern adaptatif |
| `IsControlJustPressed` en boucle | `RegisterKeyMapping` |
| `DrawMarker` + Wait(0) | `ox_target:addBoxZone` |
| Faire confiance au client | Valider server-side |
| Oublier de capturer `source` | `local src = source` ligne 1 |
| Concatener SQL | Placeholders `?` toujours |
| `PlayerPedId()` en loop | `cache.ped` |
| `GetEntityCoords` en loop | Cache + refresh interval |
| Globals partout | `local` systematiquement |
| Oublier `SetModelAsNoLongerNeeded` | Toujours liberer apres spawn |
| Pas de nettoyage `onResourceStop` | Handler cleanup obligatoire |
| Pas de rate limit sur actions eco | Cooldown + playerDropped cleanup |
| `ESX = nil; TriggerEvent('esx:getSharedObject')` | `exports.es_extended:getSharedObject()` |
| Pas de nil check sur Player | `if not Player then return end` |

---

## Sources officielles

| Source | URL |
|--------|-----|
| FiveM Natives | https://docs.fivem.net/natives/ |
| FiveM Docs | https://docs.fivem.net/docs/ |
| ESX | https://docs.esx-framework.org/ |
| QBCore | https://docs.qbcore.org/ |
| QBox | https://docs.qbox.re/ |
| ox_core | https://overextended.dev/ox_core |
| ox_lib | https://overextended.dev/ox_lib |
| ox_inventory | https://overextended.dev/ox_inventory |
| ox_target | https://overextended.dev/ox_target |
| ox_doorlock | https://overextended.dev/ox_doorlock |
| oxmysql | https://overextended.dev/oxmysql |
| cfxnatives | https://cfxnatives.dev |
| Assets/Props | https://forge.plebmasters.de/ |
| awesome-ox | https://github.com/overextended/awesome-ox |

---

## server.cfg — Hardening recommande

```cfg
sv_entityLockdown strict
setr sv_filterRequestControl 4
sv_disableClientReplays true
sv_enableNetworkedSounds false
sv_enableNetworkedScriptEntityStates false
sv_pureLevel 2
sv_authMaxVariance 2
sv_authMinTrust 5
sv_endpointPrivacy true
set sv_enableDevtools false
set rateLimiter_stateBag_rate 75
set rateLimiter_stateBag_burst 125
```
