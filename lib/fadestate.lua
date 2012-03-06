
FadeState = class()

function FadeState:init( start, stop, rate, callback )
  self.fade = start or 0.0
  self.target = stop or 1.0
  self.rate = rate or 0.5
  print( "Start", self.fade, self.target, self.rate )
  self.callback = callback
  self.update = (rate < 0) and self.fadeDown or self.fadeUp
end

function FadeState:fadeUp(dt)
  self.fade = self.fade + (self.rate * dt)
  if self.fade >= self.target then self:wrapUp() end
end

function FadeState:fadeDown(dt)
  self.fade = self.fade + (self.rate * dt)
  if self.fade <= self.target then self:wrapUp() end
end

function FadeState:wrapUp()
  self.fade = self.target
  print( "Done", self.fade, self.target, self.rate )
  if self.callback then self.callback() end
  Waygame:popState()
end

function FadeState:draw()
  Waygame:downdraw(self)
  Graphics:fillScreen( 0, 0, 0, 255-(255*self.fade) )
end

