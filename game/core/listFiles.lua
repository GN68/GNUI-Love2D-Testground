---@diagnostic disable: lowercase-global
---@param dir string
---@param recursive boolean
---@param list string[]?
function listFiles(dir,recursive,list)
	local list = {}
	for _, item in pairs(love.filesystem.getDirectoryItems(dir)) do
		local info = love.filesystem.getInfo(item)
		if info.type == "file" and item:find("%.lua$") then
			require(dir.."."..item:sub(1,-5))
		elseif info.type == "directory" and item ~= "." and item ~= ".." then
			if recursive then
				listFiles(dir..item.."/", true,list)
			end
		end
	end
	return list
end
