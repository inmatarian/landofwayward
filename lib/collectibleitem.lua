
CollectibleItem = Sprite:subclass()
CollectibleItem.ANIMLEN = 0.5

function CollectibleItem:init( x, y, id, animator )
  CollectibleItem:superinit( self, x, y, 1, 1 )
  self.anim = animator
  self.anim:setPattern("default")
  self.frame = 1
  self.id = id
end

function CollectibleItem:update(dt)
  CollectibleItem:super().update( self, dt )
  self.anim:update(dt)
  self.frame = self.anim:current()
end

function CollectibleItem:handleTouchedByPlayer( player )
  self.map:removeSprite( self )
  Waygame.deadItems[self.id] = true
  if self.sound then Sound:playsound( self.sound ) end
end

