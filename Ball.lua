-- TODO: make collisions based on angle/edges (i.e. original Pong)
--       ^ include varying y-force based on this too

-- define ball object; child of game object
Ball = GameObject:new()
table.remove(allGameObjects)  -- don't want prototype in object list

function Ball:new(x, y, speedx, speedy, maxspeedx, maxspeedy, width, height, color)
    local obj = GameObject:new(x, y, speedx, speedy, maxspeedx, maxspeedy, width, height, color)
    obj.parent = Ball
    
    setmetatable(obj,self)
    self.__index = self
    return obj
end


function Ball:spawnBall()
    local initSpeedX = 400 * (math.random() < 0.5 and 1 or -1)
    local initSpeedY = math.random() < 0.5 and math.random(25,150) or math.random(-25,-150)
    ball = self:new(window.width/2-5, window.height/2-5, initSpeedX, initSpeedY, 400, 500, 15, 15, {51,204,51,255})
end
Ball:spawnBall()

--[[
function Ball:draw()    -- overwrite parent default: rectangle
    love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    love.graphics.circle("fill", self.x, self.y, self.height/2, 50)
end
--]]

function Ball.bounce()
    --local bassBounce = love.audio.newSource("sounds/deep-bass-bounce.wav", "static")
    local bassBounce = love.audio.newSource("sounds/ball-bounce.mp3", "static")
    table.insert(soundQueue, bassBounce)
end

function Ball.score()
    local pointScored = love.audio.newSource("sounds/point-scored.wav", "static")
    pointScored:setPitch(3)
    table.insert(soundQueue, pointScored)
end