
Camera = class {
  xHang = 9.5,
  yHang = 7
}

function Camera:init( sprite )
  self.following = sprite
  self.x = sprite.x - self.xHang
  self.y = sprite.y - self.yHang
  self.left, self.top, self.right, self.bottom = 0, 0, 256, 256
  self:restrictBounds()
end

function Camera:setBounds( left, top, right, bottom )
  self.left, self.top, self.right, self.bottom = left, top, right, bottom
  self:restrictBounds()
end

function Camera:update(dt)
  self:anchorFollow()
end

function Camera:anchorFollow()
  local math = math
  local spr = self.following
  local surround = 2
  local tx, ty = (spr.x+spr.xexcess) - self.xHang, (spr.y+spr.yexcess) - self.yHang
  local dx, dy = self.x - tx, self.y - ty

  local zx = (math.abs(dx) <= surround) and 0 or (math.abs(dx) - surround)
  local zy = (math.abs(dy) <= surround) and 0 or (math.abs(dy) - surround)

  if dx < 0 then zx = zx * -1 end
  if dy < 0 then zy = zy * -1 end

  self.x = self.x - zx
  self.y = self.y - zy

  self:restrictBounds()
end

function Camera:floatyFollow(dt)
  local spr = self.following
  -- local xwindow, ywindow = 3, 2
  local tx, ty = spr.x - self.xHang, spr.y - self.yHang
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

