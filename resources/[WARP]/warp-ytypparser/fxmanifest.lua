fx_version 'cerulean'
games {'gta5'}

-- dependency "warp-base"
-- dependency "ghmattimysql"


client_script "@warp-errorlog/client/cl_errorlog.lua"


client_script {
	'util/xml.lua',
	'client/ytyp/*',
	'client/cl_ytyp.lua',
	
}

exports {
	'request',
} 