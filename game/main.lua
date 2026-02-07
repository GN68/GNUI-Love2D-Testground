
for _, item in pairs(love.filesystem.getDirectoryItems("core")) do
	if item:find("%.lua$") then
		require("core."..item:sub(1,-5))
	end
end

local GNUI = require("lib.GNUI")

print(GNUI)

function love.load()
end

function love.update()
end

function love.draw()
end
