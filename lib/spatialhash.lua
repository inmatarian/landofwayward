
SpatialHash = class()

function SpatialHash:init( width, height )
  self.width = width
  self.height = height
  self.data = {}
  self.emptyTables = Util.Stack()
end

local function internalAdd( self, x, y, v )
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return end
  local key = 1 +(y*self.width + x)
  local tab = self.data[key]
  if not tab then
    tab = self.emptyTables:pop() or {}
    self.data[key] = tab
  end
  tab[v] = true
end

function SpatialHash:add( x, y, w, h, v )
  local fl=math.floor
  local x1, x2, y1, y2 = fl(x), fl(x+w-0.01), fl(y), fl(y+h-0.01)
  for sy = y1, y2 do
    for sx = x1, x2 do
      internalAdd( self, sx, sy, v )
    end
  end
end

function SpatialHash:get( x, y )
  x, y = math.floor(x), math.floor(y)
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return nil end
  return self.data[1 + (y*self.width + x)]
end

local function internalRemove( self, x, y, v )
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return end
  local key = 1 +(y*self.width + x)
  local tab = self.data[key]
  if type(tab)~="table" then return end
  tab[v] = nil
  local empty = true
  for i, v in pairs(tab) do empty = false; break end
  if empty then
    if self.emptyTables:size() < 256 then self.emptyTables:push(tab) end
    self.data[key] = nil
  end
end

function SpatialHash:remove( x, y, w, h, v )
  local fl=math.floor
  local x1, x2, y1, y2 = fl(x), fl(x+w-0.01), fl(y), fl(y+h-0.01)
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
      if group then
        local empty = true
        for i, v in pairs(group) do empty = false; break end
        Graphics:drawRect( (x-left-offx)*16+1, (y-top-offy)*16+1, 14, 14, nil, empty )
      end
    end
  end
end

