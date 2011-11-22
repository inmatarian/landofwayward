
Health = CollectibleItem:subclass {
  sound = SoundEffect.HEALTH,
  quantity = 10
}

local ANIMLEN = Health.ANIMLEN
Health.animFrames = { default={{231, ANIMLEN}, {232, ANIMLEN}} }

function Health:init( x, y, id )
  Health:superinit( self, x, y, id, Animator(self.animFrames) )
end

function Health:handleTouchedByPlayer( player )
  Waygame.health = math.min( Waygame.health + self.quantity, 100 )
  Health:super().handleTouchedByPlayer(self, player)
end

