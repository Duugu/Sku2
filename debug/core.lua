_, Sku2 = ...

---------------------------------------------------------------------------------------------------------
--- throw error and output in default chat
-- @param aErrorText
function Sku2:Error(aErrorText)
   print(aErrorText)
   error(aErrorText)
end