
DialogState = class()

DialogState.w = 16 * 16
DialogState.h = 16 * 8
DialogState.x = Graphics.gameWidth / 2 - DialogState.w / 2
DialogState.y = Graphics.gameHeight / 2 - DialogState.h / 2
DialogState.tx = 100
DialogState.ty = 100

function DialogState:init( dialog, position )
  self:setup( dialog )
end

function DialogState:setup( dialog )
  self.dialog = dialog
  self.current = 0
  self:advanceDialog()
end

function DialogState:advanceDialog()
  self.current = self.current + 1
  if self.current <= #self.dialog then
    local diag = self.dialog[self.current]
    -- self.name = diag.name
    self.lines = Util.stringSplit( Util.wordwrapLine( diag.text, 24 ), "\n" )
  end
end

function DialogState:update(dt)
  if Input.menu:isClicked() or Input.enter:isClicked() then
    self:advanceDialog()
    if self.current > #self.dialog then
      Waygame:popState()
    end
  end
end

function DialogState:draw()
  Waygame:downdraw(self)
  Graphics:drawFixedSign( self.x, self.y, self.w, self.h, Palette.BLUE )
  for i = 1, #self.lines do
    Graphics:text( self.tx, self.ty + ((i-1)*12), Palette.WHITE, self.lines[i] )
  end
end

