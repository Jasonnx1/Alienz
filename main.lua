Object = require "Classic"
require "Animation"
require "TextBox"
require "Game"
lg = love.graphics
local MAX_DT = 0.1
font = love.graphics.newFont("assets/font.ttf",20)


function love.reload()

    game = Game()
    game.tutorialSkip = true
    textBox = TextBox()
    textBox:queueText("Welcome to Alienz ! -Spacebar to continue-")
    textBox:queueText("Choose your Starter:")

end

function love.load()
    --optional settings for window
    love.window.setMode(640, 640, {resizable=true, vsync=true, minwidth=640, minheight=640})
    game = Game()
    textBox = TextBox()
    textBox:queueText("Welcome to Alienz ! -Spacebar to continue-")
    textBox:queueText("Choose your Starter:")
end

function love.update(dt)

    if dt > MAX_DT then
        return  -- skip update to avoid huge jump in delta time
    end

    textBox:update(dt)
    game:update(dt)
end

function map(val, start, e, min, max)

    result = (val - start)/(e - start)*(max - min) + min;

    return result;

end

function love.keypressed(key)

    if(game.gameOver == true and key == "r") then
        game:reset()
        textBox:reset()
        love:reload()
    end

    if(textBox.active == true) then
        textBox:keyPressed(key)
    else
        game:keyPressed(key)
    end

    
end

function love.draw()
    love.graphics.setColor(1,1,1)

    lg.push()   
        game:draw()
    lg.pop()

    love.graphics.setColor(1,1,1)
    textBox:draw()
end


