
Health = CollectibleItem:subclass()

local ANIMLEN = Health.ANIMLEN
Health.animFrames = { default={{231, ANIMLEN}, {232, ANIMLEN}} }

function Health:init( x, y )
  Health:superinit( self, x, y, Animator(self.animFrames) )
end

