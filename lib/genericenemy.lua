
GenericEnemy = Sprite:subclass()
GenericEnemy.ANIMLEN = 0.5

function GenericEnemy:init( x, y, id, animator )
  GenericEnemy:superinit( self, x, y, 1, 1 )
  self.anim = animator or Animator{default={{1, Animator.FREEZE}}}
  self.anim:setPattern("default")
  self.frame = 1
  self.id = id
  self.sleeping = true
end

function GenericEnemy:update(dt)
  GenericEnemy:super().update( self, dt )
  self.frame = self.anim:current()

  if self.sleeping then
    -- Don't begin attacking player until about to be visible
    if not Waygame.player:isSpriteNearVisible(self) then return end
    self.sleeping = false
  end

  self.anim:update(dt)

  local err, mesg = true
  if ((not self.co) or (coroutine.status(self.co)=="dead")) and self.run then
    self.co = coroutine.create( self.run )
    err, mesg = coroutine.resume(self.co, self)
  elseif self.co and coroutine.status(self.co) ~= "dead" then
    err, mesg = coroutine.resume(self.co, dt)
  end
  if err == false then error(mesg) end
end

function GenericEnemy:wait( secs )
  local dt = 0
  while dt < secs do
    dt = dt + coroutine.yield()
  end
end

function GenericEnemy:move( dir )
  if self.moving then return end
  GenericEnemy:super().move(self, dir)
  while self.moving do
    coroutine.yield()
  end
end

