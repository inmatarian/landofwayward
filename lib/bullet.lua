
Bullet = Sprite:subclass {
  speed = 10;
  tangible = false;
}

do
  local LEN = 0.125
  Bullet.animFrames = {
    default = { { SpriteCode.PLAYERBULLET1, LEN },
                { SpriteCode.PLAYERBULLET2, LEN },
                { SpriteCode.PLAYERBULLET3, LEN },
                { SpriteCode.PLAYERBULLET4, LEN } },
    explode = { { SpriteCode.PLAYERBULLETFLASH1, LEN },
                { SpriteCode.PLAYERBULLETFLASH2, LEN },
                { 0, Animator.FREEZE } }
  }
end

function Bullet:init( x, y, dir )
  Bullet:superinit( self, x, y, 1, 1 )
  self.frame = 1
  self.dir = dir
  self.anim = Animator( self.animFrames )
  self.anim:setPattern("default")
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
  self:prepareToDie()
end

function Bullet:touch( other )
  if self.dieSoon then return end
  -- hurt enemies, or player? who knows?!
  self:prepareToDie()
end

function Bullet:prepareToDie()
  if self.dieSoon then return end
  self.dieSoon = 0.4
  self.speed = self.speed * 0.5
  self.anim:setPattern("explode")
end

