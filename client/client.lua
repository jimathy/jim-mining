local Props, Targets, Peds, Blip, soundId = {}, {}, {}, {}, GetSoundId()

Mining = {
	Functions = {},
	MineOre = {},
	Other = {},
	Menus = {},
}

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

Mining.Functions.checkForJob = function()
	if Config.General.requiredJob then
		if hasJob(Config.General.requiredJob) then
			Mining.Functions.makeJob()
		else
			Mining.Functions.removeJob()
		end
	else
		Mining.Functions.makeJob()
	end
end

Mining.Functions.weightedRandomReward = function()
	local totalWeight, weightedTable = 0, {}
	for _, item in ipairs(Config.setMiningTable) do
		local weight = item.rarity == "common" and 5 or item.rarity == "rare" and 3 or 1
		totalWeight += weight
		local prop = item.prop
		if not Config.General.K4MB1Prop then
			prop = "cs_x_rubweec"
		end
		table.insert(weightedTable, {name = item.name, weight = totalWeight, prop = prop})
	end

	local randValue = math.random(1, totalWeight)
	for _, item in ipairs(weightedTable) do
		if randValue <= item.weight then
			return item
		end
	end
end

Mining.Functions.spawnProp = function(coords, propName, adjustHeight)
	local propCoords = vec4(coords.x, coords.y, coords.z + adjustHeight, coords.a)
	local prop = makeProp({coords = propCoords, prop = propName}, 1, false)
	local rot = GetEntityRotation(prop)
	SetEntityRotation(prop, rot.x - math.random(60,100), rot.y, rot.z, 0, 0)
	return prop
end

Mining.Functions.setupMiningTarget = function(name, coords, prop, emptyProp, setReward, job)
	Targets[name] = createCircleTarget({name, vec3(coords.x, coords.y, coords.z), 1.2, {name = name, debugPoly = debugMode, useZ = true}}, {
		{	action = function()
				Mining.MineOre.pickaxe({stone = prop, name = name, coords = coords, emptyProp = emptyProp, setReward = setReward})
			end,
			icon = "fas fa-hammer",
			item = "pickaxe",
			label = locale("info", "mine_ore")..
					" ("..(Items["pickaxe"] and Items["pickaxe"].label or "pickaxe❌")..") "..
					(Config.General.AltMining and Items[setReward].label or "")..
					(debugMode and " ["..name.."]" or ""),
			job = job,
			canInteract = function()
				return not isMining
			end,
		},
		{	action = function()
				Mining.MineOre.miningDrill({stone = prop, name = name, coords = coords, emptyProp = emptyProp, setReward = setReward})
			end,
			icon = "fas fa-screwdriver",
			item = "miningdrill",
			label = locale("info", "mine_ore")..
					" ("..(Items["miningdrill"] and Items["miningdrill"].label or "miningdrill❌")..")"..
					(Config.General.AltMining and Items[setReward].label or "")..
					(debugMode and " ["..name.."]" or ""),
			job = job,
			canInteract = function()
				return not isMining
			end,
		},
		{	action = function()
				Mining.MineOre.miningLaser({stone = prop, name = name, coords = coords, emptyProp = emptyProp, setReward = setReward})
			end,
			icon = "fas fa-screwdriver-wrench",
			item = "mininglaser",
			label = locale("info", "mine_ore")..
					" ("..(Items["mininglaser"] and Items["mininglaser"].label or "mininglaser❌")..")"..
					(Config.General.AltMining and Items[setReward].label or "")..
					(debugMode and " ["..name.."]" or ""),
			job = job,
			canInteract = function()
				return not isMining
			end,
		},
	}, 1.7)
end

Mining.Functions.makeJob = function()
	Mining.Functions.removeJob()
	if Locations["Mines"]["MineShaft"].Enable then
		CreateModelHide(vec3(-596.04, 2089.01, 131.41), 10.5, `prop_mineshaft_door`, true)
	end

	--Ore Spawning
	for mine, loc in pairs(Locations["Mines"]) do
		if loc.Enable then

			if loc["OrePositions"] then
				for i, coords in ipairs(loc["OrePositions"]) do
					local name = "Ore".."_"..mine.."_"..i
					local chosenProp, reward = propTable[math.random(#propTable)], "stone"

					if Config.General.AltMining then
						local weightedReward = Mining.Functions.weightedRandomReward()
						chosenProp = {
							full = weightedReward.prop,
							empty = nil
						}
						reward = weightedReward.name
					end
					local mainProp = Mining.Functions.spawnProp(coords, chosenProp.full, Config.General.K4MB1Prop and 0.8 or 1.1)
					local emptyProp
					if chosenProp.empty then
						emptyProp = Mining.Functions.spawnProp(coords, chosenProp.empty, Config.General.K4MB1Prop and 0.8 or 1.1)
					end
					Mining.Functions.setupMiningTarget(name, coords, mainProp, emptyProp, reward, loc.Job)
				end
			end
		--[[Blips]]--
			if loc.Blip.Enable then
				Blip[#Blip+1] = makeBlip(loc["Blip"])
			end

		--[[LIGHTS]]--
			if loc["Lights"] then
				if loc["Lights"].Enable then
					for i = 1, #loc["Lights"].positions do
						makeDistProp({coords = loc["Lights"].positions[i], prop = loc["Lights"].prop}, 1, false)
					end
				end
			end
		--[[Stores]]--
			if loc["Store"] then
				for i = 1, #loc["Store"] do
				local name = getScript()..":Store:"..mine..":"..i
					Peds[#Peds+1] = makePed(loc["Store"][i].model, loc["Store"][i].coords, 1, 1, loc["Store"][i].scenario)
					Targets[name] =
						createCircleTarget({name, loc["Store"][i].coords.xyz, 1.0, { name=name, debugPoly = debugMode, useZ=true, }, }, {
							{ 	action = function()
									openShop({ items = Config.Items, shop = "miningShop", coords = loc["Store"][i].coords })
								end,
								icon = "fas fa-store",
								label = locale("info", "browse_store")..(debugMode and " ["..name.."]" or ""),
								job = loc.Job,
							},
							(( mine == "K4MB1Shaft" and Config.General.K4MB1Cart ) and
								{	action = function()
										mineCartMenu(true)
									end,
									icon = "fas fa-wheelchair",
									label = "Minecart",
									job = loc.Job,
								} or nil
							),
						}, 2.0)
				end
			end
		--[[Smelting]]--
			if loc["Smelting"] then
				for i = 1, #loc["Smelting"] do
					local name = getScript()..":Smelting:"..i
					if loc["Smelting"][i].Enable then
						Blip[#Blip+1] = makeBlip(loc["Smelting"][i])
					end
					Targets[name] =
						createCircleTarget({name, loc["Smelting"][i].coords.xyz, 3.0, { name=name, debugPoly = debugMode, useZ=true, }, }, {
							{ 	action = function()
									craftingMenu({ craftable = Crafting.SmeltMenu, coords = loc["Smelting"][i].coords }) end,
									icon = "fas fa-fire-burner",
									label = locale("info", "use_smelter")..(debugMode and " ["..name.."]" or ""),
									job = loc.Job,
									canInteract = function()
										return not CraftLock
									end,
							},
						}, 10.0)
				end
			end
		--[[Cracking]]--
			if loc["Cracking"] then
				for i = 1, #loc["Cracking"] do
					local name = getScript()..":Cracking:"..mine..":"..i
					if loc["Cracking"][i].Enable then
						Blip[#Blip+1] = makeBlip(loc["Cracking"][i])
					end
					Props[#Props+1] = makeProp(loc["Cracking"][i], 1, false)
					local bench = Props[#Props]
					Targets[name] =
						createCircleTarget({name, loc["Cracking"][i].coords.xyz, 1.2, { name=name, debugPoly = debugMode, useZ=true, }, }, {
							{ 	action = function()
									Mining.Other.crackStart({ bench = bench })
								end,
								icon = "fas fa-compact-disc",
								label = locale("info", "crackingbench")..(debugMode and " ["..name.."]" or ""),
								item = "stone",
								job = loc.Job,
								canInteract = function()
									return not Cracking
								end,
							},
						}, 2.0)
				end
			end
		--[[Ore Buyer]]--
			if loc["OreBuyer"] then
				for i = 1, #loc["OreBuyer"] do
					local name = getScript()..":OreBuyer:"..mine..":"..i
					Peds[#Peds+1] = makePed(loc["OreBuyer"][i].model, loc["OreBuyer"][i].coords, 1, 1, loc["OreBuyer"][i].scenario)
					local ped = Peds[#Peds]
					if loc["OreBuyer"][i].Enable then
						Blip[#Blip+1] = makeBlip(loc["OreBuyer"][i])
					end
					Targets[name] =
						createCircleTarget({name, loc["OreBuyer"][i].coords.xyz, 0.9, { name = name, debugPoly = debugMode, uzeZ = true }, }, {
							{	action = function()
									sellMenu({
										name = name,
										ped = ped,
										sellTable = Selling["OreSell"]
									})
								end,
								icon = "fas fa-sack-dollar",
								label = locale("info", "sell_ores")..(debugMode and " ["..name.."]" or ""),
								job = Config.General.requiredJob
							},
						}, 2.0)
				end
			end
		--[[Jewel Cutting]]--
			if loc["JewelCut"] then
				for i = 1, #loc["JewelCut"] do
					local name = getScript()..":JewelCut:"..mine..":"..i
					if loc["JewelCut"][i].Enable then
						Blip[#Blip+1] = makeBlip(loc["JewelCut"][i])
					end
					Props[#Props+1] = makeProp(loc["JewelCut"][i], 1, false)
					local bench = Props[#Props]
					Targets[name] =
						createCircleTarget({name, loc["JewelCut"][i].coords.xyz, 1.2, { name = name, debugPoly = debugMode, useZ = true }, }, {
							{ 	action = function()
									Mining.Menus.jewelCut({bench = bench})
								end,
								icon = "fas fa-gem",
								label = locale("info", "jewelcut")..(debugMode and " ["..name.."]" or ""),
								job = Config.General.requiredJob,
								canInteract = function()
									return not CraftLock
								end,
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
					local name = getScript()..":Cart:"..mine..":"..i
					Peds[#Peds+1] = makePed("G_M_M_ChemWork_01", cartCoords[i].coords, 1, 1, "WORLD_HUMAN_CLIPBOARD")
					Targets[name] =
						createCircleTarget({name, cartCoords[i].coords.xyz, 1.0, { name=name, debugPoly = debugMode, useZ=true, }, }, {
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
			local name = getScript()..":Washing:"..k
			Targets[name] =
				createCircleTarget({ name, v.coords.xyz, 9.0, { name = name, debugPoly = debugMode, usez = true, }, }, {
					{	action = function()
							Mining.Other.washStart({ coords = v.coords })
						end,
						icon = "fas fa-hands-bubbles",
						item = "stone",
						label = locale("info", "washstone")..(debugMode and " ["..name.."]" or ""),
						canInteract = function()
							return not Washing
						end

					},
				}, 2.0)
			if v.blipEnable then
				Blip[#Blip+1] = makeBlip(v)
			end
		end
	end
	--[[Panning]]--
	if Locations["Panning"].Enable then
		for location in pairs(Locations["Panning"].positions) do
			local loc = Locations["Panning"].positions[location]
			if loc.Blip.Enable then Blip[#Blip+1] = makeBlip(loc["Blip"]) end
			for i = 1, #loc.Positions do
				local name = getScript()..":Panning:"..location..":"..i
				Targets[name] =
					createBoxTarget( { name, loc.Positions[i].coords.xyz, loc.Positions[i].w, loc.Positions[i].d, { name=name, heading = loc.Positions[i].coords.w, debugPoly = debugMode, minZ=loc.Positions[i].coords.z-10.0, maxZ=loc.Positions[i].coords.z+10.0 }, }, {
						{ 	action = function()
								Mining.Other.panStart({ coords = loc.Positions[i].coords })
							end,
							icon = "fas fa-ring",
							item = "goldpan",
							label = locale("info", "goldpan"),
							canInteract = function()
								return not Panning
							end,
						},
					}, 2.0)
			end
		end
	end
	--[[Jewel Buyer]]--
	if Locations["JewelBuyer"].Enable then
		for k, v in pairs(Locations["JewelBuyer"].positions) do
			local name = getScript()..":JewelBuyer:"..k
			if v.blipTrue then Blip[#Blip+1] = makeBlip(v) end
			Peds[#Peds+1] = makePed(v.model, v.coords, 1, 1, v.scenario)
			local ped = Peds[#Peds]
			Targets[name] =
				createCircleTarget({ name, v.coords.xyz, 1.2, { name = name, debugPoly = debugMode, useZ = true }, }, {
					{	action = function()
							sellMenu({
                        		name = name,
								ped = ped,
								sellTable = Selling["JewelSell"]
							})
						end,
						icon = "fas fa-gem", label = locale("info", "jewelbuyer")..(debugMode and " ["..name.."]" or ""), job = Config.General.requiredJob
					},
				}, 2.0)
		end
	end
end

--------------------------------------------------------

Mining.Other.stoneBreak = function(name, stone, coords, job, rot, empty)
	CreateThread(function()
		local prop, emptyProp, setReward = stone, empty, "stone"
		removeZoneTarget(Targets[name])
		Targets[name] = nil

		if Config.General.AltMining then
			destroyProp(prop)
			Wait(debugMode and 2000 or GetTiming(Config.Timings["OreRespawn"]))

			local weightedReward = Mining.Functions.weightedRandomReward()
			local propPick = { full = weightedReward.prop, empty = nil }
			setReward = weightedReward.name

			prop = Mining.Functions.spawnProp(coords, propPick.full, Config.General.K4MB1Prop and 0.8 or 1.1)
			destroyProp(emptyProp)

			if propPick.empty then
				emptyProp = Mining.Functions.spawnProp(coords, propPick.empty, Config.General.K4MB1Prop and 0.8 or 1.1)
			end
		else
			debugPrint("^5Debug^7: ^2Hiding prop and target^7: '^6"..name.."^7' ^2at coords^7: ^6"..coords)
			SetEntityAlpha(prop, 0)
			Wait(debugMode and 2000 or GetTiming(Config.Timings["OreRespawn"]))
			SetEntityAlpha(prop, 255)
		end

		Mining.Functions.setupMiningTarget(name, coords, prop, emptyProp, setReward, job)

		debugPrint("^5Debug^7: ^2Remaking Prop and Target^7: '^6"..name.."^7' ^2at coords^7: ^6"..coords)
	end)
end

isMining = false
Mining.MineOre.pickaxe = function(data)
	local Ped = PlayerPedId()
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
	if progressBar({label = locale("info", "drilling_ore"), time = GetTiming(Config.Timings["Pickaxe"]), cancel = true, icon = "pickaxe"}) then
		TriggerServerEvent(getScript()..":Reward", { mine = true, cost = nil, setReward = data.setReward })
		Mining.Other.stoneBreak(data.name, data.stone, data.coords, data.job, data.rot, data.emptyProp)
		if Config.BreakTool.Pickaxe then
			breakTool({ item = "pickaxe", damage = math.random(2, 3) })
		end
	end
	stopAnim(dict, anim)
	destroyProp(PickAxe)
	unloadPtfxDict("core")
	unloadDrillSound()
	StopSound(soundId)
	IsDrilling, isMining = false, false
end

Mining.MineOre.miningDrill = function(data)
	local Ped = PlayerPedId()
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
		if progressBar({label = locale("info", "drilling_ore"), time = GetTiming(Config.Timings["Mining"]), cancel = true, icon = "miningdrill"}) then
			TriggerServerEvent(getScript()..":Reward", { mine = true, cost = nil, setReward = data.setReward })
			Mining.Other.stoneBreak(data.name, data.stone, data.coords, data.job, data.rot, data.emptyProp)
			if Config.BreakTool.MiningDrill then
				breakTool({ item = "miningdrill", damage = math.random(2, 3) })
			end
			if Config.BreakTool.DrillBit then
				breakTool({ item = "drillbit", damage = math.random(2, 3) })
			else
				--Destroy drill bit chances
				local chance = math.random(1, 100)
				debugPrint("Debug: crackStart chance: "..chance)
				if chance >= 90 then
					local breakId = GetSoundId()
					PlaySoundFromEntity(breakId, "Drill_Pin_Break", Ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
					removeItem("drillbit", 1)
				end
			end
		end
		stopAnim(dict, anim)
		unloadDrillSound()
		StopSound(soundId)
		destroyProp(DrillObject)
		unloadPtfxDict("core")
		IsDrilling, isMining = false, false
	else
		triggerNotify(nil, locale("error", "no_drillbit"), nil) isMining = false return
	end
end

Mining.MineOre.miningLaser = function(data)
	local Ped = PlayerPedId()
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
	if progressBar({label = locale("info", "drilling_ore"), time = GetTiming(Config.Timings["Laser"]), cancel = true, icon = "mininglaser"}) then
		TriggerServerEvent(getScript()..":Reward", { mine = true, cost = nil, setReward = data.setReward })
		Mining.Other.stoneBreak(data.name, data.stone, data.coords, data.job, data.rot, data.emptyProp)
		if Config.BreakTool.MiningLaser then
			breakTool({ item = "mininglaser", damage = math.random(2, 3) })
		end
	end
	IsDrilling, isMining = false, false
	stopAnim(dict, anim)
	ReleaseAmbientAudioBank("DLC_HEIST_BIOLAB_DELIVER_EMP_SOUNDS")
	ReleaseAmbientAudioBank("dlc_xm_silo_laser_hack_sounds")
	StopSound(soundId)
	destroyProp(DrillObject)
	unloadPtfxDict("core")
end

------------------------------------------------------------
-- Cracking Command / Animations
Cracking = false
Mining.Other.crackStart = function(data)
	local Ped = PlayerPedId()
	if Cracking then return end
	local cost = 1
	if hasItem("stone", cost) then
		Cracking = true
		-- Sounds & Anim Loading
		local dict, anim ="amb@prop_human_parking_meter@male@idle_a", "idle_a"
		loadDrillSound()
		local benchcoords = GetOffsetFromEntityInWorldCoords(data.bench, 0.0, -0.2, 2.08)
		--Calculate if you're facing the bench--
		lookEnt(data.bench)
		lockInv(true)
		if #(benchcoords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, benchcoords, 0.5, 400, 0.0, 0) Wait(400) end
		local Rock = makeProp({ prop = "prop_rock_5_smash1", coords = vec4(benchcoords.x, benchcoords.y, benchcoords.z, 0)}, 0, 1)
		if Config.General.DrillSound then
			PlaySoundFromCoord(soundId, "Drill", benchcoords, "DLC_HEIST_FLEECA_SOUNDSET", 0, 4.5, 0)
		end
		loadPtfxDict("core")
		CreateThread(function()
			while Cracking do
				UseParticleFxAssetNextCall("core")
				local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", benchcoords.x, benchcoords.y, benchcoords.z-0.9, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0)
				Wait(100)
			end
		end)
		playAnim(dict, anim, -1, 1)
		--TaskPlayAnim(Ped, dict, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
		if progressBar({label = locale("info", "cracking_stone"), time = GetTiming(Config.Timings["Cracking"]), cancel = true, icon = "stone"}) then
			TriggerServerEvent(getScript()..":Reward", { crack = true, cost = cost })
			if Config.BreakTool.DrillBit then
				breakTool({ item = "drillbit", damage = math.random(2, 3) })
			else
				--Destroy drill bit chances
				local chance = math.random(1, 100)
				debugPrint("Debug: crackStart chance: "..chance)
				if chance >= 90 then
					local breakId = GetSoundId()
					PlaySoundFromEntity(breakId, "Drill_Pin_Break", Ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
					removeItem("drillbit", 1)
				end
			end
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
		triggerNotify(nil, locale("error", "no_stone"), 'error')
	end
end

------------------------------------------------------------
-- Washing Command / Animations
Washing = false
Mining.Other.washStart = function(data)
	local Ped = PlayerPedId()
	if Washing then return end
	local cost = 1
	if hasItem("stone", cost) then
		Washing = true
		lockInv(true)
		--Create Rock and Attach
		local Rock = makeProp({ prop = "prop_rock_5_smash1", coords = vec4(0, 0, 0, 0)}, 0, 1)
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
		if progressBar({ label = locale("info", "washing_stone"), time = GetTiming(Config.Timings["Washing"]), cancel = true, icon = "stone" }) then
			TriggerServerEvent(getScript()..":Reward", { wash = true, cost = cost })
		end
		lockInv(false)
		StopParticleFxLooped(water, 0)
		destroyProp(Rock)
		unloadPtfxDict("core")
		Washing = false
		ClearPedTasks(Ped)
	else
		triggerNotify(nil, locale("error", "no_stone"), 'error')
	end
end

------------------------------------------------------------
-- Gold Panning Command / Animations
Panning = false
Mining.Other.panStart = function(data)
	local Ped = PlayerPedId()
	if Panning then return else Panning = true end
	lockInv(true)
	--Create Rock and Attach
	local trayCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, -0.9)
	Props[#Props+1] = makeProp({ coords = vec4(trayCoords.x, trayCoords.y, trayCoords.z+1.03, GetEntityHeading(Ped)), prop = "bkr_prop_meth_tray_01b"} , 1, 1)
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
	if progressBar({ label = locale("info", "goldpanning"), time = GetTiming(Config.Timings["Panning"]), cancel = true, icon = "goldpan" }) then
		TriggerServerEvent(getScript()..":Reward", { pan = true, cost = nil })
		if Config.BreakTool.GoldPan then
			breakTool({ item = "goldpan", damage = math.random(2, 3) })
		end
	end
	ClearPedTasksImmediately(Ped)
	destroyProp(Props[#Props])
	unloadPtfxDict("core")
	lockInv(false)
	Panning = false
end

--Cutting Jewels
Mining.Menus.jewelCut = function(data)
	loadDrillSound()
	local Menu = {}
    local table = {
		{ header = locale("info", "gem_cut"),	txt = locale("info", "gem_cut_section"), craftable = Crafting.GemCut, },
		{ header = locale("info", "make_ring"), txt = locale("info", "ring_craft_section"), craftable = Crafting.RingCut, },
		{ header = locale("info", "make_neck"), txt = locale("info", "neck_craft_section"), craftable = Crafting.NeckCut, },
		{ header = locale("info", "make_ear"), txt = locale("info", "ear_craft_section"), craftable = Crafting.EarCut, },
	}
	for i = 1, #table do
		Menu[#Menu+1] = {
			header = table[i].header,
			txt = table[i].txt,
			onSelect = function()
				craftingMenu({
					craftable = table[i].craftable,
					coords = GetEntityCoords(data.bench),
					sound = {
						 soundId = soundId, audioName = "Drill", audioRef = "DLC_HEIST_FLEECA_SOUNDSET"
					},
					-- requiredItem = function()
					-- 	if Config.BreakTool.DrillBit then
					-- 		breakTool({ item = "drillbit", damage = math.random(2, 3) })
					-- 	else
					-- 		--Destroy drill bit chances
					-- 		if math.random(1, 100) >= 90 then
					-- 			local breakId = GetSoundId()
					-- 			PlaySoundFromEntity(breakId, "Drill_Pin_Break", Ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
					-- 			removeItem("drillbit", 1)
					-- 		end
					-- 	end
					-- end,
					onBack = function()
						Mining.Menus.jewelCut(data)
					end
				})
			end,
		}
	end
	openMenu(Menu, {
		header = locale("info", "craft_bench"),
		headertxt = locale("info", "req_drill_bit"),
		canClose = true,
	})
end

Mining.Functions.removeJob = function()
	for k in pairs(Targets) do removeZoneTarget(k) end
	for _, v in pairs(Peds) do DeletePed(v) end
	for i = 1, #Props do DeleteObject(Props[i]) end
	for i = 1, #Blip do RemoveBlip(Blip[i]) end
end

onResourceStop(Mining.Functions.removeJob, true)
onPlayerLoaded(function() Wait(1000) Mining.Functions.checkForJob() end, true)

if Config.General.requiredJob then
	RegisterNetEvent('QBCore:Client:OnJobUpdate', Mining.Functions.checkForJob)
end