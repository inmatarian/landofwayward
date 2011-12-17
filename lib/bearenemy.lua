
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
  print("Bear activated", self.id)
  while true do
    if self:distanceToPlayer() < 12 then
      self:move( "IT" )
    else
      self:wait( 1.0 )
    end
  end
end

