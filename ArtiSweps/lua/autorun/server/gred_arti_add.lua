AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_artisweps_spawnaltitude"			, "1000", GRED_SVAR)
CreateConVar("gred_sv_artisweps_mortarspawnaltitude"	, "700", GRED_SVAR)
CreateConVar("gred_sv_artisweps_aircrafts"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_skybox_mdls"			,  "0"  , GRED_SVAR)

resource.AddWorkshop(1131455085) -- Base addon
resource.AddWorkshop(1529340885) -- SWEPs