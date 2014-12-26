local SCOREBOARD = {}
local PLAYERP = {}

surface.CreateFont( "ScoreboardSubTitle",
{
	font		= "ChatFont",
	size		= 20,
	weight		= 300
})

surface.CreateFont( "ScoreboardRank",
{
	font		= "ChatFont",
	size		= 18,
	weight		= 530,
})

surface.CreateFont( "ScoreboardDefaultTitle",
{
	font		= "ChatFont",
	size		= 50,
	weight		= 300
})

surface.CreateFont( "RankLine",
{
	font		= "ChatFont",
	size		= 15,
	weight		= 650
})

function PLAYERP:Init()

	self.CopyID = self:Add("DImageButton")
	self.CopyID:SetImage("icon16/attach.png")
	self.CopyID:SizeToContents()
	self.CopyID:SetPos(330,8)
	self.CopyID:SetToolTip("Click to copy Steam ID")
	self.CopyID.DoClick = function()
		SetClipboardText( self.Player:SteamID() )
		LocalPlayer():ChatPrint("[SCOREBOARD] Copied Steam ID of "..self.Player:Nick())
	end

	self.Kills = self:Add("DLabel")
	self.Kills:SizeToContents()
	self.Kills:SetFont("TargetID")
	self.Kills:Dock(FILL)
	self.Kills:DockMargin(352,0,0,0)
	
	self.Pings = self:Add("DLabel")
	self.Pings:SizeToContents()
	self.Pings:SetFont("TargetID")
	self.Pings:Dock(FILL)
	self.Pings:DockMargin(415,0,0,0)

	self.Death = self:Add("DLabel")
	self.Death:SizeToContents()
	self.Death:SetFont("TargetID")
	self.Death:Dock(FILL)
	self.Death:DockMargin(488,0,0,0)

	self.Team = self:Add("DLabel")
	self.Team:Dock(RIGHT)
	self.Team:SetFont("TargetID")
	
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetSize(32,32)
	self.Avatar:SetMouseInputEnabled(false)

	self.Name = self:Add("DLabel", self)
	self.Name:SizeToContents()
	self.Name:SetFont("TargetID")
	self.Name:Dock(FILL)
	self.Name:DockMargin(35,0,0,0)
	
	self:SetParent(SCOREBOARD_)
	self:DockMargin(20,12,0,0)
	self:Dock(TOP)
	self:DockPadding( 3, 3, 3, 3 )
	self:SetHeight( 32 )
end

function PLAYERP:Think()
	self.Kills:SetText("Kills: "..self.Player:Frags())
	self.Pings:SetText("Ping: "..self.Player:Ping())
	self.Death:SetText("Deaths: "..self.Player:Deaths())

	if (self.Player:Team() == 1) then
		self.Team:SetText("Red")
		self.Team:SetColor(Color(255,0,0))
	elseif (self.Player:Team() == 2) then
		self.Team:SetText("Blue")
		self.Team:SetColor(Color(0,0,255))
	else
		self.Team:SetText("")
	end

	self:SetZPos( (self.Player:Frags() * -50) + self.Player:Deaths() )
end

function PLAYERP:SetPlayer(ply)

	self.Player = ply

	self.Avatar:SetPlayer( ply )
	self.Name:SetText(ply:Nick())

end


function PLAYERP:PreformLayout()
	self:Dock(TOP)
end

function PLAYERP:Paint(w,h)

	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(32,32,32,255))

end

PLAYERP = vgui.Register("GGSBL", PLAYERP, "DPanel")

function SCOREBOARD:PerformLayout()
	self:SetSize( 700, ScrH() - 200 )
	self:SetPos( ScrW() / 2 - 350, 70 )
end

function SCOREBOARD:Init()
	
	self.Title = self:Add("DLabel")
	self.Title:SetText("Gun Game")
	self.Title:SetFont("ScoreboardDefaultTitle")
	self.Title:Dock(TOP)
	self.Title:DockMargin(250,5,0,0)
	self.Title:SizeToContents()
	self.Title:SetColor(Color(255,255,255))

	self.ServerName = self:Add("DLabel")
	self.ServerName:SetText(GetHostName())
	self.ServerName:SetFont("ScoreboardSubTitle")
	self.ServerName:SizeToContents()
	self.ServerName:Dock(TOP)
	self.ServerName:DockMargin(150,7,0,0)
	self.ServerName:SetColor(Color(255,255,255))

	self.Bman = self:Add("DLabel")
	self.Bman:SetSize(200,20)
	self.Bman:SetText("Gun Game by Bman")
	self.Bman:SetFont("TargetID")
	self.Bman:SetPos(5,0)

	self.ScrollPanel = self:Add( "DScrollPanel" )
	self.ScrollPanel:Dock( FILL )
	self.ScrollPanel:DockMargin(20,20,20,20)
	function self.ScrollPanel:Paint(w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(27, 97, 115, 200))
	end

	self.SteamGroup =  self:Add("DImageButton", self)
	self.SteamGroup:SetPos(660,10)
	self.SteamGroup:SetImage("materials/icons/steamicon32.png")
	self.SteamGroup:SizeToContents()
	self.SteamGroup:SetToolTip("Click to visit our Steam group!")
	self.SteamGroup.DoClick = function()
		gui.OpenURL("http://steamcommunity.com/groups/hexteriacommunity")
	end

	self.Website =  self:Add("DImageButton", self)
	self.Website:SetPos(625,10)
	self.Website:SetImage("materials/icons/hexteria32.png")
	self.Website:SetSize(32,32)
	self.Website:SetToolTip("Click to visit our website and forums!")
	self.Website.DoClick = function()
		gui.OpenURL("http://www.hexteria.com/")
	end
end

function SCOREBOARD:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color(32, 32, 32, 250) )
end

function SCOREBOARD:Think()
	
	for k,v in pairs (player.GetAll()) do
		if (IsValid(v.Line)) then continue end

		v.Line = vgui.Create("GGSBL")
		v.Line:SetPlayer(v)

		self.ScrollPanel:AddItem(v.Line)
	end
end

SCOREBOARD = vgui.Register( "GGSB", SCOREBOARD, "EditablePanel" )

function GM:ScoreboardShow()
	
	if ( !IsValid( SCOREBOARD_ ) ) then
		SCOREBOARD_ = vgui.Create( "GGSB" )
	end

	if ( IsValid( SCOREBOARD_ ) ) then
		SCOREBOARD_:Show()
		SCOREBOARD_:MakePopup()
		SCOREBOARD_:SetKeyboardInputEnabled( false )
	end
end

function GM:ScoreboardHide()
	
	if ( IsValid( SCOREBOARD_ ) ) then
		SCOREBOARD_:MoveTo(ScrW() / 2 - 350, 0 - SCOREBOARD_:GetTall(), 0.1, 0, 4, function()
			SCOREBOARD_:Remove()
		end)
	end
end

