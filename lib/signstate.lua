
SignState = class()

SignState.w = 16 * 16
SignState.h = 16 * 8
SignState.x = Graphics.gameWidth / 2 - SignState.w / 2
SignState.y = Graphics.gameHeight / 2 - SignState.h / 2

function SignState:init( text )
  self.text = text
end

function SignState:update(dt)
  if Input.menu:isClicked() or Input.enter:isClicked() then
    Waygame:popState()
  end
end

function SignState:drawBorder(x, y, w, h, color)
  Graphics:setColor(color)
  for i = 16, SignState.w-32, 16 do
    Graphics:drawSprite( x+i, y, SpriteCode.WINDOWU )
    Graphics:drawSprite( x+i, y+h-16, SpriteCode.WINDOWD )
  end
  for i = 16, SignState.h-32, 16 do
    Graphics:drawSprite( x, y+i, SpriteCode.WINDOWL )
    Graphics:drawSprite( x+w-16, y+i, SpriteCode.WINDOWR )
  end
  Graphics:drawSprite( x, y, SpriteCode.WINDOWUL )
  Graphics:drawSprite( x+w-16, y, SpriteCode.WINDOWUR )
  Graphics:drawSprite( x, y+h-16, SpriteCode.WINDOWDL )
  Graphics:drawSprite( x+w-16, y+h-16, SpriteCode.WINDOWDR )
end

function SignState:draw()
  Waygame:downdraw(self)
  Graphics:drawRect( self.x+4, self.y+4, self.w-8, self.h-8, Palette.BROWN )
  self:drawBorder( self.x, self.y, self.w, self.h, Palette.BROWN )
  Graphics:text( "center", "center", Palette.WHITE, self.text )
end

