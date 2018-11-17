SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false

SWEP.PrintName					= ""
SWEP.strikedalay				= 0
SWEP.strikeentity     	  		= ""
SWEP.Primary.Ammo				= ""
SWEP.ShellCount					= 0
SWEP.ExactShellCount			= nil
SWEP.Team						= ""
SWEP.StrikeString				= ""
SWEP.Bomber						= false
SWEP.RocketRun					= false

SWEP.Smoke						= false
SWEP.RandomPos					= 0
SWEP.LoopTimerTime1				= 0
SWEP.LoopTimerTime2				= 0
SWEP.FireRate					= 200

SWEP.SndLang					= ""
SWEP.SndAccent                  = 0
SWEP.ModelTimer                 = 0
SWEP.CustomAngle				= 50

SWEP.Category					= "Gredwitch's SWEPs"
SWEP.Author						= "Gredwitch"
SWEP.Contact					= "qhamitouche@gmail.com"
SWEP.Purpose					= "Destroy the enemy"
SWEP.Instructions				= "Right ckick to look through the binoculars, left click to call in a strike."
SWEP.MuzzleAttachment			= "1"
SWEP.ShellEjectAttachment		= "2"
SWEP.Slot						= 4
SWEP.SlotPos					= 35
SWEP.DrawAmmo					= true
SWEP.DrawWeaponInfoBox			= false
SWEP.BounceWeaponIcon   		= false
SWEP.DrawCrosshair				= false
SWEP.Weight						= 50
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= true
SWEP.XHair						= false
SWEP.HoldType 					= "camera"

SWEP.ViewModelFOV				= 70
SWEP.WaitGuns					= 10
SWEP.GunCount					= 1
SWEP.GunOffset					= 50
SWEP.ViewModelFlip				= false
SWEP.ViewModel					= "models/weapons/v_invisib.mdl"
SWEP.WorldModel					= "models/weapons/w_binos.mdl"
SWEP.Base 						= "gred_scoped_base"
SWEP.PreSound 					= nil
SWEP.PreSoundName				= nil
SWEP.PreSndPossibilities		= nil
SWEP.PreSndFormat				= nil

SWEP.Primary.Sound				= Sound("weapons/satellite/targaquired.mp3")
SWEP.Primary.RPM				= 10
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.KickUp				= 1
SWEP.Primary.KickDown			= 1
SWEP.Primary.KickHorizontal		= 1
SWEP.Primary.Automatic			= false

SWEP.Secondary.ScopeZoom		= 6
SWEP.Secondary.UseParabolic		= false
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot		= true		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	
SWEP.GunRun						= false
SWEP.GunSnd						= ""
SWEP.AircraftModel				= "models/mm1/box.mdl"

SWEP.data 						= {}
SWEP.data.ironsights			= 1
SWEP.ScopeScale 				= 1

SWEP.PoorBastard 				= false
SWEP.NextShoot 					= 0

SWEP.RadioCallInSnd				= ""

SWEP.IronSightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.IronSightsAng = Vector(50.353, 17.884, -19.428)
SWEP.SightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.SightsAng = Vector(50.353, 17.884, -19.428)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-21.994, 0, 0)

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-19.507, 0, 0) },
	["r-index-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-71.792, 0, 0) },
	["r-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.483, 1.309, 0) },
	["l-upperarm-movement"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.88), angle = Angle(0, 0, 0) },
	["Da Machete"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.263, -1.826), angle = Angle(0, 0, 0) },
	["r-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.507, 0, 0) },
	["r-pinky-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-47.32, 0, 0) },
	["r-ring-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-54.065, 0, 0) },
	["r-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0) },
	["r-thumb-tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.666, 0, 0) },
	["r-upperarm-movement"] = { scale = Vector(1, 1, 1), pos = Vector(7.394, 2.101, -9.54), angle = Angle(-10.502, -12.632, 68.194) },
	["r-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.526, 0, 0) },
	["r-middle-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-37.065, 0, 0) },
	["r-thumb-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.816, 18.775, -30.143) },
	["l-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0) },
	["r-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.982, 0, 0) }
}

SWEP.VElements = {
	["binos"] = { type = "Model", model = "models/weapons/binos.mdl", bone = "r-thumb-low", rel = "", pos = Vector(3.907, -0.109, -1.125), angle = Angle(-2.829, 27.281, 105.791), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:GetCallInSound()
		if GetConVar("gred_sv_spam"):GetInt() <= 0 then
		local ct = CurTime()
		local rand = math.random(1,2)
		if !self.Owner.LastHit then
			suppressed = "unsuppressed/"
		else
			if self.Owner.LastHit + 7 <= ct then
				suppressed = "unsuppressed/"
			else
				suppressed = "suppressed/"
			end
		end
		if self.SndLang == "English" then
			if self.SndAccent == 1 then
				CallSnd = "english/"..suppressed..self.RadioCallInSnd..rand..".wav"
			else
				CallSnd = "american_01/"..suppressed..self.RadioCallInSnd..rand..".wav"
			end
		else
			CallSnd = "german_01/"..suppressed..self.RadioCallInSnd..rand..".wav"
		end
		return CallSnd
	else return 0 end
end
if SERVER then
	function SWEP:PrimaryAttack()
		if !self:CanPrimaryAttack() or (self.IsCallingIn and GetConVar("gred_sv_spam"):GetInt() <= 0) then return end
		self.IsCallingIn = true
		local CallSnd = self:GetCallInSound()
		if CallSnd != 0 then
			sound.Add( {
				name = "CallSnd",
				channel = CHAN_AUTO,
				volume = 1.0,
				level = 80,
				pitch = { 100 },
				sound = CallSnd
			} )
			self.Owner:EmitSound("CallSnd")
			-- self.snd = snd
			sndDur = SoundDuration(CallSnd) + math.random(0.5,0.6)
		else
			sndDur = CallSnd
		end
		ply = self.Owner
		sndl = self.SndLang
		snda = self.SndAccent
		ss = self.StrikeString
		local PlayerPos = self.Owner:GetEyeTrace().HitPos
		local PlyAng = self.Owner:EyeAngles().y
		timer.Simple(sndDur, function()
			if self.Weapon && IsValid( self.Weapon.Owner) then
				local trace = {}
				trace.start = PlayerPos
				trace.endpos = PlayerPos + Vector(0,0,1000)
				trace.filter = {ply}
				tr = util.TraceLine(trace)
				if tr.Hit and !tr.HitSky then
					local trace = {}
					trace.start = tr.HitPos + Vector(0,0,50)
					trace.endpos = tr.HitPos + Vector(0,0,1000)
					trace.filter = {ply}
					tr = util.TraceLine(trace)
				end
				if tr.Hit and !tr.HitSky then
					if self.GunRun or self.RocketRun or self.Bomber or self.StrikeString == "Air" then
						if self.SndLang == "English" then
							if self.SndAccent == 1 then
								snd = "radio/allied/british/airsupportnotvalidtarget"..math.random(1,5)..".ogg"
							else
								snd = "radio/allied/american/airsupportnotvalidtarget"..math.random(1,5)..".ogg"
							end
						else
							snd = "radio/axis/airsupportnotvalidtarget"..math.random(1,5)..".ogg"
						end
					else
						if self.SndLang == "English" then
							if self.SndAccent == 1 then
								if self.StrikeString == "Chemical mortar" then 
									snd = "radio/allied/british/gasartillerynotvalidtarget"..math.random(1,5)..".ogg"
								else
									snd = "radio/allied/british/artillerynotvalidtarget"..math.random(1,5)..".ogg"
								end
							else
								snd = "radio/allied/american/artillerynotvalidtarget"..math.random(1,5)..".ogg"
							end
						else
							snd = "radio/axis/artillerynotvalidtarget"..math.random(1,5)..".ogg"
						end
					end
					self.Weapon:EmitSound(snd)
					timer.Simple(SoundDuration(snd) + 1, function() self.IsCallingIn = false end)
					net.Start("gred_net_message_ply")
						net.WriteEntity(ply)
						net.WriteString("[GREDWITCH'S SWEPS]Bad target! Don't aim inside buildings")
					net.Send(ply)
				else
					snd = self.SoundName..(math.random(1,self.SndPossibilities))..self.SndFormat
					self.Weapon:EmitSound(snd)
				
					net.Start("gred_net_message_ply")
						net.WriteEntity(ply)
						net.WriteString("[GREDWITCH'S SWEPS]"..self.StrikeString.." strike begins in "..(self.strikedalay).." seconds")
					net.Send(ply)
					self:TakePrimaryAmmo(1)
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					
					local ArtiStrike = ents.Create("gred_arti_ent")
					ArtiStrike:SetPos(tr.HitPos)
					ArtiStrike:SetAngles(ArtiStrike:GetAngles() + Angle(0,PlyAng,0))
					
					ArtiStrike.PlyPos				= PlayerPos
					ArtiStrike.ShellType			= self.strikeentity
					ArtiStrike.Delay	    		= self.strikedalay
					ArtiStrike.ShellCount			= self.ShellCount
					ArtiStrike.Owner				= ply
					ArtiStrike.Team					= self.Team
					ArtiStrike.StrikeString 		= self.StrikeString
					ArtiStrike.WaitGuns				= self.WaitGuns
					ArtiStrike.PreSound				= self.PreSound
					ArtiStrike.PreSoundName			= self.PreSoundName
					ArtiStrike.PreSndFormat			= self.PreSndFormat
					ArtiStrike.PreSndPossibilities	= self.PreSndPossibilities
					ArtiStrike.Bomber				= self.Bomber
					
					ArtiStrike.GunRun				= self.GunRun
					ArtiStrike.RocketRun			= self.RocketRun
					ArtiStrike.FireRate				= self.FireRate
					
					ArtiStrike.Smoke				= self.Smoke
					ArtiStrike.RandomPos			= self.RandomPos
					ArtiStrike.LoopTimerTime1		= self.LoopTimerTime1
					ArtiStrike.LoopTimerTime2		= self.LoopTimerTime2
					
					ArtiStrike.GunCount				= self.GunCount
					ArtiStrike.GunOffset			= self.GunOffset
					ArtiStrike.CustomAngle			= self.CustomAngle
					ArtiStrike.StrikeType			= self.StrikeType
					ArtiStrike.AircraftModel		= self.AircraftModel
					ArtiStrike.ModelTimer			= self.ModelTimer
					
					ArtiStrike.RandomBullets		= self.RandomBullets
					ArtiStrike:Spawn()
					ArtiStrike:Activate()
					timer.Simple(SoundDuration(snd) + 1, function() self.IsCallingIn = false end)
				end
			else
				if sndl == "English" then
					if snda == 1 then
						if ss == "Chemical mortar" then
							snd = "radio/allied/british/gasartillerydoesnotcopy"..math.random(1,5)..".ogg"
						else
							snd = "radio/allied/british/artillerydoesnotcopy"..math.random(1,5)..".ogg"
						end
					else
						snd = "radio/allied/american/artillerydoesnotcopy"..math.random(1,5)..".ogg"
					end
				else
					snd = "radio/axis/artillerydoesnotcopy"..math.random(1,5)..".ogg"
				end
				local ent = ents.Create("prop_dynamic")
				ent:SetPos(ply:GetPos())
				ent:EmitSound(snd)
				ent:Remove()
			end
		end)
	end
end