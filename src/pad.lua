local love = require('love')
local pad = {
  x = 0,
  y = 0,
  width = 32,
  height = 128,
  buttonUp = 'k',
  buttonDown = 'j',
  speed = 100,
}

function pad:new(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end

function pad:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

function pad:update(dt)
  if love.keyboard.isDown(self.buttonUp) and self.y >= 2 then
    self.y = self.y - self.speed * dt
  elseif love.keyboard.isDown(self.buttonDown) and self.y < 471 then
    self.y = self.y + self.speed * dt
  end
end

return pad
