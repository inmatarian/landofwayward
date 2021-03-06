
local floor = math.floor

Sprite = class {
  x = 0, y = 0, w = 1, h = 1;
  frame = 0;
  speed = 5;
  moving = false;
  tangible = true;
  xexcess = 0;
  yexcess = 0;
  xtarget = 0;
  ytarget = 0;
  lastdir = "S";
  jump = 0;
  weakSpritesTable = setmetatable( {}, {__mode="kv"} )
}

function Sprite:init( x, y, w, h )
  self.x = x or Sprite.x
  self.y = y or Sprite.y
  self.w = w or Sprite.w
  self.h = h or Sprite.h

  self.xtarget, self.ytarget = self.x, self.y

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
  if Waygame.debug then
    Graphics:drawRect( x, y - self.jump, 16, 16 )
  end

  if self.animator then
    self.frame = self.animator:current()
  end

  if self.frame > 0 then
    Graphics:drawSprite( x, y - self.jump, self.frame )
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

  if not self.moving then
    local ent = self.map:getEntity( nx, ny )
    if ent > EntityCode.BLOCK then
      self:steppedOn( ent, nx, ny )
    end
  end
end

function Sprite:setPos( newx, newy )
  self.x, self.y = newx, newy
end

function Sprite:intPos()
  return floor(self.x), floor(self.y)
end

function Sprite:move( dir )
  if self.moving then return end
  local xt, yt = self.x, self.y

  if dir == "N" then yt = floor(yt - 1)
  elseif dir == "S" then yt = floor(yt + 1)
  elseif dir == "W" then xt = floor(xt - 1)
  elseif dir == "E" then xt = floor(xt + 1)
  end

  local blocked, ent = self:blockedAt( xt, yt )
  if blocked then
    self:thud( dir, ent )
    if EntityCode.isSign(ent) then
      self:touchSign( ent, xt, yt )
    elseif ent == EntityCode.PORTAL then
      self:handlePortal( dir, xt, yt )
    end
    if self.tangible then return true end
  end
  local other = self:testCollisionAt( xt, yt )
  if type(other)=="table" then
    self:touch( other )
    if self.tangible then return true end
  end

  self.lastdir = dir
  self.xtarget, self.ytarget = xt, yt
  self.xexcess, self.yexcess = 0, 0
  self.moving = true
end

function Sprite:blockedAt( x, y )
  local ent = self.map:getEntity( x, y )
  return self:blockedBy( ent ), ent
end

function Sprite:blockedBy( ent )
  if ent == EntityCode.BLOCK or
     ent == EntityCode.PORTAL
  then
    return true
  end
end

function Sprite:testCollisionAt( x, y )
  for yt = y-1, y+1 do
    for xt = x-1, x+1 do
      local others = self.map:getSpritesAt( xt, yt )
      if others then
        for other, _ in pairs(others) do
          if other ~= self and other ~= self.parent then
            if Util.rectOverlaps( x, y, self.w, self.h,
                                  other.x, other.y, other.w, other.h )
            then
              return other
            end
          end
        end
      end
    end
  end
end

function Sprite:setMap( map )
  self.map = map
  if self.tangible then
    self.map:updateSpatialHash( self )
  end
end

function Sprite:setGamestate( state )
  self.gamestate = state
end

function Sprite:getSeekDir( other )
  local x, y = other.x - self.x, other.y - self.y
  local tx = ((x<0) and "W") or ((x>0) and "E") or nil
  local ty = ((y<0) and "N") or ((y>0) and "S") or nil
  if not tx then return ty end
  if not ty then return tx end
  -- randomly choose weighted toward the larger distance
  x, y = math.abs(x), math.abs(y)
  if math.random(0, x+y) < x then return tx end
  return ty
end

function Sprite:getFacingSeekDir( other )
  local x, y = other.x - self.x, other.y - self.y
  local tx = ((x<0) and "W") or ((x>0) and "E") or nil
  local ty = ((y<0) and "N") or ((y>0) and "S") or nil
  if not tx then return ty end
  if not ty then return tx end
  x, y = math.abs(x), math.abs(y)
  return (x > y) and tx or ty
end

function Sprite:getLinedUpSeekDir( other )
  local x, y = other.x - self.x, other.y - self.y
  if ( y == 0 ) or ( x == 0 ) then return "I" end
  local ax, ay = math.abs(x), math.abs(y)
  if ax > ay then
    return ( x < 0 ) and "W" or "E"
  else
    return ( y < 0 ) and "N" or "S"
  end
end

-- Direction translation tables
local oppdir = { N="S", E="W", S="N", W="E" }
local cwdir =  { N="E", E="S", S="W", W="N" }
local ccwdir = { N="W", E="N", S="E", W="S" }

local function perpendicular_dir( d )
  local r = math.random( 0, 1 );
  if ( d == "N" ) or ( d == "S" ) then return (r==0) and "W" or "E"
  elseif ( d == "W" ) or ( d == "E" ) then return (r==0) and "N" or "S"
  end
  return "I"
end

function Sprite:translateDir( d )
  local player = Waygame.player
  if d == "T" then return self:getSeekDir(player) end
  if d == "A" then return oppdir[self:getSeekDir(player)] end
  if d == "C" then return cwdir[self:getSeekDir(player)] end
  if d == "K" then return ccwdir[self:getSeekDir(player)] end
  if d == "L" then return self:getLinedUpSeekDir(player) end
  if d == "P" then return perpendicular_dir(self:getSeekDir(player)) end
  if d == "F" then return self:getFacingSeekDir(player) end
  if d == "R" then return Util.randomPick("N", "S", "W", "E") end
  return d -- leave everything else untranslated
end

-- virtual methods
function Sprite:overlaps( other ) end
function Sprite:touch( other ) end
function Sprite:thud( dir ) end
function Sprite:touchSign( ent, x, y ) end
function Sprite:handleTouchedByPlayer( player ) end
function Sprite:handleShotByPlayer() end
function Sprite:handleShotByEnemy() end
function Sprite:steppedOn( ent, x, y ) end
function Sprite:handlePortal( ent, x, y ) end

