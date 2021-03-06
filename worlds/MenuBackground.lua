MenuBackground = class("MenuBackground", Game)

function MenuBackground:initialize()
  Game.initialize(self)
  self.padding = 40
  self.left = MissileSpawner:new(self.padding, 0, 0)
  self.right = MissileSpawner:new(self.width - self.padding, 0, math.tau / 2)
  self.top = MissileSpawner:new(0, self.padding, math.tau / 4)
  self.bottom = MissileSpawner:new(0, self.height - self.padding, math.tau * 0.75)
  self:add(self.left, self.right, self.top, self.bottom)
  self.camera:update()
end

function MenuBackground:start()
  -- yeah, this is messy
  self.player.active = false
  self.player.visible = false
  self.player.invincible = true
  delay(1, function() self:remove(self.player) end)
  
  delay(0, function()
    self:remove(self.hud)
    self:generateMasks()
    self:add(self.background)
  end)
end

function MenuBackground:update(dt)
  PhysicalWorld.update(self, dt)
  self.left.y = math.random(self.padding, self.height - self.padding)
  self.right.y = math.random(self.padding, self.height - self.padding)
  self.top.x = math.random(self.padding, self.width - self.padding)
  self.bottom.x = math.random(self.padding, self.width - self.padding)
end
