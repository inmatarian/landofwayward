
Testboard_Erhardt = MobileSprite:subclass()
local Erhardt = Testboard_Erhardt

Erhardt.diag = {
  { text="This is a test dialog, demonstrating wordwrap and dialog box." },
  { text="This is a second sentence in the dialog." },
  { text="And this is your brain on drugs. Any questions?" }
}

function Erhardt:init( map )
  local x, y = map:locateEntity( EntityCode.ERHARDT )
  Erhardt:superinit(self, x, y)
  map:addSprite(self)
  self:setStandardAnimator( SpriteCode.ERHARDT )
end

function Erhardt:run()
  while true do
    self:wait( 3 )
    local target = string.format("ERHARDT%i", math.random(1, 3))
    local x, y = self.map:locateEntity( EntityCode[target] )
    if x then
      local p = PathFinder.getPath( self, x, y, self.map )
      self:move( p )
    else
      print("Couldn't find", target)
    end
  end
end

function Erhardt:handleTouchedByPlayer( dir )
  Waygame:pushState( DialogState(self.diag) )
end
