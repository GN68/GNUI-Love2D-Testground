--[[______   __   ___              _       ____                 _      __
  / ____/ | / /  /   | __  _______(_)___ _/ __/___  _  ______ _(_)____/ /
 / / __/  |/ /  / /| |/ / / / ___/ / __ `/ /_/ __ \| |/_/ __ `/ / ___/ / 
/ /_/ / /|  /  / ___ / /_/ / /  / / /_/ / __/ /_/ />  </ /_/ / / /  / /  
\____/_/ |_/  /_/  |_\__,_/_/  /_/\__,_/_/  \____/_/|_|\__, /_/_/  /_/
--A Vector2 library for easy ease                     /____]]

local event = require("lib.event")

---@class Vector2
---@field x number
---@field y number
---@operator add: Vector2
---@operator sub: Vector2
---@operator mul: Vector2
---@operator div: Vector2
---@operator unm: Vector2
---@operator pow: Vector2
---@operator mod: Vector2
---@operator concat: Vector2
---@field VALUES_CHANGED Event
local Vector2 = {}

---Creates a new Vector2.
---@overload fun(vec2:Vector2): Vector2
---@param x number?
---@param y number?
---@return Vector2
function Vector2.new(x,y)
	local self
	if type(x) == "Vector2" then
		self = x:clone()
	else
		self = {
			x=x or 0,
			y=y or 0,
			VALUES_CHANGED = event.new()
		}
		setmetatable(self,Vector2)
	end
	return self
end


Vector2.__index = function (t,key)
	local val = rawget(Vector2,key)
	if val then
		return val
	elseif type(key) == "string" and key:match('^[xy_]+$') then -- swizzling
		if #key == 2 then
			local a = key:sub(1,1)
			local b = key:sub(2,2)
			t.VALUES_CHANGED:invoke()
			return Vector2.new(t[a] or 0, t[b] or 0)
		elseif #key == 1 then
			t.VALUES_CHANGED:invoke()
			return t[key]
		end
	end
end
Vector2.__type = "Vector2"
Vector2.__newindex = function (t,key,value)
	if key:match('^[xy_]+$')  then
		local a = key:sub(1,1)
		local b = key:sub(2,2)
		t[a] = value.x
		t[b] = value.y
	else
		error("invalid swizzle, only accepts x,y or _, but recived \"" .. tostring(key:match('^[xy_]+$') ) .. "\"")
	end
end

Vector2.__call = function (t,x,y)
	return Vector2.new(x,y)
end

---Copies a Vector2.
---@return Vector2
function Vector2:copy()
	return Vector2.new(self.x,self.y)
end


Vector2.__eq = function (a,b)
	return a.x == b.x and a.y == b.y
end


Vector2.__add = function (a,b)
	return a:clone():add(b,b)
end


---@return Vector2
Vector2.__sub = function (a,b)
	return a:clone():sub(b,b)
end


---@return Vector2
Vector2.__mul = function (a,b)
	return a:clone():mul(b,b)
end


---@return Vector2
Vector2.__div = function (a,b)
	return a:clone():div(b,b)
end


---@return Vector2
Vector2.__unm = function (a)
	a.x = -a.x
	a.y = -a.y
	return a
end


---@return Vector2
Vector2.__mod = function (a,b)
	return a:clone():mod(b,b)
end


---@return Vector2
Vector2.__pow = function (a, b)
	return a:clone():pow(b,b)
end


---@return string
Vector2.__tostring = function (a)
	return "("..tostring(a.x) .. ","..tostring(a.y)..")"
end


---@return Vector2
Vector2.__concat = function (a,b)
---@diagnostic disable-next-line: param-type-mismatch
	local new
	new = Vector2.new(tonumber(tostring(a.x) .. tostring(b.x)),tonumber(tostring(a.y) .. tostring(b.y)))
	a.VALUES_CHANGED:invoke(a)
	return new
end


---@return number
Vector2.__len = function (a)
	return Vector2.length(a)
end


---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:set(x,y)
	self:rawset(x,y)
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:rawset(x,y)
	local t = type(x)
	if t == "Vector2" then
		self.x = x.x
		self.y = x.y
	else
		self.x = x
		self.y = y
	end
	return self
end


---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:add(x,y)
	local t = type(x)
	if t == "Vector2" then
		self.x = self.x + x.x
		self.y = self.y + x.y
	else
		self.x = self.x + x
		self.y = self.y + y
	end
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:sub(x,y)
	local t = type(x)
	if t == "Vector2" then
		self.x = self.x - x.x
		self.y = self.y - x.y
	else
		self.x = self.x - x
		self.y = self.y - y
	end
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:mul(x,y)
	local t = type(x)
	if t == "Vector2" then
		self.x = self.x * x.x
		self.y = self.y * x.y
	else
		self.x = self.x * x
		self.y = self.y * y
	end
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:div(x,y)
	local t = type(x)
	if t == "Vector2" then
		self.x = self.x / x.x
		self.y = self.y / x.y
	else
		self.x = self.x / (x or 1)
		self.y = self.y / (y or 1)
	end
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---Applies a modulus to the Vector2
---@overload fun(self : Vector2, vec2 : Vector2)
---@param x number
---@param y number
---@return Vector2
function Vector2:mod(x,y)
	local t = type(x)
	if t == "Vector2" then
		self.x = self.x % x.x
		self.y = self.y % x.y
	else
		self.x = self.x % x
		self.y = self.y % y
	end
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---Returns the length squared of the Vector2.
---@return number
function Vector2:lengthSquared()
	return self.x ^ 2 + self.y ^ 2
end


---Returns the length squared of the Vector2.
---@return number
function Vector2:length()
	return math.sqrt(Vector2.lengthSquared(self))
end


---Normalizes the Vector2.
---@return Vector2
function Vector2:normalize()
	local d = self:length()
	self.x = self.x / d
	self.y = self.y / d
	self.VALUES_CHANGED:invoke(self.x,self.y)
	return self
end


---Returns a copy of this Vector2 but normalizd.
---@return Vector2
function Vector2:normalized()
	return self:copy():normalize()
end


---Makes the Vector2 absolute.
---@return Vector2
function Vector2:abs()
	self.x = math.abs(self.x)
	self.y = math.abs(self.y)
	return self
end


---returns two values, x and y
---@return number
---@return number
function Vector2:unpack()
	return self.x, self.y
end


---Returns the cross product of the Vector2.
---@return Vector2
function Vector2:cross(vec2)
	return self.x * vec2.y - self.y * vec2.x
end

---Returns the dot product of the Vector2.
---@return Vector2
function Vector2:dot(vec2)
	return self.x * vec2.y + self.y * vec2.x
end


---Applies the math.floor function.
---@param snap number?
---@return Vector2
function Vector2:floor(snap)
	snap = snap or 1
	self.x = math.floor(self.x / snap) * snap
	self.y = math.floor(self.y / snap) * snap
	return self
end


---Applies the math.ceil Vector2.
---@param snap number?
---@return Vector2
function Vector2:ceil(snap)
	snap = snap or 1
	self.x = math.ceil(self.x / snap) * snap
	self.y = math.ceil(self.y / snap) * snap
	return self
end


---Rotates the Vector2. the angle is in degrees.
---@return Vector2
function Vector2:rotate(angle)
	local d = math.rad(angle)
	self.x = math.cos(d) * self.x - math.sin(d) * self.y
	self.y = math.sin(d) * self.x + math.cos(d) * self.y
	return self
end


return Vector2
