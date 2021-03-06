
ExplorerState = class {}

do
  local LENGTH = 0.05
  ExplorerState.ammoFrames = {
    default = { { SpriteCode.AMMO4, Animator.FREEZE } },
    newammo = {
      { SpriteCode.AMMO1, LENGTH },
      { SpriteCode.AMMO2, LENGTH },
      { SpriteCode.AMMO4, LENGTH },
      { SpriteCode.AMMO3, LENGTH },
      { SpriteCode.AMMO4, Animator.FREEZE },
    }
  }
end

function ExplorerState:init()
  self.hp, self.enemyhp = 50, 50
  self.id = "maps/testboard.tmx"
  self.map = Map("maps/testboard.tmx")
  local px, py = self.map:locateEntity(EntityCode.SYLVIA)
  px, py = px or 1, py or 1
  self.player = Player( px, py )
  self.player:setGamestate(self)
  self.camera = Camera(self.player)
  self.map:addSprite(self.player)
  self:loadThings()
  self.camera:setBounds( 0, 0, self.map.width, self.map.height )
  self.ammoAnim = Animator( self.ammoFrames )
  collectgarbage()
end

function ExplorerState:loadThings()
  for y = 0, self.map.height do
    for x = 0, self.map.width do
      local code = self.map:getEntity( x, y )
      local factory = self.entityFactory[code]
      if factory then
        local id = Util.hash( self.id, x, y )
        if not Waygame.deadItems[id] then
          local thing = factory(self, x, y, id)
          self.map:addSprite(thing)
          thing:setGamestate(self)
        end
      end
    end
  end
end

do
  local factory = {}
  factory[EntityCode.AMMO] = function(self, x, y, id) return Ammo(x, y, id) end;
  factory[EntityCode.HEALTH] = function(self, x, y, id) return Health(x, y, id) end;
  factory[EntityCode.RUFFIAN] = function(self, x, y, id) return RuffianEnemy(x, y, id) end;
  factory[EntityCode.TIGER] = function(self, x, y, id) return TigerEnemy(x, y, id) end;
  factory[EntityCode.SNAKE] = function(self, x, y, id) return SnakeEnemy(x, y, id) end;
  factory[EntityCode.BEAR] = function(self, x, y, id) return BearEnemy(x, y, id) end;
  factory[EntityCode.GHOST] = function(self, x, y, id) return GhostEnemy(x, y, id) end;
  factory[EntityCode.EYE] = function(self, x, y, id) return EyeEnemy(x, y, id) end;
  factory[EntityCode.DRAGON] = function(self, x, y, id) return DragonEnemy(x, y, id) end;
  factory[EntityCode.SPIDER] = function(self, x, y, id) return SpiderEnemy(x, y, id) end;
  ExplorerState.entityFactory = factory
end

function ExplorerState:draw()
  Graphics:resetColor()
  local cam = self.camera
  self.map:draw(cam)

  self:drawAmmo()
  self:drawHealth()
  self:drawKeys()

  if Waygame.debug then
    local pl = self.player
    Graphics:text( 0, 0, Palette.WHITE,
      string.format("PLY P(%.2f,%.2f) X(%.2f,%.2f) T(%i,%i)",
        pl.x, pl.y, pl.xexcess, pl.yexcess, pl.xtarget, pl.ytarget) )
    local vx, vy = cam:screenTranslate( pl.x, pl.y )
    Graphics:text( 0, 8, Palette.WHITE,
      string.format("CAM P(%.2f,Y%.2f) S(X%.2f,Y%.2f)", cam.x, cam.y, vx, vy) )
  end
end

function ExplorerState:drawAmmo()
  local amax = Waygame.ammoMax
  if amax == 0 then return end
  local ammo = Waygame.ammo
  local x = (math.floor(Graphics.gameWidth / 2.0)-5)-(7*(amax-1))
  local y = Graphics.gameHeight - 13

  local i = 1
  if ammo > 0 then
    while i<=(ammo-1) do
      Graphics:drawSprite( x, y, SpriteCode.AMMO4 )
      i, x = i + 1, x + 14
    end
    Graphics:drawSprite( x, y, self.ammoAnim:current() )
    i, x = i + 1, x + 14
  end
  while i<=amax do
    Graphics:drawSprite( x, y, SpriteCode.AMMO0 )
    i, x = i + 1, x + 14
  end
end

function ExplorerState:drawHealth()
  local y = Graphics.gameHeight - 13
  local x1, x2 = 4, Graphics.gameWidth - 107
  Graphics:drawMeterBar( x1, y, SpriteCode.LIFEBAR, self.hp, "left" )
  Graphics:drawMeterBar( x2, y, SpriteCode.ENEMYBAR, self.enemyhp, "right" )
end

function ExplorerState:drawKeys()
  local x, y = Graphics.gameWidth - 14, 4

  -- if waygame.redkey then
  Graphics:drawSprite( x, y, SpriteCode.GRAYKEY )
  x = x - 10
  Graphics:drawSprite( x, y, SpriteCode.PURPLEKEY )
  x = x - 10
  Graphics:drawSprite( x, y, SpriteCode.BLUEKEY )
  x = x - 10
  Graphics:drawSprite( x, y, SpriteCode.CYANKEY )
  x = x - 10
  Graphics:drawSprite( x, y, SpriteCode.GREENKEY )
  x = x - 10
  Graphics:drawSprite( x, y, SpriteCode.YELLOWKEY )
  x = x - 10
  Graphics:drawSprite( x, y, SpriteCode.REDKEY )
end

function ExplorerState:update(dt)
  if Input.menu:isClicked() or Input.pause:isClicked() then
    Waygame:pushState( PauseState() )
  else
    self.map:update(dt)
    self.camera:update(dt)
    self:updateAmmo(dt)
  end
  self.hp = self.hp + dt * 10
  if self.hp > 120 then self.hp = 0 end
  self.enemyhp = self.enemyhp + dt * 10
  if self.enemyhp > 120 then self.enemyhp = 0 end
end

function ExplorerState:updateAmmo(dt)
  local W = Waygame
  if W.ammo < W.ammoMax then
    W.ammoRecover = W.ammoRecover + ((dt/2.5)*(1.0+W.ammoMax/7.0))
    if W.ammoRecover >= 1.0 then
      W.ammo = W.ammo + 1
      self.ammoAnim:resetPattern("newammo")
      if W.ammo < W.ammoMax then
        W.ammoRecover = W.ammoRecover - 1.0
      else
        W.ammoRecover = 0
      end
    end
  end
  self.ammoAnim:update(dt)
end

function ExplorerState:fadeIn( speed, callback )
  Waygame:pushState( FadeState( 0.0, 1.0, speed or 0.5, callback ) )
end

function ExplorerState:fadeOut( speed, callback )
  Waygame:pushState( FadeState( 1.0, 0.0, speed or -0.5, callback ) )
end

function ExplorerState:handleSign(ent)
  if self.signTable and self.signTable[ent] then
    Waygame:pushState( SignState(self.signTable[ent]) )
  else
    print("Unhandled sign", ent)
  end
end

function ExplorerState:handleTrigger( ent, x, y )
  local code = 1 + (ent - EntityCode.TRIGGER1)
  local handler = string.format("handleTrigger%i", code)
  if self[handler] then
    self[handler](self, x, y)
  else
    print("Unhandled trigger", ent)
  end
end

function ExplorerState:handleExit( ent, x, y )
  print( "Exit", ent, x, y )
end

