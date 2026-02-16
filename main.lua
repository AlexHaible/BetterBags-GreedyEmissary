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


local defaults = {
    profile = {}
}
local configOptions

-- List of Item IDs for Greedy Emissary
local greedyEmissary = {
    -- Hellcaller Chest
    245589,
    -- Elixirs
    245639, 245642, 246114, 245652, 245654, 245634, 245636, 245638,
    245630, 246127, 245590, 245641, 245632, 245635, 245633, 245614,
    245643, 245640, 245637,
    -- Ensembles
    244793, 244794, 244795, 244796, 244797, 244798, 244799, 244800,
    244801, 244802, 244803, 244804, 244805,
    -- Mounts, Pets, Cosmetics, Toys, etc.
    246264, 246242, 206018, 206003, 76755, 206005, 206276, 206275,
    206007, 206039, 206004, 206020, 206008, 142542, 143543, 143327,
    -- Charms
    245896, 245893, 245891, 245892, 245894, 245895, 245889, 245749,
    245890, 245924, 245887, 245888, 245899
}

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



function GreedyEmissary:addGreedyEmissaryToCategory()
    local ctx = Context:New('BBGreedyEmissary_AddItemToCategory')
    local categoryName = L:G("Greedy Emissary")
    -- Loop through list of greedyemissary and add to category.
    for _, itemID in ipairs(greedyEmissary) do
        Categories:AddItemToCategory(ctx, itemID, categoryName)
    end
end

-- On plugin load, wipe the Categories we've added
function GreedyEmissary:OnInitialize()
    self.db = AceDB:New("BetterBags_GreedyEmissaryDB", defaults)
    self.db:SetProfile("global")


    self:addGreedyEmissaryConfig()
    self:clearGreedyEmissaryCategory()

    self:addGreedyEmissaryToCategory()
end
