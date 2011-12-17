
RuffianEnemy = GenericEnemy:subclass()

local ANIMLEN = 0.25
local CODE = SpriteCode.RUFFIAN
RuffianEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
    {CODE+2, ANIMLEN},
    {CODE+3, ANIMLEN}
  }
}

function RuffianEnemy:init( x, y, id )
  RuffianEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function RuffianEnemy:run()
  print("Ruffian activated", self.id)
  while true do
    self:wait( 2.0 )
    self:move( "R4 I2 H4 I2" )
  end
end

