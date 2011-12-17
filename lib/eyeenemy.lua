
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
  print("Eye activated", self.id)
  while true do
    local dist = self:distanceToPlayer()
    if dist >= 40 then
      self:wait( 1.0 )
    elseif dist >= 20 then
      self:move( "IR" )
    else
      self:move("I")
      self:move( Util.randomPick( "T", "R", "P" ) )
    end
  end
end

