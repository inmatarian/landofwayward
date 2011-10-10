
Health = CollectibleItem:subclass()

local ANIMLEN = Health.ANIMLEN
Health.animFrames = { default={{231, ANIMLEN}, {232, ANIMLEN}} }

function Health:init( x, y )
  Health:superinit( self, x, y, Animator(self.animFrames) )
end

function Health:handleTouchedByPlayer( player )
  Waygame.health = Waygame.health + 10
  if Waygame.health > 100 then Waygame.health = 100 end
  self.map:removeSprite( self )
end

