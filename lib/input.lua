
Button = class()

function Button:init( ... )
  self.eats = {}
  for i = 1, select("#", ...) do
    self.eats[ tostring(select(i, ...)) ] = true
  end
end

function Button.test( eats, active, direct )
  for k, v in pairs(active) do
    if eats[k] then return (direct and v) or true end
  end
end

function Button:isPressed()
  return self.test( self.eats, Input.length )
end

function Button:isClicked()
  return self.test( self.eats, Input.clicked )
end

function Button:isRepeating() return
  self.test( self.eats, Input.repeating )
end

function Button:pressedLength()
  return self.test( self.eats, Input.length, true ) or 0
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
  if not self:isPressed(k) then self.clicked[k], self.length[k] = true, 0.001 end
end

function Input:handleReleased(k)
  k = tostring(k)
  self.repeating[k], self.clicked[k], self.length[k] = nil, nil, nil
end

function Input:update(dt)
  for k, _ in pairs(self.clicked) do self.clicked[k] =  nil end
  for k, _ in pairs(self.repeating) do self.repeating[k] = nil end
  for k, v in pairs(self.length) do self.length[k] = v + dt end
end

function Input:isPressed(k)
  return self.length[tostring(k)]~=nil
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

