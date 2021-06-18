local mta = getrawmetatable(game)
local back = mta.__namecall
setreadonly(mta, false)

local MarketService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local GuiService = game:GetService("GuiService")

mta.__namecall = newcclosure(function(self, ...)
    if checkcaller() then
        if self == game then
            local method = getnamecallmethod()
            if method == "HttpGet" or method == "HttpGetAsync" then
                return HttpGet(self, ...)
            elseif method == "GetObjects" then 
                return GetObjects(self, ...)
            elseif method == "OpenVideosFolder" or method == "OpenScreenshotsFolder" then 
                return 0
            end
        end
        if self == MarketService then
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

setreadonly(mta, true)

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

getgenv().require = function(ms)
   local old = syn.get_thread_identity()

   syn.set_thread_identity(2)
   local g, res = pcall(getrenv().require, ms)
   syn.set_thread_identity(old)
   if not g then
       error (res)
   end
   return res    
end

getgenv().gethui = function() 
  return game:GetService'CoreGui'
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

getgenv().getcallingscript = function(lvl)
    lvl = lvl and lvl + 1 or 1
    local func = setfenv(lvl, getfenv(lvl))
    return getfenv(func).script
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


--bit lib

getgenv().bit = {}

for i, v in next, bit32 do
    bit[i] = v
end

bit.badd = function(a, b)
    return a + b
end

bit.bsub = function(a, b)
    return a - b
end

bit.bdiv = function(a, b)
    return a / b
end

bit.bmul = function(a, b)
    return a * b
end

bit.bswap = function(x)
    local a = bit.band(x, 0xff)
    x = bit.rshift(x, 8)
    local b = bit.band(x, 0xff)
    x = bit.rshift(x, 8)
    local c = bit.band(x, 0xff)
    x = bit.rshift(x, 8)
    local d = bit.band(x, 0xff)
    return bit.lshift(bit.lshift(bit.lshift(a, 8) + b, 8) + c, 8) + d
end

function rrotate(x, disp)
    disp = disp % 32
    local low = bit.band(x, 2 ^ disp - 1)
    return bit.rshift(x, disp) + bit.lshift(low, 32 - disp)
end

bit.rol = function(x, disp)
    return rrotate(x, -disp)
end

bit.ror = function(x, disp) --this is wrong fix this lol idk
    return rrotate(x, disp)
end

bit.tohex = function(x, n)
    n = n or 8
    local up
    if n <= 0 then
        if n == 0 then
            return ""
        end
        up = true
        n = -n
    end
    x = bit.band(x, 16 ^ n - 1)
    return ("%0" .. n .. (up and "X" or "x")):format(x)
end

bit.tobit = function(x)
    return x % 2 ^ 32
end

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
    local pnolist = {
        Instance = {
            Archivable = true,
            ClassName = true,
            DataCost = true,
            Parent = true,
            RobloxLocked = true
        },
        BasePart = {
            Position = true,
            Rotation = true
        },
        BaseScript = {
            LinkedSource = true
        }
    }
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
        name = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name or name
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

getgenv().getloadedmodules = getmodules
getgenv().replaceclosure = hookfunction
