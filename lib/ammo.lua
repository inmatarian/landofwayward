
Ammo = CollectibleItem:subclass()

local ANIMLEN = Ammo.ANIMLEN
Ammo.animFrames = { default={{229, ANIMLEN}, {230, ANIMLEN}} }

function Ammo:init( x, y )
  Ammo:superinit( self, x, y, Animator(self.animFrames) )
end

