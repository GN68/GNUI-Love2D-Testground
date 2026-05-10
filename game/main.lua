---@diagnostic disable: assign-type-mismatch
love.graphics.setDefaultFilter("nearest", "nearest")



for _, item in pairs(love.filesystem.getDirectoryItems("core")) do
	if item:find("%.lua$") then
		require("core."..item:sub(1,-5))
	end
end

for _, item in pairs(love.filesystem.getDirectoryItems("src")) do
	if item:find("%.lua$") then
		require("src."..item:sub(1,-5))
	end
end

local remap = require("src.remap")



local GNUI = require("lib.GNUI")
local screen = GNUI.getScreen()

-- creates a new box with children
local box = GNUI.parse(screen,{
	
	layout = "VERTICAL",
	size = vec(100,-1),
	childAlign = vec(-1,0),
	sizing = {"FILL","FILL"},
	gap = 0,
	
	{ -- children
		{
			padding=vec(3,0,3,0),
			type="textField",
			sizing={"FILL","FIXED"},
			size=vec(0,10),
			textAlign={1,0},
			name="input",
			validator = function (field)
				local func = loadstring("return "..field)
---@diagnostic disable-next-line: redundant-return-value
				return func and true or false
			end
		},
		{
			type="box",
			textAlign={1,0},
			minSize=vec(100,15),
			sizing={"FILL","FIT"},
			name="output"
		},
		{
			layout="VERTICAL",
			sizing={"FILL","FILL"},
			{
				{
					layout="HORIZONTAL",
					sizing={"FILL","FIXED"},
					size=vec(0,15),
					{
						{
							variant="destructive",
							type="button",
							sizing={"FILL","FILL"},
							text="<X]",
							name="erase"
						},
						{
							variant="destructive",
							type="button",
							sizing={"FILL","FILL"},
							text="C",
							name="clear",
						},
						{
							variant="destructive",
							type="button",
							sizing={"FILL","FILL"},
							text="CA",
							name="clearAll",
						},
						{
							variant="primary",
							type="button",
							sizing={"FILL","FILL"},
							text="cpy",
							name="copy",
						},
					},
				},
				{
					layout="HORIZONTAL",
					sizing={"FILL","FILL"},
					{
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="7",
							name="insert7",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="8",
							name="insert8",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="9",
							name="insert9",
						},
						{
							variant="primary",
							type="button",
							sizing={"FILL","FILL"},
							text="/",
							name="insertDivide",
						},
					},
				},
				{
					layout="HORIZONTAL",
					sizing={"FILL","FILL"},
					{
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="4",
							name="insert4",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="5",
							name="insert5",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="6",
							name="insert6",
						},
						{
							variant="primary",
							type="button",
							sizing={"FILL","FILL"},
							text="*",
							name="insertMultiply",
						},
					},
				},
				{
					layout="HORIZONTAL",
					sizing={"FILL","FILL"},
					{
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="1",
							name="insert1",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="2",
							name="insert2",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="3",
							name="insert3",
						},
						{
							variant="primary",
							type="button",
							sizing={"FILL","FILL"},
							text="-",
							name="insertSubtract",
						},
					},
				},
				{
					layout="HORIZONTAL",
					sizing={"FILL","FILL"},
					{
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text=".",
							name="insertDecimal",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="0",
							name="insert0",
						},
						{
							variant="tertiary",
							type="button",
							sizing={"FILL","FILL"},
							text="=",
							name="evaluate",
						},
						{
							variant="primary",
							type="button",
							sizing={"FILL","FILL"},
							text="+",
							name="insertAdd",
						},
					},
				},
			},
		},
	}
})

local input = box:getChild("input") ---@type GNUI.TextField
local output = box:getChild("output") ---@type GNUI.TextField

local erase = box:getChild("erase") ---@type GNUI.Button
erase.PRESSED:register(function ()
	input:erase()
end)

local clear = box:getChild("clear") ---@type GNUI.Button
clear.PRESSED:register(function ()
	input:clear()
end)

local clearAll = box:getChild("clearAll") ---@type GNUI.Button
clearAll.PRESSED:register(function ()
	input:clear()
end)
local copy = box:getChild("copy") ---@type GNUI.Button
copy.PRESSED:register(function ()
	if tonumber(output.text) then
		love.system.setClipboardText(output.text)
	end
end)


local insert7 = box:getChild("insert7") ---@type GNUI.Button
insert7.PRESSED:register(function () input:appendText("7") end)

local insert8 = box:getChild("insert8") ---@type GNUI.Button
insert8.PRESSED:register(function () input:appendText("8") end)

local insert9 = box:getChild("insert9") ---@type GNUI.Button
insert9.PRESSED:register(function () input:appendText("9") end)

local insertDivide = box:getChild("insertDivide") ---@type GNUI.Button
insertDivide.PRESSED:register(function () input:appendText("/") end)

local insert4 = box:getChild("insert4") ---@type GNUI.Button
insert4.PRESSED:register(function () input:appendText("4") end)

local insert5 = box:getChild("insert5") ---@type GNUI.Button
insert5.PRESSED:register(function () input:appendText("5") end)

local insert6 = box:getChild("insert6") ---@type GNUI.Button
insert6.PRESSED:register(function () input:appendText("6") end)

local insertMultiply = box:getChild("insertMultiply") ---@type GNUI.Button
insertMultiply.PRESSED:register(function () input:appendText("*") end)

local insert1 = box:getChild("insert1") ---@type GNUI.Button
insert1.PRESSED:register(function () input:appendText("1") end)


local insert2 = box:getChild("insert2") ---@type GNUI.Button
insert2.PRESSED:register(function () input:appendText("2") end)

local insert3 = box:getChild("insert3") ---@type GNUI.Button
insert3.PRESSED:register(function () input:appendText("3") end)

local insertSubtract = box:getChild("insertSubtract") ---@type GNUI.Button
insertSubtract.PRESSED:register(function () input:appendText("-") end)

local insert0 = box:getChild("insert0") ---@type GNUI.Button
insert0.PRESSED:register(function () input:appendText("0") end)

local insertDecimal = box:getChild("insertDecimal") ---@type GNUI.Button
insertDecimal.PRESSED:register(function () input:appendText(".") end)

local evaluate = box:getChild("evaluate") ---@type GNUI.Button
evaluate.PRESSED:register(function ()
	local expression = loadstring("return "..input.field)
	if expression then
		local ok, result = pcall(expression)
		if ok then
			output:setText(result)
		else
			output:setText("Error")
		end
	else
		output:setText("Error")
	end
end)

local insertAdd = box:getChild("insertAdd") ---@type GNUI.Button


screen:addChild(box)

--────────────────────────-< GNUI Boilerplate >-────────────────────────--


love.keyboard.setKeyRepeat(true)

local font
function love.load()
	font = love.graphics.newFont("lib/GNUI/style/theme/Javacraft.otf", 5)
	love.graphics.setFont(font)
	font:setLineHeight(2)
	
end

function love.resize(w, h)
-- get real dimensions
  WindowWidth = w
  WindowHeight = h
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
	screen:inputMouse(button,1)
end

function love.mousereleased(x,y,button)
	screen:inputMouse(button,0)
end

function love.wheelmoved(x,y) screen:inputMouse(0,y) end

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
