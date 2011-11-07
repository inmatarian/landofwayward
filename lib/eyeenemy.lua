
EyeEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.EYE
EyeEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function EyeEnemy:init( x, y, id )
  EyeEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function EyeEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end
