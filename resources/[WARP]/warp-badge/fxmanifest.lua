fx_version 'bodacious'
game 'gta5'

ui_page {
    'html/ui.html',
}


client_scripts {
    'client/client.lua',
	'@warp-lib/client/cl_main.lua',
}


server_scripts {
	'@warp-lib/server/sv_main.lua',
    'server/server.lua',
}


files {
	'html/ui.html',
	'html/assets/*.png',
	'html/css/*.css',
	'html/js/*.js',

}