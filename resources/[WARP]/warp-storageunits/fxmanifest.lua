fx_version "cerulean"

games {"gta5"}

description ""

version "1.0.0"

server_script '@warp-lib/server/sv_main.lua'
client_script '@warp-lib/client/cl_main.lua'


client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

