fx_version 'cerulean'
game 'gta5'

client_script "client/cl_*.lua"
server_script "server/sv_*.lua"

-- shared_script '@warp-lib/import.lua'

ui_page "html/admin-menu.html"

files({
    "html/admin-menu.html",
    "html/js/*.js",
    "html/*.css",
    "html/*.svg"
})