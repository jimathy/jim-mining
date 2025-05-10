name "Jim-Mining"
author "Jimathy"
version "3.0.04"
description "Mining Script"
fx_version "cerulean"
game "gta5"
lua54 'yes'

server_script '@oxmysql/lib/MySQL.lua'

shared_scripts {
	'locales/*.lua',
	'config.lua',

    --Jim Bridge - https://github.com/jimathy/jim-bridge
    '@jim_bridge/starter.lua',

	'shared/*.lua',
}
client_scripts {
    'client.lua'
}

server_script 'server.lua'

dependency 'jim_bridge'