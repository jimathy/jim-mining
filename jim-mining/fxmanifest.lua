name "Mining"
author "Jimathy"
description "Mining Script By Jimathy"
fx_version "cerulean"
game "gta5"

this_is_a_map 'yes'

dependencies {
	'qb-menu',
    'qb-target',
}

client_scripts {
    'client.lua',
    'config.lua',
}

server_script {
    'server.lua',
    'config.lua',
}