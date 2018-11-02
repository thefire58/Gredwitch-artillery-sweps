AddCSLuaFile()

local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
CreateConVar("gred_sv_artisweps_aircrafts"				,  "1"  , GRED_SVAR)
CreateConVar("gred_sv_artisweps_skybox_mdls"			,  "0"  , GRED_SVAR)

local function gredsettings(CPanel)
	CPanel:ClearControls()
	Created = true;
	
	CPanel:AddControl( "CheckBox", { Label = "Should there be aircrafts flying over the target?", Command = "gred_sv_artisweps_aircrafts" } );
	
	CPanel:AddControl( "CheckBox", { Label = "Should the aircrafts be skybox-sized?", Command = "gred_sv_artisweps_skybox_mdls" } );
end

hook.Add( "PopulateToolMenu", "gred_arti_menu", function()
	spawnmenu.AddToolMenuOption( "Options", "Gredwitch's Arti SWEPs", "GredwitchSWEPSettings", "Settings", "", "", gredsettings )
end );

if SERVER then AddCSLuaFile() end

local HasBase = steamworks.ShouldMountAddon(1131455085) and steamworks.IsSubscribed(1131455085) 

timer.Simple(5,function()
	if !HasBase and not GredFrame then
		if CLIENT then
			GredFrame=vgui.Create('DFrame')
			GredFrame:SetTitle("Grediwtch's Base is not installed / enabled")
			GredFrame:SetSize(ScrW()*0.95, ScrH()*0.95)
			GredFrame:SetPos((ScrW() - GredFrame:GetWide()) / 2, (ScrH() - GredFrame:GetTall()) / 2)
			GredFrame:MakePopup()
			
			local h=vgui.Create('DHTML')
			h:SetParent(GredFrame)
			h:SetPos(GredFrame:GetWide()*0.005, GredFrame:GetTall()*0.03)
			local x,y = GredFrame:GetSize()
			h:SetSize(x*0.99,y*0.96)
			h:SetAllowLua(true)
			h:OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1131455085.html')
		end
		print("[GREDWITCH'S EMPLACEMENT PACK] Gredwitch's Base is not installed or not enabled!")
	end
end)
if !HasBase then return end