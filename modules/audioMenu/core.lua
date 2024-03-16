print("modules\\audioMenu\\core.lua loading", SDL3)

local _G = _G
local L = Sku2.L

local moduleName = "audioMenu"
Sku2.modules[moduleName] = Sku2.modules:NewModule(moduleName)
local this = Sku2.modules[moduleName]

---------------------------------------------------------------------------------------------------------------------------------------
-- module events
---------------------------------------------------------------------------------------------------------------------------------------
function this:OnInitialize()
	print("audioMenu", "OnInitialize", SDL3)
	this:CreateMenuFrame()
	this.menu.root = this:InjectMenuItems(this.menu, {"root"}, this.genericMenuItem)

end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnEnable()
	print("audioMenu", "OnEnable", SDL3)

	-- --------------> test menu start
		print("add test menu")
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"eins"}, this.genericMenuItem)
		--tNewMenuEntry.isMultiselect = true
		--tNewMenuEntry.filterable = true
		tNewMenuEntry.buildChildrenFunc = function(self)
			local tNewMenuEntry = this:InjectMenuItems(self, {"Size"}, this.genericMenuItem)
			tNewMenuEntry.dynamic = true
			tNewMenuEntry.buildChildrenFunc = function(self)
				local tNewMenuEntry = this:InjectMenuItems(self, {"Small"}, this.genericMenuItem)
				tNewMenuEntry.onEnterFunc = function(self)
					print(" xxx Small onEnterFunc")
				end
				local tNewMenuEntry = this:InjectMenuItems(self, {"Large"}, this.genericMenuItem)
				tNewMenuEntry.onEnterFunc = function(self)
					print(" xxx Large onEnterFunc", self.name)
				end
				tNewMenuEntry.actionFunc = function(self)
					print(" xxx Large actionFunc", self.name)
					self:Update(self.name.." NEW")
				end
				local tNewMenuEntry = this:InjectMenuItems(self, {"Laroxx"}, this.genericMenuItem)
				tNewMenuEntry.onEnterFunc = function(self)
					print(" xxx Laroxx onEnterFunc", self.name)
				end
				tNewMenuEntry.actionFunc = function(self)
					print(" xxx Laroxx actionFunc", self.name)
					self:Update(self.name.." NEWXX")
				end
			end
			local tNewMenuEntry = this:InjectMenuItems(self, {"Quests"}, this.genericMenuItem)
			tNewMenuEntry.dynamic = true
			tNewMenuEntry.buildChildrenFunc = function(self)
				local tNewMenuEntry = this:InjectMenuItems(self, {"aaa", "bbb", "ccc"}, this.genericMenuItem)
			end
		end
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"zwei empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"zwei aa empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"zwei bb empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"zwei bbc empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"empty"}, this.genericMenuItem)
		tNewMenuEntry.empty = true
		local tNewMenuEntry = this:InjectMenuItems(this.menu.root, {"vier empty"}, this.genericMenuItem)
	-- <-------------- test menu end
end

---------------------------------------------------------------------------------------------------------------------------------------
function this:OnDisable()
	print("audioMenu", "OnDisable", SDL3)
	local this = Sku2.modules.audioMenu

end