
DragonEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.DRAGON
DragonEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function DragonEnemy:init( x, y, id )
  DragonEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function DragonEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end

