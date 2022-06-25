fx_version 'bodacious'
game 'gta5'

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script "@Void-errorlog/client/cl_errorlog.lua"

client_script "client.lua"
client_script "client_casino.lua"
client_script "client_peds.lua"

--data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file 'HANDLING_FILE' 'handling.meta'

files {
--	'interiorproxies.meta',
	'handling.meta'
}

