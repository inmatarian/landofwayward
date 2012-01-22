
local Button = class()

function Button:init( ... )
  self.eats = {}
  for i = 1, select("#", ...) do
    self.eats[ tostring(select(i, ...)) ] = true
  end
end

local function testButton( eats, active )
  for k, _ in pairs(eats) do
    if active[k] then return true end
  end
  return false
end

function Button:isPressed()
  return testButton( self.eats, Input.pressed )
end

function Button:isClicked()
  return testButton( self.eats, Input.clicked )
end

function Button:isRepeating()
  return testButton( self.eats, Input.repeating )
end

function Button:pressedLength()
  local len = 0
  for k, _ in pairs(self.eats) do
    local v = Input.length[k]
    if v and v > len then len = v end
  end
  return len
end

------------------------------------------------------------

Input = {
  up = Button("up");
  down = Button("down");
  left = Button("left");
  right = Button("right");
  shoot = Button(" ");
  menu = Button("escape");
  pause = Button("p");
  enter = Button("return");

  pressed = {};
  clicked = {};
  repeating = {};
  length = {};
}

function Input:init()
  love.keyboard.setKeyRepeat( 500, 50 )
end

function Input:handlePressed(k)
  k = tostring(k)
  self.repeating[k] = true
  if not self.pressed[k] then
    self.pressed[k] = true
    self.clicked[k] = true
    self.length[k] = 0.001
  end
end

function Input:handleReleased(k)
  k = tostring(k)
  self.repeating[k] = nil
  self.pressed[k] = nil
  self.clicked[k] = nil
  self.length[k] = nil
end

function Input:update(dt)
  for k, _ in pairs(self.clicked) do self.clicked[k] =  nil end
  for k, _ in pairs(self.repeating) do self.repeating[k] = nil end
  for k, v in pairs(self.length) do self.length[k] = v + dt end
end

function Input:isPressed(k)
  return self.pressed[tostring(k)]
end

function Input:isClicked(k)
  return self.clicked[tostring(k)]
end

function Input:isRepeating(k)
  return self.repeating[tostring(k)]
end

function Input:pressedLength(k)
  return self.length[tostring(k)] or 0
end

