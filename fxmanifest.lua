fx_version 'cerulean'
game 'gta5'

description 'ML NPC Density Reducer with In-Game Menu - Fully configurable'
author 'ml (edited by Grok)'
version '1.1.0'

shared_script 'config.lua'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

lua54 'yes'

dependencies {
    'qb-core'
}