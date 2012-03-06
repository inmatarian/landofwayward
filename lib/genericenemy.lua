
GenericEnemy = MobileSprite:subclass {
  ANIMLEN = 0.5,
  hits = 1,
  sleeping = true
}

function GenericEnemy:init( x, y, id, animator )
  GenericEnemy:superinit( self, x, y )
  self.animator = animator or Animator{default={{1, Animator.FREEZE}}}
  self.animator:setPattern("default")
  self.frame = 1
  self.id = id
end

function GenericEnemy:update(dt)
  if self.sleeping and Waygame.player:isSpriteNearVisible(self) then
    -- Don't begin attacking player until about to be visible
    self.sleeping = false
  end

  GenericEnemy:super().update( self, dt )
end

function GenericEnemy:handleShotByPlayer()
  Sound:playsound( SoundEffect.ENEMYHURT )
  if self.hits > 0 then self.hits = self.hits - 1 end
  if self.hits <= 0 then
    self.map:removeSprite( self )
    Waygame:killItem(self.id)
  end
end

function GenericEnemy:blockedBy( ent )
  if ent == EntityCode.NOENEMYWALL or
     ent == EntityCode.GOOP or
     EntityCode.isSign(ent)
  then
    return true
  end
  return GenericEnemy:super().blockedBy( self, ent )
end

