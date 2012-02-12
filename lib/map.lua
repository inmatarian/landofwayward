
local deflate = require("lib.3rdparty.deflate.deflatelua")

Layer = class()

function Layer:init( width, height, default )
  self.width = width
  self.height = height
  self.default = self.default or 0
  self.data = {}
end

function Layer:set( x, y, v )
  x, y = math.floor(x), math.floor(y)
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return end
  self.data[1 +(y*self.width + x)] = v
end

function Layer:get( x, y )
  x, y = math.floor(x), math.floor(y)
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return self.default end
  return self.data[1 + (y*self.width + x)]
end

function Layer:draw( camera )
  local left, top, right, bottom, offx, offy = camera:layerDrawingParameters()
  for y = top, bottom do
    for x = left, right do
      local tile = self:get( x, y )
      if tile then
        Graphics:drawRect( (x-left-offx)*16+1, (y-top-offy)*16+1, 14, 14 )
      end
    end
  end
end

------------------------------------------------------------------------------

TileLayer = Layer:subclass()

function TileLayer:draw( camera )
  local left, top, right, bottom, offx, offy = camera:layerDrawingParameters()
  for y = top, bottom do
    for x = left, right do
      local tile = self:get( x, y )
      if tile > 0 then
        Graphics:drawTile( (x-left-offx)*16, (y-top-offy)*16, tile )
      end
    end
  end
end

function TileLayer:findFirst( x )
  local N = #self.data
  for i = 1, N do
    if self.data[i] == x then
      return (i-1)%self.width, math.floor((i-1)/self.width)
    end
  end
end

------------------------------------------------------------------------------
-- A couple of bootleg xml dom functions, move to util?

local DOM = {}

function DOM.getElementByLabel( elem, str )
  for _,e in ipairs(elem) do
    if type(e)=="table" and e.label==str then return e end
  end
end

function DOM.getElementsByLabel( elem, str )
  local results = {}
  for _,e in ipairs(elem) do
    if type(e)=="table" and e.label==str then table.insert(results,e) end
  end
  if #results ~= 0 then return results end
end

function DOM.loadLayer( data, width, height, firstgid )
  local layer = TileLayer( width, height )
  if data.xarg.encoding == "csv" then
    local str = data[1]
    local N, i, x, y = str:len(), 0, 0, 0
    if str:sub(i,i)=='\n' then i = i + 1 end
    while i <= N do
      local t = str:find(',', i) or N
      local v = tonumber( str:sub(i, t-1) )
      assert( type(v) == "number" )
      layer:set( x, y, v )
      i, x = t + 1, x + 1
      if x >= width then x = 0; y = y + 1 end
      if str:sub(i,i)=='\n' then i = i + 1 end
    end
  elseif data.xarg.encoding == "base64" then
    local inflate
    if data.xarg.compression == "zlib" then inflate = deflate.inflate_zlib
    elseif data.xarg.compression == "gzip" then inflate = deflate.gunzip
    else error("Unknown compression "..data.xarg.compression) end

    local decoded = Util.base64decode(data[1])
    local x, y, b, long = 0, 0, 0, { 0, 0, 0, 0 }
    inflate {
      input = decoded,
      output = function(v)
        b = b + 1
        long[b] = v
        if b == 4 then
          local t = (long[2] * 256) + long[1]
          layer:set( x, y, t )
          x = x + 1
          if x >= width then x, y = 0, y + 1 end
          b = 0
        end
      end
    }
  end
  return layer
end

------------------------------------------------------------------------------

Map = class( { width=0; height=0 } )

function Map:init( filename )
  self.layers = { above = false, below = false, entity = false }
  self.sprites = {}
  self:loadTMX( filename )
  self.spatialHash = SpatialHash( self.width, self.height, false )
  self.spriteQueue = Util.Queue()
end

function Map:loadTMX( filename )
  local xml = love.filesystem.read( filename )
  assert( xml, "error loading "..filename )
  local tree = Util.xmlCollect( xml )
  assert( tree, "error loading "..filename )
  local map = DOM.getElementByLabel( tree, "map" )
  assert( map, "error loading "..filename )
  local tileset = DOM.getElementByLabel( map, "tileset" )
  assert( tileset, "error loading "..filename )
  local layers = DOM.getElementsByLabel( map, "layer" )
  assert( layers, "error loading "..filename )

  self.width, self.height = tonumber(map.xarg.width), tonumber(map.xarg.height)
  local firstgid = tonumber(tileset.xarg.firstgid)

  for _, elem in ipairs(layers) do
    local w, h = tonumber(elem.xarg.width), tonumber(elem.xarg.height)
    local layernum
    local props = DOM.getElementByLabel( elem, "properties" )
    for _, property in ipairs(props) do
      if property.xarg.name == "layernum" then layernum = property.xarg.value end
    end
    if layernum ~= nil then
      local dataelem = DOM.getElementByLabel( elem, "data" )
      local layer = DOM.loadLayer( dataelem, w, h, firstgid )
      if layernum == "1" then
        self.layers.below = layer
      elseif layernum == "2" then
        self.layers.above = layer
      elseif layernum == "0" then
        self.layers.entity = layer
      end
    end
  end
end

function Map:draw( camera )
  if self.layers.below then
    self.layers.below:draw(camera)
  end
  if Waygame.debug then
    if self.layers.entity then
      self.layers.entity:draw(camera)
    end
    self.spatialHash:draw(camera)
  end
  for i = 1, #self.sprites do
    self.sprites[i]:draw(camera)
  end
  if self.layers.above then
    self.layers.above:draw(camera)
  end
end

function Map:addSprite( sprite )
  table.insert(self.sprites, sprite)
  sprite:setMap( self )
end

function Map:removeSprite( sprite )
  for i, v in ipairs(self.sprites) do
    if sprite==v then
      table.remove( self.sprites, i )
    end
  end
  if sprite.tangible then
    self.spatialHash:remove(sprite.x, sprite.y, sprite.w, sprite.h, sprite)
  end
end

function Map:update(dt)
  for i = 1, #self.sprites do
    self.spriteQueue:enqueue(self.sprites[i])
  end
  while not self.spriteQueue:isEmpty() do
    self.spriteQueue:dequeue():update(dt)
  end
  table.sort( self.sprites, Sprite.sortingFunction )
end

function Map:locateEntity( number )
  if not self.layers.entity then return end
  return self.layers.entity:findFirst( number )
end

function Map:getEntity( x, y )
  if not self.layers.entity then return end
  return self.layers.entity:get( x, y )
end

function Map:updateSpatialHash( sprite, ox, oy, ow, oh )
  if ox then self.spatialHash:remove(ox, oy, ow, oh, sprite) end
  self.spatialHash:add(sprite.x, sprite.y, sprite.w, sprite.h, sprite)
end

function Map:getSpritesAt( x, y )
  return self.spatialHash:get(x, y)
end

