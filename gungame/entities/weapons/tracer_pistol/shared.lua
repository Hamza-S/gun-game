//General Settings \\ 
SWEP.PrintName 		= "Tracer Gun" // The name of your SWEP 
 
SWEP.Author 		= "Bman" // Your name 
SWEP.Instructions 	= "Shoot & Spy." // How do people use your SWEP? 
SWEP.Contact 		= "" // How people should contact you if they find bugs, errors, etc 
SWEP.Purpose 		= "" // What is the purpose of the SWEP? 
 
SWEP.AdminSpawnable = true // Is the SWEP spawnable for admins? 
SWEP.Spawnable 		= false // Can everybody spawn this SWEP? - If you want only admins to spawn it, keep this false and admin spawnable true. 
 
SWEP.ViewModelFOV 	= 64 // How much of the weapon do you see? 
SWEP.ViewModel 		= "models/weapons/v_pistol.mdl" // The viewModel = the model you see when you're holding the weapon.
SWEP.WorldModel 	= "models/weapons/w_pistol.mdl" // The world model = the model you when it's down on the ground.
 
SWEP.AutoSwitchTo 	= false // When someone picks up the SWEP, should it automatically change to your SWEP? 
SWEP.AutoSwitchFrom = true // Should the weapon change to the a different SWEP if another SWEP is picked up?
 
SWEP.Slot 			= 1 // Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 1 // Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6) 
 
SWEP.HoldType = "Pistol" // How is the SWEP held? (Pistol SMG Grenade Melee) 
 
SWEP.FiresUnderwater = true // Does your SWEP fire under water?
 
SWEP.Weight = 5 // Set the weight of your SWEP. 
 
SWEP.DrawCrosshair = true // Do you want the SWEP to have a crosshair? 
 
SWEP.DrawAmmo = false // Does the ammo show up when you are using it? True / False 
 
SWEP.ReloadSound = "vo/coast/cr_sorry.wav" // Reload sound, you can use the default ones, or you can use your own; Example; "sound/myswepreload.wav" 
 
SWEP.base = "weapon_base" //What your weapon is based on.
//General settings\\
 
SWEP.Primary.Sound = "vo/coast/cr_sorry.wav" // The sound that plays when you shoot your SWEP :-] 
SWEP.Primary.TakeAmmo = 0 // How much ammo does the SWEP use each time you shoot?
SWEP.Primary.Ammo = "Pistol" // The ammo used by the SWEP. (pistol/smg1) 

 

function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound) 
        self:SetWeaponHoldType( self.HoldType )
end 


function SWEP:DrawHUD()
	draw.RoundedBox(0,ScrW()/2-5,ScrH()/2-5, 5, 5, Color(255,0,0,255))
end
 
function SWEP:PrimaryAttack()

	local ply = self.Owner
  	local tr = self.Owner:GetEyeTrace()
  	local ent = tr.Entity
  	local shootPos = self.Owner:GetShootPos()
		
		if ent:GetClass() == "player" then
			local targetPlayer = ent
			local targetName = ent:Nick()
			local targetHealth = ent:Health()

			ply:ChatPrint("Player found! "..targetName..": HP:"..targetHealth)

		else
			ply:ChatPrint("ERROR: Not a player!")
		end
 
end 