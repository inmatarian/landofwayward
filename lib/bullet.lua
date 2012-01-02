
Bullet = Sprite:subclass {
  speed = 10;
  tangible = false;
}

function Bullet:init( x, y, dir, bulletType, parent, animator )
  Bullet:superinit( self, x, y, 1, 1 )
  self.frame = 0
  self.dir = dir
  self.bulletType = bulletType
  self.anim = animator
  self.parent = parent
  print("Created a bullet", self, bulletType, parent)
end

function Bullet:update(dt)
  Bullet:super().update(self, dt)
  self.anim:update(dt)
  self.frame = self.anim:current()
  if self.dieSoon then
    self.dieSoon = self.dieSoon - dt
    if self.dieSoon <= 0 then
      self.map:removeSprite(self)
    end
  end
  if not self.moving then
    self:move( self.dir )
  end
end

function Bullet:thud( dir )
  if self.dieSoon then return end
  self:prepareToDie( 0.0, 0.0 )
  print("Bullet dying from thud", self, self.bulletType)
end

function Bullet:touch( other )
  if self.dieSoon then return end
  if self.bulletType == "player" then
    other:handleShotByPlayer()
  else
    other:handleShotByEnemy()
  end
  self:prepareToDie( 0.4, 0.25 )
  print("Bullet dying", self, self.bulletType, other, self.parent)
end

function Bullet:prepareToDie( time, speed )
  if self.dieSoon then return end
  self.dieSoon = time
  self.speed = self.speed * speed
  self.anim:setPattern("explode")
end

