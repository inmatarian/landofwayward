
PauseState = class()
PauseState.CURTAIN = { 0, 8, 16, 192 }
PauseState.MAINMENU = { "Resume", "Options", "Save", "Reset", "Quit" }

function PauseState:init()
  self.text = GrowingText("center", "center", WHITE, "Paused")
  self.controlMenu = ControlMenu( self.MAINMENU )
end

function PauseState:draw()
  Waygame:downdraw(self)
  Graphics:fillScreen( self.CURTAIN )
  self.text:draw()
  self.controlMenu:draw( 240, 120 )
end

function PauseState:update(dt)
  self.text:update(dt)
  local selection = self.controlMenu:update(dt)

  if selection then
    if self.controlMenu.current == self.MAINMENU then
      if selection == "Resume" or selection == "_escape" then
        Waygame:popState()
      elseif selection == "Reset" then
        Waygame:popState()
        Waygame:popState()
        Waygame:pushState( TitleState() )
      elseif selection == "Quit" then
        Waygame:popState()
        Waygame:popState()
      end
    end
  end
end

