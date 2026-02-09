--[[______   __   ___              _       ____                 _      __
  / ____/ | / /  /   | __  _______(_)___ _/ __/___  _  ______ _(_)____/ /
 / / __/  |/ /  / /| |/ / / / ___/ / __ `/ /_/ __ \| |/_/ __ `/ / ___/ / 
/ /_/ / /|  /  / ___ / /_/ / /  / / /_/ / __/ /_/ />  </ /_/ / / /  / /  
\____/_/ |_/  /_/  |_\__,_/_/  /_/\__,_/_/  \____/_/|_|\__, /_/_/  /_/
--A Vector3 library for easy ease                     /____]]
local Vector2 = require("lib.vec2")

local event = require("lib.event")

---@class Vector3
---@field x number
---@field y number
---@field z number
---@operator add: Vector3
---@operator sub: Vector3
---@operator mul: Vector3
---@operator div: Vector3
---@operator unm: Vector3
---@operator pow: Vector3
---@operator mod: Vector3
---@operator concat: Vector3
---@field VALUES_CHANGED Event
local Vector3 = {}

---Creates a new Vector3.
---@overload fun(vec3:Vector3): Vector3
---@param x number?
---@param y number?
---@param z number?
---@return Vector3
function Vector3.new(x,y,z)
	local self
	if type(x) == "Vector3" then
		local v = x
		x,y,z = v.x,v.y,v.z
	end
	self = {
		x=x or 0,
		y=y or 0,
		z=z or 0,
		VALUES_CHANGED = event.new()
	}
	setmetatable(self,Vector3)
	return self
end


Vector3.__index = function (t,k)
	local val = rawget(Vector3,k)
	if val then
		return val
	elseif type(k) == "string" and k:match('^[xyz_]+$') then -- swizzling
		if #k == 3 then
			local x = k:sub(1,1)
			local y = k:sub(2,2)
			local z = k:sub(3,3)
			t.VALUES_CHANGED:invoke()
			return Vector3.new(t[x] or 0, t[y] or 0, t[z] or 0)
		elseif #k == 2 then
			local x = k:sub(1,1)
			local y = k:sub(2,2)
			t.VALUES_CHANGED:invoke()
			return Vector2.new(t[x] or 0, t[y] or 0)
		elseif #k == 1 then
			t.VALUES_CHANGED:invoke()
			return t[k]
		end
	end
end
Vector3.__type = "Vector3"
Vector3.__newindex = function (t,k,v)
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

Vector3.__call = function (t,x,y,z)
	return Vector3.new(x,y,z)
end


---Copies the given Vector3.
---@return Vector3
function Vector3:copy()
	return Vector3.new(self)
end


Vector3.__eq = function (a,b)
	return a.x == b.x
	and a.y == b.y
	and a.z == b.z
end


Vector3.__add = function (a,b)
	return a:copy():add(b,b)
end


---@return Vector3
Vector3.__sub = function (a,b)
	return a:copy():sub(b,b)
end


---@return Vector3
Vector3.__mul = function (a,b)
	return a:copy():mul(b,b)
end


---@return Vector3
Vector3.__div = function (a,b)
	return a:copy():div(b,b)
end


---@return Vector3
Vector3.__unm = function (a)
	a.x = -a.x
	a.y = -a.y
	a.z = -a.y
	return a
end


---@return Vector3
Vector3.__mod = function (a,b)
	return a:copy():mod(b,b)
end


---@return Vector3
Vector3.__pow = function (a, b)
	return a:copy():pow(b,b)
end


Vector3.__clamp = function (a,min,max)
	a.x = math.clamp(a.x,min.x,max.x)
	a.y = math.clamp(a.y,min.y,max.y)
	a.z = math.clamp(a.z,min.z,max.z)
	return a
end


---@return string
Vector3.__tostring = function (a)
	return "("..tostring(a.x) .. ","..tostring(a.y)..","..tostring(a.z)..")"
end


---@return Vector3
Vector3.__concat = function (a,b)
---@diagnostic disable-next-line: param-type-mismatch
	local new
	new = Vector3.new(
		tonumber(tostring(a.x) .. tostring(b.x)),
		tonumber(tostring(a.y) .. tostring(b.y)),
		tonumber(tostring(a.z) .. tostring(b.z))
	)
	a.VALUES_CHANGED:invoke(a)
	return new
end


---@return number
Vector3.__len = function (a)
	return Vector3.length(a)
end


---@overload fun(self : Vector3, vec3 : Vector3): Vector3
---@overload fun(self : Vector3, value: number): Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:set(x,y,z)
	self:rawset(x,y or x,z or x)
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---@overload fun(self : Vector3, vec3 : Vector3): Vector3
---@overload fun(self : Vector3, value: number): Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:rawset(x,y,z)
	local t = type(x)
	if t == "Vector3" then
		self.x = x.x
		self.y = x.y
		self.z = x.z
	else
		self.x = x
		self.y = y
		self.z = z
	end
	return self
end


---@overload fun(self : Vector3, vec3 : Vector3): Vector3
---@overload fun(self : Vector3, value: number): Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:add(x,y,z)
	local t = type(x)
	if t == "Vector3" then
		self.x = self.x + x.x
		self.y = self.y + x.y
		self.z = self.z + x.z
	else
		self.x = self.x + x
		self.y = self.y + y or x
		self.z = self.z + z or x
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---@overload fun(self : Vector3, vec3 : Vector3): Vector3
---@overload fun(self : Vector3, value: number): Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:sub(x,y,z)
	local t = type(x)
	if t == "Vector3" then
		self.x = self.x - x.x
		self.y = self.y - x.y
		self.z = self.z - x.z
	else
		self.x = self.x - x
		self.y = self.y - y or x
		self.z = self.z - z or x
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---@overload fun(self : Vector3, vec3 : Vector3): Vector3
---@overload fun(self : Vector3, value : number): Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:mul(x,y,z)
	local t = type(x)
	if t == "Vector3" then
		self.x = self.x * x.x
		self.y = self.y * x.y
		self.z = self.z * x.z
	else
		self.x = self.x * x
		self.y = self.y * y or x
		self.z = self.z * z or x
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---@overload fun(self : Vector3, vec3 : Vector3): Vector3
---@overload fun(self : Vector3, value: number): Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:div(x,y,z)
	local t = type(x)
	if t == "Vector3" then
		self.x = self.x / x.x
		self.y = self.y / x.y
		self.z = self.z / x.z
	else
		self.x = self.x / (x or 1)
		self.y = self.y / (y or x or 1)
		self.z = self.z / (z or x or 1)
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---Applies a modulus to the Vector3
---@overload fun(self : Vector3, vec3 : Vector3)
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3:mod(x,y,z)
	local t = type(x)
	if t == "Vector3" then
		self.x = self.x % x.x
		self.y = self.y % x.y
		self.z = self.z % x.z
	else
		self.x = self.x % x
		self.y = self.y % (y or x)
		self.z = self.z % (z or x)
	end
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---Returns the length squared of the Vector3.
---@return number
function Vector3:lengthSquared()
	return self.x ^ 2 + self.y ^ 2 + self.z ^ 2
end


function Vector3:length()
	return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end


---Normalizes the Vector3.
---@return Vector3
function Vector3:normalize()
	local d = self:length()
	self.x = self.x / d
	self.y = self.y / d
	self.z = self.z / d
	self.VALUES_CHANGED:invoke(self.x,self.y,self.z)
	return self
end


---Returns a copy of this Vector3 but normalizd.
---@return Vector3
function Vector3:normalized()
	return self:copy():normalize()
end


---Makes the Vector3 absolute.
---@return Vector3
function Vector3:abs()
	self.x = math.abs(self.x)
	self.y = math.abs(self.y)
	self.z = math.abs(self.z)
	return self
end


---returns two values, x and y
---@return number
---@return number
---@return number
function Vector3:unpack()
	return self.x, self.y, self.z
end


function Vector3:cross(v)
	return Vector3.new(
		self.y * v.z - self.z * v.y,
		self.z * v.x - self.x * v.z,
		self.x * v.y - self.y * v.x
	)
end

function Vector3:dot(v)
	return self.x * v.x + self.y * v.y + self.z * v.z
end


---Applies the math.floor function.
---@param snap number?
---@return Vector3
function Vector3:floor(snap)
	snap = snap or 1
	self.x = math.floor(self.x / snap) * snap
	self.y = math.floor(self.y / snap) * snap
	self.z = math.floor(self.z / snap) * snap
	return self
end


---Applies the math.ceil Vector3.
---@param snap number?
---@return Vector3
function Vector3:ceil(snap)
	snap = snap or 1
	self.x = math.ceil(self.x / snap) * snap
	self.y = math.ceil(self.y / snap) * snap
	self.z = math.ceil(self.z / snap) * snap
	return self
end


---Rotates the Vector3 to a given axis. the angle is in degrees.
---@param angle number
---@param axis Vector3
---@return Vector3
function Vector3:rotate(angle,axis)
	angle = math.deg(angle)
	local k = axis:normalized()
	local cos = math.cos(angle)
	local sin = math.sin(angle)

	local v = self

	local term1 = Vector3.new(
		v.x * cos,
		v.y * cos,
		v.z * cos
	)

	local cross = k:cross(v)
	local term2 = Vector3.new(
		cross.x * sin,
		cross.y * sin,
		cross.z * sin
	)

	local dot = k:dot(v)
	local term3 = Vector3.new(
		k.x * dot * (1 - cos),
		k.y * dot * (1 - cos),
		k.z * dot * (1 - cos)
	)

	return Vector3.new(
		term1.x + term2.x + term3.x,
		term1.y + term2.y + term3.y,
		term1.z + term2.z + term3.z
	)
end


return Vector3
