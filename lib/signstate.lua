
SignState = class()

SignState.w = Graphics.gameWidth / 2
SignState.h = Graphics.gameWidth / 8
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

function SignState:draw()
  Waygame:downdraw(self)
  Graphics:drawRect( self.x, self.y, self.w, self.h, Palette.BROWN )
  Graphics:text( "center", "center", Palette.WHITE, self.text )
end

