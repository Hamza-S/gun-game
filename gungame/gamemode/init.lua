--[[--------------------------------------------
Author: Bman
Description: Gun Game gamemode for Gary's Mod.
Version: 1.0.0
Website: forums.hexteria.com
----------------------------------------------]]--

resource.AddFile("materials/menu.png")
resource.AddFile("materials/leave.png")

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_config.lua" )
AddCSLuaFile( "player_hooks.lua" )
AddCSLuaFile( "sh_meta.lua" )
AddCSLuaFile( "vgui/cl_helpmenu.lua" )

AddCSLuaFile( "vgui/cl_scoreboard.lua")

include( 'shared.lua' )
include( 'sh_config.lua' )
include ( 'player_hooks.lua' )
include ( 'sh_meta.lua' )

util.AddNetworkString("HelpMenu")
util.AddNetworkString("roundstats_msg")

util.AddNetworkString("humiliation_msg")
util.AddNetworkString("ChooseTeam")

util.AddNetworkString("triplekill_msg")
util.AddNetworkString("hexakill_msg")
util.AddNetworkString("immortalkill_msg")
util.AddNetworkString("killingspree_msg")
util.AddNetworkString("killingfrenzy_msg")
util.AddNetworkString("rampagekill_msg")
util.AddNetworkString("killcam_msg")

function GM:Initialize()
	round = 1
	self.BaseClass.Initialize( self )
end

function GM:Think()
--[[--------------------------------------------------------------
I apologize about the mess. This is for the leaderboards in-game
--]]--------------------------------------------------------------

	leaderBoard = {}
	
	for k,v in pairs (player.GetAll()) do
		local currInfo = {ply = v, glevel = v:GetNWInt("gunlevel")}
			table.insert(leaderBoard, currInfo)
	end
	
		table.SortByMember(leaderBoard, "glevel")
	
	for k,v in pairs (player.GetAll()) do
		if (k == 0) then
			return;
		elseif (k >= 1 && 2 > k) then
			
			numberOne = leaderBoard[1]
				SetGlobalString("1stPlace","1st: "..numberOne.ply:Nick().."- "..numberOne.glevel.."/18") --First place player
		
		elseif (k >= 2 && 3 > k) then
			
			numberOne = leaderBoard[1]
				SetGlobalString("1stPlace","1st: "..numberOne.ply:Nick().."- "..numberOne.glevel.."/18") --First place player
			
			numberTwo = leaderBoard[2]
				SetGlobalString("2ndPlace","2nd: "..numberTwo.ply:Nick().."- "..numberTwo.glevel.."/18") --Second place player
		
		elseif (k >= 3 ) then
			numberOne = leaderBoard[1]
				SetGlobalString("1stPlace","1st: "..numberOne.ply:Nick().."- "..numberOne.glevel.."/18") --First place player
			
			numberTwo = leaderBoard[2]
				SetGlobalString("2ndPlace","2nd: "..numberTwo.ply:Nick().."- "..numberTwo.glevel.."/18") --Second place player
			
			numberThree = leaderBoard[3]
				SetGlobalString("3rdPlace","3rd: "..numberThree.ply:Nick().."- "..numberThree.glevel.."/18") --Third place player
		else
			return;
		end
	end
end

local ShootGodDisable = function( ply ) -- Make sure this goes above your GM:PlayerSpawn
    if ply:KeyDown(IN_ATTACK) then
        ply:GodDisable()
        ply:SetMaterial("")
    end
end

function shuffle(t) --Shuffle array; credits to Nick Gammon; http://www.gammon.com.au/forum/?id=9908
  	local n = #t
 
  	while n >= 2 do
   		 -- n is now the last pertinent index
   	 local k = math.random(n) -- 1 <= k <= n
   		 -- Quick swap
   	 t[n], t[k] = t[k], t[n]
   	 n = n - 1
		
	end
 		
 	return t;
	
end

shuffle(GUNGAMECONFIG.guns) --Shuffle our guns from the GUNGAMECONFIG.guns table in sh_config.lua.

randomgunsTable = {} --Create this table to insert our new random keys from the shuffle function.

for k, v in ipairs (GUNGAMECONFIG.guns) do --Loop through the shuffled table, and insert the new keys into randomgunsTable.
  	table.insert( randomgunsTable, k , v) --Insert the values.
end

table.insert( GUNGAMECONFIG.guns, "weapon_crowbar") --Make sure that the weapon_crowbar is always the last key in the table.
table.insert( randomgunsTable, "weapon_crowbar") --Make sure that the weapon_crowbar is always the last key in the table.

function GM:PlayerInitialSpawn( ply )

		--[[ local randomTeam = math.random(1,2)

			local randomTeam = math.random(1,2)
			local teamName = team.GetName(randomTeam)
				
				ply:SetTeam(randomTeam)
			
			for k,v in pairs (player.GetAll()) do
				v:ChatPrint(ply:Nick().." has joined "..teamName)
			end

		--]]
	
		--net.Start("ChooseTeam")
		--net.WriteString(ply:Nick())
		--net.Send(ply)
		
		if ( team.NumPlayers(2) > team.NumPlayers(1) ) then
			ply:ChangeTeam(1)

		elseif (team.NumPlayers(1) > team.NumPlayers(2)) then
			ply:ChangeTeam(2)
		else
			local randomTeam = math.random(1,2)
			ply:ChangeTeam(randomTeam)
		end
		
		ply:SetNWInt("killstreak", 0)
		ply:SetNWInt("muted", 0)
		ply:SetNWInt("gunlevel", 1)
		ply:SetNWInt("xrayenable", 0)
		

end

--function GM:ShowTeam( ply )
	--net.Start("ChooseTeam")
	--net.WriteString(ply:Nick())
	--net.Send(ply)
--end

function GM:PlayerSpawn(ply)
	
	if IsValid(ply) then
		local gunlevel = ply:GetNWInt("gunlevel") --Get their gun level 
		local giveguns = randomgunsTable[gunlevel] --Use gun level number to go through the GUNGAMECONFIG.guns table to give that player the appropriate gun.
		
		for k,v in pairs (GUNGAMECONFIG.tplayermdl) do
			util.PrecacheModel(v)
		end
		
		for k,v in pairs (GUNGAMECONFIG.ctplayermdl) do
			util.PrecacheModel(v)
		end
		
		if ply:Team() == 1 then
			ply:SetModel(table.Random(GUNGAMECONFIG.tplayermdl))
		else
			ply:SetModel(table.Random(GUNGAMECONFIG.ctplayermdl))
		end
	
			ply:SetNWInt("killstreak", 0)
			ply:SetNWInt("vampirism", 0)
			ply:SetNWInt("xrayenable", 0)
			ply:GodEnable()
			ply:SetNoCollideWithTeammates(true)
			ply:SetMaterial("models/effects/splodearc_sheet")
			ply:SetNWInt("gungamemaxgunlevel", #GUNGAMECONFIG.guns) --Don't let them pass the max limit for the that table. (Also used for /x where x = max gun level in cl_init.lua HUD:Paint())
			ply:StripWeapons()
			ply:Give(giveguns)
			ply:Give("ptp_cs_knife")

			ply:SetupHands() --Hands crap.
		
		timer.Simple(0.2, function() -- Put this in GM:PlayerSpawn
        	hook.Add("KeyPress", "ShootGodDisable", ShootGodDisable)
		end)

		timer.Simple(2,function()
			ply:GodDisable()
			ply:SetMaterial("")
			hook.Remove("KeyPress", "ShootGodDisable")
		end)
	end
end

function GM:PlayerShouldTakeDamage(ply, atk)
	if ( ply:Team() == atk:Team() && ply:IsPlayer() && atk:IsPlayer() ) then
		return false;
	end
	return true;
end

function GM:PlayerSelectSpawn(ply) 

	
		--local randomSpawn = math.random(1,2) --Choose random number; 1 or 2.

		local Tspawn = ents.FindByClass("info_player_terrorist") --T spawns (Make sure to use CS:S maps.)
		local CTspawn = ents.FindByClass("info_player_counterterrorist") --CT spawns (Make sure to use CS:S maps.)
			
			local random_t = math.random(#Tspawn) --Randomize a spawn-point for the terrorist spawn points on that map.
			local random_ct = math.random(#CTspawn) --^ (Counter-Terrorist)

		--[[
		if (randomSpawn == 1) then --If the random number from randomSpawn is 1 then spawn them in the T area, on a random T spawn point.
			return Tspawn[random_t]
		
		elseif (randomSpawn == 2) then
			return CTspawn[random_ct] --^ (Counter-Terrorist)

		else
			--(flag:ca)
		end
		--]]

		if ply:Team() == 1 then
			return Tspawn[random_t]
		
		elseif ply:Team() == 2 then
			return CTspawn[random_ct]
		else
		end
	
end

function GM:PlayerDeath(ply, inf, atk)
	ply.NextSpawnTime = CurTime() + 3
		ply.DeathTime = CurTime()
	
	if (atk:IsPlayer() && ply:IsValid() && ply ~= atk && ply:IsPlayer() && atk:IsValid()) then --Check if attacker and player are both valid, and are players.

		local getatkWeapon = atk:GetActiveWeapon():GetClass() --Get the attackers gun and store it in the variable; used for checking for winner and humiliation.
		local addglevel = atk:GetNWInt("gunlevel") + 1 --Adding  gunlevel variable.
		local removeglevel = ply:GetNWInt("gunlevel") - 1 --Removing a gunlevel variable.
		local addkillstreak = atk:GetNWInt("killstreak") + 1 --Adding a streak variable.
		local givenextgun = GUNGAMECONFIG.guns[addglevel] --Giving the player the next gun in the GUNGAMECONFIG.guns table in sh_config.lua
			
			
		if (atk == ply) then --If the player kills themselves, then remove a gun level.
				
			if (ply:GetNWInt("gunlevel") == 1) then
				ply:SetNWInt("gunlevel", 1)
			else
				ply:SetNWInt("gunlevel", removeglevel)
			end

			elseif (getatkWeapon == "weapon_crowbar") then --Checking for winner
				hook.Call("GGRoundEnd", GAMEMODE, atk)

			elseif (getatkWeapon == "ptp_cs_knife") then --Check if the killer used a knife. (Used for humiliation.)
				
				if (ply:GetNWInt("gunlevel") == 1) then
						atk:SetNWInt("killstreak", addkillstreak)
							ply:SetNWInt("gunlevel", 1)

						net.Start("humiliation_msg")
						net.WriteString(atk:Nick())
						net.WriteString(ply:Nick())
						net.Broadcast()
					
				else
					atk:SetNWInt("killstreak", addkillstreak)
						ply:SetNWInt("gunlevel", removeglevel)

						net.Start("humiliation_msg")
						net.WriteString(atk:Nick())
						net.WriteString(ply:Nick())
						net.Broadcast()
					end

			elseif (atk:GetNWInt("vampirism") == 1) then --Check for Vampirism kill-streak.
					
				local randomHealth = math.random(1,5)
					atk:SetHealth(atk:Health() + randomHealth)
						atk:ChatPrint("[VAMPIRISM] You were given "..randomHealth.." health, for killing "..ply:Nick(0))
						
					atk:SetNWInt("gunlevel", addglevel)
						atk:SetNWInt("killstreak", addkillstreak)
					
					timer.Simple(0.4, function()
						atk:StripWeapons()
							atk:Give(givenextgun)
								atk:Give("ptp_cs_knife")
					end)
			
						ply:SetNWInt("killstreak", 0) --Set the streak 0 to the player who the atk killed.

				
			elseif (!atk:IsPlayer()) then  --If a prop or fall damage kills the player.
				ply:SetNWInt("killstreak", 0)
				ply:SetNWInt("gunlevel", removeglevel)
			
			else  --If a player kills someone, add 1 to their kill, and add a gun-level, and set the players killstreak to 0, and killstreak to atk.
				atk:SetNWInt("gunlevel", addglevel)
				atk:SetNWInt("killstreak", addkillstreak)
					
				timer.Simple(0.4, function()
					atk:StripWeapons()
					atk:Give(givenextgun)
					atk:Give("ptp_cs_knife")
				end)
				
				ply:SetNWInt("killstreak", 0) --Set the streak 0 to the player who the atk killed.
		
			end
		end
end

function GM:PlayerDeathThink(ply)
		
	if (ply.NextSpawnTime && ply.NextSpawnTime > CurTime()) then return end

	if (ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed(IN_ATTACK2) || ply:KeyPressed(IN_JUMP)) then

		ply:Spawn()

	end

end

--[[---------------------------------------------
Perk Master: (Thanks for the help Valyriace)
	3: Triple Kill, speed bost,
	6, HexaKill, xray
	9, Immortal, vampirism,
	12, Killing Spree, armor 1-3
	15, Killing Frenzy, armor 3-5,
	18, Rampage, armor 5-8

	Note*: Killstreaks nw var is 1 behind.
-----------------------------------------------]]

hook.Add("PlayerDeath", "TripleKill", function(ply, atk, vic)

	if (atk:GetNWInt("killstreak") == 2 && atk:Alive()) then
			atk:SetWalkSpeed(250)
				atk:SetRunSpeed(350)
					atk:ChatPrint("Triple Kill perk activated!")
			
			net.Start("triplekill_msg")
			net.WriteString(atk:Nick())
			net.Broadcast()
	end
end)

hook.Add("PlayerDeath", "HexaKill", function(ply, atk, vic)

	if (atk:GetNWInt("killstreak") == 5 && atk:Alive()) then 
		
		atk:ChatPrint("Activated Quadra Kill perk!")
			net.Start("hexakill_msg")
			net.WriteString(atk:Nick())
			net.Broadcast()

		atk:SetNWInt("xrayenable", 1)
		
		timer.Simple(8, function()
			atk:SetNWInt("xrayenable", 0)
			atk:ChatPrint("X-Ray disabled!")
		end)
	end

end)

hook.Add("PlayerDeath", "ImmortalKill", function(ply, atk, vic)

	if (atk:GetNWInt("killstreak") == 8 && atk:Alive()) then
			atk:SetNWInt("vampirism", 1)
				atk:ChatPrint("Immortal Kill perk activated!")
			net.Start("immortalkill_msg")
			net.WriteString(atk:Nick())
			net.Broadcast()
	end
end)

hook.Add("PlayerDeath", "KillingSpree", function(ply, atk, vic)

	if (atk:GetNWInt("killstreak") >= 11 && atk:GetNWInt("killstreak") <= 13 && atk:Alive()) then
			local armorkillingSpree = math.random(1,3)
				atk:SetArmor(atk:Armor() + armorkillingSpree)
					atk:ChatPrint("You were given "..armorkillingSpree.." for killing "..ply:Nick())
						net.Start("killingspree_msg")
						net.WriteString(atk:Nick())
						net.Broadcast()
	end
end)

hook.Add("PlayerDeath", "KillingFrenzy", function(ply, atk, vic)

	if (atk:GetNWInt("killstreak") >= 14 && atk:GetNWInt("killstreak") <= 17 && atk:Alive()) then
		local armorkillingFrenzy = math.random(3,5)
			atk:SetArmor(atk:Armor() + armorkillingFrenzy)
				atk:ChatPrint("You were given "..armorkillingFrenzy.." for killing "..ply:Nick())
					net.Start("killingfrenzy_msg")
					net.WriteString(atk:Nick())
					net.Broadcast()
	end
end)

hook.Add("PlayerDeath", "RampageKill", function(ply, atk, vic)

	if (atk:GetNWInt("killstreak") >= 17 && atk:Alive()) then
		local armorrampageKill = math.random(5,8)
			atk:SetArmor(atk:Armor() + armorrampageKill)
				atk:ChatPrint("You were given "..armorrampageKill.." for killing "..ply:Nick())
					net.Start("rampagekill_msg")
					net.WriteString(atk:Nick())
					net.Broadcast()
	end
end)

function GM:PlayerSetHandsModel( ply, ent ) --Hands crap.

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

--[[---------------------------------------------------------
							Round system
--]]---------------------------------------------------------

function RoundEnd(atk)
local nameofchamp = atk:Nick()

	for k,v in pairs (player.GetAll()) do
		v:Freeze(true)
		v:ScreenFade( 2, Color(0,0,0,255), 3, 5 )
			net.Start("roundstats_msg")
			net.WriteString(atk:Nick())
			net.Send(v)
	end

	atk:SetNWInt("killstreak", addkillstreak)
							
	timer.Simple(8, function() --Wait five seconds; call RoundBegin().

		hook.Call("GGRoundBegin", GAMEMODE)

	end)
end
hook.Add("GGRoundEnd", "GGRoundFinish", RoundEnd)


function RoundBegin() --Round beggining function. There is no time limit on rounds.

round = round + 1

--if (round == 5) then --Check if global variable round has reached 5; if it has start the round changer.

	--for k,v in pairs (player.GetAll()) do
		--v:ChatPrint("5/5 Changing map!")
	--end

--end

	if (round <= 5 || round >= 5) then
		for k,v in pairs (player.GetAll()) do
			v:SetNWInt("gunlevel", 1)
			v:SetNWInt("killstreak", 0)
			v:SetFrags(0)
		
			local gunlevel = v:GetNWInt("gunlevel") --Store the number of the int for their current gunlevel
			local giveguns = randomgunsTable[gunlevel]
		
			v:StripWeapons()
			v:ChatPrint("Round "..round.." starting!")
		
			v:Spawn()
			v:Give(giveguns)
			v:Give("ptp_cs_knife")
			
			timer.Simple(3, function()
				v:Freeze(false)
			end)
		end
	end
end
hook.Add("GGRoundBegin", "GGRoundStart", RoundBegin)

concommand.Add( "clhorsetagredteamchange123", function( ply, cmd, args, str )
	ply:SetTeam(1)
	ply:Spawn()
	for k,v in pairs (player.GetAll()) do
		v:ChatPrint(ply:Nick().." has joined team Red!")
	end
end )

concommand.Add( "clchickencoup123chairdeskblueteam", function( ply, cmd, args, str )
	ply:SetTeam(2)
	ply:Spawn()
	for k,v in pairs (player.GetAll()) do
		v:ChatPrint(ply:Nick().." has joined team Blue!")
	end
end )