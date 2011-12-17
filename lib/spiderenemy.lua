
SpiderEnemy = GenericEnemy:subclass {
  speed = 6
}

local ANIMLEN = 0.25
local CODE = SpriteCode.SPIDER
SpiderEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function SpiderEnemy:init( x, y, id )
  SpiderEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function SpiderEnemy:run()
  print("Spider activated", self.id)
  local waiting = true
  while true do
    local dist = self:distanceToPlayer()
    if dist >= 40 then
      self:wait( 1.0 )
    else
      if math.random( 0, 9 ) == 0 then waiting = not waiting end
      if waiting then
        self:move( "I" )
      else
        self:move( "R" )
      end
    end
  end
end

