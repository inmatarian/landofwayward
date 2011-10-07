
local ANIMLEN = 0.5

Collectible = Sprite:subclass()

function Collectible:init( x, y, animator )
  Collectible:superinit(self, x, y, 1, 1)
  self.anim = animator
  self.anim:setPattern("default")
  self.frame = 1
end

function Collectible:update(dt)
  Player.__index.update(self, dt)
  self.anim:update(dt)
  self.frame = self.anim:current()
end

----------------------------------------

Health = Collectible:subclass()
Health.animFrames = { default={{231, ANIMLEN}, {232, ANIMLEN}} }

function Health:init( x, y )
  Health:superinit(self, x, y, Animator(self.animFrames))
end

----------------------------------------

Ammo = Collectible:subclass()
Ammo.animFrames = { default={{229, ANIMLEN}, {230, ANIMLEN}} }

function Ammo:init( x, y )
  Ammo:superinit(self, x, y, Animator(self.animFrames))
end

----------------------------------------


