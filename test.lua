function classcall(class, ...)
  local inst = {}
  setmetatable(inst, inst)
  inst.__index = class
  if inst.init then inst:init(...) end
  return inst
end

function class( superclass )
  local t = {}
  t.__index = superclass
  t.__call = classcall
  return setmetatable(t, t)
end

NoiseMap = class()

function NoiseMap:init( w, h )
  self.width = w or 8
  self.height = h or 8
  self.data = {}
  self:divide( 0, 0, self.width+1, self.height+1, math.random(), math.random(), math.random(), math.random())
end

function NoiseMap:get(x, y) return self.data[ y*self.width+x ] end
function NoiseMap:set(x, y, v) self.data[ y*self.width+x ] = v end

function NoiseMap:displace( v )
  local max = v / (self.width + self.height) * 3
  return (math.random() - 0.5) * max
end

function NoiseMap:divide( x, y, w, h, c1, c2, c3, c4 )
  if w > 2 or h > 2 then
    local nW = w/2
    local nH = h/2
    local mid = ( c1 + c2 + c3 + c4 ) / 4 + self:displace(nW, nH)
    local e1 = (c1 + c2) / 2
    local e2 = (c2 + c3) / 2
    local e3 = (c3 + c4) / 2
    local e4 = (c4 + c1) / 2

    if mid < 0 then mid = 0 elseif mid > 1 then mid = 1 end

    self:divide(x, y, nW, nH, c1, e1, mid, e4);
    self:divide(x + nW, y, nW, nH, e1, c2, e2, mid);
    self:divide(x + nW, y + nH, nW, nH, mid, e2, c3, e3);
    self:divide(x, y + nH, nW, nH, e4, mid, e3, c4);
  else
    local c = (c1+c2+c3+c4)/4
    self:set( math.floor(x), math.floor(y), c )
  end
end

function NoiseMap:dump()
  for y = 0, self.height-1 do
    for x = 0, self.width-1 do
      io.write( string.format("%8.3f ", self:get(x, y)) )
    end
    io.write("\n")
  end
end

map = NoiseMap()
map:dump()

