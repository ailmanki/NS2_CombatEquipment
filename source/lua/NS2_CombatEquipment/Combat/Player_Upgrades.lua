local oldPlayerReset_Lite = Player.Reset_Lite
function Player:Reset_Lite()
	if GetHasGameRules() then
		local owner = Server.GetOwner(self)
		if owner then
			local ownerId = self:GetId()
			for _, sentry in ientitylist( Shared.GetEntitiesWithClassname("Sentry") ) do
				--Print("ownerId: " .. sentry.ownerId .. ", clientId: " .. ownerId)
				if sentry.personal and sentry.ownerId == ownerId then
					if sentry:GetCanDie() then
						sentry:Kill()
					else
						DestroyEntity(sentry)
					end
				end
			end
		end
	end
	oldPlayerReset_Lite(self)
end
