--[[-------------------------------------------
Author: Bman
Description: Gun Game gamemode for Gary's Mod.
Version: 1.0.0
Website: forums.hexteria.com
--]]-------------------------------------------

GM.Name = "Gun Game"
GM.Author = "Bman"
GM.Email = "hamzabman@gmail.com"
GM.Website = "forums.hexteria.com"
DeriveGamemode("base")

TEAM_T = 1
TEAM_CT = 2

team.SetUp( TEAM_T, "Red", Color(255,0,0), true)
team.SetUp( TEAM_CT, "Blue", Color(0,0,255), true)


