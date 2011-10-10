
Player = Sprite:subclass()
do
  local LENGTH = 0.25
  Player.animFrames = {
    N = { { 1, LENGTH }, { 2, LENGTH } },
    S = { { 3, LENGTH }, { 4, LENGTH } },
    W = { { 5, LENGTH }, { 6, LENGTH } },
    E = { { 7, LENGTH }, { 8, LENGTH } }
  }
end

function Player:init( x, y )
  print("Player.init", self, x, y )
  Player:superinit( self, x, y, 1, 1 )
  self.frame = 1
  self.animator = Animator( Player.animFrames )
end

function Player:handleKeypress( u, d, l, r )
  local dir, least = "I", 9999999
  if u > 0 and u < least then dir, least = "N", u end
  if d > 0 and d < least then dir, least = "S", d end
  if l > 0 and l < least then dir, least = "W", l end
  if r > 0 and r < least then dir, least = "E", r end
  if dir ~= "I" then self:move( dir ) end
end

function Player:move( dir )
  if self.moving then return end
  Player:super().move(self, dir)
  self.animator:setPattern(dir)
end

function Player:update(dt)
  Player:super().update(self, dt)
  self.animator:update(dt)
  self.frame = self.animator:current()
end

function Player:touch( other )
  other:handleTouchedByPlayer( self )
end

