# jim-mining
FiveM Custom mining script by me from scratch

- Highly customisable via `locations.lua`
  - Locations are easily changeable/removable

- Features several ways to get materials
  - Gold Panning - Search specified streams for gold and silver, or trash
  - Mining - Mine to get stones that can be wash or cracked for materials
  - Stone Washing - Wash stone to find rare gems or gold
  - Stone Cracking - Crack open stones to find ores for crafting materials

- Customisable points for mining, stone cracking and gold panning
  - Add a Location for an ore to the config and it will use this location for both qb-target and a prop
  - Can place them anywhere, doesn't have to be just one mining location
  - I opted for a drilling animation as opposed to the pickaxe swinging
  - Nicely animated for better immersion

- NPC's spawn on the blip locations
  - These locations can also give third eye and select ones have context menus for selling points

- NPC's and ore's Spawn at Mineshaft + Quarry so your players can go to either

- Features simplistic built in crafting that uses recipes in the config.lua

- Features Jewel Cutting bench as an attempt to add more than just gold bars and such to sell
  - You can use your gold bars and jewels to craft other items to sell to a Jewellery Buyer

## Video Previews
- Mineshaft Store: https://streamable.com/voay5z
- Multiple ways to mine ore: https://streamable.com/ui5dn2
- Gold Panning: https://streamable.com/zdjluz
- Stone Cracking: https://streamable.com/e6j8h0
- Stone Washing: https://streamable.com/rafnzt
- Smelting Menu: https://streamable.com/sejgfp
- Selling Ore: https://streamable.com/sjbmbo
- Gem Cutting & Jewellery Crafting: https://streamable.com/nmdntz
- Gem and Jewellery Buyer: https://streamable.com/t2jfzc
- K4MB1- Cave Support: https://streamable.com/5hivk9

## Custom Items & Images
  ![General](https://i.imgur.com/g8nqbvN.jpeg)

- Should be easy to understand and add/remove items you want or not
## Dependencies
- [`jim_bridge`](https://github.com/jimathy/jim_bridge)
- `qb-menu`/`ox_lib` - for the menus
- `qb-target`/`ox_target` - for the third eye selection

# How to install
## QB Install:
If you want to use your own items or repurpose this script:
- Create a folder named `[jim]` in your `[resources]` folder
- Place `jim-mining` your resources folder
- (Remove -main from the folder name if you haven't already)
- Add the following code to your `server.cfg/resources.cfg` BELOW `[qb]`
```
ensure [jim]
```
If you want to use the items already set in the script:

- Add the images to your inventory folder
	- qb-inventory: `[qb]/qb-inventory/html/images`

- Put these lines in your `[qb]/qb-core/shared/items.lua`

```lua
-- jim-mining stuff
stone = { name = "stone", label = "Stone", weight = 2000, type = "item", image = "stone.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "Stone woo" },

uncut_emerald = { name = "uncut_emerald", label = "Uncut Emerald", weight = 100, type = "item", image = "uncut_emerald.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A rough Emerald" },
uncut_ruby = { name = "uncut_ruby", label = "Uncut Ruby", weight = 100, type = "item", image = "uncut_ruby.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A rough Ruby" },
uncut_diamond = { name = "uncut_diamond", label = "Uncut Diamond", weight = 100, type = "item", image = "uncut_diamond.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A rough Diamond"},
uncut_sapphire = { name = "uncut_sapphire", label = "Uncut Sapphire", weight = 100, type = "item", image = "uncut_sapphire.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A rough Sapphire"},

emerald = { name = "emerald", label = "Emerald", weight = 100, type = "item", image = "emerald.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A Emerald that shimmers" },
ruby = { name = "ruby", label = "Ruby", weight = 100, type = "item", image = "ruby.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A Ruby that shimmers" },
diamond = { name = "diamond", label = "Diamond", weight = 100, type = "item", image = "diamond.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A Diamond that shimmers" },
sapphire = { name = "sapphire", label = "Sapphire", weight = 100, type = "item", image = "sapphire.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A Sapphire that shimmers" },

gold_ring = { name = "gold_ring", label = "Gold Ring", weight = 200, type = "item", image = "gold_ring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
diamond_ring = { name = "diamond_ring", label = "Diamond Ring", weight = 200, type = "item", image = "diamond_ring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
ruby_ring = { name = "ruby_ring", label = "Ruby Ring", weight = 200, type = "item", image = "ruby_ring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
sapphire_ring = { name = "sapphire_ring", label = "Sapphire Ring", weight = 200, type = "item", image = "sapphire_ring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},
emerald_ring = { name = "emerald_ring", label = "Emerald Ring", weight = 200, type = "item", image = "emerald_ring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},

silver_ring = { name = "silver_ring", label = "Silver Ring", weight = 200, type = "item", image = "silver_ring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
diamond_ring_silver = { name = "diamond_ring_silver", label = "Diamond Ring Silver", weight = 200, type = "item", image = "diamond_ring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},
ruby_ring_silver = { name = "ruby_ring_silver", label = "Ruby Ring Silver", weight = 200, type = "item", image = "ruby_ring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},
sapphire_ring_silver = { name = "sapphire_ring_silver", label = "Sapphire Ring Silver", weight = 200, type = "item", image = "sapphire_ring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},
emerald_ring_silver = { name = "emerald_ring_silver", label = "Emerald Ring Silver", weight = 200, type = "item", image = "emerald_ring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil,   description = ""},

goldchain = { name = "goldchain", label = "Golden Chain", weight = 200, type = "item", image = "goldchain.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
diamond_necklace = { name = "diamond_necklace", label = "Diamond Necklace", weight = 200, type = "item", image = "diamond_necklace.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
ruby_necklace = { name = "ruby_necklace", label = "Ruby Necklace", weight = 200, type = "item", image = "ruby_necklace.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
sapphire_necklace = { name = "sapphire_necklace", label = "Sapphire Necklace", weight = 200, type = "item", image = "sapphire_necklace.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
emerald_necklace = { name = "emerald_necklace", label = "Emerald Necklace", weight = 200, type = "item", image = "emerald_necklace.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },

silverchain = { name = "silverchain", label = "Silver Chain", weight = 200, type = "item", image = "silverchain.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
diamond_necklace_silver = { name = "diamond_necklace_silver", label = "Diamond Necklace Silver", weight = 200, type = "item", image = "diamond_necklace_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
ruby_necklace_silver = { name = "ruby_necklace_silver", label = "Ruby Necklace Silver", weight = 200, type = "item", image = "ruby_necklace_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil,   description = "" },
sapphire_necklace_silver = { name = "sapphire_necklace_silver", label = "Sapphire Necklace Silver", weight = 200, type = "item", image = "sapphire_necklace_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},
emerald_necklace_silver = { name = "emerald_necklace_silver", label = "Emerald Necklace Silver", weight = 200, type = "item", image = "emerald_necklace_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},

goldearring = { name = "goldearring", label = "Golden Earrings", weight = 200, type = "item", image = "gold_earring.png", unique = false, useable = false, 	shouldClose = false, combinable = nil, description = ""},
diamond_earring = { name = "diamond_earring", label = "Diamond Earrings", weight = 200, type = "item", image = "diamond_earring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = ""},
ruby_earring = { name = "ruby_earring", label = "Ruby Earrings", weight = 200, type = "item", image = "ruby_earring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
sapphire_earring = { name = "sapphire_earring", label = "Sapphire Earrings", weight = 200, type = "item", image = "sapphire_earring.png", unique = false, useable = false, shouldClose = false, combinable = nil,   description = "" },
emerald_earring = { name = "emerald_earring", label = "Emerald Earrings", weight = 200, type = "item", image = "emerald_earring.png", unique = false, useable = false, shouldClose = false, combinable = nil,   description = "" },

silverearring = { name = "silverearring", label = "Silver Earrings", weight = 200, type = "item", image = "silver_earring.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
diamond_earring_silver = { name = "diamond_earring_silver", label = "Diamond Earrings Silver", weight = 200, type = "item", image = "diamond_earring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
ruby_earring_silver = { name = "ruby_earring_silver", label = "Ruby Earrings Silver", weight = 200, type = "item", image = "ruby_earring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
sapphire_earring_silver = { name = "sapphire_earring_silver", label = "Sapphire Earrings Silver", weight = 200, type = "item", image = "sapphire_earring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
emerald_earring_silver = { name = "emerald_earring_silver", label = "Emerald Earrings Silver", weight = 200, type = "item", image = "emerald_earring_silver.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },

carbon = { name = "carbon", label = "Carbon", weight = 1000, type = "item", image = "carbon.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "Carbon, a base ore." },
ironore = { name = "ironore", label = "Iron Ore", weight = 1000, type = "item", image = "ironore.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "Iron, a base ore." },
copperore = { name = "copperore", label = "Copper Ore", weight = 1000, type = "item", image = "copperore.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "Copper, a base ore." },
goldore = { name = "goldore", label = "Gold Ore", weight = 1000, type = "item", image = "goldore.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "Gold Ore" },
silverore = { name = "silverore", label = "Silver Ore", weight = 1000, type = "item", image = "silverore.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "Silver Ore" },

goldingot = { name = "goldingot", label = "Gold Ingot", weight = 1000, type = "item", image = "goldingot.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
silveringot = { name = "silveringot", label = "Silver Ingot", weight = 1000, type = "item", image = "silveringot.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },

pickaxe = { name = "pickaxe", label = "Pickaxe", weight = 1000, type = "item", image = "pickaxe.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
miningdrill = { name = "miningdrill", label = "Mining Drill", weight = 1000, type = "item", image = "miningdrill.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
mininglaser = { name = "mininglaser", label = "Mining Laser", weight = 900, type = "item", image = "mininglaser.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },
drillbit = { name = "drillbit", label = "Drill Bit", weight = 10, type = "item", image = "drillbit.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },

goldpan = { name = "goldpan", label = "Gold Panning Tray", weight = 10, type = "item", image = "goldpan.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "" },

bottle = { name = "bottle", label = "Empty Bottle", weight = 10, type = "item", image = "bottle.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "A glass bottle" },
can = { name = "can", label = "Empty Can", weight = 10, type = "item", image = "can.png", unique = false, useable = false, shouldClose = false, combinable = nil, description = "An empty can, good for recycling" },
```


## OX_Inv Install:
If you want to use your own items or repurpose this script:
- Create a folder named `[jim]` in your `[resources]` folder
- Place `jim-mining` your resources folder
- (Remove -main from the folder name if you haven't already)
- Add the following code to your `server.cfg/resources.cfg` BELOW `[ox]`
```
ensure [jim]
```
If you want to use the items already set in the script:

- Add the images to your inventory folder
	- qb-inventory: `[ox]/ox_inventory/web/images`

- Put these lines in your `[ox]/ox_inventory/data/items.lua`
```lua
    bottle = {
        name = "bottle",
        label = "Empty Bottle",
        weight = 10,
        client = {
            image = "bottle.png",
        }
    },
    can = {
        name = "can",
        label = "Empty Can",
        weight = 10,
        client = {
            image = "can.png",
        }
    },

    -- Jim-mining stuff
    stone = {
		label = "Stone",
		weight = 2000,
		stack = true,
		close = false,
		description = "Stone woo",
		client = {
			image = "stone.png",
		}
	},

    uncut_emerald = {
		label = "Uncut Emerald",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Emerald",
		client = {
			image = "uncut_emerald.png",
		}
	},
    uncut_ruby = {
		label = "Uncut Ruby",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Ruby",
		client = {
			image = "uncut_ruby.png",
		}
	},
    uncut_diamond = {
		label = "Uncut Diamond",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Diamond",
		client = {
			image = "uncut_diamond.png",
		}
	},
	uncut_sapphire = {
		label = "Uncut Sapphire",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Sapphire",
		client = {
			image = "uncut_sapphire.png",
		}
	},

    emerald = {
		label = "Emerald",
		weight = 150,
		stack = true,
		close = false,
		description = "A shiny Emerald gemstone!",
		client = {
			image = "emerald.png",
		}
	},
    ruby = {
		label = "Ruby",
		weight = 150,
		stack = true,
		close = false,
		description = "A shiny Ruby gemstone!",
		client = {
			image = "ruby.png",
		}
	},
    diamond = {
		label = "Diamond",
		weight = 150,
		stack = true,
		close = false,
		description = "A shiny Diamond gemstone!",
		client = {
			image = "diamond.png",
		}
	},
    sapphire = {
		label = "Sapphire",
		weight = 150,
		stack = true,
		close = false,
		description = "A shiny Sapphire gemstone!",
		client = {
			image = "sapphire.png",
		}
	},

    gold_ring = {
		label = "Gold Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "gold_ring.png",
		}
	},
    diamond_ring = {
		label = "Diamond Ring",
		weight = 136,
		stack = true,
		close = true,
		description = "A diamond ring seems like the jackpot to me!",
		client = {
			image = "diamond_ring.png",
		}
	},
    ruby_ring = {
		label = "Ruby Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_ring.png",
		}
	},
    sapphire_ring = {
		label = "Sapphire Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_ring.png",
		}
	},
    emerald_ring = {
		label = "Emerald Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_ring.png",
		}
	},

    silver_ring = {
		label = "Silver Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silver_ring.png",
		}
	},
    diamond_ring_silver = {
		label = "Diamond Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_ring_silver.png",
		}
	},
    ruby_ring_silver = {
		label = "Ruby Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_ring_silver.png",
		}
	},
	sapphire_ring_silver = {
		label = "Sapphire Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "A sparkling ring of sapphire.",
		client = {
			image = "sapphire_ring_silver.png",
		}
	},
	emerald_ring_silver = {
		label = "Emerald Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_ring_silver.png",
		}
	},
	goldchain = {
		label = "Golden Chain",
		weight = 226,
		stack = true,
		close = true,
		description = "A golden chain seems like the jackpot to me!",
		client = {
			image = "goldchain.png",
		}
	},
	diamond_necklace = {
		label = "Diamond Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_necklace.png",
		}
	},
	ruby_necklace = {
		label = "Ruby Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_necklace.png",
		}
	},
	sapphire_necklace = {
		label = "Sapphire Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_necklace.png",
		}
	},
	emerald_necklace = {
		label = "Emerald Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_necklace.png",
		}
	},


	silverchain = {
		label = "Silver Chain",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silverchain.png",
		}
	},
	diamond_necklace_silver = {
		label = "Diamond Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_necklace_silver.png",
		}
	},
	ruby_necklace_silver = {
		label = "Ruby Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_necklace_silver.png",
		}
	},
	sapphire_necklace_silver = {
		label = "Sapphire Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_necklace_silver.png",
		}
	},
	emerald_necklace_silver = {
		label = "Emerald Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_necklace_silver.png",
		}
	},

	goldearring = {
		label = "Golden Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "Golden earrings for your Golden Girl",
		client = {
			image = "gold_earring.png",
		}
	},
	diamond_earring = {
		label = "Diamond Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_earring.png",
		}
	},
	ruby_earring = {
		label = "Ruby Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_earring.png",
		}
	},
	sapphire_earring = {
		label = "Sapphire Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_earring.png",
		}
	},
	emerald_earring = {
		label = "Emerald Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_earring.png",
		}
	},

	silverearring = {
		label = "Silver Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silver_earring.png",
		}
	},
	diamond_earring_silver = {
		label = "Diamond Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_earring_silver.png",
		}
	},
	ruby_earring_silver = {
		label = "Ruby Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_earring_silver.png",
		}
	},
	sapphire_earring_silver = {
		label = "Sapphire Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_earring_silver.png",
		}
	},
	emerald_earring_silver = {
		label = "Emerald Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_earring_silver.png",
		}
	},
    carbon = {
        label = "Carbon",
        weight = 1000,
        stack = true,
        close = false,
        description = "Carbon, a base ore.",
        client = {
            image = "carbon.png",
        }
    },
    ironore = {
        label = "Iron Ore",
        weight = 1000,
        stack = true,
        close = false,
        description = "Iron, a base ore.",
        client = {
            image = "ironore.png",
        }
    },
    copperore = {
        label = "Copper Ore",
        weight = 1000,
        stack = true,
        close = false,
        description = "Copper, a base ore.",
        client = {
            image = "copperore.png",
        }
    },
    goldore = {
        label = "Gold Ore",
        weight = 1000,
        stack = true,
        close = false,
        description = "Gold Ore",
        client = {
            image = "goldore.png",
        }
    },
    silverore = {
        label = "Silver Ore",
        weight = 1000,
        stack = true,
        close = false,
        description = "Silver Ore",
        client = {
            image = "silverore.png",
        }
    },
    goldingot = {
        label = "Gold Ingot",
        weight = 1000,
        stack = true,
        close = false,
        description = "",
        client = {
            image = "goldingot.png",
        }
    },
    silveringot = {
        label = "Silver Ingot",
        weight = 1000,
        stack = true,
        close = false,
        description = "",
        client = {
            image = "silveringot.png",
        }
    },
	pickaxe = {
		label = "Pickaxe",
		weight = 1000,
		stack = false,
		close = false,
		description = "",
		client = {
			image = "pickaxe.png",
		}
	},
	miningdrill = {
		label = "Mining Drill",
		weight = 1000,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "miningdrill.png",
		}
	},
	mininglaser = {
		label = "Mining Laser",
		weight = 900,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "mininglaser.png",
		}
	},
	drillbit = {
		label = "Drill Bit",
		weight = 10,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "drillbit.png",
		}
	},
	goldpan = {
		label = "Gold Panning Tray",
		weight = 10,
		stack = true,
		close = false,
		description = "Don't worry you'll hit gold eventually!",
		client = {
			image = "goldpan.png",
		}
	},
```