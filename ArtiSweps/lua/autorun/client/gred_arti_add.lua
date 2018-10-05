AddCSLuaFile()

-- local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
-- local GRED_SVAR = { FCVAR_REPLICATED }
-- CreateConVar("gred_sv_easyuse"					,  "1"  , GRED_SVAR)
-- CreateClientConVar("gred_cl_sound_shake"		, "1" , true,false)

local function gredsettings(CPanel)
	CPanel:ClearControls()
	Created = true;
	
	-- CPanel:AddControl( "CheckBox", { Label = "Should there be sound shake?", Command = "gred_cl_sound_shake" } );
	
	CPanel:NumSlider( "Shell spawn altitude", "gred_sv_arti_spawnaltitude", 1, 1000, 0 );
end

hook.Add( "PopulateToolMenu", "gred_arti_menu", function()
	spawnmenu.AddToolMenuOption( "Options", "Gredwitch's Arti SWEPs", "GredwitchSWEPSettings", "Settings", "", "", gredsettings )
end );