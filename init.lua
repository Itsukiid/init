local mt = getrawmetatable(game)
local back = mt.__namecall
local idx = mt.__index
local GetService = game.GetService
setreadonly(mt, false)
local Marketplace = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local GuiService = game:GetService("GuiService")

mt.__namecall = newcclosure(function(self, ...)
    if checkcaller() then
        if self == game then
            local method = getnamecallmethod()
            if method == "HttpGet" or method == "HttpGetAsync" then
                return HttpGet(...)
            elseif method == "GetObjects" then 
                return GetObjects(self, ...)
            elseif method == "OpenVideosFolder" or method == "OpenScreenshotsFolder" then 
                return 0
            end
        end
        if self == Marketplace then
            local method = getnamecallmethod()
            if method == "PerformPurchase" or method == "PromptBundlePurchase" or method == "PromptGamePassPurchase" or method == "PromptNativePurchase" or method == "PromptProductPurchase" or method == "PromptPurchase" or method == "PromptThirdPartyPurchase" then
                return 0
            end
        end
        if self == BrowserService then
            local method = getnamecallmethod()
            if method == "OpenBrowserWindow" or method == "CopyAuthCookieFromBrowserToEngine" or method == "OpenNativeOverlay" or method == "OpenWeChatAuthWindow"  then
                return 0
            end
        end
        if self == GuiService then
            local method = getnamecallmethod()
            if method == "OpenBrowserWindow" then
                return 0
            end
        end
    end
    return back(self, ...)
end)

setreadonly(mt, true)

local MT = {
  __index = function(a, b)
	if b == "Fire" then
		return function(self, ...) fireonesignal(self.__OBJECT, ...) end
	elseif b == "Enable" then
		return function(self) enableconnection(self.__OBJECT) end 
	elseif b == "Disable" then
		return function(self) disableconnection(self.__OBJECT) end
	end
	return nil
  end,
  __newindex = function(a, b, c)
		if b == "Enabled" then
			if c and not rawget(a, "_ENABLED") then
				enableconnection(self.__OBJECT) 
				rawset(T, "_ENABLED", true)
			elseif rawget(a, "_ENABLED") then
				disableconnection(self.__OBJECT) 
				rawset(T, "_ENABLED", false)
			end
		end
	end,
	__type = "Event"
}

getgenv().getconnections = function(a)
	local temp = a:Connect(function() end)
	local signals = getothersignals(temp)
	for i,v in pairs(signals) do
		signals[i] = setmetatable(v, MT)
	end
	temp:Disconnect()
	return signals
end

getgenv().firesignal = function(a, ...)
    local temp = a:Connect(function() end)
    temp:Disconnect()
    return firesignalhelper(temp, ...)
end

getgenv().gethui = function() 
  return game:GetService'CoreGui'
end

getgenv().getexecutorname = function()
	return "Lead"
end

getgenv().fireproximityprompt = function(Obj, Amount, Skip)
  if Obj.ClassName == "ProximityPrompt" then
      Amount = Amount or 1
      local PromptTime = Obj.HoldDuration
      if Skip then
          Obj.HoldDuration = 0
      end
      for i = 1, Amount do
          Obj:InputHoldBegin()
          if not Skip then
              wait(Obj.HoldDuration)
          end
          Obj:InputHoldEnd()
      end
      Obj.HoldDuration = PromptTime
  else
      error("userdata<ProximityPrompt> expected")
  end
end

getgenv().get_hidden_gui = gethui
getgenv().getmodules = function()
    local tabl = {}
    for i, v in next, getreg() do
        if type(v) == "table" then
            for n, c in next, v do
                if typeof(c) == "Instance" and (c:IsA("ModuleScript")) then
                    table.insert(tabl, c)
                end
            end
        end
    end
    return tabl
end

getgenv().getscripts = function()
    local tabl = {}
    for i, v in next, getreg() do
        if type(v) == "table" then
            for n, c in next, v do
                if typeof(c) == "Instance" and (c:IsA("LocalScript") or c:IsA("ModuleScript")) then
                    table.insert(tabl, c)
                end
            end
        end
    end
    return tabl
end

getgenv().getinstances = function()
    local tabl = {}
    for i, v in next, getreg() do
        if type(v) == "table" then
            for n, c in next, v do
                if typeof(c) == "Instance" then
                    table.insert(tabl, c)
                end
            end
        end
    end
    return tabl
end

getgenv().getnilinstances = function()
    local tabl = {}
    for i, v in next, getreg() do
        if type(v) == "table" then
            for n, c in next, v do
                if typeof(c) == "Instance" and c.Parent == nil then
                    table.insert(tabl, c)
                end
            end
        end
    end
    return tabl
end


getgenv().getscriptenvs = function()
	local tabl = {}
	for i, v in next, getscripts() do
		local succ, res = pcall(getsenv, v)
        if succ then
		    tabl[res.script] = res
		end
	end
	return tabl
end

getgenv().getcallingscript = newcclosure(function()
	local depth = 2
	local env
	pcall(function()
		while true do
			nenv = getfenv(depth)
			if nenv == nil then return end
			env = nenv
			depth = depth + 1
		end
	end)
 
	return env and env.script or nil
 end)

getgenv().getfunctions = function()
	local tabl = {}
	for i,v in next,getreg() do
		if typeof(v) == "table" then
			for a,b in next,v do
				if type(b) == "function" then
					table.insert(tabl, b)
				end
			end
		end
	end
	return tabl
end

getgenv().getallthreads = function()
	local threads = {}
	for i, v in next, getreg() do
		if type(v) == "thread" then
			threads[#threads + 1] = v
		end
	end
	return threads
end

getgenv().getscriptclosure = function(Script)
    assert(typeof(Script) == "Instance", "invalid argument #1 to 'getscriptclosure' (expected an Instance)")
    assert(Script.ClassName == "LocalScript", "invalid argument #1 to 'getscriptclosure' (expected a LocalScript)")
    for _, Closure in pairs(getreg()) do
        if type(Closure) == "function" then
            if getfenv(Closure).script == Script then
                return Closure
            end
        end
    end
    error("script is not running")
end

getgenv().clonefunction = newcclosure(function(p1)
        assert(type(p1) == "function", "invalid argument #1 to '?' (function expected)", 2)
        local A = p1
        local B = xpcall(setfenv, function(p2, p3)
                return p2, p3
            end, p1, getfenv(p1))
        if B then
            return function(...)
                return A(...)
            end
        end
        return coroutine_wrap(function(...)
            while true do
        A = coroutine_yield(A(...))
        end
    end)
end)

getgenv().dumpstring = function(gaysex)
    assert(type(gaysex) == "string", "String expected", 2)
    return tostring("\\" .. table.concat({string.byte(gaysex, 1, #gaysex)}, "\\"))
end

getgenv().makewriteable = newcclosure(function(tab)
	setreadonly(tab, false)
end)

getgenv().makereadonly = newcclosure(function(tab)
	setreadonly(tab, true)
end)

getgenv().iswriteable = newcclosure(function(tab)
	return not isreadonly(tab)
end)

getgenv().info = function(arg)
	return game:GetService("TestService"):Message(tostring(arg))
end

getgenv().setcallingscript = function(a) rawset(getfenv(0), "script", a) end
getgenv().getpropvalue = function(o,p) return o[p] end
getgenv().setpropvalue = function(o,p,v) o[p] = v end

--bit lib

local M = {_TYPE='module', _NAME='bitop.funcs', _VERSION='1.0-0'}

local floor = math.floor

local MOD = 2^32
local MODM = MOD-1

local function memoize(f)

  local mt = {}
  local t = setmetatable({}, mt)

  function mt:__index(k)
    local v = f(k)
    t[k] = v
    return v
  end

  return t
end

local function make_bitop_uncached(t, m)
  local function bitop(a, b)
    local res,p = 0,1
    while a ~= 0 and b ~= 0 do
      local am, bm = a%m, b%m
      res = res + t[am][bm]*p
      a = (a - am) / m
      b = (b - bm) / m
      p = p*m
    end
    res = res + (a+b) * p
    return res
  end
  return bitop
end

local function make_bitop(t)
  local op1 = make_bitop_uncached(t, 2^1)
  local op2 = memoize(function(a)
    return memoize(function(b)
      return op1(a, b)
    end)
  end)
  return make_bitop_uncached(op2, 2^(t.n or 1))
end

-- ok? probably not if running on a 32-bit int Lua number type platform
function M.tobit(x)
  return x % 2^32
end

M.bxor = make_bitop {[0]={[0]=0,[1]=1},[1]={[0]=1,[1]=0}, n=4}
local bxor = M.bxor

function M.bnot(a)   return MODM - a end
local bnot = M.bnot

function M.band(a,b) return ((a+b) - bxor(a,b))/2 end
local band = M.band

function M.bor(a,b)  return MODM - band(MODM - a, MODM - b) end
local bor = M.bor

local lshift, rshift -- forward declare

function M.rshift(a,disp) -- Lua5.2 insipred
  if disp < 0 then return lshift(a,-disp) end
  return floor(a % 2^32 / 2^disp)
end
rshift = M.rshift

function M.lshift(a,disp) -- Lua5.2 inspired
  if disp < 0 then return rshift(a,-disp) end
  return (a * 2^disp) % 2^32
end
lshift = M.lshift

function M.tohex(x, n) -- BitOp style
  n = n or 8
  local up
  if n <= 0 then
    if n == 0 then return '' end
    up = true
    n = - n
  end
  x = band(x, 16^n-1)
  return ('%0'..n..(up and 'X' or 'x')):format(x)
end
local tohex = M.tohex

function M.extract(n, field, width) -- Lua5.2 inspired
  width = width or 1
  return band(rshift(n, field), 2^width-1)
end
local extract = M.extract

function M.replace(n, v, field, width) -- Lua5.2 inspired
  width = width or 1
  local mask1 = 2^width-1
  v = band(v, mask1) -- required by spec?
  local mask = bnot(lshift(mask1, field))
  return band(n, mask) + lshift(v, field)
end
local replace = M.replace

function M.bswap(x)  -- BitOp style
  local a = band(x, 0xff); x = rshift(x, 8)
  local b = band(x, 0xff); x = rshift(x, 8)
  local c = band(x, 0xff); x = rshift(x, 8)
  local d = band(x, 0xff)
  return lshift(lshift(lshift(a, 8) + b, 8) + c, 8) + d
end
local bswap = M.bswap

function M.rrotate(x, disp)  -- Lua5.2 inspired
  disp = disp % 32
  local low = band(x, 2^disp-1)
  return rshift(x, disp) + lshift(low, 32-disp)
end
local rrotate = M.rrotate

function M.lrotate(x, disp)  -- Lua5.2 inspired
  return rrotate(x, -disp)
end
local lrotate = M.lrotate

M.rol = M.lrotate  -- LuaOp inspired
M.ror = M.rrotate  -- LuaOp insipred


function M.arshift(x, disp) -- Lua5.2 inspired
  local z = rshift(x, disp)
  if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
  return z
end
local arshift = M.arshift

function M.btest(x, y) -- Lua5.2 inspired
  return band(x, y) ~= 0
end

--
-- Start Lua 5.2 "bit32" compat section.
--

M.bit32 = {} -- Lua 5.2 'bit32' compatibility


local function bit32_bnot(x)
  return (-1 - x) % MOD
end
M.bit32.bnot = bit32_bnot

local function bit32_bxor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = bxor(a, b)
    if c then
      z = bit32_bxor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end
M.bit32.bxor = bit32_bxor

local function bit32_band(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = ((a+b) - bxor(a,b)) / 2
    if c then
      z = bit32_band(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return MODM
  end
end
M.bit32.band = bit32_band

local function bit32_bor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = MODM - band(MODM - a, MODM - b)
    if c then
      z = bit32_bor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end
M.bit32.bor = bit32_bor

function M.bit32.btest(...)
  return bit32_band(...) ~= 0
end

function M.bit32.lrotate(x, disp)
  return lrotate(x % MOD, disp)
end

function M.bit32.rrotate(x, disp)
  return rrotate(x % MOD, disp)
end

function M.bit32.lshift(x,disp)
  if disp > 31 or disp < -31 then return 0 end
  return lshift(x % MOD, disp)
end

function M.bit32.rshift(x,disp)
  if disp > 31 or disp < -31 then return 0 end
  return rshift(x % MOD, disp)
end

function M.bit32.arshift(x,disp)
  x = x % MOD
  if disp >= 0 then
    if disp > 31 then
      return (x >= 0x80000000) and MODM or 0
    else
      local z = rshift(x, disp)
      if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
      return z
    end
  else
    return lshift(x, -disp)
  end
end

function M.bit32.extract(x, field, ...)
  local width = ... or 1
  if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
  x = x % MOD
  return extract(x, field, ...)
end

function M.bit32.replace(x, v, field, ...)
  local width = ... or 1
  if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
  x = x % MOD
  v = v % MOD
  return replace(x, v, field, ...)
end


--
-- Start LuaBitOp "bit" compat section.
--

M.bit = {} -- LuaBitOp "bit" compatibility

function M.bit.tobit(x)
  x = x % MOD
  if x >= 0x80000000 then x = x - MOD end
  return x
end
local bit_tobit = M.bit.tobit

function M.bit.tohex(x, ...)
  return tohex(x % MOD, ...)
end

function M.bit.bnot(x)
  return bit_tobit(bnot(x % MOD))
end

local function bit_bor(a, b, c, ...)
  if c then
    return bit_bor(bit_bor(a, b), c, ...)
  elseif b then
    return bit_tobit(bor(a % MOD, b % MOD))
  else
    return bit_tobit(a)
  end
end
M.bit.bor = bit_bor

local function bit_band(a, b, c, ...)
  if c then
    return bit_band(bit_band(a, b), c, ...)
  elseif b then
    return bit_tobit(band(a % MOD, b % MOD))
  else
    return bit_tobit(a)
  end
end
M.bit.band = bit_band

local function bit_bxor(a, b, c, ...)
  if c then
    return bit_bxor(bit_bxor(a, b), c, ...)
  elseif b then
    return bit_tobit(bxor(a % MOD, b % MOD))
  else
    return bit_tobit(a)
  end
end
M.bit.bxor = bit_bxor

function M.bit.lshift(x, n)
  return bit_tobit(lshift(x % MOD, n % 32))
end

function M.bit.rshift(x, n)
  return bit_tobit(rshift(x % MOD, n % 32))
end

function M.bit.arshift(x, n)
  return bit_tobit(arshift(x % MOD, n % 32))
end

function M.bit.rol(x, n)
  return bit_tobit(lrotate(x % MOD, n % 32))
end

function M.bit.ror(x, n)
  return bit_tobit(rrotate(x % MOD, n % 32))
end

function M.bit.bswap(x)
  return bit_tobit(bswap(x % MOD))
end

getgenv().bit = M

--bit lib

syn.protect_gui = function(a)
	if type(a) == "userdata" and a:IsA("ScreenGui") then
	a.Parent = game:GetService'CoreGui'
   end
end

syn.secure_call = function(Closure, Spoof, ...)
    assert(typeof(Spoof) == "Instance", "invalid argument #1 to '?' (LocalScript or ModuleScript expected, got " .. type(Spoof) .. ")")
    assert(Spoof.ClassName == "LocalScript" or Spoof.ClassName == "ModuleScript", "invalid argument #1 to '?' (LocalScript or ModuleScript expected, got " .. type(Spoof) .. ")")

    local OldScript = getfenv().script
    local OldThreadID = syn.get_thread_identity()

    getfenv().script = Spoof
    syn.set_thread_identity(2)
    local Success, Err = pcall(Closure, ...)
    syn.set_thread_identity(OldThreadID)
    getfenv().script = OldScript
    if not Success and Err then
        error(Err)
    end
end


getgenv().saveinstance = function()
    local buffersize
    local placename
    local savebuffer
    local stlgui
    local b64encode = syn.crypt.base64.encode
    do
    end
    local rwait
    do
    local rswait = game:GetService('RunService').RenderStepped
    rwait = function()
        return rswait:wait()
    end
    end
    local pesplist = {
        UnionOperation = {
            AssetId = 'Content',
            ChildData = 'BinaryString',
            FormFactor = 'Token',
            InitialSize = 'Vector3',
            MeshData = 'BinaryString',
            PhysicsData = 'BinaryString'
        },
        MeshPart = {
            InitialSize = 'Vector3',
            PhysicsData = 'BinaryString'
        },
        Terrain = {
            SmoothGrid = 'BinaryString',
            MaterialColors = 'BinaryString'
        }
    }
    local ldecompile
    do
    ldecompile = function(scr)
    return '-- Lead currently doesnt have a decompiler'
    end
    end
    local slist
    do
    local tmp = { }
    local _list_0 = {
    'Chat',
    'InsertService',
    'JointsService',
    'Lighting',
    'ReplicatedFirst',
    'ReplicatedStorage',
    'ServerStorage',
    'StarterGui',
    'StarterPack',
    'StarterPlayer',
    'Teams',
    'Workspace'
    }
    for _index_0 = 1, #_list_0 do
    local x = _list_0[_index_0]
    table.insert(tmp, game:FindService(x))
    end
    slist = tmp
    end
    local ilist
    do
    local _tbl_0 = { }
    for _, v in ipairs({
        'BubbleChat',
        'Camera',
        'CameraScript',
        'ChatScript',
        'ControlScript',
        'ClientChatModules',
        'ChatServiceRunner',
        'ChatModules'
    }) do
        _tbl_0[v] = true
    end
    ilist = _tbl_0
    end
    local pattern = '["&<>\']'
    local escapes = {
    ['"'] = '&quot;',
    ['&'] = '&amp;',
    ['<'] = '&lt;',
    ['>'] = '&gt;',
    ['\''] = '&apos;'
    }
    local quantum_hackerman_pcomp_lget_wfetch_query_getsz_base64_decode
    quantum_hackerman_pcomp_lget_wfetch_query_getsz_base64_decode = function()
    local version_query_async_kernelmode_base = HttpGet('http://setup.roblox.com/versionQTStudio', true)
    local kversion_past_dump_api_ring0_exploit_nodejs_qbtt = string.format('http://setup.roblox.com/%s-API-Dump.json', version_query_async_kernelmode_base)
    local l_unquery_lua_top_stack_lpsz_tvalue_str_const_ptr = HttpGet(kversion_past_dump_api_ring0_exploit_nodejs_qbtt, true)
    local ignore_base_api_wget_linux_git_push_unicode = game:GetService('HttpService'):JSONDecode(l_unquery_lua_top_stack_lpsz_tvalue_str_const_ptr).Classes
    local kernel_base_addresses_to_system_modules = { }
    for _index_0 = 1, #ignore_base_api_wget_linux_git_push_unicode do
        local windows_websocket_query_syscall = ignore_base_api_wget_linux_git_push_unicode[_index_0]
        local win_sock_active_connection_email = windows_websocket_query_syscall.Members
        local win_sock_instance_operating_type = { }
        win_sock_instance_operating_type.Name = windows_websocket_query_syscall.Name
        win_sock_instance_operating_type.Superclass = windows_websocket_query_syscall.Superclass
        win_sock_instance_operating_type.Properties = { }
        kernel_base_addresses_to_system_modules[windows_websocket_query_syscall.Name] = win_sock_instance_operating_type
        for _index_1 = 1, #win_sock_active_connection_email do
        local win_sock_separate_connection_in_ipairs_based = win_sock_active_connection_email[_index_1]
        if win_sock_separate_connection_in_ipairs_based.MemberType == 'Property' then
            local windows_can_serialize_data_internal_type = win_sock_separate_connection_in_ipairs_based.Serialization
            if windows_can_serialize_data_internal_type.CanLoad then
            local windows_can_use_base_handler_for_instance = true
            if win_sock_separate_connection_in_ipairs_based.Tags then
                local _list_0 = win_sock_separate_connection_in_ipairs_based.Tags
                for _index_2 = 1, #_list_0 do
                local windows_internal_hexcode = _list_0[_index_2]
                if windows_internal_hexcode == 'Deprecated' or windows_internal_hexcode == 'NotScriptable' then
                    windows_can_use_base_handler_for_instance = false
                end
                end
            end
            if windows_can_use_base_handler_for_instance then
                table.insert(win_sock_instance_operating_type.Properties, {
                Name = win_sock_separate_connection_in_ipairs_based.Name,
                ValueType = win_sock_separate_connection_in_ipairs_based.ValueType.Name,
                Special = false
                })
            end
            end
        end
        end
    end
    for win_sock_receiving_end, win_sock_carrier_ip_handle in pairs(pesplist) do
        local corresponding_socket_handle = kernel_base_addresses_to_system_modules[win_sock_receiving_end].Properties
        for callback_ptr_base_handler, serializer_intro_fnbase in pairs(win_sock_carrier_ip_handle) do
        table.insert(corresponding_socket_handle, {
            Name = callback_ptr_base_handler,
            ValueType = serializer_intro_fnbase,
            Special = true
        })
        end
    end
    return (function(elevate_permissions_into_nigmode_ring_negative_four)
        return elevate_permissions_into_nigmode_ring_negative_four
    end)(kernel_base_addresses_to_system_modules)
    end
    local plist
    do
    local ran, result = pcall(quantum_hackerman_pcomp_lget_wfetch_query_getsz_base64_decode)
    if ran then
        plist = result
    else
        return result
    end
    end
    local properties = setmetatable({ }, {
    __index = function(self, name)
        local proplist = { }
        local layer = plist[name]
        while layer do
        local _list_0 = layer.Properties
        for _index_0 = 1, #_list_0 do
            local p = _list_0[_index_0]
            table.insert(proplist, p)
        end
        layer = plist[layer.Superclass]
        end
        table.sort(proplist, function(a, b)
        return a.Name < b.Name
        end)
        self[name] = proplist
        return proplist
    end
    })
    local identifiers = setmetatable({
    count = 0
    }, {
    __index = function(self, obj)
        self.count = self.count + 1
        local rbxi = 'RBX' .. self.count
        self[obj] = rbxi
        return rbxi
    end
    })
    local typesizeround
    typesizeround = function(s)
    return math.floor(buffersize / (0x400 ^ s) * 10) / 10
    end
    local getsizeformat
    getsizeformat = function()
    local res
    for i, v in ipairs({
        'b',
        'kb',
        'mb',
        'gb',
        'tb'
    }) do
        if buffersize < 0x400 ^ i then
        res = typesizeround(i - 1) .. v
        break
        end
    end
    return res
    end
    local getsafeproperty
    getsafeproperty = function(i, name)
    return i[name]
    end
    local getplacename
    getplacename = function()
    local name = 'place' .. game.PlaceId
    pcall(function()
        name = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name
    end)
    return name:gsub('[^%w%s_]', '') .. '.rbxlx'
    end
    local savecache
    savecache = function()
    local savestr = table.concat(savebuffer)
    appendfile(placename, savestr)
    buffersize = buffersize + #savestr
    stlgui.Text = string.format('Saving (%s)', getsizeformat())
    savebuffer = { }
    return rwait()
    end
    local savehierarchy
    savehierarchy = function(h)
    local savepr = #savebuffer
    if savepr > 0x1600 then
        savecache()
    end
    for _index_0 = 1, #h do
        local _continue_0 = false
        repeat
        local i = h[_index_0]
        local sprops
        local clsname = i.ClassName
        if i.RobloxLocked or ilist[i.Name] or not plist[clsname] then
            _continue_0 = true
            break
        end
        local props = properties[clsname]
        savebuffer[#savebuffer + 1] = '<Item class="' .. clsname .. '" referent="' .. identifiers[i] .. '"><Properties>'
        for _index_1 = 1, #props do
            local _continue_1 = false
            repeat
            local p = props[_index_1]
            local value
            local tag
            local raw
            if p.Special then
                if raw == nil then
                _continue_1 = true
                break
                end
            else
                local isok = p.Ok
                local _exp_0 = isok
                if nil == _exp_0 then
                local ok, what = pcall(getsafeproperty, i, p.Name)
                p.Ok = ok
                if ok then
                    raw = what
                else
                    _continue_1 = true
                    break
                end
                elseif true == _exp_0 then
                raw = i[p.Name]
                elseif false == _exp_0 then
                _continue_1 = true
                break
                end
            end
            local _exp_0 = p.ValueType
            if 'BrickColor' == _exp_0 then
                tag = 'int'
                value = raw.Number
            elseif 'Color3' == _exp_0 then
                tag = 'Color3'
                value = '<R>' .. raw.r .. '</R><G>' .. raw.g .. '</G><B>' .. raw.b .. '</B>'
            elseif 'ColorSequence' == _exp_0 then
                tag = 'ColorSequence'
                local ob = { }
                local _list_0 = raw.Keypoints
                for _index_2 = 1, #_list_0 do
                local v = _list_0[_index_2]
                ob[#ob + 1] = v.Time .. ' ' .. v.Value.r .. ' ' .. v.Value.g .. ' ' .. v.Value.b .. ' 0'
                end
                value = table.concat(ob, ' ')
            elseif 'Content' == _exp_0 then
                tag = 'Content'
                value = '<url>' .. raw:gsub(pattern, escapes) .. '</url>'
            elseif 'BinaryString' == _exp_0 then
                tag = 'BinaryString'
                if p.Name == "SmoothGrid" or p.Name == "MaterialColors" then
                value = "<![CDATA[" .. b64encode(raw) .. "]]>"
                else
                value = b64encode(raw)
                end
            elseif 'CoordinateFrame' == _exp_0 then
                local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:components()
                tag = 'CoordinateFrame'
                value = '<X>' .. X .. '</X>' .. '<Y>' .. Y .. '</Y>' .. '<Z>' .. Z .. '</Z>' .. '<R00>' .. R00 .. '</R00>' .. '<R01>' .. R01 .. '</R01>' .. '<R02>' .. R02 .. '</R02>' .. '<R10>' .. R10 .. '</R10>' .. '<R11>' .. R11 .. '</R11>' .. '<R12>' .. R12 .. '</R12>' .. '<R20>' .. R20 .. '</R20>' .. '<R21>' .. R21 .. '</R21>' .. '<R22>' .. R22 .. '</R22>'
            elseif 'NumberRange' == _exp_0 then
                tag = 'NumberRange'
                value = raw.Min .. ' ' .. raw.Max
            elseif 'NumberSequence' == _exp_0 then
                tag = 'NumberSequence'
                local ob = { }
                local _list_0 = raw.Keypoints
                for _index_2 = 1, #_list_0 do
                local v = _list_0[_index_2]
                ob[#ob + 1] = v.Time .. ' ' .. v.Value .. ' ' .. v.Envelope
                end
                value = table.concat(ob, ' ')
            elseif 'PhysicalProperties' == _exp_0 then
                tag = 'PhysicalProperties'
                if raw then
                value = '<CustomPhysics>true</CustomPhysics>' .. '<Density>' .. raw.Density .. '</Density>' .. '<Friction>' .. raw.Friction .. '</Friction>' .. '<Elasticity>' .. raw.Elasticity .. '</Elasticity>' .. '<FrictionWeight>' .. raw.FrictionWeight .. '</FrictionWeight>' .. '<ElasticityWeight>' .. raw.ElasticityWeight .. '</ElasticityWeight>'
                else
                value = '<CustomPhysics>false</CustomPhysics>'
                end
            elseif 'ProtectedString' == _exp_0 then
                tag = 'ProtectedString'
                if p.Name == 'Source' then
                if i.ClassName == 'Script' then
                    value = '-- Server scripts can not be decompiled\n'
                else
                    value = ldecompile(i)
                end
                else
                value = raw
                end
                value = value:gsub(pattern, escapes)
            elseif 'Rect2D' == _exp_0 then
                tag = 'Rect2D'
                value = '<min>' .. '<X>' .. raw.Min.X .. '</X>' .. '<Y>' .. raw.Min.Y .. '</Y>' .. '</min>' .. '<max>' .. '<X>' .. raw.Max.X .. '</X>' .. '<Y>' .. raw.Max.Y .. '</Y>' .. '</max>'
            elseif 'UDim2' == _exp_0 then
                tag = 'UDim2'
                value = '<XS>' .. raw.X.Scale .. '</XS>' .. '<XO>' .. raw.X.Offset .. '</XO>' .. '<YS>' .. raw.Y.Scale .. '</YS>' .. '<YO>' .. raw.Y.Offset .. '</YO>'
            elseif 'Vector2' == _exp_0 then
                tag = 'Vector2'
                value = '<X>' .. raw.x .. '</X>' .. '<Y>' .. raw.y .. '</Y>'
            elseif 'Vector3' == _exp_0 then
                tag = 'Vector3'
                value = '<X>' .. raw.x .. '</X>' .. '<Y>' .. raw.y .. '</Y>' .. '<Z>' .. raw.z .. '</Z>'
            elseif 'bool' == _exp_0 then
                tag = 'bool'
                value = tostring(raw)
            elseif 'double' == _exp_0 then
                tag = 'float'
                value = raw
            elseif 'float' == _exp_0 then
                tag = 'float'
                value = raw
            elseif 'int' == _exp_0 then
                tag = 'int'
                value = raw
            elseif 'string' == _exp_0 then
                tag = 'string'
                value = raw:gsub(pattern, escapes)
            else
                if p.ValueType:sub(1, 6) == 'Class:' then
                tag = 'Ref'
                if raw then
                    value = identifiers[raw]
                else
                    value = 'null'
                end
                elseif typeof(raw) == 'EnumItem' then
                tag = 'token'
                value = raw.Value
                end
            end
            if tag then
                savebuffer[#savebuffer + 1] = '<' .. tag .. ' name="' .. p.Name .. '">' .. value .. '</' .. tag .. '>'
            end
            _continue_1 = true
            until true
            if not _continue_1 then
            break
            end
        end
        savebuffer[#savebuffer + 1] = '</Properties>'
        local chl = i:GetChildren()
        if #chl ~= 0 then
            savehierarchy(chl, savebuffer)
        end
        savebuffer[#savebuffer + 1] = '</Item>'
        _continue_0 = true
        until true
        if not _continue_0 then
        break
        end
    end
    end
    local savefolder
    savefolder = function(n, h)
    local Ref = identifiers[Instance.new('Folder')]
    table.insert(savebuffer, '<Item class="Folder" referent="' .. Ref .. '"><Properties><string name="Name">' .. n .. '</string></Properties>')
    savehierarchy(h)
    return table.insert(savebuffer, '</Item>')
    end
    local savegame
    savegame = function()
    local i_ply = game:GetService('Players').LocalPlayer:GetChildren()
    local i_nil = getnilinstances()
    for i, v in next,i_nil do
        if v == game then
        table.remove(i_nil, i)
        break
        end
    end
    writefile(placename, '<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4"><External>null</External><External>nil</External>')
    savehierarchy(slist)
    savefolder('Local Player', i_ply)
    savefolder('Instances in Nil', i_nil)
    table.insert(savebuffer, '</roblox>')
    return savecache()
    end
    do
    stlgui = Instance.new('TextLabel')
    stlgui.BackgroundTransparency = 1
    stlgui.Font = Enum.Font.Code
    stlgui.Name = 'TextLabel'
    stlgui.Position = UDim2.new(0.7, 0, 0, -20)
    stlgui.Size = UDim2.new(0.3, 0, 0, 20)
    stlgui.Text = 'Starting...'
    stlgui.TextColor3 = Color3.new(1, 1, 1)
    stlgui.TextScaled = true
    stlgui.TextStrokeTransparency = 0.7
    stlgui.TextWrapped = true
    stlgui.TextXAlignment = Enum.TextXAlignment.Right
    stlgui.TextYAlignment = Enum.TextYAlignment.Top
    stlgui.Parent = game:GetService('CoreGui'):FindFirstChild('RobloxGui')
    end
    do
    local plys = game:GetService('Players')
    local loc = plys.LocalPlayer
    local _list_0 = plys:GetPlayers()
    for _index_0 = 1, #_list_0 do
        local p = _list_0[_index_0]
        if p ~= loc then
        ilist[p.Name] = true
        end
    end
    end
    do
    placename = getplacename()
    buffersize = 0
    savebuffer = { }
    local elapse_t = tick()
    local ok, err = pcall(savegame)
    elapse_t = tick() - elapse_t
    if ok then
        stlgui.Text = string.format("Saved! Time %d seconds; size %s", elapse_t, getsizeformat())
        wait(math.log10(elapse_t) * 2)
    else
        stlgui.Text = 'Failed! Check F9 console for more info.'
        warn('Error encountered while saving')
        warn('Information about error:')
        print(err)
        wait(3 + math.log10(elapse_t))
    end
    return stlgui:Destroy()
    end
end

getgenv().syn_crypt_b64_encode = syn.crypt.base64.encode
getgenv().syn_crypt_b64_decode = syn.crypt.base64.decode
getgenv().syn_context_get = syn.get_thread_identity
getgenv().syn_context_set = syn.set_thread_identity
getgenv().syn_getcallingscript = getcallingscript
getgenv().syn_getgc = getgc
getgenv().syn_getgenv = getgenv
getgenv().syn_getinstances = getinstances
getgenv().syn_getloadedmodules = getmodules
getgenv().syn_getmenv = getsenv
getgenv().syn_getreg = getreg
getgenv().syn_getrenv = getrenv
getgenv().syn_getsenv = getsenv
getgenv().syn_islclosure = islclosure
getgenv().syn_mouse1click = mouse1click
getgenv().syn_mouse1press = mouse1press
getgenv().syn_mouse1release = mouse1release
getgenv().syn_mouse2click = mouse2click
getgenv().syn_mouse2press = mouse2press
getgenv().syn_mouse2release = mouse2release
getgenv().syn_mousemoverel = mousemoverel
getgenv().syn_newcclosure = newcclosure
getgenv().hookfunc = hookfunction
getgenv().replaceclosure = hookfunction

getgenv().make_readonly = makereadonly
getgenv().makewritable = makewriteable
getgenv().make_writable = makewriteable
getgenv().make_writeable = makewriteable
getgenv().is_readonly = isreadonly
getgenv().iswritable = iswriteable
getgenv().is_writable = iswriteable
getgenv().is_writeable = iswriteable

getgenv().get_instances = getinstances
getgenv().get_scripts = getscripts
getgenv().getloadedmodules = getmodules -- not strictly accurate
getgenv().get_loaded_modules = getmodules -- not strictly accurate
getgenv().get_nil_instances = getnilinstances
getgenv().get_script_envs = getscriptenvs
getgenv().get_calling_script = getcallingscript
getgenv().getscriptcaller = getcallingscript
getgenv().getcaller = getcallingscript
getgenv().get_all_threads = getallthreads


getgenv().get_gc_objects = getgc
getgenv().get_namecall_method = getnamecallmethod
getgenv().set_namecall_method = setnamecallmethod

getgenv().is_l_closure = islclosure
getgenv().is_c_closure = iscclosure

getgenv().httpget = HttpGet
getgenv().getobjects = GetObjects

getgenv().getcontext = syn.get_thread_identity
getgenv().getidentity = syn.get_thread_identity
getgenv().getthreadcontext = syn.get_thread_identity
getgenv().get_thread_context = syn.get_thread_identity
getgenv().get_thread_identity = syn.get_thread_identity
getgenv().setcontext = syn.set_thread_identity
getgenv().setidentity = syn.set_thread_identity
getgenv().setthreadcontext = syn.set_thread_identity
getgenv().set_thread_context = syn.set_thread_identity
getgenv().set_thread_identity = syn.set_thread_identity
getgenv().hookfunc = hookfunction
getgenv().replaceclosure = hookfunction
getgenv().Game = game
getgenv().securecall = secure_call
getgenv().identifyexecutor = getexecutorname

local t = {}
 
local string = string
local math = math
local table = table
local error = error
local tonumber = tonumber
local tostring = tostring
local type = type
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local assert = assert


local StringBuilder = {
    buffer = {}
}

function StringBuilder:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.buffer = {}
    return o
end

function StringBuilder:Append(s)
    self.buffer[#self.buffer+1] = s
end

function StringBuilder:ToString()
    return table.concat(self.buffer)
end

local JsonWriter = {
    backslashes = {
        ['\b'] = "\\b",
        ['\t'] = "\\t", 
        ['\n'] = "\\n", 
        ['\f'] = "\\f",
        ['\r'] = "\\r", 
        ['"']  = "\\\"", 
        ['\\'] = "\\\\", 
        ['/']  = "\\/"
    }
}

function JsonWriter:New()
    local o = {}
    o.writer = StringBuilder:New()
    setmetatable(o, self)
    self.__index = self
    return o
end

function JsonWriter:Append(s)
    self.writer:Append(s)
end

function JsonWriter:ToString()
    return self.writer:ToString()
end

function JsonWriter:Write(o)
    local t = type(o)
    if t == "nil" then
        self:WriteNil()
    elseif t == "boolean" then
        self:WriteString(o)
    elseif t == "number" then
        self:WriteString(o)
    elseif t == "string" then
        self:ParseString(o)
    elseif t == "table" then
        self:WriteTable(o)
    elseif t == "function" then
        self:WriteFunction(o)
    elseif t == "thread" then
        self:WriteError(o)
    elseif t == "userdata" then
        self:WriteError(o)
    end
end

function JsonWriter:WriteNil()
    self:Append("null")
end

function JsonWriter:WriteString(o)
    self:Append(tostring(o))
end

function JsonWriter:ParseString(s)
    self:Append('"')
    self:Append(string.gsub(s, "[%z%c\\\"/]", function(n)
        local c = self.backslashes[n]
        if c then return c end
        return string.format("\\u%.4X", string.byte(n))
    end))
    self:Append('"')
end

function JsonWriter:IsArray(t)
    local count = 0
    local isindex = function(k) 
        if type(k) == "number" and k > 0 then
            if math.floor(k) == k then
                return true
            end
        end
        return false
    end
    for k,v in pairs(t) do
        if not isindex(k) then
            return false, '{', '}'
        else
            count = math.max(count, k)
        end
    end
    return true, '[', ']', count
end

function JsonWriter:WriteTable(t)
    local ba, st, et, n = self:IsArray(t)
    self:Append(st) 
    if ba then      
        for i = 1, n do
            self:Write(t[i])
            if i < n then
                self:Append(',')
            end
        end
    else
        local first = true;
        for k, v in pairs(t) do
            if not first then
                self:Append(',')
            end
            first = false;          
            self:ParseString(k)
            self:Append(':')
            self:Write(v)           
        end
    end
    self:Append(et)
end

function JsonWriter:WriteError(o)
    error(string.format(
        "Encoding of %s unsupported", 
        tostring(o)))
end

function JsonWriter:WriteFunction(o)
    if o == Null then 
        self:WriteNil()
    else
        self:WriteError(o)
    end
end

local StringReader = {
    s = "",
    i = 0
}

function StringReader:New(s)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.s = s or o.s
    return o    
end

function StringReader:Peek()
    local i = self.i + 1
    if i <= #self.s then
        return string.sub(self.s, i, i)
    end
    return nil
end

function StringReader:Next()
    self.i = self.i+1
    if self.i <= #self.s then
        return string.sub(self.s, self.i, self.i)
    end
    return nil
end

function StringReader:All()
    return self.s
end

local JsonReader = {
    escapes = {
        ['t'] = '\t',
        ['n'] = '\n',
        ['f'] = '\f',
        ['r'] = '\r',
        ['b'] = '\b',
    }
}

function JsonReader:New(s)
    local o = {}
    o.reader = StringReader:New(s)
    setmetatable(o, self)
    self.__index = self
    return o;
end

function JsonReader:Read()
    self:SkipWhiteSpace()
    local peek = self:Peek()
    if peek == nil then
        error(string.format(
            "Nil string: '%s'", 
            self:All()))
    elseif peek == '{' then
        return self:ReadObject()
    elseif peek == '[' then
        return self:ReadArray()
    elseif peek == '"' then
        return self:ReadString()
    elseif string.find(peek, "[%+%-%d]") then
        return self:ReadNumber()
    elseif peek == 't' then
        return self:ReadTrue()
    elseif peek == 'f' then
        return self:ReadFalse()
    elseif peek == 'n' then
        return self:ReadNull()
    elseif peek == '/' then
        self:ReadComment()
        return self:Read()
    else
        return nil
    end
end
        
function JsonReader:ReadTrue()
    self:TestReservedWord{'t','r','u','e'}
    return true
end

function JsonReader:ReadFalse()
    self:TestReservedWord{'f','a','l','s','e'}
    return false
end

function JsonReader:ReadNull()
    self:TestReservedWord{'n','u','l','l'}
    return nil
end

function JsonReader:TestReservedWord(t)
    for i, v in ipairs(t) do
        if self:Next() ~= v then
             error(string.format(
                "Error reading '%s': %s", 
                table.concat(t), 
                self:All()))
        end
    end
end

function JsonReader:ReadNumber()
        local result = self:Next()
        local peek = self:Peek()
        while peek ~= nil and string.find(
        peek, 
        "[%+%-%d%.eE]") do
            result = result .. self:Next()
            peek = self:Peek()
    end
    result = tonumber(result)
    if result == nil then
            error(string.format(
            "Invalid number: '%s'", 
            result))
    else
        return result
    end
end

function JsonReader:ReadString()
    local result = ""
    assert(self:Next() == '"')
        while self:Peek() ~= '"' do
        local ch = self:Next()
        if ch == '\\' then
            ch = self:Next()
            if self.escapes[ch] then
                ch = self.escapes[ch]
            end
        end
                result = result .. ch
    end
        assert(self:Next() == '"')
    local fromunicode = function(m)
        return string.char(tonumber(m, 16))
    end
    return string.gsub(
        result, 
        "u%x%x(%x%x)", 
        fromunicode)
end

function JsonReader:ReadComment()
        assert(self:Next() == '/')
        local second = self:Next()
        if second == '/' then
            self:ReadSingleLineComment()
        elseif second == '*' then
            self:ReadBlockComment()
        else
            error(string.format(
        "Invalid comment: %s", 
        self:All()))
    end
end

function JsonReader:ReadBlockComment()
    local done = false
    while not done do
        local ch = self:Next()      
        if ch == '*' and self:Peek() == '/' then
            done = true
                end
        if not done and 
            ch == '/' and 
            self:Peek() == "*" then
                    error(string.format(
            "Invalid comment: %s, '/*' illegal.",  
            self:All()))
        end
    end
    self:Next()
end

function JsonReader:ReadSingleLineComment()
    local ch = self:Next()
    while ch ~= '\r' and ch ~= '\n' do
        ch = self:Next()
    end
end

function JsonReader:ReadArray()
    local result = {}
    assert(self:Next() == '[')
    local done = false
    if self:Peek() == ']' then
        done = true;
    end
    while not done do
        local item = self:Read()
        result[#result+1] = item
        self:SkipWhiteSpace()
        if self:Peek() == ']' then
            done = true
        end
        if not done then
            local ch = self:Next()
            if ch ~= ',' then
                error(string.format(
                    "Invalid array: '%s' due to: '%s'", 
                    self:All(), ch))
            end
        end
    end
    assert(']' == self:Next())
    return result
end

function JsonReader:ReadObject()
    local result = {}
    assert(self:Next() == '{')
    local done = false
    if self:Peek() == '}' then
        done = true
    end
    while not done do
        local key = self:Read()
        if type(key) ~= "string" then
            error(string.format(
                "Invalid non-string object key: %s", 
                key))
        end
        self:SkipWhiteSpace()
        local ch = self:Next()
        if ch ~= ':' then
            error(string.format(
                "Invalid object: '%s' due to: '%s'", 
                self:All(), 
                ch))
        end
        self:SkipWhiteSpace()
        local val = self:Read()
        result[key] = val
        self:SkipWhiteSpace()
        if self:Peek() == '}' then
            done = true
        end
        if not done then
            ch = self:Next()
                    if ch ~= ',' then
                error(string.format(
                    "Invalid array: '%s' near: '%s'", 
                    self:All(), 
                    ch))
            end
        end
    end
    assert(self:Next() == "}")
    return result
end

function JsonReader:SkipWhiteSpace()
    local p = self:Peek()
    while p ~= nil and string.find(p, "[%s/]") do
        if p == '/' then
            self:ReadComment()
        else
            self:Next()
        end
        p = self:Peek()
    end
end

function JsonReader:Peek()
    return self.reader:Peek()
end

function JsonReader:Next()
    return self.reader:Next()
end

function JsonReader:All()
    return self.reader:All()
end

function Encode(o)
    local writer = JsonWriter:New()
    writer:Write(o)
    return writer:ToString()
end

function Decode(s)
    local reader = JsonReader:New(s)
    return reader:Read()
end

function Null()
    return Null
end
