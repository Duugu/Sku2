print("modules\\sounds\\code.lua loading", SDL3)
local moduleName = "sounds"
local L = Sku2.L

Sku2.modules[moduleName]._prototypes = Sku2.modules[moduleName]._prototypes or {}
Sku2.modules[moduleName]._prototypes.code = Sku2.modules[moduleName]._prototypes.code or {}
local prototype = Sku2.modules[moduleName]._prototypes.code
setmetatable(prototype, Sku2.modules.MTs.__newindex)

---------------------------------------------------------------------------------------------------------------------------------------
--prototype definition
---------------------------------------------------------------------------------------------------------------------------------------
local module = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
--locals; not flavor specific; will be available as upvalues in all functions



---------------------------------------------------------------------------------------------------------------------------------------
prototype.outputSoundFiles = {
   ["sound-brass1"] = "aura;sound".."#".."brass 1",
   ["sound-brass2"] = "aura;sound".."#".."brass 2",
   ["sound-brass3"] = "aura;sound".."#".."brass 3",
   ["sound-brass4"] = "aura;sound".."#".."brass 4",
   ["sound-brass5"] = "aura;sound".."#".."brass 5",
   ["sound-error_brang"] = "aura;sound".."#".."brang",
   ["sound-error_bring"] = "aura;sound".."#".."bring",
   ["sound-error_dang"] = "aura;sound".."#".."dang",
   ["sound-error_drmm"] = "aura;sound".."#".."drmm",
   ["sound-error_shhhup"] = "aura;sound".."#".."shhhup",
   ["sound-error_spoing"] = "aura;sound".."#".."spoing",
   ["sound-error_swoosh"] = "aura;sound".."#".."swoosh",
   ["sound-error_tsching"] = "aura;sound".."#".."tsching",
   ["sound-glass1"] = "aura;sound".."#".."glass 1",
   ["sound-glass2"] = "aura;sound".."#".."glass 2",
   ["sound-glass3"] = "aura;sound".."#".."glass 3",
   ["sound-glass4"] = "aura;sound".."#".."glass 4",
   ["sound-glass5"] = "aura;sound".."#".."glass 5",
   ["sound-waterdrop1"] = "aura;sound".."#".."waterdrop 1",
   ["sound-waterdrop2"] = "aura;sound".."#".."waterdrop 2",
   ["sound-waterdrop3"] = "aura;sound".."#".."waterdrop 3",
   ["sound-waterdrop4"] = "aura;sound".."#".."waterdrop 4",
   ["sound-waterdrop5"] = "aura;sound".."#".."waterdrop 5",
   ["sound-notification1"] = "aura;sound".."#".."notification".." 1",
   ["sound-notification2"] = "aura;sound".."#".."notification".." 2",
   ["sound-notification3"] = "aura;sound".."#".."notification".." 3",
   ["sound-notification4"] = "aura;sound".."#".."notification".." 4",
   ["sound-notification5"] = "aura;sound".."#".."notification".." 5",
   ["sound-notification6"] = "aura;sound".."#".."notification".." 6",
   ["sound-notification7"] = "aura;sound".."#".."notification".." 7",
   ["sound-notification8"] = "aura;sound".."#".."notification".." 8",
   ["sound-notification9"] = "aura;sound".."#".."notification".." 9",
   ["sound-notification10"] = "aura;sound".."#".."notification".." 10",
   ["sound-notification11"] = "aura;sound".."#".."notification".." 11",
   ["sound-notification12"] = "aura;sound".."#".."notification".." 12",
   ["sound-notification13"] = "aura;sound".."#".."notification".." 13",
   ["sound-notification14"] = "aura;sound".."#".."notification".." 14",
   ["sound-notification15"] = "aura;sound".."#".."notification".." 15",
   ["sound-notification16"] = "aura;sound".."#".."notification".." 16",
   ["sound-notification17"] = "aura;sound".."#".."notification".." 17",
   ["sound-notification18"] = "aura;sound".."#".."notification".." 18",
   ["sound-notification19"] = "aura;sound".."#".."notification".." 19",
   ["sound-notification20"] = "aura;sound".."#".."notification".." 20",
   ["sound-notification21"] = "aura;sound".."#".."notification".." 21",
   ["sound-notification22"] = "aura;sound".."#".."notification".." 22",
   ["sound-notification23"] = "aura;sound".."#".."notification".." 23",
   ["sound-notification24"] = "aura;sound".."#".."notification".." 24",
   ["sound-notification25"] = "aura;sound".."#".."notification".." 25",
   ["sound-notification26"] = "aura;sound".."#".."notification".." 26",
   ["sound-notification27"] = "aura;sound".."#".."notification".." 27",
   ["sound-axe01"] = "aura;sound".."#axe 01",
   ["sound-blaze01"] = "aura;sound".."#blaze 01",
   ["sound-interface01"] = "aura;sound".."#interface 01",
   ["sound-interface02"] = "aura;sound".."#interface 02",
   ["sound-interface03"] = "aura;sound".."#interface 03",
   ["sound-interface04"] = "aura;sound".."#interface 04",
   ["sound-interface05"] = "aura;sound".."#interface 05",
   ["sound-interface06"] = "aura;sound".."#interface 06",
   ["sound-shot01"] = "aura;sound".."#shot 01",
   ["sound-sword01"] = "aura;sound".."#sword 01",
   ["sound-sword02"] = "aura;sound".."#sword 02",
   ["sound-sword03"] = "aura;sound".."#sword 03",
   ["sound-TutorialClose01"] = "aura;sound".."#Tutorial Close 01",
   ["sound-TutorialOpen01"] = "aura;sound".."#Tutorial Open 01",
   ["sound-TutorialSuccess01"] = "aura;sound".."#Tutorial Success 01",
}

---------------------------------------------------------------------------------------------------------------------------------------
function prototype:SetUpModule()
	print(moduleName, "SetUpModule", self)
	
end

---------------------------------------------------------------------------------------------------------------------------------------
--remaining module specific functions
