--[[______   __   ___              _       ____                 _      __
  / ____/ | / /  /   | __  _______(_)___ _/ __/___  _  ______ _(_)____/ /
 / / __/  |/ /  / /| |/ / / / ___/ / __ `/ /_/ __ \| |/_/ __ `/ / ___/ / 
/ /_/ / /|  /  / ___ / /_/ / /  / / /_/ / __/ /_/ />  </ /_/ / / /  / /  
\____/_/ |_/  /_/  |_\__,_/_/  /_/\__,_/_/  \____/_/|_|\__, /_/_/  /_/
--A Vector4 library for easy ease                     /____]]

local event = require("lib.event")

---@class Vector4
---@field x number
---@field y number
---@field z number
---@field w number
---@operator add: Vector4
---@operator sub: Vector4
---@operator mul: Vector4
---@operator div: Vector4
---@operator unm: Vector4
---@operator pow: Vector4
---@operator mod: Vector4
---@operator concat: Vector4
---@field VALUES_CHANGED Event
local Vector4 = {}

---Creates a new Vector4.
---@overload fun(vec4:Vector4): Vector4
---@param x number?
---@param y number?
---@param z number?
---@param w number?
---@return Vector4
function Vector4.new(x,y,z,w)
	local self
	if type(x) == "Vector4" then
		local v = x
		x,y,z,w = v.x,v.y,v.z,v.w
	else
		self = {
			x = x or 0,
			y = y or 0,
			z = z or 0,
			w = w or 0,
			VALUES_CHANGED = event.new()
		}
		setmetatable(self,Vector4)
	end
	return self
end


Vector4.__index = function (t,k)
	local val = rawget(Vector4,k)
	if val then
		return val
	elseif type(k) == "string" and k:match('^[xy_]+$') then -- swizzling
		if #k == 2 then
			local x = k:sub(1,1)
			local y = k:sub(2,2)
			local z = k:sub(3,3)
			t.VALUES_CHANGED:invoke()
			return Vector4.new(t[x] or 0, t[y] or 0, t[z] or 0)
		elseif #k == 2 then
			local x = k:sub(1,1)
			local y = k:sub(2,2)
			t.VALUES_CHANGED:invoke()
			return Vector4.new(t[x] or 0, t[y] or 0)
		elseif #k == 1 then
			t.VALUES_CHANGED:invoke()
			return t[k]
		end
	end
end
Vector4.__type = "Vector4"
Vector4.__newindex = function (t,k,v)
	if k:match('^[xy_]+$')  then
		local x = k:sub(1,1)
		local y = k:sub(2,2)
		local z = k:sub(3,3)
		if x then t[x] = v.x end
		if y then t[y] = v.y end
		if z then t[z] = v.z end
	else
		error("invalid swizzle, only accepts x,y,z or _, but recived \"" .. tostring(k:match('^[xyz_]+$') ) .. "\"")
	end
end

Vector4.__call = function (t,x,y,z,w)
	return Vector4.new(x,y,z,w)
end


---Copies the given Vector4.
---@return Vector4
function Vector4:copy()
	return Vector4.new(self)
end


Vector4.__eq = function (a,b)
	return a.x == b.x
	and a.y == b.y
	and a.z == b.z
	and a.w == b.w
end


Vector4.__add = function (a,b)
	return a:copy():add(b,b)
end


---@return Vector4
Vector4.__sub = function (a,b)
	return a:copy():sub(b,b)
end


---@return Vector4
Vector4.__mul = function (a,b)
	return a:copy():mul(b,b)
end


---@return Vector4
Vector4.__div = function (a,b)
	return a:copy():div(b,b)
end


---@return Vector4
Vector4.__unm = function (a)
	a.x = -a.x
	a.y = -a.y
	a.z = -a.y
	return a
end


---@return Vector4
Vector4.__mod = function (a,b)
	return a:copy():mod(b,b)
end


---@return Vector4
Vector4.__pow = function (a, b)
	return a:copy():pow(b,b)
end


---@return string
Vector4.__tostring = function (a)
	return "("..tostring(a.x) .. ","..tostring(a.y)..","..tostring(a.z)..","..tostring(a.w)..")"
end


---@return Vector4
Vector4.__concat = function (a,b)
---@diagnostic disable-next-line: param-type-mismatch
	local new
	new = Vector4.new(
		tonumber(tostring(a.x) .. tostring(b.x)),
		tonumber(tostring(a.y) .. tostring(b.y)),
		tonumber(tostring(a.z) .. tostring(b.z)),
		tonumber(tostring(a.w) .. tostring(b.w))
	)
	a.VALUES_CHANGED:invoke(a)
	return new
end


---@return number
Vector4.__len = function (a)
	return Vector4.length(a)
end


---@overload fun(self : Vector4, vec4 : Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4:set(x,y,z,w)
	self:rawset(x,y,z,w)
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---@overload fun(self : Vector4, vec3 : Vector4)
---@param x number
---@param y number
---@param z number
---@return Vector4
function Vector4:rawset(x,y,z,w)
	local t = type(x)
	if t == "Vector4" then
		self.x = x.x
		self.y = x.y
		self.z = x.z
		self.w = x.w
	else
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	end
	return self
end


---@overload fun(self : Vector4, vec4 : Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4:add(x,y,z,w)
	local t = type(x)
	if t == "Vector4" then
		self.x = self.x + x.x
		self.y = self.y + x.y
		self.z = self.z + x.z
		self.w = self.w + x.w
	else
		self.x = self.x + x
		self.y = self.y + y
		self.z = self.z + z
		self.w = self.w + w
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z,self.w)
	return self
end


---@overload fun(self : Vector4, vec4 : Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4:sub(x,y,z,w)
	local t = type(x)
	if t == "Vector4" then
		self.x = self.x - x.x
		self.y = self.y - x.y
		self.z = self.z - x.z
		self.w = self.w - x.w
	else
		self.x = self.x - x
		self.y = self.y - y
		self.z = self.z - z
		self.w = self.w - w
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z,self.w)
	return self
end


---@overload fun(self : Vector4, vec4 : Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4:mul(x,y,z,w)
	local t = type(x)
	if t == "Vector4" then
		self.x = self.x * x.x
		self.y = self.y * x.y
		self.z = self.z * x.z
		self.w = self.w * x.w
	else
		self.x = self.x * x
		self.y = self.y * y
		self.z = self.z * z
		self.w = self.w * w
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z,self.w)
	return self
end


---@overload fun(self : Vector4, vec4 : Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4:div(x,y,z,w)
	local t = type(x)
	if t == "Vector4" then
		self.x = self.x / x.x
		self.y = self.y / x.y
		self.z = self.z / x.z
		self.w = self.w / x.w
	else
		self.x = self.x / (x or 1)
		self.y = self.y / (y or 1)
		self.z = self.z / (z or 1)
		self.w = self.w
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z,self.w)
	return self
end


---Applies a modulus to the Vector4
---@overload fun(self : Vector4, vec4 : Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4:mod(x,y,z,w)
	local t = type(x)
	if t == "Vector4" then
		self.x = self.x % x.x
		self.y = self.y % x.y
		self.z = self.z % x.z
		self.w = self.w % x.w
	else
		self.x = self.x % x
		self.y = self.y % y
		self.z = self.z % z
		self.w = self.w
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z,self.w)
	return self
end


---Returns the length squared of the Vector4.
---@return number
function Vector4:lengthSquared()
	return self.x ^ 2 + self.y ^ 2 + self.z ^ 2 + self.w ^ 2
end


function Vector4:length()
	return math.sqrt(self.x^2 + self.y^2 + self.z^2 + self.w^2)
end


---Normalizes the Vector4.
---@return Vector4
function Vector4:normalize()
	local d = self:length()
	self.x = self.x / d
	self.y = self.y / d
	self.z = self.z / d
	self.w = self.w / d
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z,self.w)
	return self
end


---Returns a copy of this Vector4 but normalizd.
---@return Vector4
function Vector4:normalized()
	return self:copy():normalize()
end


---Makes the Vector4 absolute.
---@return Vector4
function Vector4:abs()
	self.x = math.abs(self.x)
	self.y = math.abs(self.y)
	self.z = math.abs(self.z)
	self.w = math.abs(self.w)
	return self
end


---returns two values, x and y
---@return number
---@return number
---@return number
function Vector4:unpack()
	return self.x, self.y, self.z
end


function Vector4:cross(b,c)
	local a = self
	return Vector4.new(
		  a.y * (b.z * c.w - b.w * c.z) - a.z * (b.y * c.w - b.w * c.y) + a.w * (b.y * c.z - b.z * c.y),
		-(a.x * (b.z * c.w - b.w * c.z) - a.z * (b.x * c.w - b.w * c.x) + a.w * (b.x * c.z - b.z * c.x)),
		  a.x * (b.y * c.w - b.w * c.y) - a.y * (b.x * c.w - b.w * c.x) + a.w * (b.x * c.y - b.y * c.x),
		-(a.x * (b.y * c.z - b.z * c.y) - a.y * (b.x * c.z - b.z * c.x) + a.z * (b.x * c.y - b.y * c.x))
	)
end

function Vector4:dot(v)
	return self.x * v.x + self.y * v.y + self.z * v.z + self.w * v.w
end


---Applies the math.floor function.
---@param snap number?
---@return Vector4
function Vector4:floor(snap)
	snap = snap or 1
	self.x = math.floor(self.x / snap) * snap
	self.y = math.floor(self.y / snap) * snap
	self.z = math.floor(self.z / snap) * snap
	self.w = math.floor(self.w / snap) * snap
	return self
end


---Applies the math.ceil Vector4.
---@param snap number?
---@return Vector4
function Vector4:ceil(snap)
	snap = snap or 1
	self.x = math.ceil(self.x / snap) * snap
	self.y = math.ceil(self.y / snap) * snap
	self.z = math.ceil(self.z / snap) * snap
	self.w = math.ceil(self.w / snap) * snap
	return self
end

--[[
---Rotates the Vector4 to a given axis. the angle is in degrees.
---@param angle number
---@param axis Vector4
---@return Vector4
function Vector4:rotate(angle,axis)
	angle = math.deg(angle)
	local k = axis:normalized()
	local cos = math.cos(angle)
	local sin = math.sin(angle)

	local v = self

	local term1 = Vector4.new(
		v.x * cos,
		v.y * cos,
		v.z * cos
	)

	local cross = k:cross(v)
	local term2 = Vector4.new(
		cross.x * sin,
		cross.y * sin,
		cross.z * sin
	)

	local dot = k:dot(v)
	local term3 = Vector4.new(
		k.x * dot * (1 - cos),
		k.y * dot * (1 - cos),
		k.z * dot * (1 - cos)
	)

	return Vector4.new(
		term1.x + term2.x + term3.x,
		term1.y + term2.y + term3.y,
		term1.z + term2.z + term3.z
	)
end
]]

return Vector4
