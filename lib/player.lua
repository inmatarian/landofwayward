
Player = Sprite:subclass()
do
  local LENGTH = 0.25
  local SHOTLEN = 0.1
  local FREEZE = Animator.FREEZE
  Player.animFrames = {
    N = { { 1, LENGTH }, { 2, LENGTH } },
    S = { { 3, LENGTH }, { 4, LENGTH } },
    W = { { 5, LENGTH }, { 6, LENGTH } },
    E = { { 7, LENGTH }, { 8, LENGTH } },
    NHold = { { 1, FREEZE } },
    SHold = { { 3, FREEZE } },
    WHold = { { 5, FREEZE } },
    EHold = { { 7, FREEZE } },
    NShoot = { { 2, SHOTLEN }, { 1, FREEZE } },
    SShoot = { { 4, SHOTLEN }, { 3, FREEZE } },
    WShoot = { { 6, SHOTLEN }, { 5, FREEZE } },
    EShoot = { { 8, SHOTLEN }, { 7, FREEZE } },
  }
end

function Player:init( x, y )
  print("Player.init", self, x, y )
  Player:superinit( self, x, y, 1, 1 )
  self.frame = 1
  self.animator = Animator( Player.animFrames )
  Waygame.player = self
end

function Player:handleKeypress(key)
  local u, d, l, r, sp = key["up"], key["down"], key["left"], key["right"], key[" "]

  if Waygame:isKey("s") then self.speed = (self.speed == 5) and 10 or 5 end

  if sp >= 1 then
    local dir = "I"
    if u == 1 then dir = "N" end
    if d == 1 then dir = "S" end
    if l == 1 then dir = "W" end
    if r == 1 then dir = "E" end
    if dir ~= "I" then
      self:shoot( dir )
    elseif sp == 1 then
      self.animator:setPattern(self.lastdir.."Hold")
    end
  else
    local dir, least = "I", 9999999
    if u > 0 and u < least then dir, least = "N", u end
    if d > 0 and d < least then dir, least = "S", d end
    if l > 0 and l < least then dir, least = "W", l end
    if r > 0 and r < least then dir, least = "E", r end
    if dir ~= "I" then
      self:move( dir )
    else
      self.animator:setPattern(self.lastdir)
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
    self.map:addSprite( PlayerBullet( x, y, dir ) )
    Sound:playsound( SoundEffect.PLAYERSHOOT )
  else
    Sound:playsound( SoundEffect.NOAMMO )
  end
end

function Player:update(dt)
  Player:super().update(self, dt)
  self.animator:update(dt)
  self.frame = self.animator:current()
  self:handleKeypress(Waygame.keypress)
end

function Player:touch( other )
  other:handleTouchedByPlayer( self )
end

function Player:isSpriteNearVisible( other )
  local x, y = self.x, self.y
  local ox, oy = other.x, other.y
  return (ox > (x - 12)) and (ox < (x + 12)) and (oy > (y - 9)) and (oy < (y + 9))
end

