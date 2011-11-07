
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

function Util.printr( t, indent) -- http://richard.warburton.it
  indent = indent or ''
  if indent:len() > 40 then return end
  local lines = 0
  for key, value in pairs(t) do
    io.write(indent,'[',tostring(key),']')
    if type(value)=="table" then io.write(':\n'); Util.printr(value,indent..'  ')
    elseif type(value)=="string" then
      if value:len() > 64 then io.write(' = "',value:sub(1,61),'..."\n')
      else io.write(' = "',value,'"\n') end
    else io.write(' = ',tostring(value),'\n') end
    lines = lines + 1
    if lines > 20 then io.write(indent,"..."); break end
  end
end

function Util.hash(...)
  local s = select(1, ...)
  for n = 2, select('#', ...) do
    local e = select(n, ...)
    s=s..":"..tostring(e)
  end
  return s
end

