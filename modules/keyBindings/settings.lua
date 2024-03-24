print("modules\\keyBindings\\settings.lua loading", SDL3)
local moduleName = "keyBindings"
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
   skuKeyBinds = {
		flavors = {"classic", "era", "sod", "retail"},
		title = "skuKeyBinds title",
		desc = "skuKeyBinds desc",
		menuBuilder = false,
		children = {
         SKU_KEY_MENUCLOSE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ESCAPE",}, menuBuilder = false,},
         SKU_KEY_MENUITEMSPELLCURRENT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-RIGHT",}, menuBuilder = false,},
         SKU_KEY_MENUITEMEXECUTE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ENTER",}, menuBuilder = false,},
         SKU_KEY_MENUITEMCLEARFILTER = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "BACKSPACE",}, menuBuilder = false,},
         SKU_KEY_MENUITEMFIRST = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "HOME",}, menuBuilder = false,},
         SKU_KEY_MENUITEMLAST = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "END",}, menuBuilder = false,},
         SKU_KEY_MENUITEMUP = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "UP",}, menuBuilder = false,},
         SKU_KEY_MENUITEMDOWN = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "DOWN",}, menuBuilder = false,},
         SKU_KEY_MENUITEMLEFT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "LEFT",}, menuBuilder = false,},
         SKU_KEY_MENUITEMRIGHT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "RIGHT",}, menuBuilder = false,},
         SKU_KEY_OPENMENU = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F1",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK1 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F9",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK2 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F10",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK3 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F11",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK4 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F12",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK1SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F9",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK2SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F10",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK3SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F11",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK4SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F12",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK5 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK5SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK6 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK6SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK7 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK7SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK8 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK8SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK9 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK9SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK10 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_MENUQUICK10SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SELECTNEXTBASEWAYPOINT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TARGETDISTANCE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_PANICMODE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-Y",}, menuBuilder = false,},
         SKU_KEY_MMSCANWIDE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F",}, menuBuilder = false,},
         SKU_KEY_MMSCANNARROW = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-R",}, menuBuilder = false,},
         SKU_KEY_STARTRRFOLLOW = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-Z",}, menuBuilder = false,},
         SKU_KEY_MOVETONEXTWP = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-W",}, menuBuilder = false,},
         SKU_KEY_MOVETOPREVWP = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-S",}, menuBuilder = false,},
         SKU_KEY_ADDLARGEWP = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ALT-O",}, menuBuilder = false,},
         SKU_KEY_ADDSMALLWP = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ALT-P",}, menuBuilder = false,},
         SKU_KEY_TOGGLEMMSIZE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-M",}, menuBuilder = false,},
         SKU_KEY_QUICKWP1 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F5",}, menuBuilder = false,},
         SKU_KEY_QUICKWP1SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F5",}, menuBuilder = false,},
         SKU_KEY_QUICKWP2 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F6",}, menuBuilder = false,},
         SKU_KEY_QUICKWP2SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F6",}, menuBuilder = false,},
         SKU_KEY_QUICKWP3 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F7",}, menuBuilder = false,},
         SKU_KEY_QUICKWP3SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F7",}, menuBuilder = false,},
         SKU_KEY_QUICKWP4 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F8",}, menuBuilder = false,},
         SKU_KEY_QUICKWP4SET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F8",}, menuBuilder = false,},
         SKU_KEY_DEBUGMODE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-F3",}, menuBuilder = false,},
         SKU_KEY_QUESTSHARE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-T",}, menuBuilder = false,},
         SKU_KEY_OPENADVGUIDE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F4",}, menuBuilder = false,},
         SKU_KEY_ROLLNEED = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-B",}, menuBuilder = false,},
         SKU_KEY_ROLLGREED = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-G",}, menuBuilder = false,},
         SKU_KEY_ROLLPASS = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-X",}, menuBuilder = false,},
         SKU_KEY_ROLLINFO = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-C",}, menuBuilder = false,},
         SKU_KEY_STOPTTSOUTPUT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-V",}, menuBuilder = false,},
         SKU_KEY_QUESTABANDON = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-D",}, menuBuilder = false,},
         SKU_KEY_CHATOPEN = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-F2",}, menuBuilder = false,},
         SKU_KEY_TOGGLEREACHRANGE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SCANCONTINUE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-L",}, menuBuilder = false,},
         SKU_KEY_SCAN1 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SCAN2 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SCAN3 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SCAN4 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SCAN5 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-U",}, menuBuilder = false,},
         SKU_KEY_SCAN6 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-O",}, menuBuilder = false,},
         SKU_KEY_SCAN7 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-P",}, menuBuilder = false,},
         SKU_KEY_SCAN8 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "CTRL-SHIFT-I",}, menuBuilder = false,},
         SKU_KEY_TURNTOBEACON = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "I",}, menuBuilder = false,},
         SKU_KEY_STOPROUTEORWAYPOINT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_NOTIFYONRESOURCES = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_DOMONITORPARTYHEALTH2CONTI = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_ENABLESOFTTARGETINGENEMY = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-I",}, menuBuilder = false,},
         SKU_KEY_ENABLESOFTTARGETINGFRIENDLY = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-P",}, menuBuilder = false,},
         SKU_KEY_ENABLESOFTTARGETINGINTERACT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "SHIFT-O",}, menuBuilder = false,},
         SKU_KEY_OUTPUTHARDTARGET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_OUTPUTSOFTTARGET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TUTORIALSTEPBACK = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ALT-H",}, menuBuilder = false,},
         SKU_KEY_TUTORIALSTEPREPEAT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ALT-K",}, menuBuilder = false,},
         SKU_KEY_TUTORIALSTEPFORWARD = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "ALT-J",}, menuBuilder = false,},
         SKU_KEY_ENABLEPARTYRAIDHEALTHMONITOR = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_GROUPMEMBERSRANGECHECK = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET1WHITE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET2RED = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET3BLUE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET4GREEN = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET5PURPLE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET6YELLOW = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET7ORANGE = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERSET8GREY = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_SKUMARKERCLEARALL = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNIT1 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNIT2 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNIT3 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNIT4 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNIT5 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNIT6 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TURNTOUNITTURN180 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_COMBATMONSETFOLLOWTARGET = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_COMBATMONOUTPUTNUMBERINCOMBAT = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_TARGETHEALTH = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET1 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET2 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET3 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET4 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET5 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET6 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET7 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSGET8 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET1 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET2 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET3 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET4 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET5 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET6 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET7 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},
         SKU_KEY_FOCUSSET8 = {type = "string", flavors = {"classic", "era", "sod", "retail"}, defaultValue = {default = "",}, menuBuilder = false,},         
      },
   },
}





---------------------------------------------------------------------------------------------------------------------------------------
-- profile
prototype.profile = {
}
