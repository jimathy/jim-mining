Config.Locations = {
    ["Washing"] = {
        Enable = true,
        positions = {
            { name = "Stone Washing", coords = vec3(1840.18, 412.42, 160.49), sprite = 467, col = 3, disp = 6, blipEnable = true }, -- Mountains
            { name = "Stone Washing", coords = vec3(1870.91, 395.1, 160.16), sprite = 467, col = 3, disp = 6, blipEnable = false },

            { name = "Stone Washing", coords = vec3(-432.59, 2936.84, 13.87), sprite = 467, col = 3, disp = 6, blipEnable = true }, -- Stream Blip
            { name = "Stone Washing", coords = vec3(-422.37, 2946.18, 13.77), sprite = 467, col = 3, blipEnable = false },
            { name = "Stone Washing", coords = vec3(-443.21, 2926.5, 13.62), sprite = 467, col = 3, blipEnable = false },
            { name = "Stone Washing", coords = vec3(-455.48, 2917.16, 13.52), sprite = 467, col = 3, blipEnable = false },

            { name = "Stone Washing", coords = vec3(2500.64, 6129.4, 162.46), sprite = 467, col = 3, disp = 6, blipEnable = true }, -- Gordo

            { name = "Stone Washing", coords = vec3(907.06, 4377.66, 30.28), sprite = 467, col = 3, disp = 6, blipEnable = true }, -- Alamo Sea
            { name = "Stone Washing", coords = vec3(894.14, 4386.56, 30.24), sprite = 467, col = 3, blipEnable = false },
            { name = "Stone Washing", coords = vec3(893.12, 4370.74, 30.35), sprite = 467, col = 3, blipEnable = false },
            { name = "Stone Washing", coords = vec3(912.88, 4365.7, 30.39), sprite = 467, col = 3, blipEnable = false },
        },
    },
    ["Panning"] = {
        Enable = true,
        positions = {
            ["Vineyard"] = {
                Enable = true,
                Blip = { -- The location where you enter the mine
                    Enable = true,
                    name = "Gold Panning",
                    coords = vector3(-1410.58, 2005.91, 59.4),
                    sprite = 467, col = 5,
                },
                Positions = {
                    { coords = vector4(-1396.3, 2004.59, 53.59, 82.0), w = 22.1, d = 4.0 },
                    { coords = vector4(-1410.08, 2006.08, 48.8, 89.0), w = 6.3, d = 4.2 },
                    { coords = vector4(-1418.62, 2006.05, 48.41, 89.0), w = 10.9, d = 6.0 },
                }
            },
            ["Tongva"] = {
                Enable = true,
                Blip = { -- The location where you enter the mine
                    Enable = true,
                    name = "Gold Panning",
                    coords = vector3(-1550.06, 1445.13, 116.37),
                    sprite = 467, col = 5,
                },
                Positions = {
                    { coords = vector4(-1550.06, 1445.13, 106.37, 139.0), w = 10.9, d = 6.0 },
                    { coords = vector4(-1562.88, 1434.03, 107.19, 129.0), w = 24.3, d = 6.0 },
                }
            },
            ["Wilderness"] = {
                Enable = true,
                Blip = { -- The location where you enter the mine
                    Enable = true,
                    name = "Gold Panning",
                    coords = vector3(-870.24, 4424.14, 15.37),
                    sprite = 467, col = 5,
                },
                Positions = {
                    { coords = vector4(-870.24, 4424.14, 10.37, 129.0), w = 25.1, d = 19.8 },
                }
            },
        },
    },
	['JewelBuyer'] = { -- The Location of the jewel buyer, I left this as Vangelico, others will proabably change to pawn shops
        Enable = true,
        positions = {
            { name = "Jewel Buyer", coords = vec4(-629.86, -240.35, 38.16, 110.05), sprite = 527, col = 617, blipTrue = false, model = `S_M_M_HighSec_03`, scenario = "WORLD_HUMAN_CLIPBOARD", },
        },
    },
    ["Smelting"] = {
        { name = "Foundary", coords = vec3(1112.29, -2009.9, 31.46), sprite = 436, col = 1, blipTrue = false, },
    },

    ["Mines"] = {
        ["Foundary"] = {
            Enable = true,
            Blip = { -- The location where you enter the mine
                Enable = true,
                name = "Foundary",
                coords = vec4(1074.89, -1988.19, 30.89, 235.07),
                sprite = 436, col = 1,
            },
            Lights = {
                Enable = true,
                prop = "prop_worklight_02a",
                positions = {
                    vec4(1106.46, -1991.44, 31.49, 185.78),
                },
            },
            Store = {
                { name = "Foundary Store", coords = vec4(1074.89, -1988.19, 30.89, 235.07), model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
            },
            Smelting = {
                { blipEnable = true, name = "Foundary", coords = vec3(1112.29, -2009.9, 31.46), sprite = 436, col = 1,  },
            },
            Cracking = {
                { blipEnable = false, name = "Stone Cracking", coords = vec4(1109.19, -1992.8, 30.98, 146.88), sprite = 566, col = 81, prop = "prop_vertdrill_01" },
                { blipEnable = false, name = "Stone Cracking", coords = vec4(1105.56, -1992.53, 30.94, 238.19), sprite = 566, col = 81, prop = "prop_vertdrill_01" },
            },
            OreBuyer = {
                { blipEnable = false, name = "Ore Buyer", coords = vec4(1090.18, -1999.51, 30.93, 146.24), sprite = 568, col = 81, model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
            },
            JewelCut = {
                { blipEnable = false, name = "Jewel Cutting", coords = vec4(1077.11, -1984.22, 31.02, 235.8), sprite = 566, col = 81, prop = `gr_prop_gr_speeddrill_01c` },
                { blipEnable = false, name = "Jewel Cutting", coords = vec4(1075.19, -1985.45, 30.92, 144.89), sprite = 566, col = 81, prop = `gr_prop_gr_speeddrill_01c` },
            },
        },
        ["MineShaft"] = {
            Enable = true,
            Job = nil,
            Blip = {
                Enable = true,
                name = "Mine Shaft",
                coords = vec4(-596.74, 2090.99, 131.41, 16.6),
                sprite = 527,
                col = 81,
            },
            Store = {
                { name = "Mine", coords = vec4(-594.96, 2091.3, 131.47, 67.65), model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD",  },
            },
            Lights = {
                Enable = true,
                prop = "prop_worklight_02a",
                positions = {
                    vec4(-593.29, 2093.22, 131.7, 110.0),
                    vec4(-604.55, 2089.74, 131.15, 300.0),
                    vec4(-593.9, 2076.57, 131.27, 233.24),
                    vec4(-594.11, 2078.02, 131.3, 318.99),
                    vec4(-592.11, 2069.46, 131.13, 224.91),
                    vec4(-590.57, 2062.08, 130.8, 214.27),
                    vec4(-589.57, 2054.82, 130.27, 217.82),
                    vec4(-588.04, 2047.13, 129.65, 230.42),
                    vec4(-584.95, 2039.96, 129.06, 225.12),
                    vec4(-580.74, 2033.34, 128.47, 237.95),
                    vec4(-576.23, 2027.24, 127.98, 242.31),
                    vec4(-570.87, 2021.57, 127.5, 244.01),
                    vec4(-565.69, 2015.97, 127.33, 251.45),
                    vec4(-561.05, 2010.26, 127.1, 248.45),
                    vec4(-557.0, 2003.95, 127.05, 242.28),
                    vec4(-553.02, 1997.25, 126.99, 237.0),
                    vec4(-549.29, 1990.84, 126.94, 224.48),
                    vec4(-537.3, 1980.52, 126.9, 278.19),
                    vec4(-529.79, 1979.09, 126.86, 295.72),
                    vec4(-522.13, 1978.13, 126.59, 282.3),
                    vec4(-514.44, 1977.77, 126.29, 297.0),
                    vec4(-506.72, 1978.01, 126.02, 296.09),
                    vec4(-498.89, 1979.11, 125.65, 316.07),
                    vec4(-491.77, 1981.93, 124.82, 320.17),
                    vec4(-484.83, 1984.85, 124.17, 328.43),
                    vec4(-477.71, 1987.12, 123.83, 290.95),
                    vec4(-470.33, 1990.0, 123.57, 307.32),
                    vec4(-463.85, 1994.29, 123.46, 327.1),
                    vec4(-458.09, 1999.59, 123.47, 338.54),
                    vec4(-445.97, 2011.57, 123.4, 308.83),
                },
            },
            OrePositions = {
                vector4(-589.25, 2050.53, 130.11, 127.33),
                vec4(-580.30, 2037.82, 128.8, 300.0),
                vec4(-572.68, 2022.37, 127.93, 130.0),
                vec4(-563.0, 2011.85, 127.45, 130.0),
                vec4(-548.99, 1996.56, 127.28, 300.95),
                --DEEP
                vec4(-534.22, 1982.9, 127.18, 340.95),
                vec4(-531.53, 1978.88, 127.35, 170.95),
                vec4(-523.71, 1981.21, 126.75, 340.95),
                vec4(-516.25, 1977.32, 126.49, 170.95),
                vec4(-506.58, 1980.66, 126.14, 0.95),
                vec4(-499.52, 1981.87, 125.88, 0.95),
                vec4(-488.44, 1982.74, 124.64, 200.95),
                vec4(-469.78, 1993.57, 123.86, 20.95),
                vec4(-458.53, 2003.33, 123.73, 30.95),
            },
        },
        ["Quarry"] = {
            Enable = true,
            Job = nil,
            Blip = {
                Enable = true,
                name = "Quarry",
                coords = vec4(2960.9, 2754.14, 43.71, 204.58),
                sprite = 527,
                col = 81,
            },
            Store = {
                { name = "Quarry", coords = vec4(2960.9, 2754.14, 43.71, 204.58), model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD",  },
            },
            Lights = {
                Enable = true,
                prop = "prop_worklight_03a",
                positions = {
                    vec4(2991.59, 2758.07, 42.68, 250.85),
                    vec4(2991.11, 2758.02, 42.66, 194.6),
                    vec4(2971.78, 2743.33, 43.29, 258.54),
                    vec4(2998.0, 2767.45, 42.71, 249.22),
                    vec4(2959.93, 2755.26, 43.71, 164.24),
                },
            },
            OrePositions = {
                vec4(2977.54, 2741.26, 44.74, 240.0),
                vec4(2980.37, 2748.7, 43.2, 210.0),
                vec4(2985.62, 2751.35, 43.26, 200.0),
                vec4(2990.45, 2750.6, 43.6, 150.0),

                vec4(3000.77, 2754.15, 43.7, 220.0),
                vec4(3004.89, 2762.88, 43.74, 240.0),

                vec4(3006.38, 2768.63, 42.79, 270.0),
                vec4(3005.94, 2773.78, 42.51, 270.0),
            },
        },
        ["K4MB1"] = { -- K4MB1's Mineshaft in the quarry
            Enable = false,
            Job = nil,
            Blip = {
                Enable = true,
                name = "Mining Cave",
                coords = vec4(2937.98, 2744.81, 43.28, 281.59),
                sprite = 527,
                col = 81,
            },
            Store = {
                { name = "Cave Shop", coords = vec4(2908.8, 2643.6, 43.26, 328.32), model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
            },
            Smelting = {
                { blipEnable = true, name = "Smelter", coords = vec3(2921.81, 2653.42, 43.15), sprite = 436, col = 1, },
            },
            Cracking = {
                { name = "Stone Cracking", coords = vec4(2914.9, 2650.78, 43.08, 231.77), sprite = 566, col = 81, blipTrue = false, prop = `prop_vertdrill_01` }, -- Foundary
                { name = "Stone Cracking", coords = vec4(2914.61, 2649.06, 43.19, 272.74), sprite = 566, col = 81, blipTrue = false, prop = `prop_vertdrill_01` }, -- Foundary
            },
            OreBuyer = {
                { blipEnable = true, name = "Ore Buyer", coords = vec4(2917.79, 2646.26, 43.17, 6.14), sprite = 568, col = 81,model = `G_M_M_ChemWork_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
            },
            JewelCut = {
                { blipEnable = true, name = "Jewel Cutting", coords = vec4(2917.45, 2654.24, 43.03, 229.61), sprite = 566, col = 81, prop = `gr_prop_gr_speeddrill_01c` },
                { blipEnable = true, name = "Jewel Cutting", coords = vec4(2919.89, 2656.36, 43.15, 199.99), sprite = 566, col = 81, prop = `gr_prop_gr_speeddrill_01c` },
            },
            OrePositions = {
                vec4(2906.33, 2736.05, 43.85, 30.0),
                vec4(2906.98, 2732.64, 43.47, 210.42),
                vec4(2895.62, 2718.17, 44.25, 90.59),
                vec4(2909.86, 2707.41, 44.63, 90.57),
                vec4(2930.71, 2693.23, 46.09, 240.69),
                vec4(2909.24, 2692.78, 47.27, 125.55),
                vec4(2908.31, 2695.83, 46.5, 25.8),
                vec4(2903.37, 2676.71, 45.94, 290.38),
                vec4(2890.67, 2679.4, 45.05, 120.51),
                vec4(2892.67, 2701.3, 49.89, 270.39),
                vec4(2876.93, 2707.35, 49.4, 10.29),
                vec4(2866.0, 2677.71, 47.3, 230.85),
                vec4(2859.24, 2668.93, 45.27, 270.51),
                vec4(2858.36, 2663.24, 45.0, 250.02),
                vec4(2864.22, 2665.22, 48.21, 140.18),
                vec4(2868.6, 2669.71, 47.88, 5.38),
                vec4(2900.65, 2684.42, 47.24, 33.73),
                vec4(2878.67, 2686.09, 47.72, 170.0),

                vec4(2888.64, 2634.32, 42.04, 190.17),
                vec4(2879.55, 2650.2, 43.89, 0.79),
                vec4(2896.12, 2648.21, 40.65, 320.66),
                vec4(2808.16, 2650.5, 38.2, 40.41),
                vec4(2792.43, 2640.55, 39.45, 125.72),
                vec4(2793.02, 2632.56, 39.91, 70.98),
                vec4(2799.6, 2629.83, 40.89, 180.92),
                vec4(2812.67, 2633.02, 40.79, 160.98),

                vec4(2817.65, 2590.74, 32.64, 121.44),
                vec4(2835.04, 2600.4, 34.93, 215.07),
                vec4(2837.77, 2605.3, 35.40, 300.09),

                vec4(2819.55, 2606.31, 38.08, 59.71),
                vec4(2823.73, 2611.07, 38.3, 49.71),
                vec4(2827.98, 2611.26, 34.15, 40.74),
            },
        },
        --["NewLocation"] = {
        --    Enable = false,
        --    Job = nil,
        --    Blip = { },
        --    Store = { },
        --    Smelting = { },
        --    Cracking = { },
        --    OreBuyer = { },
        --    JewelCut = { },
        --    OrePositions = {  },
        --},
    },
}
