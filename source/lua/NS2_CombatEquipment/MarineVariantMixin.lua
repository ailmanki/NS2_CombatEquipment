local oldGetMaterialIndexPerWeapon = GetMaterialIndexPerWeapon
function GetMaterialIndexPerWeapon( wepClass )
    assert(wepClass)
	if wepClass == "BuildSentry" then
		return 1
	end
    return oldGetMaterialIndexPerWeapon(wepClass)
end