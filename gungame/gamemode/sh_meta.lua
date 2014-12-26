local ply = FindMetaTable("Player")

function ply:GetTeam()
	if (self:Team() == 1) then
		return "TEAM_RED"
	else
		return "TEAM_BLUE"
	end
end

function ply:ChangeTeam(teamnum)
	if (teamnum == 1) then
		self:ConCommand("clhorsetagredteamchange123")
	else
		self:ConCommand("clchickencoup123chairdeskblueteam")
	end

end


