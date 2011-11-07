
SpiderEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.SPIDER
SpiderEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function SpiderEnemy:init( x, y, id )
  SpiderEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function SpiderEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end

