
EnemyBullet = Bullet:subclass()

do
  local LEN = 0.125
  EnemyBullet.animFrames = {
    default = { { SpriteCode.PLAYERBULLET1, LEN },
                { SpriteCode.PLAYERBULLET2, LEN },
                { SpriteCode.PLAYERBULLET3, LEN },
                { SpriteCode.PLAYERBULLET4, LEN } },
    explode = { { SpriteCode.PLAYERBULLETFLASH1, LEN },
                { SpriteCode.PLAYERBULLETFLASH2, LEN },
                { 0, Animator.FREEZE } }
  }
end

function EnemyBullet:init( x, y, dir, parent )
  EnemyBullet:superinit( self, x, y, dir, "enemy", parent, Animator(self.animFrames) )
end


