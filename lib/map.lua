
require "class"
require "graphics"
require "sprite"
require "util"

------------------------------------------------------------------------------

Layer = class()

function Layer:init( width, height )
  self.width = width
  self.height = height
  self.data = {}
end

function Layer:set( x, y, v )
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return end
  self.data[1 +(y*self.width + x)] = v
end

function Layer:get( x, y )
  if x < 0 or y < 0 or x >= self.width or y >= self.height then return 0 end
  return self.data[1 + (y*self.width + x)]
end

function Layer:draw( camera )
  local left, top, right, bottom, offx, offy = camera:layerDrawingParameters()
  for y = top, bottom do
    for x = left, right do
      local tile = self:get( x, y )
      if tile > 0 then
        Graphics.drawTile( (x-left-offx)*16, (y-top-offy)*16, tile )
      end
    end
  end
end

function Layer:findFirst( x )
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
  local layer = Layer( width, height )
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
  else
    error( "unknown encoding "..data.xarg.encoding )
  end
  return layer
end

------------------------------------------------------------------------------

Map = class( { width=0; height=0 } )

function Map:init( filename )
  self.layers = { above = {}, below = {}, entity = false }
  self.sprites = {}
  self:loadTMX( filename )
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
    local layertype
    local props = DOM.getElementByLabel( elem, "properties" )
    for _, property in ipairs(props) do
      if property.xarg.name == "type" then layertype = property.xarg.value end
    end
    if layertype ~= nil then
      local dataelem = DOM.getElementByLabel( elem, "data" )
      local layer = DOM.loadLayer( dataelem, w, h, firstgid )
      if layertype == "entity" then
        self.layers.entity = layer
      elseif self.layers[layertype] then
        table.insert( self.layers[layertype], layer )
      end
    end
  end
end

function Map:draw( camera )
  for _, layer in ipairs( self.layers.below ) do
    layer:draw(camera)
  end
  for _, sprite in ipairs( self.sprites ) do
    sprite:draw(camera)
  end
  for _, layer in ipairs( self.layers.above ) do
    layer:draw(camera)
  end
  if self.drawEntityLayer then
    self.layers.entity:draw(camera)
  end
end

function Map:addSprite( sprite )
  table.insert(self.sprites, sprite)
  sprite:setMap( self )
end

function Map:update(dt)
  for _, sprite in ipairs( self.sprites ) do
    sprite:update(dt)
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
