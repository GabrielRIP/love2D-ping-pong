local love = require('love')

local ball = {
    x = 400 - 16,
    y = 300 - 16,
    image = love.graphics.newImage('assets/ball.png'),
    sideSize = 32,
    speed = 400,
    dirX = -0.5,
    dirY = -0.5,
    hit = love.audio.newSource('assets/hit.wav', 'static')
}

function ball:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function ball:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function ball:update(dt)
    self.x = self.x + self.dirX * self.speed * dt
    self.y = self.y + self.dirY * self.speed * dt

    if self.y < 0 then
        self.dirY = 0.5
        self.hit:play()
    elseif self.y > 600-32 then
        self.dirY = -0.5
        self.hit:play()
    end
end

return ball
