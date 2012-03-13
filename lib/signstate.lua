
SignState = class()

SignState.w = 16 * 16
SignState.h = 16 * 8
SignState.x = Graphics.gameWidth / 2 - SignState.w / 2
SignState.y = Graphics.gameHeight / 2 - SignState.h / 2

function SignState:init( text )
  self:setupText( text )
end

function SignState:setupText( text )
  self.lines = Util.stringSplit( text, '\n' )
  local len = 0
  for _, v in ipairs(self.lines) do
    len = math.max( len, #v )
  end
  self.tx = 160 - (len * 4)
  self.ty = 120 - (#self.lines * 6)
end

function SignState:update(dt)
  if Input.menu:isClicked() or Input.enter:isClicked() then
    Waygame:popState()
  end
end

function SignState:draw()
  Waygame:downdraw(self)
  Graphics:drawFixedSign( self.x, self.y, self.w, self.h, Palette.BROWN )
  for i = 1, #self.lines do
    Graphics:text( self.tx, self.ty + ((i-1)*12), Palette.WHITE, self.lines[i] )
  end
end

