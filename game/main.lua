love.graphics.setDefaultFilter("nearest", "nearest")

local remap = require("src.remap")

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
	size = vec(100,-1),
	childAlign = vec(-1,0),
	sizing = {"FILL","FILL"},
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


love.keyboard.setKeyRepeat(true)
local font
function love.load()
	font = love.graphics.newFont("lib/GNUI/style/theme/Javacraft.otf", 5)
	love.graphics.setFont(font)
	font:setLineHeight(2)
end

local utils = require("lib.GNUI.utils")

function love.update()
	screen:flushUpdates()
	screen:setSize(utils.getScreenSize()/3)
end

function love.mousemoved(x,y)
	screen:setCursorPos(x/3,y/3)
end

function love.mousepressed(x,y,button,isTouch,presses)
	screen:inputMouse(button-1,1)
end

function love.mousereleased(x,y,button)
	screen:inputMouse(button-1,0)
end

function love.wheelmoved(x,y)
	screen:inputMouse(0,y)
end

local isShift = false
function love.keypressed(key, scancode, isrepeat)
	screen:inputKey(remap.char2id(key) or 0,isrepeat and 2 or 1)
end

function love.textinput(text)
	screen:inputChar(text)
end

function love.keyreleased(key, scancode)
	if key == "shift" then isShift = false end
	screen:inputKey(remap.char2id(key) or 0,0)
end

function love.draw()
	love.graphics.scale(3,3)
	love.graphics.setBackgroundColor(0.5,0.5,0.6)
	screen:draw()
end
