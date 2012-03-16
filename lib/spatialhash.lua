
local floor = math.floor

SpatialHash = class()

function SpatialHash:init( width, height )
  self.width = width
  self.height = height
  self.data = {}
end

local recycleSpatialTable
local getSpatialTable
do
  local emptyTables = Util.Stack()
  local spatialMetatable = { __mode = "k" }

  function recycleSpatialTable(t)
    if emptyTables:size() < 256 then emptyTables:push(tab) end
  end

  function getSpatialTable()
    local t = emptyTables:pop()
    if not t then t = setmetatable({}, spatialMetatable) end
    return t
  end
end

local function hash( x, y )
  return string.format("%i:%i", floor(x), floor(y))
end

local function internalAdd( self, x, y, v )
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return end
  local key = hash(x, y)
  local tab = self.data[key]
  if not tab then
    tab = getSpatialTable()
    self.data[key] = tab
  end
  tab[v] = true
end

function SpatialHash:add( x, y, w, h, v )
  local x1, x2, y1, y2 = floor(x), floor(x+w-0.01), floor(y), floor(y+h-0.01)
  for sy = y1, y2 do
    for sx = x1, x2 do
      internalAdd( self, sx, sy, v )
    end
  end
end

function SpatialHash:get( x, y )
  x, y = floor(x), floor(y)
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return nil end
  return self.data[hash(x, y)]
end

local function internalRemove( self, x, y, v )
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return end
  local key = hash(x, y)
  local tab = self.data[key]
  if type(tab)~="table" then return end
  tab[v] = nil
  if not next(tab) then
    recycleSpatialTable(tab)
    self.data[key] = nil
  end
end

function SpatialHash:remove( x, y, w, h, v )
  local x1, x2, y1, y2 = floor(x-1), floor(x+w), floor(y-1), floor(y+h)
  for sy = y1, y2 do
    for sx = x1, x2 do
      internalRemove( self, sx, sy, v )
    end
  end
end

function SpatialHash:draw( camera )
  local left, top, right, bottom, offx, offy = camera:layerDrawingParameters()
  for y = top, bottom do
    for x = left, right do
      local group = self:get( x, y )
      if group and next(group) then
        Graphics:drawRect( (x-left-offx)*16+1, (y-top-offy)*16+1, 14, 14 )
      end
    end
  end
end

