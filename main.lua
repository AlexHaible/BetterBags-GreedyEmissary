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
            forceRefreshGreedyEmissarys = {
                type = "execute",
                name = "Force Refresh",
                desc = "This will forcibly refresh the Greedy Emissary category.",
                func = function()
                    GreedyEmissary:clearGreedyEmissaryCategory()
                    GreedyEmissary:addGreedyEmissaryItemsToTable()
                    GreedyEmissary:addGreedy EmissaryToCategory()
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

    Config:AddPluginConfig("Greedy Emissary", configOptions)
end

function GreedyEmissary:clearGreedyEmissaryCategory()
    Categories:WipeCategory(Context:New('BBGreedyEmissary_DeleteCategory'),L:G("Greedy Emissary"))
end

function GreedyEmissary:addGreedyEmissaryItemsToTable()
    -- Clear the table of items if needed.
    table.wipe(greedyemissary)

    -- Add Greedy Emissary items.
    table.insert(greedyemissary, { itemID = 243056, itemName = "Delver's Mana-Bound Ethergate" })
    table.insert(greedyemissary, { itemID = 245970, itemName = "P.O.S.T. Master's Express Hearthstone" })
    table.insert(greedyemissary, { itemID = 246565, itemName = "Cosmic Hearthstone" })
end

function GreedyEmissary:addGreedyEmissaryToCategory()
    local ctx = Context:New('BBGreedyEmissary_AddItemToCategory')
    -- Loop through list of greedyemissary and add to category.
    for _, item in ipairs(greedyemissary) do
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
