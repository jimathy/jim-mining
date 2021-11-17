# jim-mining
FiveM Custom mining script by me
First script created by me from scratch

After deving for a month on a server of messed up and mismatched scripts...I've learn't to do things in a tidy and dynamic way that most don't.

- Highly customisable via config.lua
- Customisable points for mining
  - Add a Location for an ore to the config and it will use this location for both bt-target and a prop
  - Can place them anywhere, doesn't have to be just one mining location
  - I opted for a drilling animation as opposed to the pickaxe swinging

- NPC's spawn on the blip locations
  - These locations can also give third eye and select ones have context menus for selling points

- Features simplistic crafting that doesnt need another system
  - Simple "take this item, give this item" crafting

- Features Stone Cracking bench to fend off to the often used "Throw the rocks in smelter and magically organise ores"
- Features Jewel cutting bench as an attempt to add more than just gold bars and such to sell

## Dependencies
- nh-context - for the menus
- bt-target - for the third eye selection

## How to install
# Minimal
- Place in your resources folder
- add the following code to your server.cfg/resources.cfg
```
ensure jim-mining
```
- If you don't want to add my items and repurpose this with your own items ignore the bottom part
- If you want to use my items then:
## Put this in your shared.lua if you want to add and use the items

```
["uncut_emerald"] 				 = {["name"] = "uncut_emerald", 			  	["label"] = "Uncut Emerald", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "uncut_emerald.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "A rough Emerald"},
	["uncut_ruby"] 					 = {["name"] = "uncut_ruby", 			  	  	["label"] = "Uncut Ruby", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "uncut_ruby.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "A rough ruby"},
	["uncut_diamond"] 				 = {["name"] = "uncut_diamond", 			  	["label"] = "Uncut Diamond", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "uncut_diamond.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "A rough diamond"},

	["emerald"] 					 = {["name"] = "emerald", 			  	  		["label"] = "Emerald", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "emerald.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "A Emerald that shimmers"},
	["ruby"] 					 	 = {["name"] = "ruby", 			  	  			["label"] = "Ruby", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "emerald.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "A Ruby that shimmers"},
	["diamond"] 					 = {["name"] = "Diamond", 			  	  		["label"] = "Diamond", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "emerald.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "A Diamond that shimmers"},

	["gold_ring"] 					 = {["name"] = "gold_ring", 			  	  	["label"] = "Gold Ring", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "diamond_ring.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "A gold ring seems like the jackpot to me!"},
	["diamond_ring"] 				 = {["name"] = "diamond_ring", 			  	  	["label"] = "Diamond Ring", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "diamond_ring.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "A diamond ring seems like the jackpot to me!"},
	["goldchain"] 				 	 = {["name"] = "goldchain", 			  	  	["label"] = "Golden Chain", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "goldchain.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "A golden chain seems like the jackpot to me!"},
	["10kgoldchain"] 				 = {["name"] = "10kgoldchain", 			  	  	["label"] = "10k Gold Chain", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "10kgoldchain.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "10 karat golden chain."},

	["carbon"] 					 	 = {["name"] = "carbon", 			  	  		["label"] = "Carbon", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "carbon.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "Carbon, a base ore."},
	["ironore"] 					 = {["name"] = "ironore", 			  	  		["label"] = "Iron Ore", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "ironore.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "Iron, a base ore."},
	["copperore"] 					 = {["name"] = "copperore", 			  	  	["label"] = "Copper Ore", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "copperore.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "Copper, a base ore."},
	["goldore"] 					 = {["name"] = "goldore", 			  	  		["label"] = "Gold Ore", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "goldore.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "Gold Ore"},
```
