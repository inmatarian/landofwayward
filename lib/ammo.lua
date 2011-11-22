
Ammo = CollectibleItem:subclass {
  sound = SoundEffect.AMMO
}

local ANIMLEN = Ammo.ANIMLEN
Ammo.animFrames = { default={{229, ANIMLEN}, {230, ANIMLEN}} }

function Ammo:init( x, y, id )
  Ammo:superinit( self, x, y, id, Animator(self.animFrames) )
end

function Ammo:handleTouchedByPlayer( player )
  Waygame.ammoMax = math.min( 7, Waygame.ammoMax + 1 )
  Ammo:super().handleTouchedByPlayer(self, player)
end

