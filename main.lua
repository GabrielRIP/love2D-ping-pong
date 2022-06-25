local love = require('love')
local pad = require('src.pad')
local bg = require('src.bg')
local ball = require('src.ball')

local font = love.graphics.newFont('assets/font.ttf', 32)
love.graphics.setFont(font)

local bluePad = pad:new {
    image = love.graphics.newImage('assets/BluePad.png'),
    speed = 200,
}

local greenPad = pad:new {
    image = love.graphics.newImage('assets/GreenPad.png'),
    speed = 200,
    x = love.graphics.getWidth() - 32,
    buttonUp = 'w',
    buttonDown = 's',
}

local background = bg:new {
    image = love.graphics.newImage('assets/bg.png'),
}

local state = 'start'    -- 'game', 'restart', 'finish'
local game = { player1 = 0, player2 = 0 }
local start = {}
local finish = { time = 0 }
local restart = {}

local function CheckCollision(x1,y1,w1,_, x2,y2,w2,h2)
    return (x1 + w1) > x2 and (x1 + w1) < (x2 + w2) and y1 > y2 and y1 < (y2 + h2),
        x1 < (x2 + w2) and x1 > x2 and y1 > y2 and y1 < (y2 + h2)
end

local function checkBodiesCollision(body)
    local rightCol, leftCol = CheckCollision(
        ball.x, ball.y, ball.sideSize, ball.sideSize,
        body.x, body.y, body.width, body.height
    )
    if rightCol then
        ball.dirX = -0.5
        ball.hit:play()
    elseif leftCol then
        ball.dirX = 0.5
        ball.hit:play()
    end
end

local function checkWin()
    local totalScore = game.player1 + game.player2
    if totalScore > 8 then
        state = 'finish'
    end
end

local function restartMatch()
    ball.x = 416
    ball.dirX = -ball.dirX
    checkWin()
end

local function checkExit()
    if ball.x < -ball.sideSize then
        game.player2 = game.player2 + 1
        restartMatch()
    elseif ball.x > 800 then
        game.player1 = game.player1 + 1
        restartMatch()
    end
end

function game.draw()
    background:draw()
    bluePad:draw()
    greenPad:draw()
    ball:draw()
    love.graphics.print(game.player1, 40, 20)
    love.graphics.print(game.player2, 740, 20)
end

function game.update(dt)
    bluePad:update(dt)
    greenPad:update(dt)
    ball:update(dt)
    checkBodiesCollision(bluePad)
    checkBodiesCollision(greenPad)
    checkExit()
end

function start.draw()
    background:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Press Space to start", 0, 200, 800, "center")
    love.graphics.setColor(1,1,1)
end

function start.update(_)
    if love.keyboard.isDown("space") then
        state = "game"
    end
end

function finish.draw()
    background:draw()
    local winner = "The winner is Player 2"
    if game.player1 > game.player2 then
        winner = "The winner is Player 1"
    end
    love.graphics.printf(winner, 0, 40, 800, "center")
end

function finish.update(dt)
    finish.time = finish.time + dt
    if finish.time >= 3 then
        state = 'restart'
    end
end

function restart.draw()
    background:draw()
end

function restart.update()
    finish.time = 0
    game.player1 = 0
    game.player2 = 0
    bluePad.y = 0
    greenPad.y = 0
    state = 'start'
end

function love.draw()
    if state == "start" then
        start.draw()
    elseif state == "game" then
        game.draw()
    elseif state == "finish" then
        finish.draw()
    elseif state == "restart" then
        restart.draw()
    end
end

function love.update(dt)
    if state == "start" then
        start.update(dt)
    elseif state == "game" then
        game.update(dt)
    elseif state == "finish" then
        finish.update(dt)
    elseif state == "restart" then
        restart.update()
    end
end
