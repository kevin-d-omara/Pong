allGameObjects = {}

GameObject = {}
function GameObject:new(x, y, speedx, speedy, maxspeedx, maxspeedy, width, height, shape, color)
    local obj = {}
    obj.x = x or 0
    obj.y = y or 0
    obj.speedx = speedx or 0
    obj.speedy = speedy or 0
    obj.maxspeedx = maxspeedx or 0
    obj.maxspeedy = maxspeedy or 0
    obj.width = width or 10
    obj.height = height or 10
    obj.shape = shape or "rectangle"
    obj.color = {}
    for k, v in ipairs(color) do
        obj.color[k] = v or 255
    end
    
    setmetatable(obj, self)
    self.__index = self
    table.insert(allGameObjects, obj)
    return obj
end

function GameObject:draw()
    love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    if self.shape == "rectangle" then
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    elseif self.shape == "circle" then
        love.graphics.circle("fill", self.x, self.y, self.height/2, 50) 
    end
end

function GameObject:move(dt)
    self.speedx = self.limitSpeed(self.speedx, self.maxspeedx)
    self.speedy = self.limitSpeed(self.speedy, self.maxspeedy)
    
    self.x = self.x + self.speedx*dt
    self.y = self.y + self.speedy*dt
end

function GameObject.limitSpeed(speed, maxspeed)
    if math.abs(speed) > maxspeed then
        local sign = speed < 0 and -1 or 1
        speed = sign * maxspeed
    end
    return speed
end

function spawnBall()
    local initSpeedX = 300 * (math.random() < 0.5 and 1 or -1)
    local initSpeedY = math.random() < 0.5 and math.random(25,300) or math.random(-25,-300)
    ball = GameObject:new(window.width/2-5, window.height/2-5, initSpeedX, initSpeedY, 300, 750, 10, 10, "circle", {51,204,51,255})
end
spawnBall()