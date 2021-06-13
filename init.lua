local MT = {
  __index = function(a, b)
	if b == "Fire" then
	  return function(self, ...) fireonesignal(self.__OBJECT, ...) end
	end
	return nil
  end
}

function attachMT(tbl)
  setmetatable(tbl, MT)
  return tbl
end

getgenv().firesignal = function(a, ...)
  temp=a:Connect(function()end)
  temp:Disconnect()
  return firesignalhelper(temp, ...)
end

getgenv().getconnections = function(a)
  temp = a:Connect(function() end)
  signals = getothersignals(temp)
  for i,v in pairs(signals) do
	signals[i] = attachMT(v)
  end
  temp:Disconnect()
  return signals
end

getgenv().gethui = function() 
  return game.CoreGui
end

getgenv().require = function(ms)
   local old = syn.get_thread_identity()
   
   syn.set_thread_identity(2)
   local g, res = pcall(req, ms)
   syn.set_thread_identity(old)
   if not g then
       error (res)
   end
   return res    
end

getgenv().get_hidden_gui = gethui
getgenv().getloadedmodules = getmodules

getgenv().getmodules = function()
local tabl = {}
for i,v in next,getreg() do
if type(v)=="table" then
for n,c in next,v do
if typeof(c) == "Instance" and (c:IsA("ModuleScript")) then --checks if its an instance and if its a modulescript
table.insert(tabl, c) --inserts modules in the tabl table
end
end
end
end
return tabl --returns the stuff in the tabl table
end

getgenv().getscripts = function()
local tabl = {}
for i,v in next,getreg() do
if type(v)=="table" then
for n,c in next,v do
if typeof(c) == "Instance" and (c:IsA("LocalScript") or c:IsA("ModuleScript")) then --checks if its an instance and if its a localscript or a modulescript
table.insert(tabl, c) --inserts scripts in the tabl table
end
end
end
end
return tabl --returns the stuff in the tabl table
end

getgenv().getinstances = function()
local tabl = {}
for i,v in next,getreg() do
if type(v)=="table" then
for n,c in next,v do
if typeof(c) == "Instance" then --checks if its an instance
table.insert(tabl, c) --inserts instances in the tabl table
end
end
end
end
return tabl --returns the stuff in the tabl table
end

getgenv().getnilinstances = function()
local tabl = {}
for i,v in next,getreg() do
if type(v)=="table" then
for n,c in next,v do
if typeof(c) == "Instance" and c.Parent==nil then --checks if its an instance and if the parent is nil
table.insert(tabl, c) --inserts nilinstances in the tabl table
end
end
end
end
return tabl --returns the stuff in the tabl table
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

getgenv().dumpstring = function(gaysex) 
assert(type(gaysex) == "string", "fam wheres the string?", 2)  --check if its a string if its not it would error "fam wheres the string?"
return tostring("\\" .. table.concat({string.byte(gaysex, 1, #gaysex)}, "\\"))
end


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

--syn lib in lua
syn.protect_gui = function(a)
if type(a) == "userdata" and a:IsA("ScreenGui") then
pcall(function() a.Parent = gethui() end)
end
end

syn.secure_call = function(Closure, Spoof, ...)
    assert(typeof(Spoof) == "Instance", "invalid argument #1 to '?' (LocalScript or ModuleScript expected, got "..type(Spoof)..")")
    assert(Spoof.ClassName == "LocalScript" or Spoof.ClassName == "ModuleScript", "invalid argument #1 to '?' (LocalScript or ModuleScript expected, got "..type(Spoof)..")")

    local OldScript = getfenv().script
    local OldThreadID = syn.get_thread_identity()

    getfenv().script = Spoof
	syn.set_thread_identity(2)
    local Success, Err = pcall(Closure, ...)
	syn.set_thread_identity(OldThreadID)
    getfenv().script = OldScript
    if not Success and Err then error(Err) end
end

getgenv().saveinstance = function()
local start = game:HttpGet("https://pastebinp.com/raw/W9dQMBLY")
for i,v in pairs(game.Workspace:GetDescendants()) do
	if v:IsA("Part") then
		start = start..'<Item class="Part" referent="RBX713F6853A0A748419CD04C9A077C10D4"><Properties><bool name="Anchored">'..tostring(v.Anchored)..'</bool><BinaryString name="AttributesSerialize"></BinaryString><bool name="CanCollide">'..tostring(v.CanCollide)..'</bool><bool name="CastShadow">'..tostring(v.CastShadow)..'</bool><int name="CollisionGroupId">0</int><string name="Name">'..tostring(v.Name)..'</string><float name="Reflectance">'..tostring(v.Reflectance)..'</float><BinaryString name="Tags"></BinaryString><float name="Transparency">'..tostring(v.Transparency)..'</float><Vector3 name="size"> <X>'..tostring(v.Size.X)..'</X> <Y>'..tostring(v.Size.Y)..'</Y> <Z>'..tostring(v.Size.Z)..'</Z> </Vector3><Color3 name="Color"><R>'..tostring(v.Color.R)..'</R><G>'..tostring(v.Color.G)..'</G><B>'..tostring(v.Color.B)..'</B></Color3><Vector3 name="Position"><X>'..v.Position.X..'</X><Y>'..v.Position.Y..'</Y><Z>'..v.Position.Z..'</Z></Vector3><Vector3 name="Orientation"><X>'..v.Orientation.X..'</X><Y>'..v.Orientation.Y..'</Y><Z>'..v.Orientation.Z..'</Z></Vector3></Properties></Item>'
	end
end
start = start..game:HttpGet("https://pastebinp.com/raw/wCcXaSZL")
writefile(game.PlaceId..".rbxlx",start)
end
