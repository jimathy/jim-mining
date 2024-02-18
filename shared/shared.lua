function loadDrillSound()
	if Config.System.Debug then print("^5Debug^7: ^2Loading Drill Sound Banks") end
	RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
end
function unloadDrillSound()
	if Config.System.Debug then print("^5Debug^7: ^2Removing Drill Sound Banks") end
	ReleaseAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET")
	ReleaseAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL")
	ReleaseAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2")
end

------------------------------------------------------------
local minecartEntity = nil
local points = {
	["Main"] = {
		vec4(-597.32, 2092.28, 131.41, 195.85),
		vec4(-592.9, 2077.47, 131.41, 195.17),
		vec4(-591.45, 2071.89, 131.28, 193.39),
		vec4(-589.41, 2062.91, 130.94, 192.61),
		vec4(-588.32, 2054.52, 130.34, 187.2),
		vec4(-587.33, 2049.1, 129.89, 190.79),
		vec4(-585.11, 2043.15, 129.37, 205.88),
		vec4(-582.46, 2038.33, 128.96, 211.06),
		vec4(-578.29, 2032.1, 128.39, 214.94),
		vec4(-574.3, 2026.73, 127.98, 219.38),
		vec4(-569.94, 2022.21, 127.71, 220.77),
		vec4(-562.91, 2014.7, 127.33, 220.61),
		vec4(-558.16, 2008.06, 127.19, 211.98),
		vec4(-548.1, 1991.22, 127.03, 201.61),
	},
	--Cross Roads
	["Right"] = {
		vec4(-543.95, 1980.29, 127.05, 191.34),
		vec4(-542.48, 1969.53, 126.96, 184.28),
		vec4(-541.43, 1960.34, 126.68, 185.48),
		vec4(-539.46, 1950.64, 126.16, 192.29),
		vec4(-536.94, 1941.68, 125.68, 193.08),
		vec4(-535.12, 1930.0, 124.79, 185.12),
		vec4(-535.73, 1918.04, 123.9, 172.21),
		vec4(-538.41, 1909.36, 123.31, 155.38),
		vec4(-545.73, 1899.81, 123.06, 137.47),
		vec4(-553.45, 1892.99, 123.06, 122.89),
		vec4(-562.74, 1887.5, 123.06, 112.81)
	},

	["Left"] = {
		vec4(-544.12, 1985.69, 127.03, 224.58),
		vec4(-540.32, 1982.75, 127.05, 243.6),
		vec4(-537.52, 1981.77, 127.05, 257.2),
		vec4(-527.43, 1980.09, 126.87, 260.39),
		vec4(-520.56, 1979.26, 126.61, 264.99),
		vec4(-514.04, 1979.04, 126.37, 268.85),
		vec4(-504.19, 1979.46, 126.06, 274.8),
		vec4(-504.19, 1979.46, 126.06, 274.8),
		vec4(-498.69, 1980.47, 125.67, 285.12),
		vec4(-492.59, 1982.97, 124.93, 294.23),
		vec4(-488.0, 1984.97, 124.44, 293.38),
		vec4(-483.61, 1986.58, 124.18, 285.18),
		vec4(-475.68, 1989.11, 123.83, 288.35),
		vec4(-470.47, 1991.31, 123.65, 298.13),
		vec4(-466.23, 1994.06, 123.56, 308.0),
		vec4(-460.4, 1999.11, 123.57, 313.9),
		vec4(-453.77, 2006.07, 123.55, 318.79),
		vec4(-449.49, 2013.25, 123.55, 340.69),
		vec4(-448.74, 2019.25, 123.55, 9.69),
		vec4(-451.61, 2032.88, 123.23, 12.03),
		vec4(-454.41, 2041.63, 122.84, 23.7),
		vec4(-461.12, 2054.57, 122.08, 27.56),
		vec4(-464.93, 2061.84, 121.09, 22.72),
		vec4(-468.31, 2070.74, 120.6, 15.32),
		vec4(-470.27, 2077.84, 120.35, 11.69),
		vec4(-471.51, 2084.36, 120.14, 11.01),
		vec4(-472.92, 2090.72, 120.1, 12.91),
	},
}

local currentPointIndex = 1

function lerp(a, b, t)
    return a + (b - a) * t
end

function calculateDistance(point1, point2)
    return Vdist(point1.x, point1.y, point1.z, point2.x, point2.y, point2.z)
end

function calculateHeadingDifference(heading1, heading2)
    local headingDiff = heading2 - heading1
    if headingDiff < -180.0 then
        headingDiff = headingDiff + 360.0
    elseif headingDiff > 180.0 then
        headingDiff = headingDiff - 360.0
    end
    return headingDiff
end

function spawnMinecart(coords)
    minecartEntity = makeProp({ prop = "k4mb1_minecart", coords = coords }, true, false)
	Wait(1000)
	AttachEntityToEntity(PlayerPedId(), minecartEntity, 20, 0.0, 0.10, 0.5, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
end

function moveMinecart(points)
    local speed = 5.0  -- Adjust the constant speed as needed
	Wait(3000)

    while true do
        local nextIndex = (currentPointIndex % #points) + 1
        local distance = calculateDistance(points[currentPointIndex], points[nextIndex])
        local timeToReachNextPoint = distance / speed

        local startTime = GetGameTimer()
        local endTime = startTime + timeToReachNextPoint * 1000

        while GetGameTimer() < endTime do
            local t = (GetGameTimer() - startTime) / (timeToReachNextPoint * 1000)
            local lerpedCoords = vec3(
                lerp(points[currentPointIndex].x, points[nextIndex].x, t),
                lerp(points[currentPointIndex].y, points[nextIndex].y, t),
                lerp(points[currentPointIndex].z, points[nextIndex].z, t)
            )

            local lerpedHeading = lerp(points[currentPointIndex].w, points[nextIndex].w, t)
            local headingDiff = calculateHeadingDifference(GetEntityHeading(minecartEntity), lerpedHeading)

            SetEntityCoordsNoOffset(minecartEntity, lerpedCoords.x, lerpedCoords.y, lerpedCoords.z, true, true, true)
            SetEntityHeading(minecartEntity, GetEntityHeading(minecartEntity) + headingDiff)

            Wait(0)
        end

		-- Check if it reached the last point and stop
		if currentPointIndex == #points -1 then
			destroyProp(minecartEntity)
			minecartEntity = nil
			currentPointIndex = 1
			break
		end
        currentPointIndex = nextIndex
    end
end

function mineCartMenu(ent, right)
	local Menu = {}
	local zadjust = 0.3
	if ent then
		Menu[#Menu+1] = {
			header = "Right Chamber",
			onSelect = function()
				local pointTable = {}
				for i = 1, #points["Main"] do pointTable[#pointTable+1] = vec4(points["Main"][i].x, points["Main"][i].y, points["Main"][i].z-zadjust, points["Main"][i].w) end
				for i = 1, #points["Right"] do pointTable[#pointTable+1] = vec4(points["Right"][i].x, points["Right"][i].y, points["Right"][i].z-zadjust, points["Right"][i].w) end
				spawnMinecart(pointTable[1])
				moveMinecart(pointTable)
			end,
		}
		Menu[#Menu+1] = {
			header = "Left Chamber",
			onSelect = function()
				local pointTable = {}
				for i = 1, #points["Main"] do pointTable[#pointTable+1] = vec4(points["Main"][i].x, points["Main"][i].y, points["Main"][i].z-zadjust, points["Main"][i].w) end
				for i = 1, #points["Left"] do pointTable[#pointTable+1] = vec4(points["Left"][i].x, points["Left"][i].y, points["Left"][i].z-zadjust, points["Left"][i].w) end
				spawnMinecart(pointTable[1])
				moveMinecart(pointTable)
			end,
		}
	else
		Menu[#Menu+1] = {
			header = "Return to Entrance",
			onSelect = function()
				local pointTable = {}
				if right then
					for i = #points["Right"], 1, -1 do pointTable[#pointTable+1] = vec4(points["Right"][i].x, points["Right"][i].y, points["Right"][i].z-zadjust, points["Right"][i].w-180) end
				else
					for i = #points["Left"], 1, -1 do pointTable[#pointTable+1] = vec4(points["Left"][i].x, points["Left"][i].y, points["Left"][i].z-zadjust, points["Left"][i].w-180) end
				end
				for i = #points["Main"], 1, -1 do pointTable[#pointTable+1] = vec4(points["Main"][i].x, points["Main"][i].y, points["Main"][i].z-zadjust, points["Main"][i].w-180) end
				spawnMinecart(pointTable[1])
				moveMinecart(pointTable)
			end,
		}
	end
	openMenu(Menu, {header = "Ride a Minecart", canClose = true})
end