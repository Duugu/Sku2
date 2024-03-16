print("modules\\audioMenu\\menu.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local moduleName = "audioMenu"
Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.UI = {}
local prototype = Sku2.modules[moduleName]._prototypes.UI
local this = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- module UI
---------------------------------------------------------------------------------------------------------------------------------------
