
GrowingText = class()
GrowingText.CLOCK = 1 / 15

function GrowingText:init( x, y, color, str )
  self.str = str
  self.clock = 0
  self.count = 1
  self.color = color
  self.y = y

  if x == "center" then
    self.x = 160-(str:len()*4)
  else
    self.x = x
  end
end

function GrowingText:update(dt)
  if self.count >= self.str:len() then return end
  self.clock = self.clock + dt
  if self.clock >= self.CLOCK then
    self.clock = self.clock - self.CLOCK
    self.count = self.count + 1
  end
end

function GrowingText:draw()
  Graphics:text( self.x, self.y, self.color, self.str:sub(1, self.count) )
end

