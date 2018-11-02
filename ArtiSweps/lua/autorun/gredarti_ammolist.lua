if SERVER then AddCSLuaFile() end
if CLIENT then
	language.Add("allied_radiobattery", "Allied radio battery")
	language.Add("axis_radiobattery", "Axis radio battery")
end

game.AddAmmoType( {
	name = "Axis radio battery",
	dmgtype = DMG_BULLET
} )
game.AddAmmoType( {
	name = "Allied radio battery",
	dmgtype = DMG_BULLET
} )

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
		print("[GREDWITCH'S ARTILLERY SWEPs] Gredwitch's Base is not installed or not enabled!")
	end
end)
if !HasBase then return end