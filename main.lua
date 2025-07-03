-- Variables --
---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
assert(BetterBags, "BetterBags - Greedy Emissary requires BetterBags")

---@class Categories: AceModule
local Categories = BetterBags:GetModule('Categories')

---@class Localization: AceModule
local L = BetterBags:GetModule('Localization')

---@class GreedyEmissary: AceModule
local GreedyEmissary = BetterBags:NewModule('GreedyEmissary')

---@class AceDB-3.0: AceModule
local AceDB = LibStub("AceDB-3.0")

---@class Config: AceModule
local Config = BetterBags:GetModule('Config')

---@class Context: AceModule
local Context = BetterBags:GetModule('Context')

---@class Events: AceModule
local Events = BetterBags:GetModule('Events')

---@type string, AddonNS
local _, addon = ...

local _, _, _, interfaceVersion = GetBuildInfo()

local db
local defaults = {
    profile = {}
}
local configOptions

-- Make an empty table to store item data in...
local greedyEmissary = {}

configOptions = {
    retailOptions = {
        name = L:G("Options"),
        type = "group",
        order = 1,
        inline = true,
        args = {
            forceRefreshGreedyEmissary = {
                type = "execute",
                name = "Force Refresh",
                desc = "This will forcibly refresh the Greedy Emissary category.",
                func = function()
                    GreedyEmissary:clearGreedyEmissaryCategory()
                    GreedyEmissary:addGreedyEmissaryItemsToTable()
                    GreedyEmissary:addGreedyEmissaryToCategory()
                    local ctx = Context:New('BBGreedyEmissary_RefreshAll')
                    Events:SendMessage(ctx, 'bags/FullRefreshAll')
                end,
            },
        },
    },
}

function GreedyEmissary:addGreedyEmissaryConfig()
    if not Config or not configOptions then
        print("Failed to load configurations for Greedy Emissary plugin.")
        return
    end

    Config:AddPluginConfig("GreedyEmissary", configOptions)
end

function GreedyEmissary:clearGreedyEmissaryCategory()
    Categories:WipeCategory(Context:New('BBGreedyEmissary_DeleteCategory'),L:G("Greedy Emissary"))
end

function GreedyEmissary:addGreedyEmissaryItemsToTable()
    -- Clear the table of items if needed.
    table.wipe(greedyEmissary)

    -- Add Greedy Emissary items, starting with the Hellcaller Chest.
    table.insert(greedyEmissary, { itemID = 245589, itemName = "Hellcaller Chest" })
    -- Add Elixirs
    table.insert(greedyEmissary, { itemID = 245639, itemName = "Arcane Elixir" })
    table.insert(greedyEmissary, { itemID = 245642, itemName = "Blistering Elixir" })
    table.insert(greedyEmissary, { itemID = 246114, itemName = "Catalyst Elixir" })
    table.insert(greedyEmissary, { itemID = 245652, itemName = "Chromic Elixir" })
    table.insert(greedyEmissary, { itemID = 245654, itemName = "Connected Elixir" })
    table.insert(greedyEmissary, { itemID = 245634, itemName = "Cursing Elixir" })
    table.insert(greedyEmissary, { itemID = 245636, itemName = "Deafening Elixir" })
    table.insert(greedyEmissary, { itemID = 245638, itemName = "Explosive Elixir" })
    table.insert(greedyEmissary, { itemID = 245630, itemName = "Ghostly Elixir" })
    table.insert(greedyEmissary, { itemID = 246127, itemName = "Healthy Elixir" })
    table.insert(greedyEmissary, { itemID = 245590, itemName = "Magma Elixir" })
    table.insert(greedyEmissary, { itemID = 245641, itemName = "Molten Elixir" })
    table.insert(greedyEmissary, { itemID = 245632, itemName = "Rallying Elixir" })
    table.insert(greedyEmissary, { itemID = 245635, itemName = "Rich Elixir" })
    table.insert(greedyEmissary, { itemID = 245633, itemName = "Sneaky Elixir" })
    table.insert(greedyEmissary, { itemID = 245614, itemName = "Trapper Elixir" })
    table.insert(greedyEmissary, { itemID = 245643, itemName = "Storming Elixir" })
    table.insert(greedyEmissary, { itemID = 245640, itemName = "Tempestuous Elixir" })
    table.insert(greedyEmissary, { itemID = 245614, itemName = "Trapper Elixir" })
    table.insert(greedyEmissary, { itemID = 245637, itemName = "Windforce Elixir" })
    -- Add Ensembles
    table.insert(greedyEmissary, { itemID = 244793, itemName = "Ensemble: Grimforged Armor" })
    table.insert(greedyEmissary, { itemID = 244794, itemName = "Ensemble: Armor of Torment" })
    table.insert(greedyEmissary, { itemID = 244795, itemName = "Ensemble: Staghelm Armor" })
    table.insert(greedyEmissary, { itemID = 244796, itemName = "Ensemble: Life-Binder's Armor" })
    table.insert(greedyEmissary, { itemID = 244797, itemName = "Ensemble: Timestalker's Armor" })
    table.insert(greedyEmissary, { itemID = 244798, itemName = "Ensemble: Emberwind Regalia" })
    table.insert(greedyEmissary, { itemID = 244799, itemName = "Ensemble: Death-Touched Battlegear" })
    table.insert(greedyEmissary, { itemID = 244800, itemName = "Ensemble: Blood Vindicator's Armor" })
    table.insert(greedyEmissary, { itemID = 244801, itemName = "Ensemble: Vestments of Searing Radiance" })
    table.insert(greedyEmissary, { itemID = 244802, itemName = "Ensemble: Shadowslayer Armor" })
    table.insert(greedyEmissary, { itemID = 244803, itemName = "Ensemble: Flamelash Armor" })
    table.insert(greedyEmissary, { itemID = 244804, itemName = "Ensemble: Hellfire Raiment" })
    table.insert(greedyEmissary, { itemID = 244805, itemName = "Ensemble: Executioner's Bladed Battlegear" })
    -- Add Mounts, Pets, Cosmetics, Toys, etc.
    table.insert(greedyEmissary, { itemID = 246264, itemName = "Inarius' Charger" })
    table.insert(greedyEmissary, { itemID = 246242, itemName = "Blood-Wrapped Treasure Bag" })
    table.insert(greedyEmissary, { itemID = 206018, itemName = "Baa'lial Soulstone" })
    table.insert(greedyEmissary, { itemID = 206003, itemName = "Horadric Haversack" })
    table.insert(greedyEmissary, { itemID = 76755,  itemName = "Tyrael's Charger" })
    table.insert(greedyEmissary, { itemID = 206005, itemName = "Wirt's Fightin' Leg" })
    table.insert(greedyEmissary, { itemID = 206276, itemName = "Wirt's Last Leg" })
    table.insert(greedyEmissary, { itemID = 206275, itemName = "Wirt's Haunted Leg" })
    table.insert(greedyEmissary, { itemID = 206007, itemName = "Treasure Nabbin' Bag" })
    table.insert(greedyEmissary, { itemID = 206039, itemName = "Enmity Bundle" })
    table.insert(greedyEmissary, { itemID = 206004, itemName = "Enmity Cloak" })
    table.insert(greedyEmissary, { itemID = 206020, itemName = "Enmity Hood" })
    table.insert(greedyEmissary, { itemID = 206008, itemName = "Nightmare Banner" })
    table.insert(greedyEmissary, { itemID = 142542, itemName = "Tome of Town Portal" })
    table.insert(greedyEmissary, { itemID = 143543, itemName = "Twelve-String Guitar" })
    table.insert(greedyEmissary, { itemID = 143327, itemName = "Livestock Lochaber Axe" })
    -- Add Charms
    table.insert(greedyEmissary, { itemID = 245896, itemName = "Small Charm of Adaptability" })
    table.insert(greedyEmissary, { itemID = 245893, itemName = "Small Charm of Alacrity" })
    table.insert(greedyEmissary, { itemID = 245891, itemName = "Small Charm of Inertia" })
    table.insert(greedyEmissary, { itemID = 245892, itemName = "Small Charm of Life" })
    table.insert(greedyEmissary, { itemID = 245894, itemName = "Small Charm of Proficiency" })
    table.insert(greedyEmissary, { itemID = 245895, itemName = "Small Charm of Savagery" })
    table.insert(greedyEmissary, { itemID = 245889, itemName = "Large Charm of Dexterity" })
    table.insert(greedyEmissary, { itemID = 245749, itemName = "Large Charm of Intelligence" })
    table.insert(greedyEmissary, { itemID = 245890, itemName = "Large Charm of Strength" })
    table.insert(greedyEmissary, { itemID = 245924, itemName = "Mongoose's Grand Charm" })
    table.insert(greedyEmissary, { itemID = 245887, itemName = "Stalwart's Grand Charm" })
    table.insert(greedyEmissary, { itemID = 245888, itemName = "Serpent's Grand Charm" })
    table.insert(greedyEmissary, { itemID = 245899, itemName = "Bat's Grand Charm" })
end

function GreedyEmissary:addGreedyEmissaryToCategory()
    local ctx = Context:New('BBGreedyEmissary_AddItemToCategory')
    -- Loop through list of greedyemissary and add to category.
    for _, item in ipairs(greedyEmissary) do
        Categories:AddItemToCategory(ctx, item.itemID, L:G("Greedy Emissary"))
        --@debug@
        print("Added " .. item.itemName .. " to category " .. L:G("Greedy Emissary"))
        --@end-debug@
    end
end

-- On plugin load, wipe the Categories we've added
function GreedyEmissary:OnInitialize()
    self.db = AceDB:New("BetterBags_GreedyEmissaryDB", defaults)
    self.db:SetProfile("global")
    db = self.db.profile

    self:addGreedyEmissaryConfig()
    self:clearGreedyEmissaryCategory()
    self:addGreedyEmissaryItemsToTable()
    self:addGreedyEmissaryToCategory()
end
