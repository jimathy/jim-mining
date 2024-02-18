local Props, Targets, Peds, Blip, soundId = {}, {}, {}, {}, GetSoundId()

--Hide the mineshaft doors
if Locations["Mines"]["MineShaft"].Enable then
	CreateModelHide(vec3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)
end
function removeJob()
	for k in pairs(Targets) do removeZoneTarget(k) end
	for _, v in pairs(Peds) do DeletePed(v) end
	for i = 1, #Props do DeleteObject(Props[i]) end
	for i = 1, #Blip do RemoveBlip(Blip[i]) end
end

local propTable = {
	{ full = "cs_x_rubweec", empty = "prop_rock_5_a" },
}
if Config.General.K4MB1Prop then
	propTable = {
		{ full = "cs_x_rubweec", empty = "prop_rock_5_a" },
		{ full = "k4mb1_crystalblue", empty = "k4mb1_crystalempty" },
		{ full = "k4mb1_crystalgreen", empty = "k4mb1_crystalempty" },
		{ full = "k4mb1_crystalred", empty = "k4mb1_crystalempty" },
		{ full = "k4mb1_bauxiteore2", empty = "k4mb1_emptyore2" },
		{ full = "k4mb1_coal2", },
		{ full = "k4mb1_copperore2", empty = "k4mb1_emptyore2" },
		{ full = "k4mb1_ironore2", empty = "k4mb1_emptyore2" },
		{ full = "k4mb1_goldore2", empty = "k4mb1_emptyore2" },
		{ full = "k4mb1_leadore2", empty = "k4mb1_emptyore2" },
		{ full = "k4mb1_tinore2", empty = "k4mb1_emptyore2" },
		{ full = "k4mb1_diamond", },
	}
end

function makeJob()
	removeJob()
	--Ore Spawning
	for mine in pairs(Locations["Mines"]) do
		local loc = Locations["Mines"][mine]
		if loc.Enable then
			--[[Blips]]--
			if loc.Blip.Enable then Blip[#Blip+1] = makeBlip(loc["Blip"]) end
			--[[Ores]]--
			if loc["OrePositions"] then
				for i = 1, #loc["OrePositions"] do local name = "Ore".."_"..mine.."_"..i
					local coords = loc["OrePositions"][i]
					local prop = nil
					local rot = nil
					local propPick = nil
					local setReward = nil
					if Config.General.AltMining then
						local totalWeight = 0
						local weightedTable = {}
						local chosenProp = nil
						for _, item in ipairs(Config.setMiningTable) do
							if item.rarity == "common" then item.weight = 5
							elseif item.rarity == "rare" then item.weight = 3
							elseif item.rarity == "ultra_rare" then item.weight = 1 end
							totalWeight = totalWeight + (item.weight or 1)
							table.insert(weightedTable, {name = item.name, rarity = item.rarity, weight = totalWeight, prop = item.prop })
						end
						local randomValue = math.random(1, totalWeight)
						for _, item in ipairs(weightedTable) do
							if randomValue <= item.weight then
								setReward = item.name
								chosenProp = item.prop
								break
							end
						end
						if Config.General.K4MB1Prop then
							for i = 1, #propTable do
								if propTable[i].full == chosenProp then
									propPick = propTable[i]
									break
								end
							end
						else
							propPick = propTable[math.random(1,#propTable)]
						end
					else
						propPick = propTable[math.random(1,#propTable)]
					end

					Props[#Props+1] = makeProp({coords = vec4(coords.x, coords.y, coords.z + (not Config.General.K4MB1Prop and 1.10 or 0.8), coords.a), prop = propPick.full}, 1, false)
					prop = Props[#Props]
					rot = GetEntityRotation(prop)
					rot = vec3(rot.x - math.random(60,100), rot.y, rot.z)
					SetEntityRotation(prop, rot.x, rot.y, rot.z, 0, 0)
					-- Empty Version
					local emptyProp = nil
					if propPick.empty then
						Props[#Props+1] = makeProp({coords = vec4(coords.x, coords.y, coords.z + (not Config.General.K4MB1Prop and 1.1 or 0.8), coords.a), prop = propPick.empty}, 1, false)
						emptyProp = Props[#Props]
						SetEntityRotation(emptyProp, rot.x, rot.y, rot.z, 0, 0)
					end
					Targets[name] =
						createCircleTarget({name, vec3(coords.x, coords.y, coords.z), 1.2, { name=name, debugPoly=Config.System.Debug, useZ=true, }, }, {
							{ 	action = function()
									TriggerEvent("jim-mining:MineOre:Pick", { stone = prop, name = name, coords = coords, rot = rot, emptyProp = emptyProp, setReward = setReward })
									print(rot)
								end,
								icon = "fas fa-hammer", item = "pickaxe", label = Loc[Config.Lan].info["mine_ore"].." ("..Items["pickaxe"].label..")", job = loc.Job, },
							{ 	action = function()
									TriggerEvent("jim-mining:MineOre:Drill", { stone = prop, name = name, coords = coords, rot = rot, emptyProp = emptyProp, setReward = setReward })
								end,
								icon = "fas fa-screwdriver", item = "miningdrill", label = Loc[Config.Lan].info["mine_ore"].." ("..Items["miningdrill"].label..")", job = loc.Job, },
							{ 	action = function()
									TriggerEvent("jim-mining:MineOre:Laser", { stone = prop, name = name, coords = coords, rot = rot, emptyProp = emptyProp, setReward = setReward })
								end,
								icon = "fas fa-screwdriver-wrench", item = "mininglaser", label = Loc[Config.Lan].info["mine_ore"].." ("..Items["mininglaser"].label..")", job = loc.Job, },
						}, 1.7)
				end
			end
		--[[LIGHTS]]--
			if loc["Lights"] then
				if loc["Lights"].Enable then
					for i = 1, #loc["Lights"].positions do
						Props[#Props+1] = makeProp({coords = loc["Lights"].positions[i], prop = loc["Lights"].prop}, 1, false)
					end
				end
			end
		--[[Stores]]--
			if loc["Store"] then
				for i = 1, #loc["Store"] do
				local name = GetCurrentResourceName()..":Store:"..mine..":"..i
					Peds[#Peds+1] = makePed(loc["Store"][i].model, loc["Store"][i].coords, 1, 1, loc["Store"][i].scenario)
					Targets[name] =
						createCircleTarget({name, loc["Store"][i].coords.xyz, 1.0, { name=name, debugPoly=Config.System.Debug, useZ=true, }, }, {
							{ 	action = function()
									openShop({ items = Config.Items, shop = "miningShop", coords = loc["Store"][i].coords })
								end,
								icon = "fas fa-store", label = Loc[Config.Lan].info["browse_store"], job = loc.Job,
							},
							((mine == "K4MB1Shaft" and Config.General.K4MB1Cart) and
							{	action = function()
									mineCartMenu(true)
								end,
								icon = "fas fa-wheelchair", label = "Minecart", job = loc.Job,
							} or nil
						),
						}, 2.0)
				end
			end
		--[[Smelting]]--
			if loc["Smelting"] then
				for i = 1, #loc["Smelting"] do
					local name = GetCurrentResourceName()..":Smelting:"..mine..":"..i
					if loc["Smelting"][i].blipEnable then Blip[#Blip+1] = makeBlip(loc["Smelting"][i]) end
					Targets[name] =
						createCircleTarget({name, loc["Smelting"][i].coords.xyz, 3.0, { name=name, debugPoly=Config.System.Debug, useZ=true, }, }, {
							{ 	action = function()
									craftingMenu({ craftable = Crafting.SmeltMenu }) end,
								icon = "fas fa-fire-burner", label = Loc[Config.Lan].info["use_smelter"], job = loc.Job,
							},
						}, 10.0)
				end
			end
		--[[Cracking]]--
			if loc["Cracking"] then
				for i = 1, #loc["Cracking"] do
					local name = GetCurrentResourceName()..":Cracking:"..mine..":"..i
					if loc["Cracking"][i].blipEnable then Blip[#Blip+1] = makeBlip(loc["Cracking"][i]) end
					Props[#Props+1] = makeProp(loc["Cracking"][i], 1, false)
					local bench = Props[#Props]
					Targets[name] =
						createCircleTarget({name, loc["Cracking"][i].coords.xyz, 1.2, { name=name, debugPoly=Config.System.Debug, useZ=true, }, }, {
							{ 	action = function()
									TriggerEvent("jim-mining:CrackStart", { bench = bench })
								end,
								icon = "fas fa-compact-disc", label = Loc[Config.Lan].info["crackingbench"], item = "stone", job = loc.Job,
							},
						}, 2.0)
				end
			end
		--[[Ore Buyer]]--
			if loc["OreBuyer"] then
				for i = 1, #loc["OreBuyer"] do
					local name = GetCurrentResourceName()..":OreBuyer:"..mine..":"..i
					Peds[#Peds+1] = makePed(loc["OreBuyer"][i].model, loc["OreBuyer"][i].coords, 1, 1, loc["OreBuyer"][i].scenario)
					local ped = Peds[#Peds]
					if loc["OreBuyer"][i].blipEnable then Blip[#Blip+1] = makeBlip(loc["OreBuyer"][i]) end
					Targets[name] =
						createCircleTarget({name, loc["OreBuyer"][i].coords.xyz, 0.9, { name = name, debugPoly = Config.System.Debug, uzeZ = true }, }, {
							{	action = function()
									sellMenu({ ped = ped, sellTable = Selling["OreSell"] })
								end,
								icon = "fas fa-sack-dollar", label = Loc[Config.Lan].info["sell_ores"], job = Config.General.Job
							},
						}, 2.0)
				end
			end
		--[[Jewel Cutting]]--
			if loc["JewelCut"] then
				for i = 1, #loc["JewelCut"] do
					local name = GetCurrentResourceName()..":JewelCut:"..mine..":"..i
					if loc["JewelCut"][i].blipEnable then Blip[#Blip+1] = makeBlip(loc["JewelCut"][i]) end
					Props[#Props+1] = makeProp(loc["JewelCut"][i], 1, false)
					local bench = Props[#Props]
					Targets[name] =
						createCircleTarget({name, loc["JewelCut"][i].coords.xyz, 1.2, { name = name, debugPoly = Config.System.Debug, useZ = true }, }, {
							{ 	action = function()
									TriggerEvent("jim-mining:JewelCut", {bench = bench})
								end,
								icon = "fas fa-gem", label = Loc[Config.Lan].info["jewelcut"], job = Config.General.Job,
							},
						}, 2.0)
				end
			end
			if (mine == "K4MB1Shaft" and Config.General.K4MB1Cart) then
				local cartCoords = {
					{ 	coords = vec4(-471.6, 2090.23, 120.08, 103.49),
						right = false,
					},
					{ 	coords = vec4(-564.39, 1885.17, 123.04, 22.38),
						right = true,
					},
				}
				for i = 1, #cartCoords do
					local name = GetCurrentResourceName()..":Cart:"..mine..":"..i
					Peds[#Peds+1] = makePed("G_M_M_ChemWork_01", cartCoords[i].coords, 1, 1, "WORLD_HUMAN_CLIPBOARD")
					Targets[name] =
						createCircleTarget({name, cartCoords[i].coords.xyz, 1.0, { name=name, debugPoly=Config.System.Debug, useZ=true, }, }, {
							{	action = function()
									mineCartMenu(false, cartCoords[i].right)
								end,
								icon = "fas fa-wheelchair", label = "Minecart", job = loc.Job,
							},
						}, 2.0)
				end
			end
		end
	end
	--[[Stone Washing]]--
		if Locations["Washing"].Enable then
			for k, v in pairs(Locations["Washing"].positions) do
				local name = GetCurrentResourceName()..":Washing:"..k
				Targets[name] =
					createCircleTarget({ name, v.coords.xyz, 9.0, { name = name, debugPoly = Config.System.Debug, usez = true, }, }, {
						{	action = function()
								TriggerEvent("jim-mining:WashStart", { coords = v.coords })
							end,
							icon = "fas fa-hands-bubbles", item = "stone", label = Loc[Config.Lan].info["washstone"],
						},
					}, 2.0)
				if v.blipEnable then Blip[#Blip+1] = makeBlip(v) end
			end
		end
	--[[Panning]]--
	if Locations["Panning"].Enable then
		for location in pairs(Locations["Panning"].positions) do
			local loc = Locations["Panning"].positions[location]
			if loc.Blip.Enable then Blip[#Blip+1] = makeBlip(loc["Blip"]) end
			for i = 1, #loc.Positions do
				local name = GetCurrentResourceName()..":Panning:"..location..":"..i
				Targets[name] =
					createBoxTarget( { name, loc.Positions[i].coords.xyz, loc.Positions[i].w, loc.Positions[i].d, { name=name, heading = loc.Positions[i].coords.w, debugPoly=Config.System.Debug, minZ=loc.Positions[i].coords.z-10.0, maxZ=loc.Positions[i].coords.z+10.0 }, }, {
						{ 	action = function()
								TriggerEvent("jim-mining:PanStart", { coords = loc.Positions[i].coords })
							end,
							icon = "fas fa-ring",
							item = "goldpan",
							label = Loc[Config.Lan].info["goldpan"],
						},
					}, 2.0)
			end
		end
	end
	--[[Jewel Buyer]]--
	if Locations["JewelBuyer"].Enable then
		for k, v in pairs(Locations["JewelBuyer"].positions) do
			local name = GetCurrentResourceName()..":JewelBuyer:"..k
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
			local ped = Peds[#Peds]
			Targets[name] =
				createCircleTarget({ name, v.coords.xyz, 1.2, { name = name, debugPoly = Config.System.Debug, useZ = true }, }, {
					{	action = function()
						sellMenu({ ped = ped, sellTable = Selling["JewelSell"] })
						end,
						icon = "fas fa-gem", label = Loc[Config.Lan].info["jewelbuyer"], job = Config.General.Job
					},
				}, 2.0)
		end
	end
end

onPlayerLoaded(function()
	if Config.General.job then
		if hasJob(Config.General.job) then makeJob() else removeJob() end
	else makeJob() end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
	if Config.General.job then
		if hasJob(Config.General.job) then makeJob() else removeJob() end
	else makeJob() end
end)
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	if Config.General.job then
		if hasJob(Config.General.job) then makeJob() else removeJob() end
	else makeJob() end
end)

--------------------------------------------------------

function stoneBreak(name, stone, coords, job, rot, empty)
	CreateThread(function()
		local prop = stone
		local emptyProp = empty
		--Stone CoolDown + Recreation
		local setReward = nil
		if Config.General.AltMining then
			local propPick = nil
			removeZoneTarget(Targets[name])
			destroyProp(prop)
			Targets[name] = nil
			Wait(Config.System.Debug and 2000 or Config.Timings["OreRespawn"])

			local totalWeight = 0
			local weightedTable = {}
			local chosenProp = nil
			for _, item in ipairs(Config.setMiningTable) do
				if item.rarity == "common" then item.weight = 5
				elseif item.rarity == "rare" then item.weight = 3
				elseif item.rarity == "ultra_rare" then item.weight = 1 end
				totalWeight = totalWeight + (item.weight or 1)
				table.insert(weightedTable, {name = item.name, rarity = item.rarity, weight = totalWeight, prop = item.prop })
			end
			local randomValue = math.random(1, totalWeight)
			for _, item in ipairs(weightedTable) do
				if randomValue <= item.weight then
					setReward = item.name
					chosenProp = item.prop
					break
				end
			end
			for i = 1, #propTable do
				if propTable[i].full == chosenProp then
					propPick = propTable[i]
					break
				end
			end

			--Unhide Stone and create a new target location
			Props[#Props+1] = makeProp({coords = vec4(coords.x, coords.y, coords.z + (not Config.General.K4MB1Prop and 1.10 or 0.8), coords.a), prop = propPick.full}, 1, false)
			prop = Props[#Props]
			SetEntityRotation(prop, rot.x, rot.y, rot.z, 0, 0)

			-- Empty Version
			destroyProp(emptyProp)
			if propPick.empty then
				Props[#Props+1] = makeProp({coords = vec4(coords.x, coords.y, coords.z + (not Config.General.K4MB1Prop and 1.1 or 0.8), coords.a), prop = propPick.empty}, 1, false)
				emptyProp = Props[#Props]
				SetEntityRotation(emptyProp, rot.x, rot.y, rot.z, 0, 0)
			end
		else
			if Config.System.Debug then print("^5Debug^7: ^2Hiding prop and target^7: '^6"..name.."^7' ^2at coords^7: ^6"..coords) end
			SetEntityAlpha(prop, 0)
			removeZoneTarget(Targets[name]) Targets[name] = nil
			Wait(Config.System.Debug and 2000 or Config.Timings["OreRespawn"])
			--Unhide Stone and create a new target location
			SetEntityAlpha(prop, 255)
		end
		Targets[name] =
			createCircleTarget({name, vec3(coords.x, coords.y, coords.z), 1.2, { name=name, debugPoly=Config.System.Debug, useZ=true, }, }, {
				{ 	action = function()
						TriggerEvent("jim-mining:MineOre:Pick", { stone = prop, name = name, coords = coords, rot = rot, emptyProp = emptyProp, setReward = setReward })
					end,
					icon = "fas fa-hammer", item = "pickaxe", label = Loc[Config.Lan].info["mine_ore"].." ("..Items["pickaxe"].label..")", job = job,
				},
				{ 	action = function()
						TriggerEvent("jim-mining:MineOre:Drill", { stone = prop, name = name,coords = coords, rot = rot, emptyProp = emptyProp, setReward = setReward })
					end,
					icon = "fas fa-screwdriver", item = "minindrill", label = Loc[Config.Lan].info["mine_ore"].." ("..Items["miningdrill"].label..")", job = job,
				},
				{ 	action = function()
						TriggerEvent("jim-mining:MineOre:Laser", { stone = prop, name = name,  coords = coords, rot = rot, emptyProp = emptyProp, setReward = setReward })
					end,
					icon = "fas fa-screwdriver-wrench", item = "mininglaser", label = Loc[Config.Lan].info["mine_ore"].." ("..Items["mininglaser"].label..")", job = job,
				},
			}, 1.3)
		if Config.System.Debug then print("^5Debug^7: ^2Remaking Prop and Target^7: '^6"..name.."^7' ^2at coords^7: ^6"..coords) end
	end)
end

local isMining = false
RegisterNetEvent('jim-mining:MineOre:Pick', function(data) local Ped = PlayerPedId()
	if isMining then return else isMining = true end -- Stop players from doubling up the event
	-- Anim Loading
	local dict, anim = "amb@world_human_hammering@male@base", "base"
	loadDrillSound()
	--Create Pickaxe and Attach
	local PickAxe = makeProp({ prop = "prop_tool_pickaxe", coords = vec4(0,0,0,0)}, 0, 1)
	DisableCamCollisionForObject(PickAxe)
	DisableCamCollisionForEntity(PickAxe)
	AttachEntityToEntity(PickAxe, Ped, GetPedBoneIndex(Ped, 57005), 0.09, -0.53, -0.22, 252.0, 180.0, 0.0, false, true, true, true, 0, true)
	local IsDrilling = true
	local rockcoords = GetEntityCoords(data.stone)
	--Calculate if you're facing the stone--
	lookEnt(data.stone)
	if #(rockcoords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, rockcoords, 0.5, 400, 0.0, 0) Wait(400) end
	loadPtfxDict("core")
	CreateThread(function()
		while IsDrilling do
			UseParticleFxAssetNextCall("core")
			playAnim(dict, anim, -1, 2)
			Wait(200)
			local pickcoords = GetOffsetFromEntityInWorldCoords(PickAxe, -0.4, 0.0, 0.7)
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", pickcoords.x, pickcoords.y, pickcoords.z, 0.0, 0.0, 0.0, 0.4, 0.0, 0.0, 0.0)
			Wait(350)
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["drilling_ore"], time = Config.Timings["Pickaxe"], cancel = true, icon = "pickaxe"}) then
		TriggerServerEvent('jim-mining:Reward', { mine = true, cost = nil, setReward = data.setReward })
		if math.random(1,10) >= 9 then
			local breakId = GetSoundId()
			PlaySoundFromEntity(breakId, "Drill_Pin_Break", Ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
			removeItem("pickaxe", 1)
		end
		stoneBreak(data.name, data.stone, data.coords, data.job, data.rot, data.emptyProp)
	end
	stopAnim(dict, anim)
	destroyProp(PickAxe)
	unloadPtfxDict("core")
	unloadDrillSound()
	StopSound(soundId)
	IsDrilling, isMining = false, false
end)

RegisterNetEvent('jim-mining:MineOre:Drill', function(data) local Ped = PlayerPedId()
	if isMining then return else isMining = true end -- Stop players from doubling up the event
	if hasItem("drillbit", 1) then
		-- Sounds & Anim loading
		loadDrillSound()
		local dict, anim = "anim@heists@fleeca_bank@drilling", "drill_straight_fail"
		--Create Drill and Attach
		local DrillObject = makeProp({ prop = "hei_prop_heist_drill", coords = vec4(0,0,0,0)}, 0, 1)
		AttachEntityToEntity(DrillObject, Ped, GetPedBoneIndex(Ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
		local IsDrilling = true
		local rockcoords = GetEntityCoords(data.stone)
		--Calculate if you're heading is within 20.0 degrees -
		lookEnt(data.stone)
		if #(rockcoords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, rockcoords, 0.5, 400, 0.0, 0) Wait(400) end
		playAnim(dict, anim, -1, 1)
		Wait(200)
		if Config.General.DrillSound then PlaySoundFromEntity(soundId, "Drill", DrillObject, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0) end
		CreateThread(function() -- Dust/Debris Animation
			loadPtfxDict("core")
			while IsDrilling do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", rockcoords.x, rockcoords.y, rockcoords.z, 0.0, 0.0, GetEntityHeading(Ped)-180.0, 1.0, 0.0, 0.0, 0.0)
				Wait(600)
			end
		end)
		if progressBar({label = Loc[Config.Lan].info["drilling_ore"], time = Config.Timings["Mining"], cancel = true, icon = "miningdrill"}) then
			TriggerServerEvent('jim-mining:Reward', { mine = true, cost = nil })
			--Destroy drill bit chances
			if math.random(1, 100) >= 90 then
				local breakId = GetSoundId()
				PlaySoundFromEntity(breakId, "Drill_Pin_Break", Ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				removeItem("drillbit", 1)
				stoneBreak(data.name, data.stone, data.coords, data.job, data.rot, data.emptyProp)
			end
		end
		stopAnim(dict, anim)
		unloadDrillSound()
		StopSound(soundId)
		destroyProp(DrillObject)
		unloadPtfxDict("core")
		IsDrilling, isMining = false, false
	else
		triggerNotify(nil, Loc[Config.Lan].error["no_drillbit"], nil) isMining = false return
	end
end)

RegisterNetEvent('jim-mining:MineOre:Laser', function(data) local Ped = PlayerPedId()
	if isMining then return else isMining = true end -- Stop players from doubling up the event
	-- Sounds & Anim Loading
	RequestAmbientAudioBank("DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS", 0)
	RequestAmbientAudioBank("dlc_xm_silo_laser_hack_sounds", 0)
	local dict, anim = "anim@heists@fleeca_bank@drilling", "drill_straight_fail"
	--Create Drill and Attach
	local DrillObject = makeProp({ prop = "ch_prop_laserdrill_01a", coords = vec4(0,0,0,0)}, 0, 1)
	AttachEntityToEntity(DrillObject, Ped, GetPedBoneIndex(Ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
	local IsDrilling = true
	local rockcoords = GetEntityCoords(data.stone)
	--Calculate if you're facing the stone--
	lookEnt(data.stone)
	--Activation noise & Anims
	playAnim(dict, 'drill_straight_idle', -1, 1)
	PlaySoundFromEntity(soundId, "Pass", DrillObject, "dlc_xm_silo_laser_hack_sounds", 1, 0)
	Wait(1000)
	playAnim(dict, anim, -1, 1)
	PlaySoundFromEntity(soundId, "EMP_Vehicle_Hum", DrillObject, "DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS", 1, 0) --Not sure about this sound, best one I could find as everything else wouldn't load
	--Laser & Debris Effect
	local lasercoords = GetOffsetFromEntityInWorldCoords(DrillObject, 0.0,-0.5, 0.02)
	CreateThread(function()
		loadPtfxDict("core")
		while IsDrilling do
			UseParticleFxAssetNextCall("core")
			local laser = StartNetworkedParticleFxNonLoopedAtCoord("muz_railgun", lasercoords.x, lasercoords.y, lasercoords.z, 0, -10.0, GetEntityHeading(DrillObject)+270, 1.0, 0.0, 0.0, 0.0)
			UseParticleFxAssetNextCall("core")
			local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", rockcoords.x, rockcoords.y, rockcoords.z, 0.0, 0.0, GetEntityHeading(Ped)-180.0, 1.0, 0.0, 0.0, 0.0)
			Wait(60)
		end
	end)
	if progressBar({label = Loc[Config.Lan].info["drilling_ore"], time = Config.Timings["Laser"], cancel = true, icon = "mininglaser"}) then
		TriggerServerEvent('jim-mining:Reward', { mine = true, cost = nil })
		stoneBreak(data.name, data.stone, data.coords, data.job, data.rot, data.emptyProp)
	end
	IsDrilling, isMining = false, false
	stopAnim(dict, anim)
	ReleaseAmbientAudioBank("DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS")
	ReleaseAmbientAudioBank("dlc_xm_silo_laser_hack_sounds")
	StopSound(soundId)
	destroyProp(DrillObject)
	unloadPtfxDict("core")
end)
------------------------------------------------------------
-- Cracking Command / Animations
local Cracking = false
RegisterNetEvent('jim-mining:CrackStart', function(data) local Ped = PlayerPedId()
	if Cracking then return end
	local cost = 1
	if hasItem("stone", cost) then
		Cracking = true
		lockInv(true)
		-- Sounds & Anim Loading
		local dict, anim ="amb@prop_human_parking_meter@male@idle_a", "idle_a"
		loadDrillSound()
		local benchcoords = GetOffsetFromEntityInWorldCoords(data.bench, 0.0, -0.2, 2.08)
		--Calculate if you're facing the bench--
		lookEnt(data.bench)
		if #(benchcoords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, benchcoords, 0.5, 400, 0.0, 0) Wait(400) end
		local Rock = makeProp({ prop = "prop_rock_5_smash1", coords = vec4(benchcoords.x, benchcoords.y, benchcoords.z, 0)}, 0, 1)
		if Config.General.DrillSound then PlaySoundFromCoord(soundId, "Drill", benchcoords, "DLC_HEIST_FLEECA_SOUNDSET", 0, 4.5, 0) end
		loadPtfxDict("core")
		CreateThread(function()
			while Cracking do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", benchcoords.x, benchcoords.y, benchcoords.z-0.9, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0)
				Wait(400)
			end
		end)
		playAnim(dict, anim, -1, 1)
		--TaskPlayAnim(Ped, dict, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
		if progressBar({label = Loc[Config.Lan].info["cracking_stone"], time = Config.Timings["Cracking"], cancel = true, icon = "stone"}) then
			TriggerServerEvent('jim-mining:Reward', { crack = true, cost = cost })
		end
		StopAnimTask(Ped, dict, anim, 1.0)
		unloadDrillSound()
		StopSound(soundId)
		unloadPtfxDict("core")
		unloadAnimDict(dict)
		destroyProp(Rock)
		lockInv(false)
		Cracking = false
	else
		triggerNotify(nil, Loc[Config.Lan].error["no_stone"], 'error')
	end
end)
------------------------------------------------------------
-- Washing Command / Animations
local Washing = false
RegisterNetEvent('jim-mining:WashStart', function(data) local Ped = PlayerPedId()
	if Washing then return end
	local cost = 1
	if hasItem("stone", cost) then
		Washing = true
		lockInv(true)
		--Create Rock and Attach
		local Rock = makeProp({ prop = "prop_rock_5_smash1", coords = vec4(0,0,0,0)}, 0, 1)
		AttachEntityToEntity(Rock, Ped, GetPedBoneIndex(Ped, 60309), 0.1, 0.0, 0.05, 90.0, -90.0, 90.0, true, true, false, true, 1, true)
		TaskStartScenarioInPlace(Ped, "PROP_HUMAN_BUM_BIN", 0, true)
		local water
		CreateThread(function()
			Wait(3000)
			loadPtfxDict("core")
			while Washing do
				UseParticleFxAssetNextCall("core")
				water = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", Ped, 0.0, 1.0, -0.2, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
				Wait(500)
			end
		end)
		if progressBar({label = Loc[Config.Lan].info["washing_stone"], time = Config.Timings["Washing"], cancel = true, icon = "stone"}) then
			TriggerServerEvent('jim-mining:Reward', { wash = true, cost = cost })
		end
		lockInv(false)
		StopParticleFxLooped(water, 0)
		destroyProp(Rock)
		unloadPtfxDict("core")
		Washing = false
		ClearPedTasks(Ped)
	else
		triggerNotify(nil, Loc[Config.Lan].error["no_stone"], 'error')
	end
end)
------------------------------------------------------------
-- Gold Panning Command / Animations
local Panning = false
RegisterNetEvent('jim-mining:PanStart', function(data) local Ped = PlayerPedId()
	if Panning then return else Panning = true end
	lockInv(true)
	--Create Rock and Attach
	local trayCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, -0.9)
	Props[#Props+1] = makeProp({ coords = vec4(trayCoords.x, trayCoords.y, trayCoords.z+1.03, GetEntityHeading(Ped)), prop = `bkr_prop_meth_tray_01b`} , 1, 1)
	CreateThread(function()
		loadPtfxDict("core")
		while Panning do
			UseParticleFxAssetNextCall("core")
			local water = StartNetworkedParticleFxLoopedOnEntity("water_splash_veh_out", Props[#Props], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0, 0, 0)
			Wait(100)
		end
	end)
	--Start Anim
	TaskStartScenarioInPlace(Ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
	if progressBar({label = Loc[Config.Lan].info["goldpanning"], time = Config.Debug and 1000 or Config.Timings["Panning"], cancel = true, icon = "goldpan"}) then
		TriggerServerEvent('jim-mining:Reward', { pan = true, cost = nil })
	end
	ClearPedTasksImmediately(Ped)
	destroyProp(Props[#Props])
	unloadPtfxDict("core")
	lockInv(false)
	Panning = false
end)

--Cutting Jewels
RegisterNetEvent('jim-mining:JewelCut', function(data)
	local Menu = {}
    local table = {
		{ header = Loc[Config.Lan].info["gem_cut"],	txt = Loc[Config.Lan].info["gem_cut_section"], craftable = Crafting.GemCut, },
		{ header = Loc[Config.Lan].info["make_ring"], txt = Loc[Config.Lan].info["ring_craft_section"], craftable = Crafting.RingCut, },
		{ header = Loc[Config.Lan].info["make_neck"], txt = Loc[Config.Lan].info["neck_craft_section"], craftable = Crafting.NeckCut, },
		{ header = Loc[Config.Lan].info["make_ear"], txt = Loc[Config.Lan].info["ear_craft_section"], craftable = Crafting.EarCut, },
	}
	for i = 1, #table do
		Menu[#Menu+1] = {
			header = table[i].header, txt = table[i].txt,
			onSelect = function()
				TriggerEvent("jim-mining:CraftMenu", { craftable = table[i].craftable, ret = true, bench = data.bench })
			end,
		}
	end
	openMenu(Menu, { header = Loc[Config.Lan].info["craft_bench"], headertxt = Loc[Config.Lan].info["req_drill_bit"], canClose = true, })
end)

RegisterNetEvent('jim-mining:CraftMenu', function(data)
	local Menu = {}
	if (data.job or data.gang) and not jobCheck(data.job or data.gang) then return end
	local Recipes = data.craftable.Recipes
	for i = 1, #Recipes do
		for k in pairs(Recipes[i]) do
			if k ~= "amount" then
				local text = ""
				local itemTable = {}
				for l, b in pairs(Recipes[i][tostring(k)]) do
					if not Items[l] then print("^3Error^7: ^2Script can't find ingredient item in items.lua - ^1"..l.."^7") return end
					text = text..Items[l].label..(b > 1 and " x"..b or "")..(Config.System.Menu == "qb" and "<br>" or "\n")
					itemTable[l] = b
					Wait(0)
				end
				local hasItems, hasTable = hasItem(itemTable)
				Menu[#Menu + 1] = {
					isMenuHeader = not hasItems or not hasItem("drillbit"),
					icon = invImg(k),
					header = Items[k].label..((Recipes[i]["amount"] and Recipes[i]["amount"] > 1 and " x" .. Recipes[i]["amount"]) or "")..(hasItems and " ✔️" or ""),
					txt = text,
					onSelect = function()
						TriggerEvent((Config.Crafting.MultiCraft and "jim-mining:Crafting:MultiCraft" or "jim-mining:Crafting:MakeItem"),
							{ item = k, craft = Recipes[i], craftable = data.craftable, ret = data.ret, bench = data.bench }
						)
					end,
				}
			end
		end
	end
	openMenu(Menu, {
		header = (data and data.ret) and Loc[Config.Lan].info["craft_bench"] or Loc[Config.Lan].info["smelter"],
		headertxt = (data and data.ret) and Loc[Config.Lan].info["req_drill_bit"] or Loc[Config.Lan].info["smelt_ores"],
		canClose = true,
		onBack = (data and data.ret) and function()
			TriggerEvent("jim-mining:JewelCut", data)
		end or nil,
	})
	lookEnt(data.coords)
end)

RegisterNetEvent('jim-mining:Crafting:MultiCraft', function(data)
    local success = Config.Crafting.MultiCraftAmounts
	local Menu = {}
    Menu[#Menu+1] = {
        isMenuHeader = true,
        icon = invImg(data.item),
        header = Items[data.item].label,
    }
	for k in pairsByKeys(success) do
        local settext = ""
        local itemTable = {}

        for l, b in pairs(data.craft[data.item]) do
            itemTable[l] = (b * k)
            settext = settext..(settext ~= "" and br or "")..Items[l].label..(b*k > 1 and "- x"..b*k or "")
            Wait(0)
        end
        local disable = hasItem(itemTable)

		Menu[#Menu + 1] = {
			isMenuHeader = not disable,
            arrow = disable,
            header = "Craft - x"..k *( data.craft.amount or 1),
            txt = settext,
            onSelect = function ()
				TriggerEvent("jim-mining:Crafting:MakeItem", {
					item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, anim = data.anim, amount = k, ret = data.ret, bench = data.bench
				})
            end,
        }
	end
	openMenu(Menu, {
		header = (data and data.ret) and Loc[Config.Lan].info["craft_bench"] or Loc[Config.Lan].info["smelter"],
		headertxt = (data and data.ret) and Loc[Config.Lan].info["req_drill_bit"] or Loc[Config.Lan].info["smelt_ores"],
		canClose = true,
		onBack = (data and data.ret) and function()
			TriggerEvent("jim-mining:CraftMenu", data)
		end or nil,
	})
end)

RegisterNetEvent('jim-mining:Crafting:MakeItem', function(data) local bartext, animDictNow, animNow, scene, Ped = "", "nil", "nil", nil, PlayerPedId()
	if not data.ret then bartext = Loc[Config.Lan].info["smelting"]..Items[data.item].label
	else bartext = Loc[Config.Lan].info["cutting"]..Items[data.item].label end
	local bartime = Config.Timings["Crafting"]
	if (data.amount and data.amount ~= 1) then data.craft.amount = data.craft.amount or 1 data.craft["amount"] *= data.amount
		for k in pairs(data.craft[data.item]) do data.craft[data.item][k] *= data.amount end
		bartime *= data.amount bartime *= 0.9
	end
	lockInv(true)
	local isDrilling = true
	if data.ret then -- If jewelcutting
		if not hasItem("drillbit", 1) then
			triggerNotify(nil, Loc[Config.Lan].error["no_drillbit"], 'error')
			TriggerEvent('jim-mining:JewelCut', data)
			lockInv(false)
			return
		else
			local dict, anim = "anim@amb@machinery@speed_drill@", "operate_02_hi_amy_skater_01"
			loadAnimDict(tostring(dict))
			lockInv(true)
			loadDrillSound()
			if Config.DrillSound then
				PlaySoundFromEntity(soundId, "Drill", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 0.5, 0)
			end
			local drillcoords = GetOffsetFromEntityInWorldCoords(data.bench, 0.0, -0.15, 1.1)
			scene = NetworkCreateSynchronisedScene(GetEntityCoords(data.bench), GetEntityRotation(data.bench), 2, false, false, 1065353216, 0, 1.3)
			NetworkAddPedToSynchronisedScene(Ped, scene, dict, anim, 0, 0, 0, 16, 1148846080, 0)
			NetworkStartSynchronisedScene(scene)
			CreateThread(function()
				loadPtfxDict("core")
				while isDrilling do
					UseParticleFxAssetNextCall("core")
					local dust = StartNetworkedParticleFxNonLoopedAtCoord("glass_side_window", drillcoords.x, drillcoords.y, drillcoords.z, 0.0, 0.0, GetEntityHeading(Ped)+math.random(0, 359), 0.2, 0.0, 0.0, 0.0)
					Wait(100)
				end
				unloadAnimDict(dict)
			end)
		end
	else -- If not Jewel Cutting, you'd be smelting (need to work out what is possible for this)
		animDictNow, animNow = "amb@prop_human_parking_meter@male@idle_a", "idle_a"
	end
	if progressBar({ label = bartext, time = bartime, cancel = true, dict = animDictNow, anim = animNow, flag = 8, icon = data.item }) then
		TriggerServerEvent('jim-mining:Crafting:GetItem', data.item, data.craft)
		if data.ret then
			if math.random(1, 1000) <= 75 then
				local breakId = GetSoundId()
				PlaySoundFromEntity(breakId, "Drill_Pin_Break", Ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				removeItem("drillbit", 1)
			end
		end
		Wait(500)
		TriggerEvent("jim-mining:CraftMenu", data)
	end
	lockInv(false)
	StopSound(soundId)
	unloadDrillSound()
	lockInv(false)
	NetworkStopSynchronisedScene(scene)
	unloadPtfxDict("core")
	isDrilling = false
	StopAnimTask(Ped, animDictNow, animNow, 1.0)
	FreezeEntityPosition(Ped, false)
end)

AddEventHandler('onResourceStop', function(r) if r == GetCurrentResourceName() then removeJob() end end)