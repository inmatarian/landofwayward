
DragonEnemy = GenericEnemy:subclass {
  hits = 3
}

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
  print("Dragon activated", self.id)
  local player = Waygame.player
  while true do
    local dist = self:distanceToPlayer()
    if dist >= 40 then
      self:wait( 1.0 )
    elseif dist >= 20 then
      self:move( "IR" )
    else
      local r = math.random( 0, 15 )
      if r > 14 then
        local p = PathFinder.getPath( self.x, self.y, player.x, player.y, self.map )
        p = p:sub(0, math.random( 1, p:len() ))
        self:move( p )
      elseif r >= 8 then
        self:move( "IT" )
      elseif r >= 4 then
        self:move( "IL" )
      else
        -- shoot
      end
    end
  end
end

