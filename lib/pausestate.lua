
PauseState = class()

function PauseState:init()
  self.text = GrowingText("center", "center", WHITE, "Paused")
end

function PauseState:draw()
  self.text:draw()
end

function PauseState:update(dt)
  self.text:update(dt)
  if Input.menu:isClicked() or Input.enter:isClicked() then
    Waygame:popState()
  end
end

