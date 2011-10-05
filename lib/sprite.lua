
Sprite = class {
  speed = 5;
  moving = false;
  xexcess = 0;
  yexcess = 0;
  xtarget = 0;
  ytarget = 0;
  lastdir = "I";
}

function Sprite:init( x, y, w, h )
  print("Sprint.init", self, x, y, w, h )
  self.x = x or 0
  self.y = y or 0
  self.w = w or 1
  self.h = h or 1
  self.frame = 0
end

function Sprite.sortingFunction( a, b )
  if a.y > b.y then return false end
  return ( a.y < b.y ) or ( a.x < b.y )
end

function Sprite:draw( camera )
  local x, y, w, h = camera:screenTranslate( self.x, self.y, self.w, self.h )
  if self.frame > 0 then
    Graphics.drawSprite( x, y, self.frame )
  else
    love.graphics.rectangle( "fill", x, y, w, h )
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
  local x, y = self:intPos()
  local xt, yt = x, y
  if dir == "N" then yt = yt - 1
  elseif dir == "S" then yt = yt + 1
  elseif dir == "W" then xt = xt - 1
  elseif dir == "E" then xt = xt + 1
  end

  local ent = self.map:getEntity( xt, yt )
  if ent == 769 then return end

  self.lastdir = dir
  self.xtarget, self.ytarget = xt, yt
  self.xexcess, self.yexcess = 0, 0
  self.moving = true
end

function Sprite:setMap( map )
  self.map = map
end
