
GenericEnemy = Sprite:subclass {
  ANIMLEN = 0.5,
  hits = 1
}

function GenericEnemy:init( x, y, id, animator )
  GenericEnemy:superinit( self, x, y, 1, 1 )
  self.animator = animator or Animator{default={{1, Animator.FREEZE}}}
  self.animator:setPattern("default")
  self.frame = 1
  self.id = id
  self.sleeping = true
end

function GenericEnemy:update(dt)
  GenericEnemy:super().update( self, dt )

  if self.sleeping then
    -- Don't begin attacking player until about to be visible
    if not Waygame.player:isSpriteNearVisible(self) then return end
    self.sleeping = false
  end

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

function GenericEnemy:move( dirs )
  if self.moving then return end
  dirs = dirs:upper()
  local waiting = 1.0 / self.speed
  for mv, count in dirs:gmatch("(%S)(%d*)") do
    local d = self:translateDir(mv)
    count = (count:len() > 0) and tonumber(count) or 1
    repeat
      if d == "I" then
        self:wait( waiting )
      elseif d == "H" then
        self.jump = 4
        self:wait( 0.5 * waiting )
        self.jump = 0
        self:wait( 0.5 * waiting )
      else
        GenericEnemy:super().move(self, d)
        self:wait( waiting )
        while self.moving do
          coroutine.yield()
        end
      end
      count = count - 1
    until count < 1
  end
end

function GenericEnemy:shoot( dirs )
  local x, y = self.x, self.y
  local waiting = 1.0 / self.speed
  for mv, count in dirs:gmatch("(%S)(%d*)") do
    local d = self:translateDir(mv)
    count = (count:len() > 0) and tonumber(count) or 1
    repeat
      if d == "I" then
        self:wait( waiting )
      else
        self.map:addSprite( EnemyBullet( x, y, d, self ) )
        if Waygame.player:isSpriteNearVisible(self) then
          Sound:playsound( SoundEffect.PLAYERSHOOT )
        end
        self:wait( waiting )
      end
      count = count - 1
    until count < 1
  end
end

function GenericEnemy:distanceTo( other )
  return math.abs(self.x - other.x) + math.abs(self.y - other.y)
end

function GenericEnemy:distanceToPlayer()
  return self:distanceTo( Waygame.player )
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

