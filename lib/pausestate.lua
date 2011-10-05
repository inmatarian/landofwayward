
PauseState = class()

function PauseState:init()
  self.text = GrowingText("center", "center", WHITE, "Paused")
end

function PauseState:draw()
  self.text:draw()
end

function PauseState:update(dt)
  self.text:update(dt)
  if Waygame.keypress["escape"]==1 then
    Waygame:popState()
  end
end

