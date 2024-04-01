--------------------------------------------------------------------------------------------------------------------
--map legacy functions to new names
if not UseContainerItem then
   UseContainerItem = C_Container.UseContainerItem
end
if not GetContainerItemInfo then
   GetContainerItemInfo = C_Container.GetItemInfo
end

--------------------------------------------------------------------------------------------------------------------
Sku2 = LibStub("AceAddon-3.0"):NewAddon("Sku2")