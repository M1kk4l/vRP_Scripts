fx_version 'adamant'
game 'gta5'

version '1.2.0'

dependency "vrp"

client_scripts {
    "lib/Tunnel.lua",
	"lib/Proxy.lua",
    "config.lua",
	"client/main.lua"
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    "@vrp/lib/utils.lua",
    "config.lua",
	"server/main.lua"
}