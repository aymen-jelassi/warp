fx_version 'bodacious'
game 'gta5'
description 'warp Phone'
version 'The Best'

ui_page 'html/ui.html'

dependency "oxmysql"


files {
	'html/css/balloon.min.css',
	'html/css/all.min.css',
	'html/ui.html',
	'html/css/materialize.min.css',
	'html/css/style.css',
	'html/js/materialize.min.js',
	'html/js/debounce.min.js',
	'html/js/moment.min.js',
	'html/js/script.js',
	'html/images/cursor.png',
	'html/images/background.png',	
	'html/images/phone-shell.png',
	'html/images/phone-background.jpg',
	'html/images/gurgle.png',
	'html/images/pager.png',
	'html/webfonts/fa-brands-400.eot',
	'html/webfonts/fa-brands-400.svg',
	'html/webfonts/fa-brands-400.ttf',
	'html/webfonts/fa-brands-400.woff',
	'html/webfonts/fa-brands-400.woff2',
	'html/webfonts/fa-regular-400.eot',
	'html/webfonts/fa-regular-400.svg',
	'html/webfonts/fa-regular-400.ttf',
	'html/webfonts/fa-regular-400.woff',
	'html/webfonts/fa-regular-400.woff2',
	'html/webfonts/fa-solid-900.eot',
	'html/webfonts/fa-solid-900.svg',
	'html/webfonts/fa-solid-900.ttf',
	'html/webfonts/fa-solid-900.woff',
	'html/webfonts/fa-solid-900.woff2',
	'html/icons/*.png',
	'html/icons/*.gif'
}

server_scripts {
	'@warp-lib/server/sv_rpc.lua',
	'@warp-lib/server/sv_sql.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

client_scripts {
	'@warp-lib/client/cl_rpc.lua',
	'client/main.lua',
	'client/init.lua',
	'client/animation.lua',
	'client/stocks.lua',
	'client/twitter.lua',
	'client/assistance.lua'
}

export 'openGuiNow'

