fx_version 'cerulean'
game 'gta5'

author 'AI Collaborator'
description 'Advanced Modular Multi-Job Script using ox_lib'
version '1.1.0'

shared_scripts {
    'config.lua'
    'fxmanifest.lua' -- Ensure fxmanifest is included in shared scripts
    'readme.md' -- Optional: Include a readme for documentation
}

client_scripts {
    'client/client.lua' -- Added subfolder path
}

server_scripts {
    'server/server.lua' -- Added subfolder path
}

dependencies {
    'qb-core',
    'ox_lib'
}