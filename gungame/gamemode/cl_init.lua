--[[-------------------------------------------
Author: Bman
Description: Gun Game gamemode for Gary's Mod.
Version: 1.0.0
Website: forums.hexteria.com
--]]-------------------------------------------

util.PrecacheSound("ggendofround.mp3")

include( 'shared.lua' )
include ('vgui/cl_scoreboard.lua')
include ( 'sh_meta.lua' )
include ( 'vgui/cl_helpmenu.lua' )

surface.CreateFont( "F1MenuTitle", { --Title font for the F1 menu.
	font = "ChatText",
	size = 40,
	shadow = true,
	outline = true,
} )

surface.CreateFont( "F1MenuText", { --Text used in the F1 menu.
	font = "ChatText",
	size = 30,
	shadow = true,
	outline = true,
} )

surface.CreateFont( "ChooseTeamFont", { --Text used in the F1 menu.
	font = "TargetID",
	size = 40,
	shadow = false,
	outline = false,
} )

net.Receive("ChooseTeam", function()

	local chooser = net.ReadString()

	local chooseteamFrame = vgui.Create("DFrame")
		chooseteamFrame:SetSize(350,500)
		chooseteamFrame:Center()
		chooseteamFrame:MakePopup()
		chooseteamFrame:SetTitle("Choose a team!")

	local redTeam = vgui.Create("DPanel", chooseteamFrame)
		redTeam:Dock(FILL)
		redTeam:DockMargin(0,0,0,250)

	local redteamAmm = vgui.Create("DLabel", redTeam)
		redteamAmm:Dock(FILL)
		redteamAmm:SetFont("ChooseTeamFont")
		redteamAmm:DockMargin(145,35,0,0)
		function redTeam:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(255,0,0,255))
			draw.SimpleText( "Red Team", "ChooseTeamFont", 100, 70, Color(0,0,0))
		end

		function redTeam:Think()
			local numRed = tostring(team.NumPlayers(1))
			redteamAmm:SetText("("..numRed..")")
		end
	
	local joinRedb = vgui.Create("DButton", redTeam )
		joinRedb:Dock(FILL)
		joinRedb:DockMargin(50,160,50,10)
		joinRedb:SetText("Join Blue")
		function joinRedb:DoClick()
			if (team.NumPlayers(1) > team.NumPlayers(2)) then
				LocalPlayer():ChatPrint("Blue team is full!")
			elseif (team.NumPlayers(2) > team.NumPlayers(1)) then
				LocalPlayer():ChangeTeam(1)
			elseif (team.NumPlayers(2) == team.NumPlayers(1)) then
				LocalPlayer():ChangeTeam(1)
			end
		end


	local blueTeam = vgui.Create("DPanel", chooseteamFrame)
		blueTeam:Dock(FILL)
		blueTeam:DockMargin(0,240,0,0)

	local blueteamAmm = vgui.Create("DLabel", blueTeam)
		blueteamAmm:Dock(FILL)
		blueteamAmm:SetFont("ChooseTeamFont")
		blueteamAmm:DockMargin(145,35,0,0)
		function blueTeam:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,255,255))
			draw.SimpleText( "Blue Team", "ChooseTeamFont", 95, 70, Color(0,0,0))
		end

		function blueTeam:Think()
			local numBlue = tostring(team.NumPlayers(2))
			blueteamAmm:SetText("("..numBlue..")")
		end
	
	local joinBlueb = vgui.Create("DButton", blueTeam )
		joinBlueb:Dock(FILL)
		joinBlueb:DockMargin(50,170,50,10)
		joinBlueb:SetText("Join Red")
		function joinBlueb:DoClick()
			if (team.NumPlayers(2) > team.NumPlayers(1)) then
				LocalPlayer():ChatPrint("Blue team is full or you're already in it!")
			elseif (team.NumPlayers(1) > team.NumPlayers(2)) then
				LocalPlayer():ChangeTeam(2)
			elseif (team.NumPlayers(1) == team.NumPlayers(2)) then
				LocalPlayer():ChangeTeam(2)
			end
		end
end)

net.Receive("roundstats_msg", function()

	local winnerName = net.ReadString()

			local winnerLabel = vgui.Create("DLabel")
				winnerLabel:SetText(winnerName.." has won the round!")
				winnerLabel:SetFont("F1MenuTitle")
				winnerLabel:SizeToContents()
				winnerLabel:Center()
				winnerLabel:SetMouseInputEnabled(true)
				winnerLabel:SetKeyboardInputEnabled(true)

				surface.PlaySound("ggendofround.mp3")

		timer.Simple(8, function()

				winnerLabel:Remove()

			end)

end)

surface.CreateFont( "LeaderFont", { --Title font for the F1 menu.
	font = "Arial",
	size = 15,
	shadow = true,
	outline = false,
	weight = 600,
} )

surface.CreateFont( "2nd3rdFont", { --Title font for the F1 menu.
	font = "Arial",
	size = 13,
	shadow = true,
	outline = false,
	weight = 600,
} )

hook.Add("HUDPaint", "LeaderBoard", function()
	
	local gradientTexture = surface.GetTextureID( "gui/gradient_down" )
	local firstPlace = GetGlobalString("1stPlace")
	local secondPlace = GetGlobalString("2ndPlace")
	local thirdPlace = GetGlobalString("3rdPlace")

	surface.SetTexture(gradientTexture)
	surface.SetDrawColor(Color(32,32,32,230))
	surface.DrawTexturedRect(0,0,350,130)

	draw.SimpleText( firstPlace, "LeaderFont", 10, 10, Color(255,255,255))
	draw.SimpleText( secondPlace, "2nd3rdFont", 10, 40, Color(255,255,255))
	draw.SimpleText( thirdPlace, "2nd3rdFont", 10, 70, Color(255,255,255))

end)

surface.CreateFont( "CustomFont1", {font = "ChatText", size = 20, shadow = true, outline = true,} )
surface.CreateFont( "AmmoFont1", {font = "ChatText", size = 25, shadow = true, outline = true,} )


function GM:HUDShouldDraw( _name )

local HideHudElements = { 
    CHudCrosshair = true;
    CHudHealth = true;
    CHudBattery = true;
    CHudAmmo = true;
    CHudSecondaryAmmo = true;
    CHudHintDisplay = true;
    CHudHistoryResource = true;
};
    return !HideHudElements[ _name ];
end

surface.CreateFont('hudfont1', { font = 'coolvetica', size = 20 })
surface.CreateFont('hudfont2', { font = 'coolvetica', size = 35 })
local smoothhp = 0
local smootharmor = 0
function GM:HUDPaint()
	
	if !(LocalPlayer() and LocalPlayer():Alive()) then return end
	if !(LocalPlayer():GetActiveWeapon() and IsValid(LocalPlayer():GetActiveWeapon())) then return end

	local ply = LocalPlayer()
	local health = math.Clamp(ply:Health(), 0, 1000)
	local healthbar = math.Clamp(ply:Health(), 0, 100)
	local armor = ply:Armor()
	local nokills = ply:Frags()
	local gunlevelcl = ply:GetNWInt("gunlevel")
	local streakkill = ply:GetNWInt("killstreak")
	local max = ply:GetNWInt("gungamemaxgunlevel")
	
	local currentWeapon = tostring(LocalPlayer():GetActiveWeapon():GetPrintName())
	local totalClip = tostring(LocalPlayer():GetActiveWeapon():Clip1())
	local amLeft = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
	
	local weap = ply:GetActiveWeapon()
	local clip_size = weap.Primary.ClipSize

	smoothhp = math.Approach(smoothhp, healthbar, 60*FrameTime())
	smootharmor = math.Approach(smootharmor, armor, 60*FrameTime())
	
	local w,h = 280, 25
	local equationhp = (w-2)*(smoothhp/100)+2
	local equationarmor = (w-2)*(smootharmor/100)+2

	local clampedAmmo = LocalPlayer():GetActiveWeapon():Clip1()

	draw.RoundedBox(0,10, ScrH() - 80, 300, 70, Color(32,32,32,255)) --Background
	draw.RoundedBox(0,320, ScrH() - 80, 70, 70, Color(32,32,32,255)) --Gun Level HUD
	
	draw.RoundedBox(0,20, ScrH() - 75, 280, 25, Color(182, 47, 33, 255)) --HP Bar background
	draw.RoundedBox(0,20, ScrH() - 75, equationhp, h, Color(231, 76, 60,255)) --HP Bar
	
	draw.RoundedBox(0,20, ScrH() - 42, 280, 25, Color(31, 118, 175, 255)) --Armor Bar background
	draw.RoundedBox(0,20, ScrH() - 42, equationarmor, h, Color(52, 152, 219, 255)) --Armor Bar
	
	draw.SimpleText( health.."%", "hudfont1", 147, ScrH() - 70, Color(255,255,255))
	draw.SimpleText( armor.."%", "hudfont1", 150, ScrH() - 39, Color(255,255,255))
	draw.SimpleText( "Gun Level", "hudfont1", 322, ScrH() - 72, Color(255,255,255))

	local w,h = surface.GetTextSize(gunlevelcl.."/18")
	draw.SimpleText( gunlevelcl.."/18", "hudfont2", 390 - w - 35, ScrH() - 55, Color(255,255,255))

	draw.RoundedBox(0,ScrW() - 10 - 300, ScrH() - 80, 300, 70, Color(32,32,32,255)) --Ammo Grey BG
	draw.RoundedBox(0,ScrW() - 0 - 300, ScrH() - 42, 280, 25, Color(171, 108, 19, 255)) --Ammo Bg empty
	
	if ( LocalPlayer():GetActiveWeapon():GetClass() != "ptp_cs_knife" || LocalPlayer():GetActiveWeapon():GetClass() != "weapon_crowbar" || clampedAmmo != 0 ) then

		local roundit = 280/clampedAmmo
		local width = math.Clamp(clampedAmmo, 0, clampedAmmo)*clampedAmmo/280
		draw.RoundedBox(0,ScrW() - 0 - 300, ScrH() - 42, 280*clampedAmmo/clip_size, 25, Color(229, 145, 26, 255)) --Ammo BG

	else

		draw.RoundedBox(0,ScrW() - 0 - 300, ScrH() - 42, 280, Color(229, 145, 26, 255)) --Ammo BG

	end
	
	draw.SimpleText(currentWeapon, "hudfont2", ScrW() - 299, ScrH() - 75, Color(255,255,255))
	
	if ( LocalPlayer():GetActiveWeapon():GetClass() == "ptp_cs_knife" || LocalPlayer():GetActiveWeapon():GetClass() == "weapon_crowbar" ) then
		return
	else
		draw.SimpleText(totalClip.."/"..amLeft, "hudfont2", ScrW() - 200, ScrH() - 44, Color(255,255,255))
	end


	--if LocalPlayer():Team() == 1 then
		--draw.SimpleText( "Team: Red", "ChatFont", 15, ScrH() - 135, Color(255,0,0))
	--elseif LocalPlayer():Team() == 2 then
		--draw.SimpleText( "Team: Blue", "ChatFont", 15, ScrH() - 135, Color(0,153,153))
	--else
	--end
	
end

surface.CreateFont( "HealthFont", { --Title font for the F1 menu.
	font = "TargetID",
	size = 20,
} )

function HoverOverPlayer()

	local tr = util.GetPlayerTrace(LocalPlayer())
		
		local trace = util.TraceLine(tr)
		if (!trace.Hit) then
			return;
		
		elseif (!trace.HitNonWorld) then
			return;

		elseif (trace.Entity:IsPlayer()) then
			text = trace.Entity:Nick()
			traceHealth = trace.Entity:Health()
  			offset = Vector(0,0,88)
   			plyPos = trace.Entity:GetPos() + offset
    		plyAng = LocalPlayer():EyeAngles()	
   		 	plyAng:RotateAroundAxis(plyAng:Forward(), 90)
    		plyAng:RotateAroundAxis(plyAng:Right(), 90)
		
			cam.Start3D2D(plyPos, plyAng, 0.6)
				if trace.Entity:Team() == 1 then
					draw.DrawText(text.." "..traceHealth.."%", "TargetID", 1, 1, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
				else
					draw.DrawText(text.." "..traceHealth.."%", "TargetID", 1, 1, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER)
				end
			cam.End3D2D()
		end
end
hook.Add("PostDrawOpaqueRenderables", "HoverOverPlayer", HoverOverPlayer)

net.Receive("triplekill_msg", function()

		local triplekillreceiver = net.ReadString()

			chat.AddText( Color( 255, 153, 51),triplekillreceiver,Color(255,255,255)," got a ",Color(204,204,0), "Triple Kill!")

end)

net.Receive("hexakill_msg", function()

		local hexakillreceiver = net.ReadString()

			chat.AddText( Color( 255, 153, 51),hexakillreceiver,Color(255,255,255), " got a ", Color(255,128,0), "Hexa Kill!")

end)

net.Receive("immortalkill_msg", function()

		local immortalkillreceiver = net.ReadString()

			chat.AddText( Color( 255, 153, 51),immortalkillreceiver,Color(255,255,255)," is ",Color(255,0,0), "Immortal!")

end)

net.Receive("killingspree_msg", function()

		local killingspreereceiver = net.ReadString()

			chat.AddText( Color( 255, 153, 51),killingspreereceiver,Color(255,255,255)," is on a ",Color(102,0,204), "Killing Spree!")

end)

net.Receive("killingfrenzy_msg", function()

		local killingfrenzyreceiver = net.ReadString()

			chat.AddText( Color( 255, 153, 51),killingfrenzyreceiver,Color(255,255,255)," is on a ",Color(50,20,204), "Killing Frenzy!")

end)

net.Receive("rampagekill_msg", function()

		local rampagekillreceiver = net.ReadString()

			chat.AddText( Color( 255, 153, 51),rampagekillreceiver,Color(255,255,255)," is on a ",Color(10,20,10), "Rampage!")

end)

net.Receive("humiliation_msg", function()

		local humiliator = net.ReadString()
			local humiliated = net.ReadString() 

		chat.AddText( Color( 255, 153, 51),humiliated,Color(255,255,255)," got humiliated by ",Color(255,0,0), humiliator)

end)

hook.Add( "PreDrawHalos", "AddHalos", function() --X-ray perk.

	local ply = LocalPlayer()
	
	if ply:GetNWInt("xrayenable") == 1 then
		
		halo.Add( player.GetAll(), Color( 255, 0, 0 ), 1, 1, 2, true, true )
	
	end
end)

function GM:PostDrawViewModel( vm, ply, weapon ) --Hands crap.

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end