
Camera = class()

function Camera:init( sprite )
  self.following = sprite
  self.x = sprite.x - 9.5
  self.y = sprite.y - 7
  self.left, self.top, self.right, self.bottom = 0, 0, 256, 256
  self:restrictBounds()
end

function Camera:setBounds( left, top, right, bottom )
  self.left, self.top, self.right, self.bottom = left, top, right, bottom
  self:restrictBounds()
end

function Camera:update(dt)
  local spr = self.following
  -- local xwindow, ywindow = 3, 2
  local tx, ty = spr.x-9.5, spr.y-7
  local dx, dy = tx-self.x, ty-self.y
  local speed = dt * 2.5

  self:scroll( dx*speed, dy*speed )
end

function Camera:scroll( dx, dy )
  self.x = self.x + dx
  self.y = self.y + dy
  self:restrictBounds()
end

function Camera:restrictBounds()
  if self.x < self.left then self.x = self.left
  elseif self.x > self.right-20 then self.x = self.right-20 end
  if self.y < self.top then self.y = self.top
  elseif self.y > self.bottom-15 then self.y = self.bottom-15 end
end

function Camera:viewPos()
  return self.x-(0.5*Graphics.gameWidth), self.y-(0.5*Graphics.gameHeight)
end

function Camera:screenTranslate( x, y, w, h )
  w = (w or 0) * 16
  h = (h or 0) * 16
  x = (x-self.x)*16 -- +(0.5*Graphics.gameWidth)-(0.5*w)
  y = (y-self.y)*16 -- +(0.5*Graphics.gameHeight)-(0.5*h)
  return x, y, w, h
end

function Camera:layerDrawingParameters()
  -- return left, top, right, bottom, offx, offy
  local floor = math.floor
  local hardx, hardy = floor(self.x), floor(self.y)
  local offx, offy = self.x - hardx, self.y - hardy

  return hardx, hardy, hardx+21, hardy+15, offx, offy
end

