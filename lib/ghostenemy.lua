
GhostEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.GHOST
GhostEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function GhostEnemy:init( x, y, id )
  GhostEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function GhostEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end

