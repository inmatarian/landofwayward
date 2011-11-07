
BearEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.BEAR
BearEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function BearEnemy:init( x, y, id )
  BearEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function BearEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end

