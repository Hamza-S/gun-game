net.Receive("HelpMenu", function()

surface.CreateFont( "F1MenuText", { --Text used in the F1 menu.
	font = "ChatText",
	size = 15,
	shadow = true,
	outline = true,
} )

		local helpFrame = vgui.Create("DSleekFrame")
			helpFrame:SetSize(700,500)
			helpFrame:Center()
			helpFrame:SetTitle("Help")
			helpFrame:MakePopup()
			helpFrame:SetVisible(true)
			helpFrame:SetDraggable(false)
			
			local helppropertySheet = vgui.Create("DSleekPropertySheet", helpFrame)
				helppropertySheet:SetSize(helpFrame:GetWide()-35, helpFrame:GetTall()-45)
				helppropertySheet:SetPos(10,20)

			local panelOne = vgui.Create("DSleekPanel", helpFrame)
				panelOne:SetSize(600,400)
				
				function panelOne:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(17, 3, 163, 100))
				end

			local rulesButton = vgui.Create("DSleekButton", panelOne)
				rulesButton:SetSize(480, 50)
				rulesButton:SetText("Rules")
				
				function rulesButton.DoClick()
					gui.OpenURL("http://forums.hexteria.com/showthread.php?tid=1971&pid=12347#pid12347")
				end
			
			local steamgroupButton = vgui.Create("DSleekButton", panelOne)
				steamgroupButton:SetSize(480,50)
				steamgroupButton:SetPos(0,50)
				steamgroupButton:SetText("Steam Group")
				
				function steamgroupButton.DoClick()
					gui.OpenURL("http://steamcommunity.com/groups/hexteriacommunity#")
				end
				
			local panelThree = vgui.Create("DSleekPanel", helpFrame)
				panelThree:SetSize(600,400)
					
				function panelThree:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(17, 3, 163, 100))
				end

					local creditsLabel = vgui.Create("DLabel", panelThree)
						creditsLabel:SetSize(600,300)
						creditsLabel:SetFont("F1MenuText")
						creditsLabel:SetPos(10,10)
						creditsLabel:SetText("Credits:\n\n Valyriace (Testing)\n RexRaytham (Testing)\n The8bitBrawler (Testing)\n Josh (Testing)\n ThreadedProcess (Server Support)\n Captain 'Murika (Testing)\n Trumple (Jetman) (Derma, Shop, VIP system)\n Verified (Scoreboard Concept)\n Kaleb (Testing)\n Madykevy (HUD Concept)\n\n Developer:\n\n Bman")


				helppropertySheet:AddSheet("Info",panelOne,"")
				helppropertySheet:AddSheet("Credits",panelThree,"")

end)