fx_version "cerulean"

games {"gta5"}

description "NoPixel Peek Interactions"

shared_scripts {
	"shared/sh_*.lua",
}

server_scripts {
	"server/sv_*.lua",
}

client_script "@mka-array/Array.lua"
client_script "@warp-lib/client/cl_ui.lua"

client_scripts {
	"client/cl_*.lua",
	'@warp-lib/client/cl_rpc.lua',
	"client/entries/cl_*.lua",
}