
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
                { SpriteCode.PLAYERBULLET4, LEN } } }
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
  if not self.moving then
    self:move( self.dir )
  end
end

function Bullet:thud( dir )
  self.map:removeSprite(self)
end

function Bullet:touch( other )
  -- hurt enemies, or player? who knows?!
  self.map:removeSprite(self)
end

