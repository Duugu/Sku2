print("modules\\bags\\settings.lua loading", SDL3)
local moduleName = "bags"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.settings = {}
local prototype = Sku2.modules[moduleName]._prototypes.settings

---------------------------------------------------------------------------------------------------------------------------------------
-- module settings
---------------------------------------------------------------------------------------------------------------------------------------
--upvalue to reference the final module inside the function definitions
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- char
prototype.char = {
}

---------------------------------------------------------------------------------------------------------------------------------------
-- global
prototype.global = {
}

---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {
}
