name "Mining"
author "Jimathy"
description "Mining Script By Jimathy"
fx_version "cerulean"
game "gta5"

dependencies {
	'qb-menu',
    'qb-target',
}

shared_scripts {
    '@qb-core/shared/locale.lua',
	'locales/en.lua',
	'config.lua'
}
client_scripts {
    'client.lua'
}

server_script {
    'server.lua'
}