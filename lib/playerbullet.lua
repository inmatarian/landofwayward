
PlayerBullet = Bullet:subclass()

do
  local LEN = 0.125
  PlayerBullet.animFrames = {
    default = { { SpriteCode.PLAYERBULLET1, LEN },
                { SpriteCode.PLAYERBULLET2, LEN },
                { SpriteCode.PLAYERBULLET3, LEN },
                { SpriteCode.PLAYERBULLET4, LEN } },
    explode = { { SpriteCode.PLAYERBULLETFLASH1, LEN },
                { SpriteCode.PLAYERBULLETFLASH2, LEN },
                { 0, Animator.FREEZE } }
  }
end

function PlayerBullet:init( x, y, dir )
  PlayerBullet:superinit( self, x, y, dir, "player", Animator(self.animFrames) )
end

