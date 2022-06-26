fx_version 'bodacious'
game 'gta5'

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@warp-errorlog/client/cl_errorlog.lua"

-- General
client_scripts {
  'client.lua',
  'client_trunk.lua',
  'cl_spikes.lua',
  'client_trunk.lua'
}

server_scripts {
  'server.lua'
}

exports {
	'getIsInService',
	'getIsCop',
	'getIsCuffed'
}