print("modules\\auras\\data.lua loading", SDL3)
local moduleName = "auras"
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
local tonumber = tonumber
local sgsub = string.gsub
local supper = string.upper
local sfind = string.find
local ssplit = string.split



------------------------------------------------------------------------------------------------------------------
function prototype:RemoveTags(aValue)
   if type(aValue) ~= "string" then
      return aValue
   end
   local tCleanValue = sgsub(aValue, "item:", "")
   tCleanValue = sgsub(tCleanValue, "spell:", "")
   tCleanValue = sgsub(tCleanValue, "output:", "")
   if tCleanValue == "true" then
      return true
   elseif tCleanValue == "false" then
      return false
   else
      return tCleanValue
   end
end

function prototype:SetUpData()
   ------------------------------------------------------------------------------------------------------------------
   local function KeyValuesHelper()
      local tKeys = {
         "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Ä", "Ö", "Ü", 
         "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
         "BACKSPACE", "BACKSPACE_MAC", "DELETE", "DELETE_MAC", "DOWN", "END", "ENTER", "ENTER_MAC", "ESCAPE", "HOME", 
         "INSERT", "INSERT_MAC", "LEFT", "NUMLOCK", "NUMLOCK_MAC", "NUMPAD0", "NUMPAD1", "NUMPAD2", "NUMPAD3", "NUMPAD4", 
         "NUMPAD5", "NUMPAD6", "NUMPAD7", "NUMPAD8", "NUMPAD9", "NUMPADDECIMAL", "NUMPADDIVIDE", "NUMPADMINUS", "NUMPADMULTIPLY", 
         "NUMPADPLUS", "PAGEDOWN", "PAGEUP", "PAUSE", "PAUSE_MAC", "PRINTSCREEN", "PRINTSCREEN_MAC", "RIGHT", "SCROLLLOCK", 
         "SCROLLLOCK_MAC", "SPACE", "TAB", "TILDE", "'", "%+", "´", ",", "#",
         "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
      }

      local tModifiers = {"CTRL-", "SHIFT-", "ALT-", "CTRL-SHIFT-", "CTRL-ALT-", "SHIFT-ALT-", }
      local tResultTable = {}

      for x = 1, #tKeys do
         if Sku2.modules.keyBindings.keys.locNames[supper(tKeys[x])] then
            tResultTable[tKeys[x]] = Sku2.modules.keyBindings.keys.locNames[supper(tKeys[x])]
         else
            tResultTable[tKeys[x]] = tKeys[x]
         end
      end

      for y = 1, #tModifiers do
         local tLocModifier = sgsub(tModifiers[y], "CTRL", Sku2.modules.keyBindings.keys.locNames["CTRL"])
         for x = 1, #tKeys do
            if Sku2.modules.keyBindings.keys.locNames[supper(tKeys[x])] then
               tResultTable[tModifiers[y]..tKeys[x]] = tLocModifier..Sku2.modules.keyBindings.keys.locNames[supper(tKeys[x])]
            else
               tResultTable[tModifiers[y]..tKeys[x]] = tLocModifier..tKeys[x]
            end
         end
      end
      return tResultTable
   end

   ------------------------------------------------------------------------------------------------------------------
   local function tNothingOutputFunction(tAuraName, tEvaluateData, aFirst, aInstant)
      --print("    module.outputs nothing nothing","module.outputs.event", tEvaluateData.event, aFirst, aInstant)
      return
   end


   ------------------------------------------------------------------------------------------------------------------
   module.itemTypes = {
      ["type"] = {
         friendlyName = "Aura Typ",
      },
      ["attribute"] = {
         friendlyName = "Attribut für Bedingung",
      },
      ["operator"] = {
         friendlyName = "Operator für Bedingung",
      },
      ["value"] = {
         friendlyName = "Wert für Bedingung",
      },
      ["then"] = {
         friendlyName = "Beginn des Dann Teils der Aura",
      },
      ["action"] = {
         friendlyName = "Aktion für Aura",
      },
      ["output"] = {
         friendlyName = "Ausgabe von Aura",
      },
   }
   ------------------------------------------------------------------------------------------------------------------
   module.actions = {
      nothing = {
         tooltip = "No action",
         friendlyName = "No action",
         func = function(tAuraName, tEvaluateData)
            --print("    module.actions nothing")
         end,
         single = false,
      },

      notifyAudio = {
         tooltip = "Die Ausgaben werden als Audio ausgegeben",
         friendlyName = "audio ausgabe",
         func = function(tAuraName, tEvaluateData)
            ----dprint("    ","action func audio benachrichtigung DING")
         end,
         single = false,
      },
      notifyChat = {
         tooltip = "Die Ausgaben werden als Text im Chat ausgegeben",
         friendlyName = "chat ausgabe",
         func = function(tAuraName, tEvaluateData)
            ----dprint("    ","action func chat benachrichtigung")
         end,
         single = false,
      },
      notifyAudioSingle = {
         tooltip = "Die Ausgaben werden als Audio ausgegeben. Die Aura wird jedoch nur einmal ausgelöst. Die nächste Auslösung der Aura erfolgt erst dann, wenn die Aura mindestens einmal nicht zugetroffen hat.",
         friendlyName = "audio ausgabe einmal",
         func = function(tAuraName, tEvaluateData)
            ----dprint("    ","action func audio benachrichtigung single")
         end,
         single = true,
      },
      notifyAudioAndChatSingle = {
         tooltip = "Die Ausgaben werden als Audio und chat ausgegeben",
         friendlyName = "audio und chat ausgabe",
         func = function(tAuraName, tEvaluateData)
            ----dprint("    ","action func audio benachrichtigung DING")
         end,
         single = true,
      },
      --[[
      notifyAudioSingleInstant = {
         tooltip = "Die Ausgaben werden als Audio ausgegeben und dabei vor allen anderen Ausgaben platziert. Die Aura wird jedoch nur einmal ausgelöst. Die nächste Auslösung der Aura erfolgt erst dann, wenn die Aura mindestens einmal nicht zugetroffen hat.",
         friendlyName = "audio ausgabe einmal sofort",
         func = function(tAuraName, tEvaluateData)
            --dprint("    ","action func audio benachrichtigung SingleInstant")
         end,
         single = true,
         instant = true,
      },
      ]]
      notifyChatSingle = {
         tooltip = "Die Ausgaben werden als Text im Chat ausgegeben. Die Aura wird jedoch nur einmal ausgelöst. Die nächste Auslösung der Aura erfolgt erst dann, wenn die Aura mindestens einmal nicht zugetroffen hat.",
         friendlyName = "chat ausgabe einmal",
         func = function(tAuraName, tEvaluateData)
            --dprint("    ","action func chat benachrichtigung single")
         end,
         single = true,
      },
   }

   ------------------------------------------------------------------------------------------------------------------
   --local tPrevAuraPlaySoundFileHandle
   module.outputs = {
      nothing = {
         tooltip = "No output",
         friendlyName = "nothing",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = tNothingOutputFunction,
            ["notifyChat"] = tNothingOutputFunction,
         },
      },
      event = {
         tooltip = "Der Name des auslösenden Ereignisses der Aura",
         friendlyName = "ereignis",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst, aInstant)
               --dprint("    ","module.outputs.event", tEvaluateData.event, aFirst, aInstant)
               if not tEvaluateData.event then return end
               if not module.values[tEvaluateData.event] then return end
               if module.values[tEvaluateData.event].friendlyNameShort then
                  --SkuOptions.Voice:OutputString(module.values[tEvaluateData.event].friendlyNameShort, aFirst, true, 0.1, true)
               else
                  --SkuOptions.Voice:OutputString(module.values[tEvaluateData.event].friendlyName, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if not tEvaluateData.event then return end
               if not module.values[tEvaluateData.event] then return end
               if module.values[tEvaluateData.event].friendlyNameShort then
                  print(module.values[tEvaluateData.event].friendlyNameShort)
               else
                  print(module.values[tEvaluateData.event].friendlyName)
               end
            end,
         },
      },
      sourceUnitId = {
         tooltip = "Die Einheiten ID der Quelle für das ausgelöste Ereignis",
         friendlyName = "quell einheit",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.sourceUnitId then
                  --dprint("    ","tEvaluateData.sourceUnitId", tEvaluateData.sourceUnitId)
                  --SkuOptions.Voice:OutputString(tEvaluateData.sourceUnitId[1], aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.sourceUnitId then
                  print(tEvaluateData.sourceUnitId)
               end
            end,
         },
      },   
      destUnitId = {
         tooltip = "Die Einheiten ID des Ziels für das ausgelöste Ereignis",
         friendlyName = "ziel einheit",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               --dprint("    ","tEvaluateData.destUnitId", tEvaluateData.destUnitId)
               if tEvaluateData.destUnitId then
                  --SkuOptions.Voice:OutputString(tEvaluateData.destUnitId[1], aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.destUnitId then
                  print(tEvaluateData.destUnitId)
               end
            end,
         },
      },
      unitHealthPlayer = {
         tooltip = "Dein Gesundheit in Prozent",
         friendlyName = "eigene Gesundheit",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitHealthPlayer then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitHealthPlayer, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitHealthPlayer then
                  print(tEvaluateData.unitHealthPlayer)
               end
            end,
         },
      },      
      auraAmount = {
         tooltip = "Die Stapel Anzahl der Aura",
         friendlyName = "aura stapel",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.auraAmount then
                  --SkuOptions.Voice:OutputString(tEvaluateData.auraAmount, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.auraAmount then
                  print(tEvaluateData.auraAmount)
               end
            end,
         },
      },
      --[[
      class = {
         tooltip = "Die Klasse der Einheit für das ausgelöste Ereignis",
         friendlyName = "klasse",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.class then
                  --SkuOptions.Voice:OutputString(tEvaluateData.class, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.class then
                  print(tEvaluateData.class)
               end
            end,
         },
      },
      ]]
      unitPowerPlayer = {
         tooltip = "Deine Ressourcen Menge (Mana, Wut, Energie) für das ausgelöste Ereignis",
         friendlyName = "eigene Ressource",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitPowerPlayer then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitPowerPlayer, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitPowerPlayer then
                  print(tEvaluateData.unitPowerPlayer)
               end
            end,
         },
      },
      unitComboPlayer = {
         tooltip = "Deine combopunkte auf dein aktuelles ziel",
         friendlyName = "Eigene combopunkte",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitComboPlayer then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitComboPlayer, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitComboPlayer then
                  print(tEvaluateData.unitComboPlayer)
               end
            end,
         },
      },

      unitHealthPlayer = {
         tooltip = "Deine Gesundheits Menge für das ausgelöste Ereignis",
         friendlyName = "eigene gesundheit",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitHealthPlayer then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitHealthPlayer, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitHealthPlayer then
                  print(tEvaluateData.unitHealthPlayer)
               end
            end,
         },
      },
      unitHealthTarget = {
         tooltip = "Your target's health percentage",
         friendlyName = "Your target's health",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitHealthTarget then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitHealthTarget, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitHealthTarget then
                  print(tEvaluateData.unitHealthTarget)
               end
            end,
         },
      },
      unitPowerTarget = {
         tooltip = "Percentage of your target's primary resource, for example mana or rage",
         friendlyName = "Your target's resource",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitPowerTarget then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitPowerTarget, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitPowerTarget then
                  print(tEvaluateData.unitPowerTarget)
               end
            end,
         },
      },
      unitHealthOrPowerUpdate = {
         tooltip = "The updated health or resource percentage from a health update or resource update event",
         friendlyName = "Health/Resource update",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.unitHealthOrPowerUpdate then
                  --SkuOptions.Voice:OutputString(tEvaluateData.unitHealthOrPowerUpdate, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.unitHealthOrPowerUpdate then
                  print(tEvaluateData.unitHealthOrPowerUpdate)
               end
            end,
         },
      },
      damageAmount = {
         tooltip = "The amount of damage from a spell, melee, or ranged attack",
         friendlyName = "Damage amount",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.damageAmount then
                  --SkuOptions.Voice:OutputString(tEvaluateData.damageAmount, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.damageAmount then
                  print(tEvaluateData.damageAmount)
               end
            end,
         },
      },
      healAmount = {
         tooltip = "The amount of healing",
         friendlyName = "Healing amount",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.healAmount then
                  --SkuOptions.Voice:OutputString(tEvaluateData.healAmount, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.healAmount then
                  print(tEvaluateData.healAmount)
               end
            end,
         },
      },
      overhealingAmount = {
         tooltip = "The amount of overhealing",
         friendlyName = "Overhealing amount",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.overhealingAmount then
                  --SkuOptions.Voice:OutputString(tEvaluateData.overhealingAmount, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.overhealingAmount then
                  print(tEvaluateData.overhealingAmount)
               end
            end,
         },
      },
      overhealingPercentage = {
         tooltip = "How much of the healing amount was overhealing",
         friendlyName = "Overhealing percentage",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.overhealingPercentage then
                  --SkuOptions.Voice:OutputString(tEvaluateData.overhealingPercentage, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.overhealingPercentage then
                  print(tEvaluateData.overhealingPercentage)
               end
            end,
         },
      },
      spellName = {
         tooltip = "Der Name des Zaubers, der die Aura ausgelöst hat",
         friendlyName = "zauber name",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.spellName then
                  --SkuOptions.Voice:OutputString(tEvaluateData.spellName, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.spellName then
                  print(tEvaluateData.spellName)
               end
            end,
         },
      },
      itemName = {
         tooltip = "Der Name des Gegenstands, der die Aura ausgelöst hat",
         friendlyName = "gegenstand name",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.itemName then
                  --SkuOptions.Voice:OutputString(tEvaluateData.itemName, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.itemName then
                  print(tEvaluateData.itemName)
               end
            end,
         },
      },
      itemCount = {
         tooltip = "Die Anzahl in deiner Tasche des Gegenstands, der die Aura ausgelöst hat",
         friendlyName = "gegenstand anzahl",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.itemCount then
                  --SkuOptions.Voice:OutputString(tEvaluateData.itemCount, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.itemCount then
                  print(tEvaluateData.itemCount)
               end
            end,
         },
      },
      buffListTarget = {
         tooltip = "Aura, die in der Buff liste des Ziels gesucht oder ausgeschlossen wurde",
         friendlyName = "wert buff liste ziel",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.buffListTarget then
                  --SkuOptions.Voice:OutputString(tEvaluateData.buffListTarget, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.buffListTarget then
                  print(tEvaluateData.buffListTarget)
               end
            end,
         },
      },
      debuffListTarget = {
         tooltip = "Aura, die in der Debuff liste des Ziels gesucht oder ausgeschlossen wurde",
         friendlyName = "wert debuff liste ziel",
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst)
               if tEvaluateData.debuffListTarget then
                  --SkuOptions.Voice:OutputString(tEvaluateData.debuffListTarget, aFirst, true, 0.1, true)
               end
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               if tEvaluateData.debuffListTarget then
                  print(tEvaluateData.debuffListTarget)
               end
            end,
         },
      },
   }

   module.outputSoundFiles = Sku2.modules.sounds.outputSoundFiles

   for tOutputString, tFriendlyName in pairs(module.outputSoundFiles) do
      module.outputs[tOutputString] = {
         tooltip = tFriendlyName,
         outputString = tOutputString,
         friendlyName = tFriendlyName,
         functs = {
            ["nothing"] = tNothingOutputFunction,
            ["notifyAudio"] = function(tAuraName, tEvaluateData, aFirst, aOutputName, aDelay)
               --if aFirst == true then
                  --[[
                  if tPrevAuraPlaySoundFileHandle then
                     StopSound(tPrevAuraPlaySoundFileHandle)
                  end
                  ]]
                  ----SkuOptions.Voice:OutputString("sound-silence0.1", true, false, 0.3, true)
               --end
               --SkuOptions.Voice:OutputString(tOutputString, aFirst, true, 0.3, true)
            end,
            ["notifyChat"] = function(tAuraName, tEvaluateData)
               print(tFriendlyName)
            end,
         },
      }
   end

   ------------------------------------------------------------------------------------------------------------------
   module.valuesDefault = {
      --auraAmount;itemCount
         ["0"] = {friendlyName = "0"},
         ["1"] = {friendlyName = "1"},
         ["2"] = {friendlyName = "2"},
         ["3"] = {friendlyName = "3"},
         ["4"] = {friendlyName = "4"},
         ["5"] = {friendlyName = "5"},
         ["6"] = {friendlyName = "6"},
         ["7"] = {friendlyName = "7"},
         ["8"] = {friendlyName = "8"},
         ["9"] = {friendlyName = "9"},
         ["10"] = {friendlyName = "10"},
         ["11"] = {friendlyName = "11"},
         ["12"] = {friendlyName = "12"},
         ["13"] = {friendlyName = "13"},
         ["14"] = {friendlyName = "14"},
         ["15"] = {friendlyName = "15"},
         ["16"] = {friendlyName = "16"},
         ["17"] = {friendlyName = "17"},
         ["18"] = {friendlyName = "18"},
         ["19"] = {friendlyName = "19"},
         ["20"] = {friendlyName = "20"},
         ["21"] = {friendlyName = "21"},
         ["22"] = {friendlyName = "22"},
         ["23"] = {friendlyName = "23"},
         ["24"] = {friendlyName = "24"},
         ["25"] = {friendlyName = "25"},
         ["26"] = {friendlyName = "26"},
         ["27"] = {friendlyName = "27"},
         ["28"] = {friendlyName = "28"},
         ["29"] = {friendlyName = "29"},
         ["30"] = {friendlyName = "30"},
         ["31"] = {friendlyName = "31"},
         ["32"] = {friendlyName = "32"},
         ["33"] = {friendlyName = "33"},
         ["34"] = {friendlyName = "34"},
         ["35"] = {friendlyName = "35"},
         ["36"] = {friendlyName = "36"},
         ["37"] = {friendlyName = "37"},
         ["38"] = {friendlyName = "38"},
         ["39"] = {friendlyName = "39"},
         ["40"] = {friendlyName = "40"},
         ["41"] = {friendlyName = "41"},
         ["42"] = {friendlyName = "42"},
         ["43"] = {friendlyName = "43"},
         ["44"] = {friendlyName = "44"},
         ["45"] = {friendlyName = "45"},
         ["46"] = {friendlyName = "46"},
         ["47"] = {friendlyName = "47"},
         ["48"] = {friendlyName = "48"},
         ["49"] = {friendlyName = "49"},
         ["50"] = {friendlyName = "50"},
         ["51"] = {friendlyName = "51"},
         ["52"] = {friendlyName = "52"},
         ["53"] = {friendlyName = "53"},
         ["54"] = {friendlyName = "54"},
         ["55"] = {friendlyName = "55"},
         ["56"] = {friendlyName = "56"},
         ["57"] = {friendlyName = "57"},
         ["58"] = {friendlyName = "58"},
         ["59"] = {friendlyName = "59"},
         ["60"] = {friendlyName = "60"},
         ["61"] = {friendlyName = "61"},
         ["62"] = {friendlyName = "62"},
         ["63"] = {friendlyName = "63"},
         ["64"] = {friendlyName = "64"},
         ["65"] = {friendlyName = "65"},
         ["66"] = {friendlyName = "66"},
         ["67"] = {friendlyName = "67"},
         ["68"] = {friendlyName = "68"},
         ["69"] = {friendlyName = "69"},
         ["70"] = {friendlyName = "70"},
         ["71"] = {friendlyName = "71"},
         ["72"] = {friendlyName = "72"},
         ["73"] = {friendlyName = "73"},
         ["74"] = {friendlyName = "74"},
         ["75"] = {friendlyName = "75"},
         ["76"] = {friendlyName = "76"},
         ["77"] = {friendlyName = "77"},
         ["78"] = {friendlyName = "78"},
         ["79"] = {friendlyName = "79"},
         ["80"] = {friendlyName = "80"},
         ["81"] = {friendlyName = "81"},
         ["82"] = {friendlyName = "82"},
         ["83"] = {friendlyName = "83"},
         ["84"] = {friendlyName = "84"},
         ["85"] = {friendlyName = "85"},
         ["86"] = {friendlyName = "86"},
         ["87"] = {friendlyName = "87"},
         ["88"] = {friendlyName = "88"},
         ["89"] = {friendlyName = "89"},
         ["90"] = {friendlyName = "90"},
         ["91"] = {friendlyName = "91"},
         ["92"] = {friendlyName = "92"},
         ["93"] = {friendlyName = "93"},
         ["94"] = {friendlyName = "94"},
         ["95"] = {friendlyName = "95"},
         ["96"] = {friendlyName = "96"},
         ["97"] = {friendlyName = "97"},
         ["98"] = {friendlyName = "98"},
         ["99"] = {friendlyName = "99"},
         ["100"] = {friendlyName = "100"},
         ["110"] = {friendlyName = "110"},
         ["120"] = {friendlyName = "120"},
         ["130"] = {friendlyName = "130"},
         ["140"] = {friendlyName = "140"},
         ["150"] = {friendlyName = "150"},
         ["200"] = {friendlyName = "200"},
         ["300"] = {friendlyName = "300"},
         ["400"] = {friendlyName = "400"},
         ["500"] = {friendlyName = "500"},

      
         ["true"] = {
            tooltip = "triff zu",
            friendlyName = "wahr",
         },
         ["false"] = {
            tooltip = "Trifft nicht zu",
            friendlyName = "falsch",
         },

      --missType
         ["ABSORB"] = {
            tooltip = "Absorbiert",
            friendlyName = "Absorbiert",
         },
         ["BLOCK"] = {
            tooltip = "Geblockt",
            friendlyName = "Geblockt",
         },
         ["DEFLECT"] = {
            tooltip = "Umgelenkt",
            friendlyName = "Umgelenkt",
         },
         ["DODGE"] = {
            tooltip = "Ausgewichen",
            friendlyName = "Ausgewichen",
         },
         ["EVADE"] = {
            tooltip = "Vermieden",
            friendlyName = "Vermieden",
         },
         ["IMMUNE"] = {
            tooltip = "Immun",
            friendlyName = "Immun",
         },
         ["MISS"] = {
            tooltip = "Verfehlt",
            friendlyName = "Verfehlt",
         },
         ["PARRY"] = {
            tooltip = "Pariert",
            friendlyName = "Pariert",
         },
         ["REFLECT"] = {
            tooltip = "Reflektiert",
            friendlyName = "Reflektiert",
         },
         ["RESIST"] = {
            tooltip = "Widerstanden",
            friendlyName = "Widerstanden",
         },
      --auraType
         ["BUFF"] = {
            tooltip = "Reagiert, wenn der Aura-Typ ein Buff ist",
            friendlyName = "buff",
         },
         ["DEBUFF"] = {
            tooltip = "Reagiert, wenn der Aura-Typ ein Debuff ist",
            friendlyName = "debuff",
         },
      --destUnitId
         ["target"] = {
            tooltip = "dein aktuelles Ziel. Beispiel: Ein Debuff, der auf deinem aktuelle Ziel ausgelaufen ist",
            friendlyName = "dein ziel",
         },
         ["player"] = {
            tooltip = "du selbst. Beispiel: Ein Buff, der auf dich gezaubert wurde",
            friendlyName = "selbst",
         },
         ["pet"] = {
            tooltip = "The player character's active pet",
            friendlyName = "Your pet",
         },
         ["focus"] = {
            tooltip = "dein fokus. Beispiel: Ein Buff, der auf deinen focus gezaubert wurde",
            friendlyName = "fokus",
         },
         ["partyWoPlayer"] = {
            tooltip = "ein beliebiges Gruppenmitglied. Beispiel: Ein Buff, der auf einem Gruppenmitglied ausgelaufen ist",
            friendlyName = "gruppenmitglieder ohne dich",
         },
         ["party"] = {
            tooltip = "ein beliebiges Gruppenmitglied. Beispiel: Ein Buff, der auf einem Gruppenmitglied ausgelaufen ist",
            friendlyName = "gruppenmitglieder",
         },
         ["party0"] = {
            tooltip = "Gruppenmitglied 0 (du).",
            friendlyName = "gruppenmitglied 0",
         },      
         ["party1"] = {
            tooltip = "Gruppenmitglied 1.",
            friendlyName = "gruppenmitglied 1",
         },      
         ["party2"] = {
            tooltip = "Gruppenmitglied 2.",
            friendlyName = "gruppenmitglied 2",
         },      
         ["party3"] = {
            tooltip = "Gruppenmitglied 3.",
            friendlyName = "gruppenmitglied 3",
         },      
         ["party4"] = {
            tooltip = "Gruppenmitglied 4.",
            friendlyName = "gruppenmitglied 4",
         },      
         ["all"] = {
            tooltip = "eine beliebige Einheit. Beispiel: Irgendein Mob stirbt",
            friendlyName = "alle",
         },


         ["targettarget"] = {
            tooltip = "ziel deines Ziels",
            friendlyName = "ziel deines ziels",
         },
         ["focustarget"] = {
            tooltip = "ziel deines deines fokus",
            friendlyName = "ziel deines fokus",
         },
         ["party0target"] = {
            tooltip = "ziel von Gruppenmitglied 0 (du).",
            friendlyName = "ziel von gruppenmitglied 0",
         },      
         ["party1target"] = {
            tooltip = "ziel von Gruppenmitglied 1.",
            friendlyName = "ziel von gruppenmitglied 1",
         },      
         ["party2target"] = {
            tooltip = "ziel von Gruppenmitglied 2.",
            friendlyName = "ziel von gruppenmitglied 2",
         },      
         ["party3target"] = {
            tooltip = "ziel von Gruppenmitglied 3.",
            friendlyName = "ziel von gruppenmitglied 3",
         },      
         ["party4target"] = {
            tooltip = "ziel von Gruppenmitglied 4.",
            friendlyName = "ziel von gruppenmitglied 4",
         },      
      --class
         ["Warrior"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Krieger hat",
            friendlyName = "krieger",
         },
         ["Paladin"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Paladin hat",
            friendlyName = "paladin",
         },
         ["Hunter"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Jäger hat",
            friendlyName = "jäger",
         },
         ["Rogue"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Schurke hat",
            friendlyName = "schurke",
         },
         ["Priest"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Priester hat",
            friendlyName = "priester",
         },
         ["Death Knight"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Todesritter hat",
            friendlyName = "todesritter",
         },
         ["Shaman"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Schamane hat",
            friendlyName = "schamane",
         },
         ["Mage"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Magier hat",
            friendlyName = "magier",
         },
         ["Warlock"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Hexer hat",
            friendlyName = "hexer",
         },
         --["Monk"] = {
            --tooltip = "Reagiert, wenn die Zieleinheit die Klasse Mönch hat",
            --friendlyName = "mönch",
         --},
         ["Druid"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Druide hat",
            friendlyName = "druide",
         },
         ["Demon Hunter"] = {
            tooltip = "Reagiert, wenn die Zieleinheit die Klasse Dämonenjäger hat",
            friendlyName = "dämonenjäger",
         },
      --event
         ["UNIT_TARGETCHANGE"] = {
            tooltip = "Eine Einheit hat das Ziel gewechselt. Quell Einheit ID ist die Einheit, die das Ziel gewechselt hat. Ziel Einheit ID ist das neue Ziel von Quell einheit.",
            friendlyName = "Ziel änderung",
            friendlyNameShort = "ziel änderung",
         },
         ["UNIT_POWER"] = {
            tooltip = "Ressource hat sich verändert (Mana, Energie, Wut etc.",
            friendlyName = "Ressourcen änderung",
            friendlyNameShort = "ressource",
         },
         ["UNIT_HEALTH"] = {
            tooltip = "Gesundheit hat sich verändert",
            friendlyName = "Gesundheit änderung",
            friendlyNameShort = "gesundheit",
         },
         ["SPELL_AURA_APPLIED;SPELL_AURA_REFRESH;SPELL_AURA_APPLIED_DOSE"] = {
            tooltip = "Buff oder Debuff erhalten oder erneuert",
            friendlyName = "aura erhalten",
            friendlyNameShort = "erhalten",
         },
         ["SPELL_AURA_REMOVED"] = {
            tooltip = "Buff oder Debuff verloren",
            friendlyName = "aura verloren",
            friendlyNameShort = "verloren",
         },
         ["SPELL_CAST_START"] = {
            tooltip = "Ein Zauber wurde begonnen",
            friendlyName = "zauber start",
         },
         ["SPELL_CAST_SUCCESS"] = {
            tooltip = "Ein Zauber wurde erfolgreich gezaubert",
            friendlyName = "zauber erfolgreich",
         },
         ["SPELL_COOLDOWN_START"] = {
            tooltip = "Der Cooldown eines Zaubers hat begonnen",
            friendlyName = "zauber cooldown start",  
            friendlyNameShort = "cooldown",
         },
         ["SPELL_COOLDOWN_END"] = {
            tooltip = "Der Cooldown eines Zaubers ist beendet",
            friendlyName = "zauber cooldown ende", 
            friendlyNameShort = "bereit",
         },
         ["ITEM_COOLDOWN_START"] = {
            tooltip = "Der Cooldown eines Gegenstands hat begonnen",
            friendlyName = "gegenstand cooldown start", 
            friendlyNameShort = "cooldown",
         },
         ["ITEM_COOLDOWN_END"] = {
            tooltip = "Der Cooldown eines Gegenstands ist beendet",
            friendlyName = "gegenstand cooldown ende", 
            friendlyNameShort = "bereit",
         },
         ["SWING_DAMAGE"] = {
            tooltip = "Ein Nahkampfangriff hat Schaden verursacht",
            friendlyName = "nahkampf schaden",
         },
         ["SWING_MISSED"] = {
            tooltip = "Ein Nahkampfangriff hat verfehlt",
            friendlyName = "nahkampf verfehlt",
         },
         ["SWING_EXTRA_ATTACKS"] = {
            tooltip = "Ein Nahkampfangriff hat einen Extrangriff gewährt",
            friendlyName = "nahkampf zusatz angriff",
         },
         ["SWING_ENERGIZE"] = {
            tooltip = "Ein Nahkampfangriff hat eine Ressource (Wut, Energie, Kombopunkt) gewährt",
            friendlyName = "nahkampf ressource",
         },
         ["RANGE_DAMAGE"] = {
            tooltip = "Ein Fernkampfangriff hat Schaden verursacht",
            friendlyName = "fernkampf schaden",
         },
         ["RANGE_MISSED"] = {
            tooltip = "Ein Fernkampfangriff hat verfehlt",
            friendlyName = "fernkampf verfehlt",
         },
         ["RANGE_EXTRA_ATTACKS"] = {
            tooltip = "Ein Fernkampfangriff hat einen Extraangriff ausgelöst",
            friendlyName = "fernkampf zusatz angriff",
         },
         --[[
         ["RANGE_ENERGIZE"] = {
            tooltip = "",
            friendlyName = "fernkampf ressource",
         },]]
         ["SPELL_PERIODIC_DAMAGE"] = {
            tooltip = "A dot spell tick has caused damage",
            friendlyName = "dot tick",
         },
         ["SPELL_PERIODIC_HEAL"] = {
            tooltip = "A hot spell tick has caused damage",
            friendlyName = "hot tick",
         },
         ["SPELL_DAMAGE"] = {
            tooltip = "Ein Zauber hat Schaden verursacht",
            friendlyName = "zauber schaden",
         },
         ["SPELL_MISSED"] = {
            tooltip = "Ein Zauber hat Schaden verfehlt",
            friendlyName = "zauber verfehlt",
         },
         ["SPELL_HEAL"] = {
            tooltip = "Ein Zauber hat Heilung verursacht",
            friendlyName = "zauber heilung",
         },
         ["SPELL_ENERGIZE"] = {
            tooltip = "Ein Zauber hat eine Ressource (Mana) gewährt",
            friendlyName = "zauber ressource",
         },
         ["SPELL_INTERRUPT"] = {
            tooltip = "Ein Zauber wurde unterbrochen",
            friendlyName = "zauber unterbrochen",
         },
         ["SPELL_EXTRA_ATTACKS"] = {
            tooltip = "Ein Zauber hat einen Extraangriff gewährt",
            friendlyName = "zauber zusatz angriff",
         },
         ["SPELL_CAST_FAILED"] = {
            tooltip = "Ein Zauber ist fehlgeschlagen",
            friendlyName = "zauber fehlgeschlagen",
         },
         ["SPELL_CREATE"] = {
            tooltip = "Etwas wurde durch einen Zauber hergestellt (z. B. Berufe-Skill)",
            friendlyName = "zauber erstellen", 
            friendlyNameShort = "erstellen",
         },
         ["SPELL_SUMMON"] = {
            tooltip = "Etwas wurde duch einen Zauber beschworen (z. B. Leerwandler beim Hexer",
            friendlyName = "zauber beschwören", 
            friendlyNameShort = "beschwören",
         },
         ["SPELL_RESURRECT"] = {
            tooltip = "Ein Zauber hat etwas wiederbelebt",
            friendlyName = "zauber wiederbeleben",  
            friendlyNameShort = "wiederbeleben",
         },
         ["UNIT_DIED"] = {
            tooltip = "Eine Einheit (Spieler, NPC, Mob etc.) ist gestorben",
            friendlyName = "einheit tot", 
            friendlyNameShort = "tot",
         },
         ["UNIT_DESTROYED"] = {
            tooltip = "Etwas wurde zerstört (z. B. ein Totem)",
            friendlyName = "einheit zerstört", 
            friendlyNameShort = "zerstört",
         },
         ["ITEM_USE"] = {
            tooltip = "Ein Gegenstand wurde verwendet",
            friendlyName = "gegenstand verwenden", 
            friendlyNameShort = "verwenden",
         },
         ["KEY_PRESS"] = {
            tooltip = "Eine Taste wurde gedrückt",
            friendlyName = "Taste gedrückt", 
            friendlyNameShort = "Taste",
         },
      --spellId
         --build from skudb on PLAYER_ENTERING_WORLD
      --itemId
         --build from skudb on PLAYER_ENTERING_WORLD
         ["itemCount"] = {
            tooltip = "Die Anzahl der verbleibenden Gegenstände in deinen Taschen, vom Typ des Gegenstands, der das Ereignis ausgelöst hat",
            friendlyName = "gegenstand anzahl", 
            friendlyNameShort = "anzahl",
         },
   }
   --add keys for pressedKey
   local tKeys = KeyValuesHelper()
   for i, v in pairs (tKeys) do
      module.valuesDefault[i] = {friendlyName = v}
   end

   module.values = {
   }

   local zeroToOneHundred = {
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
      "24",
      "25",
      "26",
      "27",
      "28",
      "29",
      "30",
      "31",
      "32",
      "33",
      "34",
      "35",
      "36",
      "37",
      "38",
      "39",
      "40",
      "41",
      "42",
      "43",
      "44",
      "45",
      "46",
      "47",
      "48",
      "49",
      "50",
      "51",
      "52",
      "53",
      "54",
      "55",
      "56",
      "57",
      "58",
      "59",
      "60",
      "61",
      "62",
      "63",
      "64",
      "65",
      "66",
      "67",
      "68",
      "69",
      "70",
      "71",
      "72",
      "73",
      "74",
      "75",
      "76",
      "77",
      "78",
      "79",
      "80",
      "81",
      "82",
      "83",
      "84",
      "85",
      "86",
      "87",
      "88",
      "89",
      "90",
      "91",
      "92",
      "93",
      "94",
      "95",
      "96",
      "97",
      "98",
      "99",
      "100",
            
   }

   local unitIDValues = {
      "target",
      "player",
      "pet",
      "party",
      "partyWoPlayer",
      "all",
      "focus",
      "party0",
      "party1",
      "party2",
      "party3",
      "party4",
      "targettarget",
      "focustarget",
      "party0target",
      "party1target",
      "party2target",
      "party3target",
      "party4target",
   }

   ------------------------------------------------------------------------------------------------------------------
   module.attributes = {
      action = {
         tooltip = "Du legst als nächstes die Aktion fest, die bei der Auslösung der Aura passieren soll",
         friendlyName = "aktion",
         evaluate = function()
            --dprint("    ","module.attributes.action.evaluate")
         end,
         values = {
            "nothing",
            "notifyAudio",
            "notifyAudioSingle",
            --"notifyAudioSingleInstant",
            "notifyChat",
            "notifyChatSingle",
            "notifyAudioAndChatSingle",
         },
      },
      destUnitId = {
         tooltip = "Die Ziel-Einheit, bei der die Aura ausgelöst werden soll",
         friendlyName = "ziel (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.destUnitId.evaluate", aEventData.destUnitId)
            if aOperator == "is" then
               aOperator = "contains"
            elseif aOperator == "isNot" then
               aOperator = "containsNot"
            end
      
            if aEventData.destUnitId then

               if aValue == "all" then
                  return true
               end
               local tEvaluation = false

               if aOperator == "containsNot" or aOperator == "contains" then
                  
                  if aValue == "party" then
                     tEvaluation = module.Operators[aOperator].func(aEventData.destUnitId, {"player", "party0", "party1", "party2", "party3", "party4"})
                  elseif aValue == "partyWoPlayer" then
                     tEvaluation = module.Operators[aOperator].func(aEventData.destUnitId, {"party1", "party2", "party3", "party4"})
                  else
                     tEvaluation = module.Operators[aOperator].func(aEventData.destUnitId, aValue)
                  end
               else
                  for x = 1, #aEventData.destUnitId do
                     if aValue == "all" then
                        return true
                     elseif aValue == "party" or aValue == "partyWoPlayer" then
                        if aValue == "party" then
                           if module.Operators[aOperator].func(aEventData.destUnitId[x], "player") == true then
                              tEvaluation = true
                           end
                        end
                        local tStart = 0
                        if aValue == "partyWoPlayer" then
                           tStart = 1
                        end
                        for x = tStart, 4 do 
                           if module.Operators[aOperator].func(aEventData.destUnitId[x], "party"..x) == true then
                              tEvaluation = true
                           end
                        end
                        for x = 1, MAX_RAID_MEMBERS do 
                           if module.Operators[aOperator].func(aEventData.destUnitId[x], "raid"..x) == true then
                              tEvaluation = true
                           end
                        end
                     else
                        tEvaluation = module.Operators[aOperator].func(aEventData.destUnitId[x], aValue)
                     end
                  end
               end
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = unitIDValues,
      },
      targetTargetUnitId = {
         tooltip = "Die Einheit des Ziels deines Ziels",
         friendlyName = "ziel deines ziels (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.targetTargetUnitId.evaluate", aEventData.targetTargetUnitId)
            if aOperator == "is" then
               aOperator = "contains"
            elseif aOperator == "isNot" then
               aOperator = "containsNot"
            end

            if aEventData.targetTargetUnitId then
               if aValue == "all" then
                  return true
               end
               local tEvaluation = false

               if aOperator == "containsNot" or aOperator == "contains" then
                  
                  if aValue == "party" then
                     tEvaluation = module.Operators[aOperator].func(aEventData.targetTargetUnitId, {"player", "party0", "party1", "party2", "party3", "party4"})
                  elseif aValue == "partyWoPlayer" then
                     tEvaluation = module.Operators[aOperator].func(aEventData.targetTargetUnitId, {"party1", "party2", "party3", "party4"})
                  else
                     tEvaluation = module.Operators[aOperator].func(aEventData.targetTargetUnitId, aValue)
                  end
               else            
                  for x = 1, #aEventData.targetTargetUnitId do
                     if aValue == "all" then
                        return true
                     elseif aValue == "party" then
                        if aValue == "party" then
                           if module.Operators[aOperator].func(aEventData.targetTargetUnitId[x], "player") == true then
                              tEvaluation = true
                           end
                        end
                        local tStart = 0
                        if aValue == "partyWoPlayer" then
                           tStart = 1
                        end
                        for x = tStart, 4 do 
                           if module.Operators[aOperator].func(aEventData.targetTargetUnitId[x], "party"..x) == true then
                              tEvaluation = true
                           end
                        end
                        for x = 1, MAX_RAID_MEMBERS do 
                           if module.Operators[aOperator].func(aEventData.targetTargetUnitId[x], "raid"..x) == true then
                              tEvaluation = true
                           end
                        end
                     else
                        tEvaluation = module.Operators[aOperator].func(aEventData.targetTargetUnitId[x], aValue)
                     end
                  end
               end
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = unitIDValues,
      },   
      pressedKey = {
         tooltip = "Welche Taste das Ereignis ausgelöst hat",
         friendlyName = "Taste",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            if aEventData.pressedKey then
               --dprint("    ","module.attributes.pressedKey.evaluate", supper(aEventData.pressedKey), aOperator, supper(aValue))
               return module.Operators[aOperator].func(supper(aEventData.pressedKey), supper(aValue))
            end
         end,
         values = {}, --values are added below the attributes table
      },
      tInCombat = {
         tooltip = "Ob das Event im Kampf auftritt",
         friendlyName = "Im Kampf",
         type = "BINARY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.tInCombat.evaluate", aEventData.tInCombat, aOperator, true)
            return module.Operators[aOperator].func(aEventData.tInCombat, aValue == "true")
         end,
         values = {
            "true",
            "false",
         },
      },
      critical = {
         tooltip = "Whether the damage or heal was critical",
         friendlyName = "Critical",
         type = "BINARY",
         evaluate = function(self, aEventData, aOperator, aValue)
            return module.Operators[aOperator].func(aEventData.critical, aValue == "true")
         end,
         values = {
            "true",
            "false",
         },
      },
      tSourceUnitIDCannAttack = {
         tooltip = "Ob die Quell-Einheit, für die Aura ausgelöst wird, angreifbar ist",
         friendlyName = "Quell Einheit angreifbar",
         type = "BINARY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.tSourceUnitIDCannAttack.evaluate", aEventData.tSourceUnitIDCannAttack, aOperator, true)
            return module.Operators[aOperator].func(aEventData.tSourceUnitIDCannAttack, aValue == "true")
         end,
         values = {
            "true",
            "false",
         },
      },
      tDestinationUnitIDCannAttack = {
         tooltip = "Ob die Ziel-Einheit, für die Aura ausgelöst wird, angreifbar ist",
         friendlyName = "Ziel Einheit angreifbar",
         type = "BINARY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.tDestinationUnitIDCannAttack.evaluate", aEventData.tDestinationUnitIDCannAttack, aOperator, true)
            return module.Operators[aOperator].func(aEventData.tDestinationUnitIDCannAttack, aValue == "true")
         end,
         values = {
            "true",
            "false",
         },
      },
      targetCannAttack = {
         tooltip = "Whether you can attack your target",
         friendlyName = "Your target is attackable",
         type = "BINARY",
         evaluate = function(self, aEventData, aOperator, aValue)
            return module.Operators[aOperator].func(aEventData.targetCanAttack, aValue == "true")
         end,
         values = {
            "true",
            "false",
         },
      },
      sourceUnitId = {
         tooltip = "Die Quell Einheit, bei der die Aura ausgelöst werden soll",
         friendlyName = "Quelle (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --print("","module.attributes.sourceUnitId.evaluate", aEventData.sourceUnitId, aOperator, aValue)
            if aOperator == "is" then
               aOperator = "contains"
            elseif aOperator == "isNot" then
               aOperator = "containsNot"
            end

            if aValue == "all" then
               return true
            end
            if aEventData.sourceUnitId then
               if type(aEventData.sourceUnitId) ~= "table" then
                  aEventData.sourceUnitId = {aEventData.sourceUnitId}
               end

               if aValue == "all" then
                  return true
               end
               local tEvaluation = false

               if aOperator == "containsNot" or aOperator == "contains" then
                  if aValue == "party" then
                     tEvaluation = module.Operators[aOperator].func(aEventData.sourceUnitId, {"player", "party0", "party1", "party2", "party3", "party4"})

                  elseif aValue == "partyWoPlayer" then
                     tEvaluation = module.Operators[aOperator].func(aEventData.sourceUnitId, {"party1", "party2", "party3", "party4"})
                  else
                     tEvaluation = module.Operators[aOperator].func(aEventData.sourceUnitId, aValue)
                  end
               else
                  for x = 1, #aEventData.sourceUnitId do
                     if aValue == "party" then
                        if aValue == "party" then
                           if module.Operators[aOperator].func(aEventData.sourceUnitId[x], "player") == true then
                              tEvaluation = true
                           end
                        end
                        local tStart = 0
                        if aValue == "partyWoPlayer" then
                           tStart = 1
                        end
                        for x = tStart, 4 do 
                           if module.Operators[aOperator].func(aEventData.sourceUnitId[x], "party"..x) == true then
                              tEvaluation = true
                           end
                        end
                        for x = 1, MAX_RAID_MEMBERS do 
                           if module.Operators[aOperator].func(aEventData.sourceUnitId[x], "raid"..x) == true then
                              tEvaluation = true
                           end
                        end
                     else
                        tEvaluation = module.Operators[aOperator].func(aEventData.sourceUnitId[x], aValue)
                     end
                  end
               end

               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = unitIDValues,
      },
      event = {
         tooltip = "Das Ereignis, das die Aura auslösen soll",
         friendlyName = "ereignis",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --print("    ","module.attributes.event.evaluate")
            if aEventData.event then
               local tEvaluation
               if sfind(aValue, ";") then
                  local tEvents = {ssplit(";", aValue)}
                  for i, v in pairs(tEvents) do
                     local tSingleEvaluation = module.Operators[aOperator].func(aEventData.event, v)
                     if tSingleEvaluation == true then
                        tEvaluation = true
                     end
                  end
               else
                  tEvaluation = module.Operators[aOperator].func(aEventData.event, aValue)
               end
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
            "UNIT_TARGETCHANGE",
            "UNIT_POWER",
            "UNIT_HEALTH",
            "SPELL_AURA_APPLIED;SPELL_AURA_REFRESH;SPELL_AURA_APPLIED_DOSE",
            "SPELL_AURA_REMOVED",
            "SPELL_CAST_START",
            "SPELL_CAST_SUCCESS",
            "SPELL_COOLDOWN_START",
            "SPELL_COOLDOWN_END",
            "ITEM_COOLDOWN_START",
            "ITEM_COOLDOWN_END",
            "SWING_DAMAGE",
            "SWING_MISSED",
            "SWING_EXTRA_ATTACKS",
            "SWING_ENERGIZE",
            "RANGE_DAMAGE",
            "RANGE_MISSED",
            "RANGE_EXTRA_ATTACKS",
            --"RANGE_ENERGIZE",
            "SPELL_PERIODIC_DAMAGE",
            "SPELL_PERIODIC_HEAL",
            "SPELL_DAMAGE",
            "SPELL_MISSED",
            "SPELL_HEAL",
            "SPELL_ENERGIZE",
            "SPELL_INTERRUPT",
            "SPELL_EXTRA_ATTACKS",
            "SPELL_CAST_FAILED",
            "SPELL_CREATE",
            "SPELL_SUMMON",
            "SPELL_RESURRECT",
            "UNIT_DIED",
            "UNIT_DESTROYED",
            "ITEM_USE",
            "KEY_PRESS",
         },
      },
      missType = {
         tooltip = "Der Typ des Verfehlen Ereignisses",
         friendlyName = "Verfehlen Typ",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.missType.evaluate")
            if aEventData.missType then
               return module.Operators[aOperator].func(aEventData.missType, aValue)
            end
         end,
         values = {
            "ABSORB",
            "BLOCK",
            "DEFLECT",
            "DODGE",
            "EVADE",
            "IMMUNE",
            "MISS",
            "PARRY",
            "REFLECT",
            "RESIST",
         },
      },
      targetUnitDistance = {
         tooltip = "Distance to your current target",
         friendlyName = "target distance",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            dprint("    ","module.attributes.targetUnitDistance.evaluate", aEventData.targetUnitDistance)
            if aEventData.targetUnitDistance then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.targetUnitDistance), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,
      },   
      unitPowerPlayer = {
         tooltip = "Dein Ressourcen Level in Prozent, das die Aura auslösen soll (deine Primärressource wie Mana, Energie, Wut etc.",
         friendlyName = "Eigene Ressource",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.unitPowerPlayer.evaluate")
            if aEventData.unitPowerPlayer then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.unitPowerPlayer), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,
      },
      unitComboPlayer = {
         tooltip = "Dein combopunkte auf das aktuelle ziel, die die Aura auslösen sollen",
         friendlyName = "Eigene combopunkte",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            dprint("    ","module.attributes.unitComboPlayer.evaluate", aEventData.unitComboPlayer)
            if aEventData.unitComboPlayer then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.unitComboPlayer), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
         },
      },   
      unitHealthPlayer = {
         tooltip = "Dein gesundheits Level in Prozent, das die Aura auslösen soll",
         friendlyName = "Eigene Gesundheit",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.unitHealthPlayer.evaluate")
            if aEventData.unitHealthPlayer then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.unitHealthPlayer), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },
      unitHealthTarget = {
         tooltip = "Your target's health percentage",
         friendlyName = "Your target's health",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            return aEventData.unitHealthTarget and module.Operators[aOperator].func(aEventData.unitHealthTarget, tonumber(aValue))
         end,
         values = zeroToOneHundred,
      },
      unitPowerTarget = {
         tooltip = "Percentage of your target's primary resource, for example mana or rage",
         friendlyName = "Your target's resource",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            return aEventData.unitPowerTarget and module.Operators[aOperator].func(aEventData.unitPowerTarget, tonumber(aValue))
         end,
         values = zeroToOneHundred,
      },
      unitHealthOrPowerUpdate = {
         tooltip = "The updated health or resource percentage from a health update or resource update event",
         friendlyName = "Health/Resource update",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            return aEventData.unitHealthOrPowerUpdate and module.Operators[aOperator].func(aEventData.unitHealthOrPowerUpdate, tonumber(aValue))
         end,
         values = zeroToOneHundred,
      },
      overhealingPercentage = {
         tooltip = "How much of the healing amount was overhealing",
         friendlyName = "Overhealing percentage",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            return aEventData.overhealingPercentage and module.Operators[aOperator].func(aEventData.overhealingPercentage, tonumber(aValue))
         end,
         values = zeroToOneHundred,
      },
      spellId = {
         tooltip = "Die Zauber-ID, die die Aura auslösen soll",
         friendlyName = "zauber nr",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --print("module.attributes.spellId.evaluate aEventData", aEventData, "aOperator", aOperator, "aValue", aValue)
            if aEventData.spellId then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.spellId), tonumber(module:RemoveTags(aValue)))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
         },      
      },
      spellNameOnCd = {
         tooltip = "Ob ein Zauber gerade auf CD ist",
         friendlyName = "zauber auf cd (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.spellNameOnCd.evaluate", aEventData, aOperator, aValue)
            if aOperator == "is" then
               aOperator = "contains"
            elseif aOperator == "isNot" then
               aOperator = "containsNot"
            end

            if aEventData.spellNameOnCd then
               local tEvaluation = module.Operators[aOperator].func(aEventData.spellNameOnCd, module:RemoveTags(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
         },      
      },
      spellName = {
         tooltip = "Der Zauber-name, der die Aura auslösen soll",
         friendlyName = "zauber name",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.spellName.evaluate")
            if aEventData.spellName then
               local tEvaluation = module.Operators[aOperator].func(aEventData.spellName, aValue)
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
         },      
      },
      buffListTarget = {
         tooltip = "Die Liste der Buffs des Ziels",
         friendlyName = "Buff Liste Ziel (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.buffListTarget.evaluate", aEventData, aOperator, aValue)
            if aEventData.buffListTarget then
               local tEvaluation = module.Operators[aOperator].func(aEventData.buffListTarget, module:RemoveTags(aValue))
               if tEvaluation == true then
                  return true
               end
            end
            return false
         end,
         values = {
         },      
      },
      debuffListTarget = {
         tooltip = "Die Liste der Debuffs  des Ziels",
         friendlyName = "Debuff Liste Ziel (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.debuffListTarget.evaluate", aEventData.debuffListTarget)
            if aEventData.debuffListTarget then
               local tEvaluation = module.Operators[aOperator].func(aEventData.debuffListTarget, module:RemoveTags(aValue))
               if tEvaluation == true then
                  return true
               end
            end
            return false
         end,
         values = {
         },      
      },
      buffListPlayer = {
         tooltip = "Your list of buffs",
         friendlyName = "Your buff list (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            return aEventData.buffListPlayer ~= nil and module.Operators[aOperator].func(aEventData.buffListPlayer, module:RemoveTags(aValue)) == true
         end,
         values = {},      
      },
      debuffListPlayer = {
         tooltip = "Your list of dbuffs",
         friendlyName = "Your debuff list (L)",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            return aEventData.debuffListPlayer ~= nil and module.Operators[aOperator].func(aEventData.debuffListPlayer, module:RemoveTags(aValue)) == true
         end,
         values = {},      
      },








      
      buffListTargetDuration = {
         tooltip = "The remaining duration of the buff from the buff list target (L) condition",
         friendlyName = "buff list target remaining duration",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            if aEventData.buffListTargetDuration then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.buffListTargetDuration), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },
      debuffListTargetDuration = {
         tooltip = "The remaining duration of the debuff from the debuff list target (L) condition",
         friendlyName = "Debuff list target remaining duration",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            if aEventData.debuffListTargetDuration then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.debuffListTargetDuration), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },   
      buffListPlayerDuration = {
         tooltip = "The remaining duration of the buff from the your buff list (L) condition",
         friendlyName = "Your buff list remaining duration",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            if aEventData.buffListPlayerDuration then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.buffListPlayerDuration), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },   
      debuffListPlayerDuration = {
         tooltip = "The remaining duration of the debuff from the your debuff list (L) condition",
         friendlyName = "Your debuff list remaining duration",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            if aEventData.debuffListPlayerDuration then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.debuffListPlayerDuration), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },

      itemName = {
         tooltip = "Der Gegenstandsname, der die Aura auslösen soll",
         friendlyName = "gegenstand name",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.itemName.evaluate")
            if aEventData.itemName then
               local tEvaluation = module.Operators[aOperator].func(aEventData.itemName, aValue)
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
         },      
      },
      itemId = {
         tooltip = "Die Gegenstands-ID, die die Aura auslösen soll",
         friendlyName = "gegenstand nr",
         type = "CATEGORY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.itemId.evaluate")
            if aEventData.itemId then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.itemId), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
         },      
      },
      itemCount = {
         tooltip = "Die verbleibende Menge eines Gegenstands in deinen Taschen, bei der die auslösen soll",
         friendlyName = "gegenstand anzahl",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.itemCount.evaluate")
            if aEventData.itemCount then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.itemCount), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },
      auraType = {
         tooltip = "Der Aura-Typ (Buff oder Debuff), der die Aura auslösen soll",
         friendlyName = "buff/debuff",
         type = "BINARY",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.auraType.evaluate")
            if aEventData.auraType then
               local tEvaluation = module.Operators[aOperator].func(aEventData.auraType, aValue)
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
            "BUFF",
            "DEBUFF",
         },      
      },
      auraAmount = {
         tooltip = "Die Anzahl der Stacks einer Aura (Buff oder Debuff), bei der die Aura auslösen soll",
         friendlyName = "aura stacks",
         type = "ORDINAL",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.auraAmount.evaluate")
            if aEventData.auraAmount then
               local tEvaluation = module.Operators[aOperator].func(tonumber(aEventData.auraAmount), tonumber(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = zeroToOneHundred,      
      },
      class = {
         tooltip = "Der Klasse, die die Aura auslösen soll",
         friendlyName = "klasse",
         type = "CATEGORY",
         evaluate = function()
            --dprint("    ","module.attributes.class.evaluate")












         end,
         values = {
            "Warrior",
            "Paladin",
            "Hunter",
            "Rogue",
            "Priest",
            "Death Knight",
            "Shaman",
            "Mage",
            "Warlock",
            --"Monk",
            "Druid",
            "Demon Hunter",
         },      
      },
      spellNameUsable = {
         tooltip = "If a spell is usable (range, cooldown, stance, etc.)",--"Der Zauber-name, der die Aura auslösen soll",
         friendlyName = "Spell usable", --"zauber name",
         type = "SET",
         evaluate = function(self, aEventData, aOperator, aValue)
            --dprint("    ","module.attributes.spellNameOnCd.evaluate", aEventData, aOperator, aValue)
            if aOperator == "is" then
               aOperator = "contains"
            elseif aOperator == "isNot" then
               aOperator = "containsNot"
            end

            if aEventData.spellNameUsable then
               local tEvaluation = module.Operators[aOperator].func(aEventData.spellNameUsable, module:RemoveTags(aValue))
               if tEvaluation == true then
                  return true
               end
            end
         end,
         values = {
         },      
         updateValues = function(self)
            module.attributes.spellNameUsable.values = {}
            for spellId, spellData in pairs(SkuDB.SpellDataTBC) do
               if C_ActionBar.FindSpellActionButtons(spellId) then
                  local spellName = spellData[Sku.Loc][SkuDB.spellKeys["name_lang"]]
                  module.attributes.spellNameUsable.values[#module.attributes.spellNameUsable.values + 1] = "spell:"..tostring(spellName)

                  if not module.values["spell:"..tostring(spellId)] then
                     module.values["spell:"..tostring(spellId)] = {friendlyName = spellId.." ("..spellName..")",}
                  end
                  if not module.values["spell:"..tostring(spellName)] then
                     module.values["spell:"..tostring(spellName)] = {friendlyName = spellName,}
                  end
               end
            end
         end,
      },

   }
   local tKeys = KeyValuesHelper()
   for i, v in pairs (tKeys) do
      table.insert(module.attributes.pressedKey.values , i)
   end

   ------------------------------------------------------------------------------------------------------------------
   module.Operators = {
      ["then"] = {
         tooltip = "",
         friendlyName = "dann",
         func = function(a) 
            --dprint("    ","action", a)
            return
         end,
      },
      ["is"] = {
         tooltip = "Gewähltes Attribut entspricht dem gewählten Wert",
         friendlyName = "gleich",
         func = function(aValueA, aValueB) 
            if aValueA == nil or aValueB == nil then return false end
            if type(aValueA) == "table" then 
               for tName, tValue in pairs(aValueA) do
                  if type(aValueB) == "table" then
                     for tNameB, tValueB in pairs(aValueB) do
                        local tResult = module:RemoveTags(tValue) == module:RemoveTags(tValueB)
                        if tResult == true then
                           return true
                        end
                     end
                  else
                     local tResult = module:RemoveTags(tValue) == module:RemoveTags(aValueB)
                     if tResult == true then
                        return true
                     end
                  end
               end
            else
               --print("aValueA", "-"..tostring(module:RemoveTags(aValueA)).."-", "aValueB", "-"..tostring(module:RemoveTags(aValueB)).."-", module:RemoveTags(aValueA) == module:RemoveTags(aValueB), tostring(aValueA) == tostring(aValueB))
               if module:RemoveTags(aValueA) == module:RemoveTags(aValueB) then 
                  return true 
               end
            end
            return false
         end,
      },
      ["isNot"] = {
         tooltip = "Gewähltes Attribut entspricht nicht dem gewählten Wert",
         friendlyName = "ungleich",
         func = function(aValueA, aValueB) 
            if aValueA == nil or aValueB == nil then return false end
            if type(aValueA) == "table" then 
               for tName, tValue in pairs(aValueA) do
                  if type(aValueB) == "table" then
                     for tNameB, tValueB in pairs(aValueB) do
                        local tResult = module:RemoveTags(tValue) == module:RemoveTags(tValueB)
                        if tResult == true then
                           return true
                        end
                     end
                  else
                     local tResult = module:RemoveTags(tValue) == module:RemoveTags(aValueB)
                     if tResult == true then
                        return true
                     end
                  end
               end
            else

               if module:RemoveTags(aValueA) ~= module:RemoveTags(aValueB) then 
                  return true 
               end
            end
            return false
         end,
      },
      ["contains"] = {
         tooltip = "Gewähltes Attribut enthält den gewählten Wert",
         friendlyName = "enthält",
         func = function(aValueA, aValueB) 
            if not aValueA or not aValueB then return false end
            if type(aValueB) ~= "table" then 
               aValueB = {aValueB}
            end
            if type(aValueA) == "table" then 
               for tName, tValue in pairs(aValueA) do
                  for tNameB, tValueB in pairs(aValueB) do
                     local tResult = module:RemoveTags(tValue) == module:RemoveTags(tValueB)
                     if tResult == true then
                        return true
                     end
                  end
               end
            else
               for tNameB, tValueB in pairs(aValueB) do
                  if module:RemoveTags(aValueA) == module:RemoveTags(tValueB) then 
                     return true 
                  end
               end
            end
         end,
      },   
      ["containsNot"] = {
         tooltip = "Gewähltes Attribut enthält nicht den gewählten Wert",
         friendlyName = "enthält nicht",
         func = function(aValueA, aValueB) 
            if not aValueA or not aValueB then return false end
            if type(aValueB) ~= "table" then 
               aValueB = {aValueB}
            end

            if type(aValueA) == "table" then 
               local tFound = false
               for tName, tValue in pairs(aValueA) do
                  for tNameB, tValueB in pairs(aValueB) do
                     local tResult = module:RemoveTags(tValue) == module:RemoveTags(tValueB)
                     if tResult == true then
                        tFound = true
                     end
                  end
               end
               if tFound == false then
                  return true
               else
                  return false
               end
            else
               local tFound = false
               for tNameB, tValueB in pairs(aValueB) do
                  if module:RemoveTags(aValueA) == module:RemoveTags(tValueB) then 
                     tFound = true
                  end
               end
               if tFound == false then
                  return true
               else
                  return false
               end            
            end
         end,
      },   
      ["bigger"] = {
         tooltip = "Gewähltes Attribut ist größer als der gewählte Wert",
         friendlyName = "größer",
         func = function(aValueA, aValueB) 
            if not aValueA or not aValueB then return false end
            if type(aValueA) == "table" then return false end
            if tonumber(module:RemoveTags(aValueA)) > tonumber(module:RemoveTags(aValueB)) then 
               return true 
            end
            return false
         end,
      },
      ["smaller"] = {
         tooltip = "Gewähltes Attribut ist kleiner als der gewählte Wert",
         friendlyName = "kleiner",
         func = function(aValueA, aValueB) 
            if not aValueA or not aValueB then return false end
            if type(aValueA) == "table" then return false end
            if tonumber(module:RemoveTags(aValueA)) < tonumber(module:RemoveTags(aValueB)) then 
               return true 
            end
            return false
         end,
      },
   }

   ---Returns a subset of the operators table, with only given operators
   local function operatorsSubset(...)
      local subset = {}
      for i, op in pairs({ ... }) do
         subset[op] = module.Operators[op]
      end
      return subset
   end

   ------------------------------------------------------------------------------------------------------------------
   ---The type of an attribute defines what operators it supports.
   module.operatorsForAttributeType = {
      ---Attributes that can only be checked for equality (e.g. spell name, class)
      CATEGORY = operatorsSubset("is", "isNot"),
      -- Attributes with only 2 possible values (e.g. in combat)
      BINARY = operatorsSubset("is"),
      ---Attributes that can also be compared to be bigger/smaller (e.g. health, resource)
      ORDINAL = operatorsSubset("is", "isNot", "bigger", "smaller"),
      ---Supports checking if contains a given element (e.g. source, buff list)
      SET = operatorsSubset("contains", "containsNot"),
   }

   ------------------------------------------------------------------------------------------------------------------
   module.Types = {
      ["if"] = {
         tooltip = "Wenn die Bedingungen dieser Aura zutreffen",
         friendlyName = "Wenn",
      },
      ["ifNot"] = {
         tooltip = "Wenn die Bedingungen dieser Aura nicht zutreffen",
         friendlyName = "Wenn nicht",
      },
   }
end