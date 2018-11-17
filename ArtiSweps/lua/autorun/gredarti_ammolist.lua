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

-- Precache sounds
local totalsounds = 0
for k,v in pairs(file.Find('sound/american_01/suppressed/*.wav', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/american_01/unsuppressed/*.wav', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/british/suppressed/*.wav', "GAME")) do
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/british/unsuppressed/*.wav', "GAME")) do
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/german_01/suppressed/*.wav', "GAME")) do 
	util.PrecacheSound(v)
	totalsounds = totalsounds + 1
end
for k,v in pairs(file.Find('sound/german_01/unsuppressed/*.wav', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1
end

for k,v in pairs(file.Find('sound/radio/axis/*.ogg', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/radio/allied/british/*.ogg', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/radio/allied/american/*.ogg', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/artillery/far/*.wav', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/artillery/flyby/*.wav', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/artillery/flyby/*.ogg', "GAME")) do 
	util.PrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

print("[GREDWITCH'S ARTILLERY SWEPs] Precached "..totalsounds.." sounds.")


timer.Simple(5,function()
	if CLIENT then
		local HasBase = steamworks.ShouldMountAddon(1131455085) and steamworks.IsSubscribed(1131455085) 
		if !HasBase and !GredFrame then
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
			print("[GREDWITCH'S ARTILLERY SWEPs] Gredwitch's Base is not installed or not enabled!")
		end
	end
end)