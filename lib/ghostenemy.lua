
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
  print("Ghost activated", self.id)
  while true do
    local dist = self:distanceToPlayer()
    if dist >= 40 then
      self:wait( 1.0 )
    elseif dist >= 20 then
      self:move( "IR" )
    else
      self:move("I")
      self:move( Util.randomPick( "T", "R" ) )
    end
  end
end

