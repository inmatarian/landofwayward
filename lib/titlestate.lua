
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
  self.currentMenu = self.MAINMENU
  self.option = 1
  self.scroll = 1
  self.SOUNDTESTMENU = generateSoundTestMenu()
end

function TitleState:draw()
  Graphics:text( 16, 16, WHITE, "The Land Of Wayward" )
  local X, Y = 160, 120
  local x, y = X, Y
  local i, N = self.scroll, self.scroll + 7
  while i < N and i <= #self.currentMenu do
    Graphics:text( x, y, WHITE, self.currentMenu[i] )
    y, i = y + 12, i + 1
  end
  love.graphics.rectangle("fill", X-8, Y+((self.option-self.scroll)*12), 7, 7)
end

function TitleState:update(dt)
  local move = 0

  if Waygame.keypress["up"]==1 then move = -1
  elseif Waygame.keypress["down"]==1 then move = 1
  elseif Waygame.keypress["pageup"]==1 then move = -6
  elseif Waygame.keypress["pagedown"]==1 then move = 6
  elseif Waygame.keypress["home"]==1 then move = -9001
  elseif Waygame.keypress["end"]==1 then move = 9001
  end

  if move ~= 0 then
    self.option = self.option + move
    if self.option <= 0 then
      self.option = 1
    elseif self.option > #self.currentMenu then
      self.option = #self.currentMenu
    end
    self.scroll = self.option - 3
    if self.scroll > #self.currentMenu - 6 then
      self.scroll = #self.currentMenu - 6
    end
    if self.scroll < 1 then self.scroll = 1 end
  else
    local selection
    if Waygame.keypress["escape"]==1 then
      selection = "_escape"
    elseif Waygame.keypress["return"]==1 then
      selection = self.currentMenu[self.option]
    end
    if selection then
      if self.currentMenu == self.MAINMENU then
        if selection == "Start" then
          Waygame:popState()
          Waygame:pushState( ExplorerState() )
        elseif selection == "Options" then
          self.currentMenu = self.OPTIONSMENU
          self.option, self.scroll = 1, 1
        elseif selection == "Quit" or selection == "_escape"  then
          Waygame:popState()
        end
      elseif self.currentMenu == self.OPTIONSMENU then
        if selection == "Sound Test" then
          self.currentMenu = self.SOUNDTESTMENU
          self.option = 1
        elseif selection == "Back" or selection == "_escape"  then
          self.currentMenu = self.MAINMENU
          self.option, self.scroll = 3, 1
        end
      elseif self.currentMenu == self.SOUNDTESTMENU then
        if selection == "Back" or selection == "_escape" then
          self.currentMenu = self.OPTIONSMENU
          self.option, self.scroll = 1, 1
        elseif selection then
          Sound:playsound( SoundEffect[selection] )
        end
      end
    end
  end
end

