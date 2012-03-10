
Player = Sprite:subclass()
do
  local LENGTH = 0.25
  local SHOTLEN = 0.1
  local FREEZE = Animator.FREEZE
  local CODE = SpriteCode.SYLVIA
  Player.animFrames = {
    N = { { CODE+0, LENGTH }, { CODE+1, LENGTH } },
    S = { { CODE+2, LENGTH }, { CODE+3, LENGTH } },
    W = { { CODE+4, LENGTH }, { CODE+5, LENGTH } },
    E = { { CODE+6, LENGTH }, { CODE+7, LENGTH } },
    NHold = { { CODE+0, FREEZE } },
    SHold = { { CODE+2, FREEZE } },
    WHold = { { CODE+4, FREEZE } },
    EHold = { { CODE+6, FREEZE } },
    NShoot = { { CODE+1, SHOTLEN }, { CODE+0, FREEZE } },
    SShoot = { { CODE+3, SHOTLEN }, { CODE+2, FREEZE } },
    WShoot = { { CODE+5, SHOTLEN }, { CODE+4, FREEZE } },
    EShoot = { { CODE+7, SHOTLEN }, { CODE+6, FREEZE } },
  }
end

function Player:init( x, y )
  print("Player.init", self, x, y )
  Player:superinit( self, x, y, 1, 1 )
  self.animator = Animator( Player.animFrames, "S" )
  Waygame.player = self
end

function Player:prioritizedDirectionPressed()
  local dir, least = "I", 9999999
  local u, d = Input.up:pressedLength(), Input.down:pressedLength()
  local l, r = Input.left:pressedLength(), Input.right:pressedLength()
  if u > 0 and u < least then dir, least = "N", u end
  if d > 0 and d < least then dir, least = "S", d end
  if l > 0 and l < least then dir, least = "W", l end
  if r > 0 and r < least then dir, least = "E", r end
  return dir
end

function Player:handleInput()
  if Input:isClicked("s") then self.speed = (self.speed == 5) and 10 or 5 end

  if Input.shoot:isClicked() then
    self.animator:setPattern(self.lastdir.."Hold")
    local dir = self:prioritizedDirectionPressed()
    if dir ~= "I" then
      self:shoot( dir )
    end

  elseif Input.shoot:isPressed() then
    local dir = "I"
    if Input.up:isClicked() then dir = "N"
    elseif Input.down:isClicked() then dir = "S"
    elseif Input.left:isClicked() then dir = "W"
    elseif Input.right:isClicked() then dir = "E" end
    if dir ~= "I" then
      self:shoot( dir )
    end

  else
    local dir = self:prioritizedDirectionPressed()
    if dir ~= "I" then
      self:move( dir )
    else
      self.animator:setPattern(self.lastdir)
      if not self.moving then
        self.xexcess, self.yexcess = 0, 0
      end
    end
  end
end

function Player:move( dir )
  if self.moving then return end
  Player:super().move(self, dir)
  self.animator:setPattern(dir)
end

function Player:shoot( dir )
  self.animator:resetPattern(dir.."Shoot")
  self.lastdir = dir
  if Waygame.ammo >= 1 then
    Waygame.ammo = Waygame.ammo - 1
    local x, y = self.x, self.y
    self.map:addSprite( PlayerBullet( x, y, dir, self ) )
    Sound:playsound( SoundEffect.PLAYERSHOOT )
  elseif Waygame.ammoMax >= 1 then
    Sound:playsound( SoundEffect.NOAMMO )
  end
end

function Player:update(dt)
  Player:super().update(self, dt)
  self:handleInput()
end

function Player:touch( other )
  other:handleTouchedByPlayer( self )
end

function Player:touchSign( ent, x, y )
  self.gamestate:handleSign( ent )
end

function Player:isSpriteNearVisible( other )
  local x, y = self.x, self.y
  local ox, oy = other.x, other.y
  return (ox > (x - 12)) and (ox < (x + 12)) and (oy > (y - 9)) and (oy < (y + 9))
end

function Player:blockedBy( ent )
  if ent == EntityCode.NOSYLVIAWALL or
     ent == EntityCode.GOOP or
     EntityCode.isSign(ent)
  then
    return true
  end
  return GenericEnemy:super().blockedBy( self, ent )
end

function Player:steppedOn( ent, x, y )
  if EntityCode.isTrigger( ent ) then
    self.gamestate:handleTrigger( ent, x, y )
  elseif EntityCode.isExit( ent ) then
    self.gamestate:handleExit( ent, x, y )
  elseif EntityCode.isTeleport( ent ) then
    self:handleTeleport(ent)
  end
end

function Player:handleTeleport( ent )
  local newEnt
  if ((ent - EntityCode.TELEPORT1) % 2) == 1 then
    newEnt = ent - 1
  else
    newEnt = ent + 1
  end
  local x, y = self.map:locateEntity( newEnt )
  if x and y then self:setPos( x, y ) end
end

function Player:handlePortal( dir, x, y )
  local dx, dy
  if dir == "N" then dx, dy = 0, -1
  elseif dir == "S" then dx, dy = 0, 1
  elseif dir == "W" then dx, dy = -1, 0
  elseif dir == "E" then dx, dy = 1, 0
  end

  local ent
  repeat
    x, y = x + dx, y + dy
    ent = self.map:getEntity(x, y)
  until ent == EntityCode.PORTAL

  self:setPos( x, y )
end


