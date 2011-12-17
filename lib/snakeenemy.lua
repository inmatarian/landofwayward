
SnakeEnemy = GenericEnemy:subclass {
  thuded = false
}

local ANIMLEN = 0.25
local CODE = SpriteCode.SNAKE
SnakeEnemy.animFrames = {
  default = {
    {CODE, ANIMLEN},
    {CODE+1, ANIMLEN},
  }
}

function SnakeEnemy:init( x, y, id )
  SnakeEnemy:superinit( self, x, y, id, Animator(self.animFrames) )
end

function SnakeEnemy:run()
  print("Snake activated", self.id)
  while true do
    local d = Util.randomPick('N', 'S', 'W', 'E')
    self.thuded = false
    repeat
      self:move(d)
    until self.thuded
    self:wait( 1.0 )
  end
end

function SnakeEnemy:touch()
  self.thuded = true
end

function SnakeEnemy:thud()
  self.thuded = true
end

