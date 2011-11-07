
TigerEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.TIGER
TigerEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function TigerEnemy:init( x, y, id )
  TigerEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function TigerEnemy:run()
  while true do
    self:wait( 2.0 )
    self:move( Util.randomPick('N', 'S', 'W', 'E') )
  end
end

