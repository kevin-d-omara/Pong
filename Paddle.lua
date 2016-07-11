Paddle = GameObject:new()
table.remove(allGameObjects)  -- don't want prototype in object list

function Paddle:new(x, y, speedx, speedy, maxspeedx, maxspeedy, width, height, color)
    local obj = GameObject:new(x, y, speedx, speedy, maxspeedx, maxspeedy, width, height, color)
    obj.bassBounce = love.audio.newSource("sounds/deep-bass-bounce.wav", "static")
    
    setmetatable(obj,self)
    self.__index = self
    return obj
end

function Paddle:bounceWall()
    table.insert(soundQueue, self.bassBounce)
end