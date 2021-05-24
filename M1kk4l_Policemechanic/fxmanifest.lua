fx_version 'adamant'
game 'gta5'

version '1.2.0'

dependency "vrp"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/css/style.css",
    "html/js/javascript.js",
}

client_scripts {
    "callback/client.lua",
    "config.lua",
	"client/main.lua",
    "client/functions.lua"
}

server_scripts {
    "callback/server.lua",
	'@mysql-async/lib/MySQL.lua',
    "@vrp/lib/utils.lua",
    "config.lua",
	"server/main.lua"
}