blur = {}

function blur:init()
  self.alphaMultipler = 15
  self.minAlpha = 1
  self.active = true
  self.supported = postfx.supported
  self.active = self.supported
  if self.supported then self:updateResolution() end
end

function blur:draw(canvas)
  love.graphics.setCanvas(self.canvas)
  love.graphics.storeColor()
  love.graphics.setColor(0, 0, 0, math.clamp(dt * 255 * self.alphaMultipler, self.minAlpha, 255))
  love.graphics.rectangle("fill", 0, 0, love.graphics.width, love.graphics.height)
  love.graphics.resetColor()
  love.graphics.draw(canvas, 0, 0)
  return self.canvas
end

function blur:updateResolution()
  self.canvas = love.graphics.newCanvas()
end