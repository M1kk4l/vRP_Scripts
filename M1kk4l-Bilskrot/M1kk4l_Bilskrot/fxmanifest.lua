--[[
	███╗   ███╗  ███╗  ██╗  ██╗██╗  ██╗  ██╗██╗██╗
	████╗ ████║ ████║  ██║ ██╔╝██║ ██╔╝ ██╔╝██║██║
	██╔████╔██║██╔██║  █████═╝ █████═╝ ██╔╝ ██║██║
	██║╚██╔╝██║╚═╝██║  ██╔═██╗ ██╔═██╗ ███████║██║
	██║ ╚═╝ ██║███████╗██║ ╚██╗██║ ╚██╗╚════██║███████╗
	╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝╚══════╝
	M1kk4l © 2021 | Alle Rettigheder Forbeholdes.
--]]

fx_version 'cerulean'
game 'gta5'

dependency {
	"vrp",
	"pNotify"
}

client_scripts {
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client.lua",
	"config.lua",
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua",
	"config.lua",
}
