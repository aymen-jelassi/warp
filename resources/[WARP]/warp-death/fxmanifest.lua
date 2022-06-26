fx_version 'bodacious'
game 'gta5'

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/loading-bar.js',
}

client_script 'client.lua'
server_script 'server.lua'

export 'GetDeathStatus'