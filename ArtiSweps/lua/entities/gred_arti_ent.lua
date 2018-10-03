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
ENT.bomber = nil

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
		if self.ShouldCreateArti and self.ShellCount >= 1 then
			if self.NextShell < ct then
				local curAng = self:GetAngles()
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
				elseif self.GunRun then
					local b = ents.Create("gred_base_bullet")
					if self.ShellType == "wac_base_7mm" then
						num = 5
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
					ang = curAng + Angle(math.random(num,-num), math.random(num,-num), math.random(num,-num))
					b:SetPos(self.Pos)
					b:SetAngles(ang)
					b.Speed=1000
					b.Size=0
					b.Width=0
					b.Damage=20
					b.Radius=70
					b.sequential=1
					b.gunRPM=self.FireRate/60
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
					self:SetAngles(curAng - Angle((1/(self.OldShellCount/50)),0,0))
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
						if self.ShellType == "gb_rocket_81mm" or self.ShellType == "gb_shell_81mmWP" then
							ply:GetViewEntity():EmitSound("artillery/far/distant_artillery_fire_0"..math.random(1,4)..".wav" )
						elseif self.ShellType == "gb_rocket_nebel" then
							ply:GetViewEntity():EmitSound("artillery/far/distant_rocket_artillery_fire_0"..math.random(1,4)..".wav")
						end
					end
					timer.Simple(math.random(self.LoopTimerTime1,self.LoopTimerTime2),function()
						if not IsValid(self) then return end
						local bpos = self.Pos + Vector(math.random(-self.RandomPos,self.RandomPos),math.random(-self.RandomPos,self.RandomPos),0)
						if !util.IsInWorld(bpos) then return end
						if self.ShellType == "gb_rocket_81mm" or self.ShellType == "gb_rocket_81mmWP" then
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
		if self.ShellCount <= 0 then self:Remove() end
		self:NextThink(ct)
		return true
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
		if self.Bomber then
		
			-- if self.Bomber or self.GunRun or self.RocketRun then
				-- local bomber = ents.Create("prop_physics")
				-- bomber:SetModel("models/vehicles/plane_he88.mdl")
				-- bomber:SetPos(self.Pos+Vector(0,0,1000))
				-- bomber:SetAngles(self:GetAngles())
				-- bomber:SetMoveType(MOVETYPE_NOCLIP)
				-- bomber:Spawn()
				-- bomber:Activate()
				-- local ph = bomber:GetPhysicsObject()
				-- if IsValid(ph) then
					-- ph:EnableCollisions(false)
					-- ph:EnableGravity(false)
					-- ph:Wake()
					-- local f = self:GetForward()
					-- ph:AddVelocity(f*999999999999)
				-- end
				-- print(bomber:GetVelocity())
				-- bomber:SetModelScale(6)
				-- bomber:ResetSequence("action")
			-- end
			timer.Simple(self.WaitGuns,function() self.ShouldCreateArti = true end)
		elseif self.GunRun or self.RocketRun then
			timer.Simple(self.WaitGuns,function() 
				self.ShouldCreateArti = true
				if SERVER and self.GunRun and self.ShellType == "wac_base_12mm" then
					for _,ply in pairs (player.GetAll()) do
						ply:GetViewEntity():EmitSound("artillery/flyby/p47d_guns.wav")
					end
				end
				self:SetAngles(self:GetAngles()+Angle(80,0,0))
			end)
		else
			self.ShouldCreateArti = true
		end
	end)
end