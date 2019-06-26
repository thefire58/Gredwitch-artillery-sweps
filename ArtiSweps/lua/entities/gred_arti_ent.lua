AddCSLuaFile()

ENT.Type 							=	"anim"
ENT.Base 							=	"base_anim"

ENT.Spawnable		            	=	false
ENT.AdminSpawnable		            =	false

ENT.PrintName		                =	"[OTHERS]Artillery strike entity"
ENT.Author			                =	"Gredwitch"
ENT.Contact			                =	"qhamitouche@gmail.com"
ENT.Category                        =	"Gredwitch's Stuff"

ENT.Model                         	=	"models/mm1/box.mdl"
ENT.AircraftModel                  	=	"models/mm1/box.mdl"
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
ENT.AutomaticFrameAdvance 			=	true

local ShellSnd = {}
local RktSnd = {}
local BmbSnd = {}
local SmokeSounds = {}
local MortarShellSnd = {}

for i = 1,4 do 
	SmokeSounds[i] =  "gred_emp/nebelwerfer/artillery_strike_smoke_close_0"..i..".wav"
	BmbSnd[i] = "bomb/bomb_whistle_0"..i..".wav"
	RktSnd[i] = "artillery/flyby/rocket_artillery_strike_incoming_0"..i..".wav"
	MortarShellSnd[i] =  "artillery/flyby/mortar_strike_incoming_0"..i..".wav"
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

sound.Add( {
	name = "apache_missile",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 140,
	pitch = {100},
	sound = "gunsounds/fh2_rocket_3p.wav"
} )

if SERVER then
	local num,ang,pos
	local tracer = 0
	local Tracer = false
	function ENT:UpdateTracers()
		tracer = tracer + 1
		if tracer >= self.TracerConvar:GetInt() then
			tracer = 0
			return "red"
		else
			return false
		end
	end

	local reachSky = Vector(0,0,9999999999)
	function ENT:Initialize()
		self.TracerConvar = GetConVar("gred_sv_tracers")
		self.Entity:SetModel(self.Model)
		self.Entity:PhysicsInit(SOLID_NONE)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_NONE)
		self.OldShellCount = self.ShellCount
		if self.GunRun and self.RandomBullets then 
			self.ShellCount = self.FireRate / (self.ShellCount + math.random(10,self.FireRate/150))
		end
		self.OldShellCount = self.ShellCount
		self.IsMortar = table.HasValue(string.Explode(" ",self.StrikeString:lower(),true),"mortar")
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
					
						if !IsValid(self) then return end
						local bpos = self.Pos + self:GetForward()*600
						if !util.IsInWorld(bpos) then return end
						local HitBPos = Vector(0,0,
						util.QuickTrace(bpos,bpos - reachSky,{self} ).HitPos.z)
						local zpos = Vector(0,0,bpos.z)
						local dist = HitBPos:Distance(zpos)
						
						------------------
						
						local snd = table.Random(BmbSnd)
						local sndDuration = SoundDuration(snd)
						
						local time = (dist/-1000)+(sndDuration-0.2) -- Calculates when to play the whistle sound
						local b = ents.Create(self.ShellType)
						if time < 0 then
							b:SetPos(bpos)
							if self.StrikeString == "Stuka" then b:SetAngles(Angle(90,0,0)) end
							b.IsOnPlane = true
							b.Owner = self.Owner
							b.GBOWNER = self.Owner
							b:Spawn()
							b:Activate()
							b.PhysicsUpdate = function(data,phys)
								phys:SetVelocityInstantaneous(Vector(0,0,-1000))
							end
							b:Arm()
							timer.Simple(-time,function()
								if !IsValid(b) then return end
								b:EmitSound(snd, 140, 100, 1)
							end)
						else
							self:EmitSound(snd,140,100,1)
							timer.Simple(time,function()
								if !IsValid(b) then return end
								b:SetPos(bpos)
								if self.StrikeString == "Stuka" then b:SetAngles(Angle(90,0,0)) end
								b.IsOnPlane = true
								b:SetAngles(curAng)
								if IsValid(self) then
									b.Owner = self.Owner
									b.GBOWNER = self.Owner
								end
								b:Spawn()
								b:Activate()
								b.PhysicsUpdate = function(data,phys)
									phys:SetVelocityInstantaneous(Vector(0,0,-1000))
								end
								b:Arm()
							end)
						end
						
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
							local ang = curAng + Angle(math.random(num,-num), math.random(num,-num), math.random(num,-num))
							local pos = i == 1 and self.Pos + self:GetRight()*self.GunOffset or self.Pos + self:GetRight()*-self.GunOffset
							gred.CreateBullet(self.Owner,pos,ang,self.ShellType,nil,nil,false,self:UpdateTracers())
						end
						self.NextShell = ct + (60/self.FireRate)
						self:SetAngles(curAng - Angle((1/(self.OldShellCount/self.CustomAngle)),0,0))
					elseif self.RocketRun then
						for i = 1,2 do
							local b = ents.Create(self.ShellType)
							if not num then num = 0 end
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
							if self.FireSND then
								ply:GetViewEntity():EmitSound(table.Random(self.FireSND))
							else
								if self.IsMortar then
									ply:GetViewEntity():EmitSound("artillery/far/mortar_fire"..math.random(1,11)..".wav" )
								else
									if string.StartWith(self.ShellType, "gb_shell_") then
										ply:GetViewEntity():EmitSound("artillery/far/distant_artillery_fire_0"..math.random(1,4)..".wav" )
									elseif self.ShellType == "gb_rocket_nebel" then
										ply:GetViewEntity():EmitSound("artillery/far/distant_rocket_artillery_fire_0"..math.random(1,4)..".wav")
									end
								end
							end
						end
						timer.Simple(math.random(self.LoopTimerTime1,self.LoopTimerTime2),function()
							if not IsValid(self) then return end
							-- 1.9s = 1000u
							-------------------
							
							local BPos = self.Pos + 
							Vector(math.random(-self.RandomPos,self.RandomPos),
							math.random(-self.RandomPos,self.RandomPos),-1) -- Creates our spawn position
							while !util.IsInWorld(BPos) do
								BPos = self.Pos + 
								Vector(math.random(-self.RandomPos,self.RandomPos),
								math.random(-self.RandomPos,self.RandomPos),-1) -- re-ceates our spawn position
							end
							local HitBPos = Vector(0,0,
							util.QuickTrace(BPos,BPos - reachSky,{self} ).HitPos.z) -- Defines the ground's pos
							local zpos = Vector(0,0,BPos.z) -- The exact spawn altitude
							local dist = HitBPos:Distance(zpos) -- Calculates the distance between our spawn altitude and the ground
							
							----------------------
							
							local snd
							if self.IncomingSnd then
								snd = table.Random(self.IncomingSnd)
							else
								if self.IsMortar then
									snd = table.Random(MortarShellSnd)
								else
									if string.StartWith(self.ShellType, "gb_shell_") then
										snd = table.Random(ShellSnd)
									elseif self.ShellType == "gb_rocket_nebel" then
										snd = table.Random(RktSnd)
									end
								end
							end
							local sndDuration = SoundDuration(snd)
							
							if self.Smoke and self.ShellType == "gb_rocket_nebel" then
								b=ents.Create("gb_shell_88mm")
							else
								b=ents.Create(self.ShellType)
							end
							local time = (dist/-1000)+(sndDuration-0.2) -- Calculates when to play the whistle sound
							if time < 0 then
								b:SetPos(BPos)
								b:SetAngles(Angle(90,0,0))
								b:SetOwner(self.Shooter)
								b.IsOnPlane = true
								b.Smoke = self.Smoke
								b.GBOWNER=ply
								b.Owner=ply
								b:Spawn()
								b:Activate()
								b:Arm()
								b.PhysicsUpdate = function(data,phys)
									phys:SetVelocityInstantaneous(Vector(0,0,-1000))
								end
								timer.Simple(-time,function()
									if !IsValid(b) then return end
									b:EmitSound(snd, 140, 100, 1)
								end)
							else
								self:EmitSound(snd,140,100,1)
								timer.Simple(time,function()
									if !IsValid(self) then return end
									if !IsValid(b) then return end
									b:SetPos(BPos)
									b:SetAngles(Angle(90,0,0))
									b:SetOwner(self.Shooter)
									b.IsOnPlane = true
									b.Smoke = self.Smoke
									b.GBOWNER=ply
									b:Spawn()
									b:Activate()
									b:Arm()
									b.PhysicsUpdate = function(data,phys)
										phys:SetVelocityInstantaneous(Vector(0,0,-1000))
									end
									b.Owner=ply
								end)
							end
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
	-- Setting up variables
	
	if not self.ShotCount then 
		self.ShotCount = 0
		self.OldPos = self.Pos
		self.Pos = self.Pos - Vector(0,0,1000)
		self.FireRockets = true
		self.Targets = {}
		self.OldTargets = {}
		self.StopTime = ct + 24
	end
	
	if not ang then ang = Angle(90,ang.y,ang.r) end
	if self.ang == nil then self.ang = ang end
	
	-- Coming in, fire rockets
	if self.FireRockets == true then
		for i = 1,2 do
			local mis = ents.Create("gb_rocket_hydra")
			if i == 1 then
				mis:SetPos(self.OldPos + self:GetRight()*100)
			else
				mis:SetPos(self.OldPos + self:GetRight()*-100)
			end
			mis:SetAngles(self.ang)
			mis.GBOWNER=self.Owner
			mis:Spawn()
			mis:Activate()
			mis:Launch()
		end
		
		self.ShotCount = self.ShotCount + 1
		if self.ShotCount > 4 then
			self.FireRockets = false
			self.LookUpTargets = true
			self.NextShell = ct + 2
			self.ang = ang
		else
			self.ang = (self.ang - Angle(10))
			self.NextShell = ct + 0.5
		end
	end
	
	-- AI mode
	
	if self.LookUpTargets == true then
		-- Looking for targets
		local DontShootAtTeam = GetConVar("gred_sv_artisweps_helisupport_shootateveryone"):GetInt() == 0
		
		local IsPlayer = IsPlayer
		for k,v in pairs (ents.FindInSphere(self.Pos,3000)) do
			if (v:IsPlayer() && (DontShootAtTeam and (v:Team() != self.Owner:Team())) or v:IsNPC() and not table.HasValue(self.Targets,v) )
			and not table.HasValue(self.OldTargets,v) then
				table.insert(self.Targets,v)
			end
		end
		-- Check if the target is a player or a vehicle.
		-- Priority order : Player in vehicle > Player > NPC
		if self.CurTarget == nil or not self.CurTarget then
			for k,v in pairs(self.Targets) do
				if v:IsPlayer() and not table.HasValue(self.OldTargets,v) then
					if v:InVehicle() then
						self.CurTarget = v
						break
					end
				end
			end
			if not IsValid(self.CurTarget) then
				for k,v in pairs(self.Targets) do
					if v:IsPlayer() and not table.HasValue(self.OldTargets,v) then
						self.CurTarget = v
						break
					end
				end
			end
			if not IsValid(self.CurTarget) then
				local t = table.Random(self.Targets)
				while table.HasValue(self.OldTargets,t) do t = table.Random(self.Targets) end
				self.CurTarget = t
			end
			table.RemoveByValue(self.Targets,self.CurTarget)
			table.insert(self.OldTargets,self.CurTarget)
			self.ShotCount = 0
		end
		
		if self.CurTarget && self.CurTarget:IsPlayer() then
			if !self.CurTarget:Alive() then self.CurTarget = nil end
		end
		
		-- Firing
		if self:TargetStillValid(self.CurTarget) then
			-- If the player is in a vehicle, fire a Hellfire
			if self.CurTarget:IsPlayer() && self.CurTarget:InVehicle() then
				local veh = self.CurTarget:GetVehicle()
				if not veh.ApacheLocked then
					local rocket = ents.Create("wac_base_grocket")
					rocket:SetModel ( "models/doi/ty_missile.mdl" )
					local pos = self:GetPos()
					rocket:SetPos(pos)
					rocket:SetAngles(ang)
					rocket.Owner = self.Owner
					rocket.Damage = 1500
					rocket.Radius = 400
					rocket.Speed = 70
					rocket.Drag = Vector(0,1,1)
					rocket.TrailLength = 200
					rocket.Scale = 15
					rocket.SmokeDens = 1
					rocket.Launcher = self
					rocket.target = self.CurTarget
					rocket.targetOffset = self.CurTarget:WorldToLocal(self.CurTarget:GetPos())
					rocket.calcTarget = function(r)
						r.hellfire = true
						return r.target:LocalToWorld(r.targetOffset)
					end
					rocket:Spawn()
					rocket:Activate()
					rocket:StartRocket()
					local ph = rocket:GetPhysicsObject()
					if ph:IsValid() then
						ph:AddAngleVelocity(Vector(30,0,0))
					end
					
					self:EmitSound("apache_missile")
					self.NextShell = ct + 1
					veh.ApacheLocked = true
				end
			else
				local targetpos = self.CurTarget:GetPos()
				if !util.IsInWorld(targetpos) then self.CurTarget = nil return end
				local ang = (targetpos-self:GetPos()):Angle()
				
				self:StopSound("apache_shoot")
				self:EmitSound("apache_shoot")
				num = 3 + (ang.p*0.05)
				ang = ang + Angle(math.random(num,-num), math.random(num,-num), math.random(num,-num))
				gred.CreateBullet(self.Owner,self:GetPos(),ang,self.ShellType,nil,nil,false,self:UpdateTracers())
				
				self.ShotCount = self.ShotCount + 1
				if self.ShotCount >= 20 then
					self.ShotCount = 0
					self.NextShell = ct + 1
				else
					self.NextShell = ct + (60/self.FireRate)
				end
			end
		else
			self.CurTarget = nil
			self.ShotCount = 0
			self.NextShell = ct + 0.2
		end
		
	end
	if self.StopTime < ct then self:Remove() end
end

function ENT:TargetStillValid(t)
	local valid = t && IsValid(t)
	if valid then
		if t:IsNPC() then
			valid = valid and t:GetNPCState() != 7
		elseif t:IsPlayer() then
			valid = valid and t:Alive()
		end
	end
	return valid
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
			if GetConVar("gred_sv_artisweps_aircrafts"):GetInt() == 1 then
						if self.Bomber then
							if self.ShellType == "gb_bomb_sc250" then 
								self.ModelTimer = self.ModelTimer * 0.7
							else
								self.ModelTimer = self.ModelTimer * 0.8
							end
						end
				timer.Simple(self.ModelTimer,function()
					if IsValid(self) then
						local bomber = ents.Create("prop_dynamic")
						bomber:SetModel(self.AircraftModel)
						if self.Bomber and self.ShellType != "gb_bomb_sc250" and self.ShellType != "gb_bomb_mk77" and !self.GunRun and !self.RocketRun then
							bomber:SetPos(Vector(self.Pos.x,self.Pos.y,util.QuickTrace(self.Pos,self.Pos + Vector(0,0,20000)).HitPos.z))
						else
							bomber:SetPos(self.Pos)
						end
						bomber.AutomaticFrameAdvance = true
						bomber:SetAngles(self:GetAngles())
						bomber:SetMoveType(MOVETYPE_NOCLIP)
						bomber:Spawn()
						bomber:Activate()
						bomber:SetSkin(math.random(0,bomber:SkinCount()))
						if GetConVar("gred_sv_artisweps_skybox_mdls"):GetInt() == 1 then
							bomber:SetModelScale(0.16)
						end
						local ph = bomber:GetPhysicsObject()
						if IsValid(ph) then
							ph:EnableCollisions(false)
						end
						bomber:ResetSequence("action")
						if self.Bomber then
							if self.ShellType == "gb_bomb_sc250" then 
								bomber:SetPlaybackRate(0.7)
							else
								bomber:SetPlaybackRate(0.8)
							end
						end
						if self.AnimPlaybackRate then bomber:SetPlaybackRate(self.AnimPlaybackRate) else self.AnimPlaybackRate = 0 end
						self.bomber = bomber
						local time = bomber:SequenceDuration()*(2*self.AnimPlaybackRate+1) + self.ModelTimer
						timer.Simple(time,function()
							if IsValid(bomber) then 
								bomber:Remove() 
							end
						end)
					end
				end)
			end
			timer.Simple(self.WaitGuns,function()
				if !IsValid(self) then return end
				self.ShouldCreateArti = true
				if SERVER and self.GunRun and self.ShellType == "wac_base_12mm" then
					for _,ply in pairs (player.GetAll()) do
						ply:GetViewEntity():EmitSound("artillery/flyby/p47d_guns.wav")
					end
				end
				if !self.Bomber then self:SetAngles(self:GetAngles()+Angle(80,0,0)) end
			end)
		else
			self.ShouldCreateArti = true
		end
	end)
end