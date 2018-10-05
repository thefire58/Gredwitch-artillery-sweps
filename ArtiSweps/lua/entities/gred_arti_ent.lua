AddCSLuaFile()

ENT.Type 							=	"anim"
ENT.Base 							=	"base_anim"

ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"Artillery strike entity"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"

ENT.Model                         	=	"models/mm1/box.mdl"
ENT.Delay							=	0
ENT.ShellType						=   ""
ENT.StrikeType						=	""
ENT.ShellCount						=	0
ENT.Team							=	""
ENT.FireRate						=	0
ENT.LoopTimerTime1					=	0
ENT.LoopTimerTime2					=	0
ENT.Smoke							=	false
ENT.Bomber							=	false
ENT.RandomPos						= 	0
ENT.Pos								=	nil
ENT.GunRun							=	false
ENT.NextShell						=	0
ENT.tracer							=	0
ENT.WaitGuns						=	0
ENT.GunSnd							=	""
ENT.bomber							=	nil
ENT.GunCount						=	1
ENT.GunOffset						=	0
ENT.CustomAngle						=	50

local ShellSnd = {}
local RktSnd = {}
local BmbSnd = {}
local SmokeSounds = {}

for i = 1,4 do 
	SmokeSounds[i] =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_0"..i..".wav"
	BmbSnd[i] = "bomb/bomb_whistle_0"..i..".wav"
	RktSnd[i] = "artillery/flyby/rocket_artillery_strike_incoming_0"..i..".wav"
	ShellSnd[i] = "artillery/flyby/artillery_strike_incoming_0"..i..".wav"
end

sound.Add( {
	name = "apache_shoot",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 140,
	pitch = {100},
	sound = "artillery/flyby/apache_cannon.wav"
} )

if SERVER then
	function ENT:Initialize() 
		self.Entity:SetModel(self.Model)
		self.Entity:PhysicsInit(SOLID_NONE)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_NONE)
		if self.GunRun then 
			self.ShellCount = self.FireRate / (self.ShellCount + math.random(10,self.FireRate/150))
			self.OldShellCount = self.ShellCount
		end
		self.OldShellCount = self.ShellCount
		self:CreateArtillery()
	end
	function ENT:Think()
		local ct = CurTime()
		if self.ShouldCreateArti then
			if self.NextShell < ct then
				local curAng = self:GetAngles()
				if self.StrikeType then
					if self.StrikeType == "Apache" then
						self:Apache(ct,curAng)
					elseif self.StrikeType == "AC-130" then
						self:AC130(ct,curAng)
					end
				else
					if self.Bomber then
						bpos = self.Pos + self:GetForward()*600
						if !util.IsInWorld(bpos) then return end
						self.Bomb = ents.Create(self.ShellType)
						self.Bomb:SetPos(bpos)
						if self.StrikeString == "Stuka" then self.Bomb:SetAngles(Angle(90,0,0)) end
						self.Bomb.IsOnPlane = true
						self.Bomb:SetAngles(curAng)
						self.Bomb.Owner = self.Owner
						self.Bomb.GBOWNER = self.Owner
						self.Bomb:Spawn()
						self.Bomb:Activate()
						self.Bomb:EmitSound(table.Random(BmbSnd), 140, 100, 1)				
						self.Bomb:Arm()
						self:SetPos(bpos)
						self.Pos = bpos
						self.NextShell = ct + 0.25
					elseif self.GunRun and self.StrikeType != "Apache" then
						if self.ShellType == "wac_base_7mm" then
							num = 0.2
						elseif self.ShellType == "wac_base_12mm" then
							num = 10
						elseif self.ShellType == "wac_base_20mm" then
							num = 14
						elseif self.ShellType == "wac_base_30mm" then
							num = 18
						elseif self.ShellType == "wac_base_40mm" then
							num = 24
						else num = 0
						end
						num = num + (curAng.p*0.05)
						for i = 1,self.GunCount do
							local b = ents.Create("gred_base_bullet")
							ang = curAng + Angle(math.random(num,-num), math.random(num,-num), math.random(num,-num))
							
							if i == 1 then
								b:SetPos(self.Pos + self:GetRight()*self.GunOffset)
							else
								b:SetPos(self.Pos + self:GetRight()*-self.GunOffset)
							end
							b:SetAngles(ang)
							b.Damage=40
							b.Radius=70
							b.sequential=0
							b.gunRPM=self.FireRate
							b.Caliber=self.ShellType
							b:Spawn()
							b:Activate()
							constraint.NoCollide(b,self,0,0,true)
							b.Owner=self.Owner
							self.tracer = self.tracer + 1
							if self.tracer >= GetConVar("gred_sv_tracers"):GetInt() then
								b:SetSkin(1)
								b:SetModelScale(7)
								self.tracer = 0
							else 
								b.noTracer = true
							end
						end
						self.NextShell = ct + (60/self.FireRate)
						self:SetAngles(curAng - Angle((1/(self.OldShellCount/self.CustomAngle)),0,0))
					elseif self.RocketRun then
						for i = 1,2 do
							local b = ents.Create(self.ShellType)
							num = num + (curAng.p*0.05)
							if i == 1 then
								b:SetPos(self.Pos + self:GetRight()*300)
							else
								b:SetPos(self.Pos + self:GetRight()*-300)
							end
							b:SetAngles(curAng)
							b.GBOWNER=self.Owner
							b:Spawn()
							b:Activate()
							b:Launch()
						end
						self.ShellCount = self.ShellCount - 1
						self.NextShell = ct + (60/self.FireRate)
						self:SetAngles(curAng - Angle((2/((self.OldShellCount)/70)),0,0))
					else
						for _,ply in pairs (player.GetAll()) do
							if self.ShellType == "gb_shell_81mm" or self.ShellType == "gb_shell_81mmWP" then
								ply:GetViewEntity():EmitSound("artillery/far/distant_artillery_fire_0"..math.random(1,4)..".wav" )
							elseif self.ShellType == "gb_rocket_nebel" then
								ply:GetViewEntity():EmitSound("artillery/far/distant_rocket_artillery_fire_0"..math.random(1,4)..".wav")
							end
						end
						timer.Simple(math.random(self.LoopTimerTime1,self.LoopTimerTime2),function()
							if not IsValid(self) then return end
							local bpos = self.Pos + Vector(math.random(-self.RandomPos,self.RandomPos),math.random(-self.RandomPos,self.RandomPos),0)
							if !util.IsInWorld(bpos) then return end
							if self.ShellType == "gb_shell_81mm" or self.ShellType == "gb_rocket_81mmWP" then
								self:EmitSound(table.Random(ShellSnd),140,100,1)
							elseif self.ShellType == "gb_rocket_nebel" then
								self:EmitSound(table.Random(RktSnd),140,100,1)
							end
							self.Shell = ents.Create(self.ShellType)
							self.Shell:SetPos(bpos)
							self.Shell:SetAngles(Angle(90,0,0))
							self.Shell.Owner = self.Owner
							self.Shell.GBOWNER = self.Owner
							self.Shell.IsOnPlane = true
							self.Shell:Spawn()
							self.Shell:Activate()
							if self.Smoke then
								self.Shell.Effect = "doi_smoke_artillery"
								self.Shell.EffectAir = "doi_smoke_artillery"
								self.Shell.Smoke = true
								self.Shell.RSound = 1
								self.Shell.ExplosionSound = table.Random(SmokeSounds)
								self.Shell.WaterExplosionSound = table.Random(SmokeSounds)
							end
							self.Shell:Arm()
						end)
						self.NextShell = ct + self.FireRate
					end
					self.ShellCount = self.ShellCount - 1
				end
			end
		end
		if self.ShellCount <= 0 then self:Remove() end
		self:NextThink(ct)
		return true
	end

end


function ENT:AC130(ct,ang)
	
end
function ENT:Apache(ct,ang)
	if self.Shoot == nil then self.Shoot = 0 end
	if self.GunTime == nil then self.GunTime = true end
	if self.Wave == nil then self.Wave = 1 end
	if self.Wave == 1 then
		ang = Angle(90,ang.y,ang.r)
		if self.GunTime then
			self:StopSound("apache_shoot")
			self:EmitSound("apache_shoot")
			num = 14 + (ang.p*0.05)
			local b = ents.Create("gred_base_bullet")
			ang = ang + Angle(math.random(num,-num), math.random(num,-num), math.random(num,-num))
			b:SetPos(self.Pos)	
			b:SetAngles(ang)
			b.Damage=40
			b.Radius=70
			b.sequential=0
			b.gunRPM=self.FireRate
			b.Caliber=self.ShellType
			b:Spawn()
			b:Activate()
			constraint.NoCollide(b,self,0,0,true)
			b.Owner=self.Owner
			self.tracer = self.tracer + 1
			if self.tracer >= GetConVar("gred_sv_tracers"):GetInt() then
				b:SetSkin(1)
				b:SetModelScale(7)
				self.tracer = 0
			else 
				b.noTracer = true
			end
			self.NextShell = ct + (60/self.FireRate)
			self.Shoot = self.Shoot + 1
			if self.Shoot >= 14 then
				self.GunTime = false
				self.Shoot = 0
			end
		else
			if self.ang == nil then self.ang = ang end
			for i = 1,2 do
				local b = ents.Create("gb_rocket_hydra")
				num = num + (ang.p*0.05)
				if i == 1 then
					b:SetPos(self.Pos + self:GetRight()*100)
				else
					b:SetPos(self.Pos + self:GetRight()*-100)
				end
				b:SetAngles(self.ang)
				b.GBOWNER=self.Owner
				b:Spawn()
				b:Activate()
				b:Launch()
				self.Shoot = self.Shoot + 1
			end
			self.ang = (self.ang - Angle(10,0,0))
			if self.Shoot >= 8 then
				self.GunTime = true
				self.Shoot = 0
				self.ang = nil
				self.NextShell = ct + 0.67
				self.Wave = 2
			else
				self.NextShell = ct + 0.67
			end
		end
	elseif self.Wave > 1 then
		ang = Angle(90,ang.y,ang.r)
		if self.GunTime then
			self:StopSound("apache_shoot")
			self:EmitSound("apache_shoot")
			ang = ang - Angle(10,0,0)
			num = 40 + (ang.p*0.05)
			local b = ents.Create("gred_base_bullet")
			ang = ang + Angle(math.random(num,-num), math.random(num,-num), math.random(num,-num))
			b:SetPos(self.Pos)	
			b:SetAngles(ang)
			b.Damage=40
			b.Radius=70
			b.sequential=0
			b.gunRPM=self.FireRate
			b.Caliber=self.ShellType
			b:Spawn()
			b:Activate()
			constraint.NoCollide(b,self,0,0,true)
			b.Owner=self.Owner
			self.tracer = self.tracer + 1
			if self.tracer >= GetConVar("gred_sv_tracers"):GetInt() then
				b:SetSkin(1)
				b:SetModelScale(7)
				self.tracer = 0
			else 
				b.noTracer = true
			end
			self.Shoot = self.Shoot + 1
			if self.Shoot >= 14 then
				self.Shoot = 0
				self.Wave = self.Wave + 1
				if self.Wave >= 4 then
					self.GunTime = false 
					self.NextShell = ct + 3
					if self.Wave == 6 then self:Remove() end
				else
					self.NextShell = ct + 1.5
				end
			else
				self.NextShell = ct + (60/self.FireRate)
			end
		else
			if self.ang == nil then self.ang = ang + Angle(0,math.random(180,-180),0) end
			for i = 1,2 do
				local b = ents.Create("gb_rocket_hydra")
				num = num + (ang.p*0.05)
				if i == 1 then
					b:SetPos(self.Pos + self:GetRight()*100)
				else
					b:SetPos(self.Pos + self:GetRight()*-100)
				end
				b:SetAngles(self.ang)
				b.GBOWNER=self.Owner
				b:Spawn()
				b:Activate()
				b:Launch()
				self.Shoot = self.Shoot + 1
			end
			self.ang = (self.ang - Angle(10,0,0))
			if self.Shoot >= 8 then
				self.GunTime = true
				self.Shoot = 0
				self.ang = nil
				self.timer = 0.5
				self.NextShell = ct + (60/30)
				self.Wave = self.Wave + 1
			else
				self.NextShell = ct + (60/90)
			end
		end
	end
end

function ENT:CreateArtillery()
	timer.Simple(self.Delay,function()
		if not IsValid(self) then return end
		self.Pos = self:GetPos()
		
		if IsValid(self.Owner) then
			if CLIENT then
				self.Owner:ChatPrint("[GREDWITCH'S SWEPS]"..self.StrikeString.." strike is launched!")
			else
				self.Owner:ChatPrint("[GREDWITCH'S SWEPS]"..self.StrikeString.." strike is launched!")
			end
		end
		
		if SERVER and self.PreSound then
			for _,ply in pairs (player.GetAll()) do
				ply:GetViewEntity():EmitSound(self.PreSound)
			end
		elseif SERVER and self.PreSoundName then
			for _,ply in pairs (player.GetAll()) do
				ply:GetViewEntity():EmitSound(self.PreSoundName..math.random(1,self.PreSndPossibilities)..self.PreSndFormat)
			end
		end
		if self.GunRun or self.RocketRun or self.Bomber then
			timer.Simple(self.WaitGuns,function()
				if !IsValid(self) then return end
				self.ShouldCreateArti = true
				if SERVER and self.GunRun and self.ShellType == "wac_base_12mm" then
					for _,ply in pairs (player.GetAll()) do
						ply:GetViewEntity():EmitSound("artillery/flyby/p47d_guns.wav")
					end
				end
				--[[
				local bomber = ents.Create("prop_physics")
				bomber:SetModel("models/vehicles/plane_he88.mdl")
				bomber:SetPos(self.Pos+Vector(0,0,1000))
				bomber:SetAngles(self:GetAngles())
				bomber:SetMoveType(MOVETYPE_NOCLIP)
				bomber:Spawn()
				bomber:Activate()
				local ph = bomber:GetPhysicsObject()
				if IsValid(ph) then
					ph:EnableCollisions(false)
					ph:EnableGravity(false)
					ph:Wake()
					local f = self:GetForward()
					ph:AddVelocity(f*999999999999)
				end
				print(bomber:GetVelocity())
				bomber:SetModelScale(6)
				bomber:ResetSequence("action")]]
				if !self.Bomber then self:SetAngles(self:GetAngles()+Angle(80,0,0)) end
			end)
		else
			self.ShouldCreateArti = true
		end
	end)
end