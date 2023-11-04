-- Locals
local xAPI = {}
local instances = {}
local _nil = {}
local _g = {}
local metatables = {}

local function descendanthandler(descendant:Instance)
	if not table.find(instances, descendant) then
		table.insert(instances, descendant)
		local function onParentChanged(Parent)
			if Parent == nil then
				table.insert(_nil, descendant)
			else
				local found = table.find(_nil, descendant)
				if found then
					table.remove(_nil, found)
				end
			end
		end
		descendant.Changed:Connect(onParentChanged)
		descendant.Destroying:Connect(onParentChanged)
	end
end

-- Connections
game.DescendantAdded:Connect(descendanthandler)

for _, descendant in pairs(game:GetDescendants()) do
	descendanthandler(descendant)
end

-- Main
local function add(aliases:any, value:any, places:any?)
	for _,alias in pairs(aliases) do
		for _,place in pairs(places or { xAPI }) do
			if type(value) == "function" then
				place[alias] = function(...)
					return value(alias, ...)
				end
			else
				place[alias] = value
			end
		end
	end
end

add({"gethui"}, function(self)
	return game:GetService("Players").LocalPlayer.PlayerGui
end)

add({"getinstances"}, function(self)
	return instances
end)

add({"getnilinstances"}, function(self)
	local r = {}

	for _, descendant in pairs(instances) do
		pcall(function()
			if descendant.Parent == nil then
				table.insert(r, descendant)
			end
		end)
	end

	return r
end)

add({"getscripts"}, function(self)
	local r = {}

	for _, descendant in pairs(instances) do
		pcall(function()
			if descendant:IsA("Script") then
				table.insert(r, descendant)
			end
		end)
	end

	return r
end)

add({"getmodules"}, function(self)
	local r = {}

	for _, descendant in pairs(instances) do
		pcall(function()
			if descendant:IsA("ModuleScript") then
				table.insert(r, descendant)
			end
		end)
	end

	return r
end)

add({"newcclosure"}, function(self, _func)
	assert(_func, "missing argument #1 to 'newcclosure' (function expected)")
	assert(type(_func) == "function", string.format("invalid argument #1 to 'newcclosure' (function expected, got %s)", type(_func)))

	return coroutine.wrap(function(...)
		while true do
			coroutine.yield(_func(...))
		end
	end)
end)

add({"newlclosure"}, function(self, _func)
	assert(_func, "missing argument #1 to 'newlclosure' (function expected)")
	assert(type(_func) == "function", string.format("invalid argument #1 to 'newlclosure' (function expected, got %s)", type(_func)))

	return function(...)
		_func(...)
	end
end)

add({"iscclosure"}, function(self, closure)
	assert(closure, "missing argument #1 to 'iscclosure' (function expected)")
	assert(type(closure) == "function", string.format("invalid argument #1 to 'iscclosure' (function expected, got %s)", type(closure)))

	local is_l_lclosure,_ = pcall(function()
		setfenv(closure, getfenv(closure))
	end)
	return not is_l_lclosure
end)

add({"islclosure"}, function(self, closure)
	assert(closure, "missing argument #1 to 'islclosure' (function expected)")
	assert(type(closure) == "function", string.format("invalid argument #1 to 'islclosure' (function expected, got %s)", type(closure)))

	local is_l_lclosure,_ = pcall(function()
		setfenv(closure, getfenv(closure))
	end)
	return is_l_lclosure
end)

add({"getcurrentline"}, function(self)
	return debug.info(3, "l")
end)

add({"getthreadidentity", "getidentity", "getthreadcontext"}, function(self)
	local identity = nil
	local messageout = game:GetService("LogService").MessageOut:Connect(function(msg, msgtype)
		if msgtype == Enum.MessageType.MessageOutput then
			for level in msg:gmatch("Current identity is (.+)") do
				if identity == nil and tonumber(level) ~= nil then
					--identity = tonumber(level)
				end
			end
		end
	end)
	
	printidentity()
	
	local limit = 0
	while not identity and limit < 5 do
		task.wait()
		limit += 1
	end

	messageout:Disconnect()

	return identity or 2
end)

add({"getthread"}, function(self)
	return coroutine.running()
end)

add({"getmemoryaddress"}, function(self, obj:any, keep_0x:boolean | nil)
	assert(obj, "missing argument #1 to 'getmemoryaddress'")
	assert(type(keep_0x) == "boolean" or keep_0x == nil, string.format("invalid argument #1 to 'getmemoryaddress' (boolean or nil expected, got %s)", type(keep_0x)))

	local str = tostring(obj)
	local strmatch = str:gmatch("(.+): 0x(.+)$")
	local address
	for _type, _addr in strmatch do
		address = _addr
	end
	if keep_0x == true then
		address = "0x"..address
	end
	if not address then
		assert(nil, string.format("invalid argument #1 to 'getmemoryaddress' (%s is not supported)", typeof(obj)))
	end
	return address
end)

add({"getgenv"}, function(self)
	return setmetatable(xAPI, {__newindex = function(self, key, value)
		getfenv(2)[key] = value
	end,__index = function(self, key)
		return (self[key] or getfenv(2)[key])
	end,})
end)

add({"getrenv"}, function(self)
	return getfenv(1)
end)

add({"identifyexecutor", "getexecutorname"}, function(self)
	local Build = 0
	local _count = 0
	for name, value in pairs(xAPI) do
		for _, char in pairs(name:split("")) do
			Build += string.byte(char)*#name
			_count += 1
		end
	end
	Build *= _count
	return "xAPI", "build::"..Build
end)

add({"isexecutorclosure", "checkclosure", "isourclosure"}, function(self, closure)
	assert(closure, string.format("missing argument #1 to '%s'", self))
	assert(type(closure) == "function", string.format("invalid argument #1 to '%s' (%s is not supported)", self, type(closure)))

	if xAPI.getrenv()[debug.info(closure, "n")] then
		return false
	else
		return true
	end
end)

add({"_G", "shared"}, _g)

add({"newproxy"}, function(self, addMetatable:boolean)
	assert(type(addMetatable) == "boolean" or addMetatable == nil, string.format("invalid argument #1 to 'newproxy' (nil or boolean expected, got %s)", type(addMetatable)))
	local userdata = newproxy(addMetatable)
	if addMetatable == true then
		local a = getmetatable(userdata)
		local raw = {}
		setmetatable(a, {__newindex=function(self, key, value)
			raw[key] = value
		end,})
		metatables[userdata] = {raw, userdata}
	end
	return userdata
end)

add({"setmetatable"}, function(self, object, meta)
	assert(object, "missing argument #1 to 'setmetatable' (table expected)")
	assert(type(object) == "table", string.format("invalid argument #1 to 'setmetatable' (expected table, got %s)", type(object)))

	metatables[object] = {meta, setmetatable(object, meta)}
	return metatables[object][2]
end)

add({"getmetatable"}, function(self, object)
	assert(object, "missing argument #1 to 'getmetatable' (expected table or userdata)")
	assert(type(object) == "userdata" or type(object) == "table", string.format("invalid argument #1 to 'getmetatable' (expected table or userdata, got %s)", type(object)))

	return getmetatable(metatables[object][2])
end)

add({"getrawmetatable"}, function(self, object)
	assert(object, "missing argument #1 to 'getrawmetatable' (expected table or userdata)")
	assert(type(object) == "userdata" or type(object) == "table", string.format("invalid argument #1 to 'getrawmetatable' (expected table or userdata, got %s)", type(object)))
	
	local result
	local raw = metatables[object][1]
	local prev_mt = metatables[object][2]
	
	local proxy = setmetatable({}, {}) -- TODO: __newindex to real metatable
	for i,v in pairs(raw) do
		proxy[i] = v
	end
	return proxy
end)

add({"isluau"}, function(self)
	return _VERSION == "Luau"
end)

return function()
	local env = getfenv(2)
	local _count = 0
	for name, value in pairs(xAPI) do
		env[name] = value
		_count += 1
	end
	
	-- for some reason importing `hookfunction` using `add` does not work
	env["hookfunction"] = function(old, new)
		assert(old, "missing argument #1 to 'hookfunction' (function expected)")
		assert(new, "missing argument #2 to 'hookfunction' (function expected)")
		assert(type(old) == "function", string.format("invalid argument #1 to 'hookfunction' (function expected, got %s)", type(old)))
		assert(type(new) == "function", string.format("invalid argument #2 to 'hookfunction' (function expected, got %s)", type(new)))

		local funcname = debug.info(old, "n")

		assert(funcname ~= "", "invalid argument #1 to 'hookfunction' (function must not be unnamed)")

		getfenv(old)[funcname] = new

		return old
	end
	
	local _,build = xAPI.identifyexecutor()
	
	print(string.format("[%s] [xAPI] Loaded %d variables!", build, _count))
end
