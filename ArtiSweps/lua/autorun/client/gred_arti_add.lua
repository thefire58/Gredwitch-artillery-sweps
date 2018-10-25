AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_artisweps_spawnaltitude"			, "1000", GRED_SVAR)
CreateConVar("gred_sv_artisweps_mortarspawnaltitude"	, "700", GRED_SVAR)
CreateConVar("gred_sv_artisweps_aircrafts"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_skybox_mdls"			,  "0"  , GRED_SVAR)
-- CreateClientConVar("gred_sv_artisweps_spawnaltitude"		, "1000" , true,false)

local function gredsettings(CPanel)
	CPanel:ClearControls()
	Created = true;
	
	CPanel:AddControl( "CheckBox", { Label = "Should there be aircrafts flying over the target?", Command = "gred_sv_artisweps_aircrafts" } );
	
	CPanel:AddControl( "CheckBox", { Label = "Should the aircrafts be skybox-sized?", Command = "gred_sv_artisweps_skybox_mdls" } );
	
	CPanel:NumSlider( "Shell spawn altitude", "gred_sv_artisweps_spawnaltitude", 1, 1000, 0 );
	
	CPanel:NumSlider( "Additional mortar shell spawn altitude", "gred_sv_artisweps_mortarspawnaltitude", 1, 700, 0 );
end

hook.Add( "PopulateToolMenu", "gred_arti_menu", function()
	spawnmenu.AddToolMenuOption( "Options", "Gredwitch's Arti SWEPs", "GredwitchSWEPSettings", "Settings", "", "", gredsettings )
end );