
DragonEnemy = GenericEnemy:subclass()

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
  local player = Waygame.player
  while true do
    self:wait( 1.0 )
    local p = PathFinder.getPath( self.x, self.y, player.x, player.y, self.map )
    print( "Dragon id following path", self.id, p )
    if p then
      for c in p:gmatch(".") do
        self:move(c)
        self:wait( 0.25 )
      end
    end
  end
end

