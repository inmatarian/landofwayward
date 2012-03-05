
TitleState = class()

TitleState.MAINMENU = { "Start", "Continue", "Options", "Quit" }
TitleState.OPTIONSMENU = { "Sound Test", "Back" }

local function generateSoundTestMenu()
  local menu = {}
  for key, _ in pairs( SoundEffect ) do
    table.insert(menu, key)
  end
  table.sort(menu)
  table.insert(menu, "Back")
  return menu
end

function TitleState:init()
  self.controlMenu = ControlMenu( self.MAINMENU )
  self.SOUNDTESTMENU = generateSoundTestMenu()
end

function TitleState:draw()
  Graphics:text( 16, 16, WHITE, "The Land Of Wayward" )
  self.controlMenu:draw( 160, 120 )
end

function TitleState:update(dt)
  local selection = self.controlMenu:update(dt)
  if selection then
    if self.controlMenu.current == self.MAINMENU then
      if selection == "Start" then
        Waygame:popState()
        Waygame:pushState( PlaceholderState( Testboard_Level ) )
      elseif selection == "Options" then
        self.controlMenu:changeMenu( self.OPTIONSMENU )
      elseif selection == "Quit" or selection == "_escape"  then
        Waygame:popState()
      end
    elseif self.controlMenu.current == self.OPTIONSMENU then
      if selection == "Sound Test" then
        self.controlMenu:changeMenu( self.SOUNDTESTMENU, 1, SoundEffect )
      elseif selection == "Back" or selection == "_escape"  then
        self.controlMenu:changeMenu( self.MAINMENU, 3 )
      end
    elseif self.controlMenu.current == self.SOUNDTESTMENU then
      if selection == "Back" or selection == "_escape" then
        self.controlMenu:changeMenu( self.OPTIONSMENU, 1 )
      elseif selection then
        Sound:playsound( SoundEffect[selection] )
      end
    end
  end
end

