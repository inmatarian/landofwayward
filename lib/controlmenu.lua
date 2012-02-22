
ControlMenu = class()

function ControlMenu:init( menu )
  self.current = menu
  self.submenu = nil
  self.option = 1
  self.scroll = 1
end

function ControlMenu:changeMenu( menu, default, submenu )
  self.current = menu
  self.submenu = submenu
  self.option = default or 1
  self.scroll = 1
end

function ControlMenu:draw( x, y )
  local X, Y = x, y
  local i, N = self.scroll, self.scroll + 7
  while i < N and i <= #self.current do
    local option = self.current[i]
    Graphics:text( x, y, WHITE, option )
    if self.submenu and self.submenu[option] then
      Graphics:text( x+12, y+8, GRAY, self.submenu[option] )
    end
    y, i = y + 16, i + 1
  end
  Graphics:drawRect( X-8, 2+Y+((self.option-self.scroll)*16), 7, 7, WHITE )
end

function ControlMenu:update(dt)
  local move = 0

  if Input:isRepeating("up") then move = -1
  elseif Input:isRepeating("down") then move = 1
  elseif Input:isRepeating("pageup") then move = -6
  elseif Input:isRepeating("pagedown") then move = 6
  elseif Input:isRepeating("home") then move = -9001
  elseif Input:isRepeating("end") then move = 9001
  end

  if move ~= 0 then
    self.option = self.option + move
    if self.option <= 0 then
      self.option = 1
    elseif self.option > #self.current then
      self.option = #self.current
    end
    self.scroll = self.option - 3
    if self.scroll > #self.current - 6 then
      self.scroll = #self.current - 6
    end
    if self.scroll < 1 then self.scroll = 1 end
  else
    if Input.menu:isClicked() then
      return "_escape"
    elseif Input.enter:isClicked() then
      return self.current[self.option]
    end
  end
end

