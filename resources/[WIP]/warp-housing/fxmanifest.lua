fx_version 'bodacious'
game 'gta5'

dependency "oxmysql"

client_scripts {
    '@warp-lib/client/cl_rpc.lua',
    '@warp-lib/client/cl_ui.lua',
    'client/cl_housing.lua',
}

server_scripts {
    '@warp-lib/server/sv_rpc.lua',
    '@warp-lib/server/sv_sql.lua',
	'server/sv_housing.lua',
}

export "retriveHousingTable"
exports {
    "checkForProperty",
    "attemptPurchase",
}