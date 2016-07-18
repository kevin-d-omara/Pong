Paddle = GameObject:new()
table.remove(allGameObjects)  -- don't want prototype in object list

function Paddle:new(side, color)
    local width = 16
    local height = 80
    local gap = 30
    local x = side == "left" and (gap) or (window.width - gap - width)
    local obj = GameObject:new(x, window.height/2-30, 0, 0, 0, 475, width, height, color)
    obj.bassBounce = love.audio.newSource("sounds/deep-bass-bounce.wav", "static")
    
    setmetatable(obj,self)
    self.__index = self
    return obj
end

function Paddle:bounceWall()
    table.insert(soundQueue, self.bassBounce)
end