
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
  print("Tiger activated", self.id)
  while true do
    local dist = self:distanceToPlayer()
    if dist >= 40 then
      self:wait( 1.0 )
    else
      if math.random( 0, 1 ) == 0 then
        self:move( "IR" )
      else
        self:move( "IT" )
      end
      if dist < 15 and math.random(0, 5) == 0 then
        self:shoot("T")
      end
    end
  end
end

