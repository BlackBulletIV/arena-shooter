noise = {}
noise.active = true

function noise:init()
  self.supported = postfx.effectsSupported
  self.timer = 0
  self.time = 0.04
  self.effect = assets.effects.noise
end

function noise:update(dt)
  if self.timer >= self.time then
    -- a 2d random factor seems to reduce the size of the occasional "artifacts"
    self.effect:send("factor", { math.random(), math.random() })
    self.timer = self.timer - self.time
  end
  
  self.timer = self.timer + dt
end
