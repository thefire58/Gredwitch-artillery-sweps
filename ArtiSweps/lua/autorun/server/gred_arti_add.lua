AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_artisweps_aircrafts"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_skybox_mdls"			,  "0"  , GRED_SVAR)
CreateConVar("gred_sv_spam"								,  "0"  , GRED_SVAR)

resource.AddWorkshop(1131455085) -- Base addon
resource.AddWorkshop(1529340885) -- SWEPs

util.AddNetworkString("gred_net_set_entity_var")

hook.Add("EntityTakeDamage","gred_getlastdmg",function(target,dmg)
	target.LastHit = CurTime()
end)

hook.Add("PlayerDeath","gred_death_nonsilent",function(ply,inflictor,attacker)
	ply:StopSound("CallSnd")
end)
hook.Add("PlayerDeath","gred_death_nonsilent",function(ply)
	ply:StopSound("CallSnd")
end)