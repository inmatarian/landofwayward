
Util = {}

Util.strict_mt = {}
Util.strict_mt.__newindex = function( t, k, v ) error("attempt to update a read-only table", 2) end
Util.strict_mt.__index = function( t, k ) error("attempt to read key "..k, 2) end

function Util.strict( table )
  return setmetatable( table, strict_mt )
end

function Util.randomPull( ... )
  local pull = math.random(0, 10000) / 10000
  for n = 1, select('#', ...) do
    local e = select(n, ...)
    if pull < e then return n end
    pull = pull - e
  end
  return nil
end

function Util.randomPick(...)
  return select( math.random( select('#', ...) ), ... )
end

function Util.setDefaultValue( tab, val )
  return setmetatable( tab, { __index = function() return val end } )
end

do
  -- Roberto Ierusalimschy's XML parser
  local function parseargs(s)
    local arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
      arg[w] = a
    end)
    return arg
  end

  local function collect(s)
    local stack = {}
    local top = {}
    table.insert(stack, top)
    local ni,c,label,xarg, empty
    local i, j = 1, 1
    while true do
      ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
      if not ni then break end
      local text = string.sub(s, i, ni-1)
      if not string.find(text, "^%s*$") then
        table.insert(top, text)
      end
      if empty == "/" then  -- empty element tag
        table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
      elseif c == "" then   -- start tag
        top = {label=label, xarg=parseargs(xarg)}
        table.insert(stack, top)   -- new level
      else  -- end tag
        local toclose = table.remove(stack)  -- remove top
        top = stack[#stack]
        if #stack < 1 then
          error("nothing to close with "..label)
        end
        if toclose.label ~= label then
          error("trying to close "..toclose.label.." with "..label)
        end
        table.insert(top, toclose)
      end
      i = j+1
    end
    local text = string.sub(s, i)
    if not string.find(text, "^%s*$") then
      table.insert(stack[#stack], text)
    end
    if #stack > 1 then
      error("unclosed "..stack[#stack].label)
    end
    return stack[1]
  end

  Util.xmlCollect = collect
end

local function tprintr(t, indent, loopt)
  for key, value in pairs(t) do
    io.write(indent, '[',tostring(key),']')
    if type(value)=="table" then
      local mt = getmetatable(value)
      if type(mt)=="table" and type(mt.__index)=="table" then
        io.write(' = Object\n')
      elseif not loopt[value] then
        loopt[value]=true
        io.write(':\n')
        tprintr(value, indent..'  ', loopt)
      else
        io.write(': (previously referenced table)\n')
      end
    elseif type(value)=="string" then
      if value:len() > 64 then
        io.write(' = "', value:sub(1,61), '..."\n')
      else
        io.write(' = "', value, '"\n')
      end
    else
      io.write(' = ', tostring(value), '\n')
    end
  end
end

function Util.printr( t ) -- http://richard.warburton.it
  tprintr(t, '', {})
end

function Util.hash(...)
  local s = select(1, ...)
  for n = 2, select('#', ...) do
    local e = select(n, ...)
    s=s..":"..tostring(e)
  end
  return s
end

function Util.rectOverlaps( ax1, ay1, aw, ah, bx1, by1, bw, bh )
  local hint = 0.001
  local ax2, ay2 = ax1+aw-hint, ay1+ah-hint
  local bx2, by2 = bx1+bw-hint, by1+bh-hint
  return not ((ax1 > bx2) or (bx1 > ax2) or (ay1 > by2) or (by1 > ay2))
end

  
local b64t = {}
local b64s='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
do
  for i = 1, #b64s do
    b64t[b64s:sub(i,i)]=i-1
  end
end

function Util.base64decode( str )
  local d = {}
  local shift, accum, out = 0, 0, 1
  for ch in str:gmatch(".") do
    local val = b64t[ch]
    if val then
      shift, accum = shift + 6, (accum * 64) + val
      if shift >= 8 then
        shift = shift - 8
        local div = 2^shift
        d[out] = string.char( math.floor(accum / div) % 256 )
        out = out + 1
        accum = accum % div
      end
    end
  end
  return table.concat(d)
end

-----------------------------------------------------------------------------

Util.Stack = class()

function Util.Stack:init()
  self:clear()
end

function Util.Stack:push(...)
  for i = 1, select('#',...) do
    self[#self+1] = select(i, ...)
  end
end

function Util.Stack:pop()
  local N, R = #self, nil
  if N > 0 then R, self[N] = self[N], nil end
  return R
end

function Util.Stack:isEmpty()
  return (#self <= 0)
end

function Util.Stack:clear()
  for i = 1, #self do
    self[i] = nil
  end
end

function Util.Stack:size()
  return #self
end

-----------------------------------------------------------------------------

Util.Queue = class{ left = 0, right = 0 }

function Util.Queue:init()
  self:clear()
end

function Util.Queue:clear()
  for i = self.left, self.right do
    self[i] = nil
  end
  self.left = 0
  self.right = 0
end

function Util.Queue:enqueue(...)
  for i = 1, select('#', ...) do
    self.right = self.right + 1
    self[self.right] = select(i, ...)
  end
end

function Util.Queue:dequeue()
  self.left = self.left + 1
  local R = self[self.left]
  self[self.left] = nil
  if self.left == self.right then self.left, self.right = 0, 0 end
  return R
end

function Util.Queue:isEmpty()
  return (self.left == self.right)
end

function Util.Queue:size()
  return self.right - self.left
end

-----------------------------------------------------------------------------

Util.MethodBinding = class()

function Util.MethodBinding:init( obj, func )
  self.obj, self.func = obj, func
end

function Util.MethodBinding.__call(self, ...)
  self.func(self.obj, ...)
end

-----------------------------------------------------------------------------

Util.CallbackTimer = class()

function Util.CallbackTimer:init( freq, func )
  self.func, self.freq = func, freq
  self.clock = 0
end

function Util.CallbackTimer:update(dt)
  self.clock = self.clock + dt
  if self.clock > self.freq then
    self.clock = self.clock - self.freq
    self.func()
  end
end

-----------------------------------------------------------------------------

