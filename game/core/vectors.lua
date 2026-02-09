---@diagnostic disable: lowercase-global, return-type-mismatch
local vec2 = require("lib.vec2")
local vec3 = require("lib.vec3")
local vec4 = require("lib.vec4")

---@overload fun(x: number, y:number): Vector2
---@overload fun(x: number, y:number, z:number): Vector3
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function vec(x,y,z,w)
	if x then
		if y then
			if z then
				if w then
					return vec4(x,y,z,w)
				end
				return vec3(x,y,z)
			end
			return vec2(x,y)
		end
		return x
	end
	error("Invalid Vector Declaration: ("..tostring(x)..","..tostring(y)..","..tonumber(z)..","..tostring(w)..")")
end
