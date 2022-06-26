fx_version 'bodacious'
games { 'rdr3', 'gta5' }
author "Mortal"
description "A simple blackjack UI Made For Sunset"
version "1.0"

ui_page "html/index.html"

files({
	"html/*",
	"html/svg/*",
	"html/img/*",
	"html/css/*",
	"html/font/*",
	"html/js/*"
})

client_scripts {
	"client/*.lua",
}