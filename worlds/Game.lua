Game = class("Game", PhysicalWorld)

function Game:initialize()
  PhysicalWorld.initialize(self, 0, 0)
  self.score = 0
  self.paused = false
  self.over = false
  self.maxSlowmo = 2
  self.slowmoRecharge = 0.2
  self.slowmo = self.maxSlowmo
  self.slowmoActive = false
  self.deltaFactor = 1
  Game.static.id = self
  love.physics.setMeter(50)
  
  self:add(
    Fade:new(0.5, true),
    HUD:new(),
    Barrier:new(),
    Player:new(love.graphics.width / 2, love.graphics.height / 2),
    EnemySpawner:new(40, 40),
    EnemySpawner:new(love.graphics.width - 40, 40),
    EnemySpawner:new(40, love.graphics.height - 40),
    EnemySpawner:new(love.graphics.width - 40, love.graphics.height - 40)
  )
end

function Game:start()
  Fade.id:fadeIn()
end

function Game:update(dt)
  if input.pressed("pause") then self:pause() end
  if self.paused then return end
  
  if not self.over then
    if self.slowmoActive then
      self.slowmo = self.slowmo - dt
      
      if self.slowmo <= 0 or input.released("slowmo") then
        if self.slowmoTween then self.slowmoTween:stop() end
        self.slowmoTween = tween(self, 0.15, { deltaFactor = 1 })
        self.slowmoActive = false
      end
    else
      if self.slowmo < self.maxSlowmo then
        self.slowmo = math.min(self.slowmo + self.slowmoRecharge * dt, self.maxSlowmo)
      end
      
      if self.slowmo > 0 and input.pressed("slowmo") then
        if self.slowmoTween then self.slowmoTween:stop() end
        self.slowmoTween = tween(self, 0.15, { deltaFactor = 0.25 })
        self.slowmoActive = true
        Player.id:showSlowmo()
      end
    end
  elseif self.canReset and input.pressed("reset") then
    Fade.id:fadeOut(self.reset, self)
  end
  
  dt = dt * self.deltaFactor
  _G.dt = dt
  PhysicalWorld.update(self, dt)
  if key.pressed.k then Player.id:die() end
end

function Game:draw()
  if not self.paused or not blur.active then
    blur.start()
    PhysicalWorld.draw(self)
  end
  
  blur.stop()
end

function Game:gameOver()
  if self.slowmoTween then self.slowmoTween:stop() end
  self.slowmoTween = tween(self, 0.25, { deltaFactor = 0.1 }, nil, self.stopGameOverSlowmo, self)
  self.over = true
  HUD.id.drawCursor = false
end

function Game:enemyKilled(enemy)
  self.score = self.score + 1
end

function Game:pause()
  if not PauseMenu.id then PauseMenu:new() end
  ammo.world = PauseMenu.id
  self.paused = true
end

function Game:unpause()
  ammo.world = self
  self.paused = false
end

function Game:reset()
  ammo.world = Game:new() -- quick, temporary way of doing it
end

function Game:stopGameOverSlowmo()
  self.slowmoTween = tween(self, "0.2:0.3", { deltaFactor = 1 }, nil, self.gameOverSlowmoStopped, self)
end

function Game:gameOverSlowmoStopped()
  self.canReset = true
  data.score(self.score)
  HUD.id:gameOver()
end
