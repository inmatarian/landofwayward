
PlaceholderState = class()

function PlaceholderState:init( nextStateClass )
  self.nextState = nextStateClass
end

function PlaceholderState:draw() end

function PlaceholderState:update(dt)
  Waygame:popState()
  Waygame:pushState( self.nextState() )
end

