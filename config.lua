love.window.setTitle("Pong")
--love.window.setMode(600, 400)
love.window.setMode(650, 470)
window = {}
window.width, window.height, window.flags = love.window.getMode()

math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
love.keyboard.setKeyRepeat(true)

gameoverFont = love.graphics.newFont(56)
titleFont = love.graphics.newFont(36)
optionFont = love.graphics.newFont(28)
subOptionFont = love.graphics.newFont(20)

maxScore = 10