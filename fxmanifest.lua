name "Jim-Mining"
author "Jimathy"
version "v2.4.3"
description "Mining Script By Jimathy"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua', 
    'shared/*.lua', 
    'locales/*.lua' 
}

server_script { 
    'framework/server/esx.lua',
    'framework/server/qb.lua',
    'server.lua' 
}

client_scripts { 
    'framework/client/esx.lua',
    'framework/client/qb.lua',
    'client.lua' 
}

