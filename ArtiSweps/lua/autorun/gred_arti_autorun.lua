
AddCSLuaFile()

if SERVER then
	util.AddNetworkString("gred_net_subtitles")
	resource.AddWorkshop(1529340885) -- SWEPs
end

hook.Add("EntityTakeDamage","gred_getlastdmg",function(target,dmg)
	target.LastHit = CurTime()
end)

hook.Add("PlayerDeath","gred_death_nonsilent",function(ply,inflictor,attacker)
	ply:StopSound("CallSnd")
end)
hook.Add("PlayerDeath","gred_death_nonsilent",function(ply)
	ply:StopSound("CallSnd")
end)

local CreateConVar = CreateConVar
local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_artisweps_aircrafts"						,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_skybox_mdls"					,  "0"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_spam"							,  "0"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_helisupport_shootateveryone"	,  "1"  , GRED_SVAR)
if CLIENT then
	CreateConVar("gred_cl_artisweps_enable_subtitles"	,  "1"  , { FCVAR_USERINFO, FCVAR_ARCHIVE }) -- Not using CreateClientConvar because I'm gonna use player:GetInfo() with it
end

gred = gred or {}
gred.AddonList = gred.AddonList or {}
table.insert(gred.AddonList,1131455085) -- Base
	
if CLIENT then
	language.Add("allied_radiobattery", "Allied radio battery")
	language.Add("axis_radiobattery", "Axis radio battery")
	
	net.Receive("gred_net_subtitles",function()
		LocalPlayer():PrintMessage(HUD_PRINTCENTER,net.ReadString())
	end)
	
	local function gred_settings_artisweps(CPanel)
		CPanel:ClearControls()
		Created = true;
		if game.IsDedicated() then
			CPanel:AddControl( "CheckBox", { Label = "Should there be aircrafts flying over the target?", Command = "gred_sv_artisweps_aircrafts" } );
			
			CPanel:AddControl( "CheckBox", { Label = "Should the aircrafts be skybox-sized?", Command = "gred_sv_artisweps_skybox_mdls" } );
			
			CPanel:AddControl( "CheckBox", { Label = "Enable the old spam mode?", Command = "gred_sv_artisweps_spam" } );
			
			CPanel:AddControl( "CheckBox", { Label = "Should the support aircrafts shoot at players in the same team than the caller?", Command = "gred_sv_artisweps_helisupport_shootateveryone" } );
		end
		
		CPanel:AddControl( "CheckBox", { Label = "Enable subtitles?", Command = "gred_cl_artisweps_enable_subtitles" } );
	end

	hook.Add( "PopulateToolMenu", "gred_menu_arti", function()
		spawnmenu.AddToolMenuOption("Options",					-- Tab
									"Gredwitch's Stuff",		-- Sub-tab
									"gred_settings_artisweps",	-- Identifier
									"Artillery SWEPs",			-- Name of the sub-sub-tab
									"",							-- Command
									"",							-- Config (deprecated)
									gred_settings_artisweps		-- Function
		)
	end)
end

game.AddAmmoType( {
	name = "Axis radio battery",
	dmgtype = DMG_BULLET
} )
game.AddAmmoType( {
	name = "Allied radio battery",
	dmgtype = DMG_BULLET
} )

-- Precache sounds

local utilPrecacheSound = util.PrecacheSound
local totalsounds = 0

for k,v in pairs(file.Find('sound/american_01/suppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/american_01/unsuppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/british/suppressed/*.wav', "GAME")) do
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/british/unsuppressed/*.wav', "GAME")) do
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/german_01/suppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v)
	totalsounds = totalsounds + 1
end
for k,v in pairs(file.Find('sound/german_01/unsuppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1
end

for k,v in pairs(file.Find('sound/radio/axis/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/radio/allied/british/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/radio/allied/american/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/artillery/far/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/artillery/flyby/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/artillery/flyby/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

print("[GREDWITCH'S ARTILLERY SWEPs] Precached "..totalsounds.." sounds.")