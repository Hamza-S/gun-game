--[[------------------------------------------------------
Player stuff.
--]]----------------------------------------------------

function GM:ShowHelp(ply)
	net.Start("HelpMenu")
	net.Send(ply)
end

function GM:PlayerDeathSound()
	return true;
end

function GM:CanPlayerSuicide(ply)
	return false;
end