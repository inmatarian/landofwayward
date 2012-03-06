
MobileSprite = Sprite:subclass {
  sleeping = false
}

function MobileSprite:init( x, y )
  MobileSprite:superinit(self, x, y, 1, 1)
end

function MobileSprite:update(dt)
  MobileSprite:super().update( self, dt )

  if not self.sleeping then
    local err, mesg = true
    if ((not self.co) or (coroutine.status(self.co)=="dead")) and self.run then
      self.co = coroutine.create( self.run )
      err, mesg = coroutine.resume(self.co, self)
    elseif self.co and coroutine.status(self.co) ~= "dead" then
      err, mesg = coroutine.resume(self.co, dt)
    end
    if err == false then error(mesg) end
  end
end


function MobileSprite:wait( secs )
  local dt = 0
  while dt < secs do
    dt = dt + coroutine.yield()
  end
end

function MobileSprite:move( dirs )
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
        MobileSprite:super().move(self, d)
        self.animator:tryPattern(d)
        self:wait( waiting )
        while self.moving do
          coroutine.yield()
        end
      end
      count = count - 1
    until count < 1
  end
end

function MobileSprite:shoot( dirs )
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
        self.animator:tryPattern(d)
        if Waygame.player:isSpriteNearVisible(self) then
          Sound:playsound( SoundEffect.PLAYERSHOOT )
        end
        self:wait( waiting )
      end
      count = count - 1
    until count < 1
  end
end

function MobileSprite:distanceTo( other )
  return math.abs(self.x - other.x) + math.abs(self.y - other.y)
end

function MobileSprite:distanceToPlayer()
  return self:distanceTo( Waygame.player )
end

function MobileSprite:setStandardAnimator( code, length )
  length = length or 0.25
  self.animator = Animator( {
    N = { { code, length }, { code+1, length } },
    S = { { code+2, length }, { code+3, length } },
    W = { { code+4, length }, { code+5, length } },
    E = { { code+6, length }, { code+7, length } },
  }, "N" )
end

