fx_version 'cerulean'

games {
  'gta5',
  'rdr3'
}

client_scripts {
  '@warp-lib/client/cl_main.lua',
	'client/cl_*.lua'
}

shared_scripts {
	"shared/*.lua"
}

server_scripts {
  '@warp-lib/client/sv_main.lua',
	'server/*.lua'
}