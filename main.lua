--[[
    By Kevin O'Mara
    Version 0.1
--]]

-- original pong: https://www.youtube.com/watch?v=it0sf4CMDeM

-- TODO:
--      - sound effects (ambient, collision, point scored)
--      - background??
--      - 'package' up; test cross platform-ness via Linux
--      ???
--      profit

function love.load()
    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
    
    require "config"
    require "GameObject"
    require "Player"
    require "collisions"
end

function love.update(dt)
    -- player input
    for _, player in ipairs(allPlayers) do
        player:checkIfKeyPressed(dt)
    end
    
    -- update screen positions
    for _, obj in ipairs(allGameObjects) do
        obj:move(dt)
    end
    
    checkForCollisions()
end

function love.draw()
    for _, obj in ipairs(allGameObjects) do
        obj:draw()
    end
    
    drawDashedLine('y', window.width/2-2, 0, 4, window.height/19, 19, {255,255,255,255})
    
    -- display score
    local score = string.format("%.2d   %.2d", player1.score, player2.score)
    love.graphics.setColor(204,0,204,255)
    love.graphics.printf(score, 0, 35, window.width, 'center')
end

--[[ arguments:
xy = horizontal (x) or vertical (y) line
x  = starting x position
y  = starting y position
w  = width of single dash
h  = height of single dash
n  = number of dashes (includes blank dashes)
color = {r,g,b,a}
--]]
function drawDashedLine(x_y, x, y, w, h, n, color)
    love.graphics.setColor(color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 255)
    for i = 0, n, 2 do
        local tx = x_y == 'y' and x-w/2 or x+w*i
        local ty = x_y == 'y' and y+h*i or y-h/2
        love.graphics.rectangle("fill", tx, ty, w, h)
    end
end





