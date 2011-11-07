
SnakeEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.SNAKE
SnakeEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function SnakeEnemy:init( x, y, id )
  SnakeEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function SnakeEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end

