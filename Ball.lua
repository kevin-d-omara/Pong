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

-- player :: denotes which direction the spawned ball will travel
function Ball:spawnBall(player)
    local maxspeedxy = 570
    local dir = player == player1 and -1 or 1
    local initSpeedX = maxspeedxy * dir
    local initSpeedY = math.random() < 0.5 and math.random(25,150) or math.random(-25,-150)
    ball = self:new(window.width/2-8, window.height/2-8, initSpeedX, initSpeedY, maxspeedxy, maxspeedxy, 16, 16, {51,204,51,255})
end
Ball:spawnBall(player1)

function Ball.bounce()
    local bassBounce = love.audio.newSource("sounds/ball-bounce.mp3", "static")
    table.insert(soundQueue, bassBounce)
end

function Ball.score()
    local pointScored = love.audio.newSource("sounds/point-scored.wav", "static")
    pointScored:setPitch(3)
    table.insert(soundQueue, pointScored)
end