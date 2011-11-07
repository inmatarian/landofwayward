
Sprite = class {
  speed = 5;
  moving = false;
  tangible = true;
  xexcess = 0;
  yexcess = 0;
  xtarget = 0;
  ytarget = 0;
  lastdir = "S";
  weakSpritesTable = setmetatable( {}, {__mode="kv"} )
}

function Sprite:init( x, y, w, h )
  self.x = x or 0
  self.y = y or 0
  self.w = w or 1
  self.h = h or 1
  self.frame = 0

  Sprite.weakSpritesTable[self]=self
end

function Sprite.sortingFunction( a, b )
  if a.y > b.y then return false end
  return ( a.y < b.y ) or ( a.x < b.x )
end

function Sprite:draw( camera )
  local x, y, w, h = camera:screenTranslate( self.x, self.y, self.w, self.h )
  if x < -w or y < -h or x > Graphics.gameWidth or y > Graphics.gameHeight then
    return
  end
  if self.frame > 0 then
    Graphics:drawSprite( x, y, self.frame )
  end
end

function Sprite:update(dt)
  self:updatePosition(dt)
end

function Sprite:updatePosition(dt)
  local xex, yex = self.xexcess, self.yexcess
  self.xexcess, self.yexcess = 0, 0
  if not self.moving then return end
  local xt, yt = self.xtarget, self.ytarget
  local oldx, oldy = self.x, self.y
  local nx, ny = oldx, oldy
  local speed = self.speed * dt

  if xt < oldx then
    nx = oldx - speed - xex
    if nx <= xt then
      self.xexcess, nx, self.moving = xt-nx, xt, false
    end
  elseif xt > oldx then
    nx = oldx + speed + xex
    if nx >= xt then
      self.xexcess, nx, self.moving = nx-xt, xt, false
    end
  end
  if yt < oldy then
    ny = oldy - speed - yex
    if ny <= yt then
      self.yexcess, ny, self.moving = yt-ny, yt, false
    end
  elseif yt > oldy then
    ny = oldy + speed + yex
    if ny >= yt then
      self.yexcess, ny, self.moving = ny-yt, yt, false
    end
  end

  self.x, self.y = nx, ny
  if self.tangible then
    self.map:updateSpatialHash( self, oldx, oldy, self.w, self.h )
  end
end

function Sprite:setPos( newx, newy )
  self.x, self.y = newx, newy
end

function Sprite:intPos()
  local floor = math.floor
  return floor(self.x), floor(self.y)
end

function Sprite:move( dir )
  if self.moving then return end
  local floor = math.floor
  local xt, yt = self.x, self.y

  if dir == "N" then yt = floor(yt - 1)
  elseif dir == "S" then yt = floor(yt + 1)
  elseif dir == "W" then xt = floor(xt - 1)
  elseif dir == "E" then xt = floor(xt + 1)
  end

  local ent = self.map:getEntity( xt, yt )
  if ent == EntityCode.BLOCK then
    self:thud( dir )
    if self.tangible then return true end
  end
  local other = self.map:getSpriteAt( xt, yt )
  if other and other ~= self then
    self:touch( other )
    if self.tangible then return true end
  end

  self.lastdir = dir
  self.xtarget, self.ytarget = xt, yt
  self.xexcess, self.yexcess = 0, 0
  self.moving = true
end

function Sprite:touch( other )
  -- virtual
end

function Sprite:thud( dir )
  -- virtual
end

function Sprite:handleTouchedByPlayer( player )
  -- virtual
end

function Sprite:setMap( map )
  self.map = map
  if self.tangible then
    self.map:updateSpatialHash( self )
  end
end

