love.graphics.setDefaultFilter("nearest", "nearest")

for _, item in pairs(love.filesystem.getDirectoryItems("core")) do
	if item:find("%.lua$") then
		require("core."..item:sub(1,-5))
	end
end

local GNUI = require("lib.GNUI")
local screen = GNUI.getScreen()

-- creates a new box with children
local box = GNUI.parse(screen,{
	
	layout = "VERTICAL",
	size = vec(200,-1),
	childAlign = vec(-1,0),
	sizing = {"FIXED","FIT"},
	padding = vec(2,2,2,2),
	gap = 0,
	
	{ -- children
		{
			variant="primary",
			type="button",
			text="One Two Three Four",
			sizing={"FILL","FIT"},
			size = vec(0,30),
		},
		{
			variant="secondary",
			type="button",
			text="One Two Three Four",
			sizing={"FILL","FIT"},
			size = vec(0,30),
		},
		{
			variant="bevel",
			type="button",
			text="Bevel",
			sizing={"FILL","FIT"},
			size = vec(0,30),
		},
		{
			text="Five Six Seven Eight Nine Ten",
			sizing={"FILL","FIT"},
		},
		{
			type="textField",
			sizing={"FILL","FIT"},
			multiline=true
		},
	}
})

screen:addChild(box)
box:setPos(10,10)
local font
function love.load()
	font = love.graphics.newFont("lib/GNUI/style/theme/Javacraft.otf", 5)
	love.graphics.setFont(font)
end

function love.update()
	screen:flushUpdates()
end


function love.draw()
	love.graphics.setBackgroundColor(0.5,0.5,0.6)
	screen:draw()
end
