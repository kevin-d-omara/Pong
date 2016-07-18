-- graphics
keys_arrow     = love.graphics.newImage("graphics/keys_cluster_arrow.png")
keys_backspace = love.graphics.newImage("graphics/key_wide_backspace.png")
keys_enter     = love.graphics.newImage("graphics/key_wide_enter.png")

require "Selector"

menu = {}

--[[ Arguments:
text = string to be displayed
x, y = positions on screen
color = {r,g,b,a}
font = font to use
selected = *true/false/nil
    -> true  = currently selected
    -> false = not currently selected
    -> nil   = not selectable (i.e. title of page)

--]]
function menu.entry(text, x, y, color, font, selected)
    local obj = {}
    obj.text = text
    obj.x = x
    obj.y = y
    obj.color = {}
    for k, v in ipairs(color or {}) do
        obj.color[k] = v
    end
    obj.font = font
    obj.selected = selected     -- nil == unselectable
    obj.key = {}
    obj.key.enter = function() end
    obj.key.left  = function() end
    obj.key.right = function() end
    return obj
end

menu.pages = {}

function menu.pages.goTo(page)
    return function()
        table.insert(menu.pages.previous, menu.pages.current)
        menu.pages.current = page
    end
end

function menu.pages.goBack()
    if #menu.pages.previous == 0 then return end
    menu.pages.current = table.remove(menu.pages.previous)
end

menu.pages.menu = {}
menu.pages.options = {}
menu.pages.controlsP1 = {}
menu.pages.controlsP2 = {}

-- menu
table.insert(menu.pages.menu, menu.entry("Menu", 0, 70, {255,255,255,255}, titleFont, nil))
table.insert(menu.pages.menu, menu.entry("Start", 0, 160, {255,255,255,255}, optionFont, true))
    menu.pages.menu[2].key.enter = function()
        gamestate = "ingame"
        music.fadeOut(music.current, .6)
        music.fadeIn(music.ingameAmbience, .6)
        music.current = music.ingameAmbience
    end
table.insert(menu.pages.menu, menu.entry("Options", 0, 230, {255,255,255,255}, optionFont, false))
    menu.pages.menu[3].key.enter = menu.pages.goTo(menu.pages.options)
table.insert(menu.pages.menu, menu.entry("Exit", 0, 300, {255,255,255,255}, optionFont, false))
    menu.pages.menu[4].key.enter = function() love.event.quit() end
menu.pages.menu.selector = Selector:new(menu.pages.menu)

-- options
table.insert(menu.pages.options, menu.entry("Options", 0, 70, {255,255,255,255}, titleFont, nil))
table.insert(menu.pages.options, menu.entry("Music Volume: "..allSongs.volume*100, 0, 160, {255,255,255,255}, optionFont, true))
    menu.pages.options[2].key.left  = function() allSongs:setVolume(allSongs.volume - 0.05); menu.pages.options[2].text = "Music Volume: "..allSongs.volume*100 end
    menu.pages.options[2].key.right = function() allSongs:setVolume(allSongs.volume + 0.05); menu.pages.options[2].text = "Music Volume: "..allSongs.volume*100 end
table.insert(menu.pages.options, menu.entry("Player 1 Controls", 0, 230, {255,255,255,255}, optionFont, false))
    menu.pages.options[3].key.enter = menu.pages.goTo(menu.pages.controlsP1)
table.insert(menu.pages.options, menu.entry("Player 2 Controls", 0, 300, {255,255,255,255}, optionFont, false))
    menu.pages.options[4].key.enter = menu.pages.goTo(menu.pages.controlsP2)
menu.pages.options.selector = Selector:new(menu.pages.options)

--[[ Arguments:
    - entry: entry of a page (i.e. menu.pages.controlsP1[2]
    - text: i.e. "Up" or "Down"
    - player: i.e. player1 or player2 (object pointers)
--]]
---[[
function enterNewControl(entry, text, player)
    return function()
        entry.text = text.." = '_'"
        oldKeyPressedFunction = love.keypressed
        local dir = text == "Up" and "up" or "down"
        function love.keypressed(key)  -- overwrite keypressed function => capture next keystroke as new key for control
            if key ~= nil then
                player.control[dir] = key
                entry.text = text.." = '"..player.control[dir].."'"
                love.keypressed = oldKeyPressedFunction
            end
        end
    end
end
--]]

-- controls player 1
table.insert(menu.pages.controlsP1, menu.entry("Player 1 Controls", 0, 70, {255,255,255,255}, titleFont, nil))
table.insert(menu.pages.controlsP1, menu.entry("Up = '"..player1.control.up.."'", 0, 160, {255,255,255,255}, optionFont, true))
    menu.pages.controlsP1[2].key.enter = enterNewControl(menu.pages.controlsP1[2], "Up", player1)
table.insert(menu.pages.controlsP1, menu.entry("Down = '"..player1.control.down.."'", 0, 230, {255,255,255,255}, optionFont, false))
    menu.pages.controlsP1[3].key.enter = enterNewControl(menu.pages.controlsP1[3], "Down", player1)
menu.pages.controlsP1.selector = Selector:new(menu.pages.controlsP1)

-- controls player 2
table.insert(menu.pages.controlsP2, menu.entry("Player 2 Controls", 0, 70, {255,255,255,255}, titleFont, nil))
table.insert(menu.pages.controlsP2, menu.entry("Up = '"..player2.control.up.."'", 0, 160, {255,255,255,255}, optionFont, true))
    menu.pages.controlsP2[2].key.enter = enterNewControl(menu.pages.controlsP2[2], "Up", player2)
table.insert(menu.pages.controlsP2, menu.entry("Down = '"..player2.control.down.."'", 0, 230, {255,255,255,255}, optionFont, false))
    menu.pages.controlsP2[3].key.enter = enterNewControl(menu.pages.controlsP2[3], "Down", player2)
menu.pages.controlsP2.selector = Selector:new(menu.pages.controlsP2)

menu.pages.previous = {}  -- this is a stack
menu.pages.current = menu.pages.menu

function menu.keypressed(key)
    if key == 'up' or key == 'w' then
        menu.pages.current.selector:previous()
    elseif key == 'down' or key == 's' then
        menu.pages.current.selector:next()
    elseif key == 'left' or key == 'a' then
        menu.pages.current.selector.current.key.left()
    elseif key == 'right' or key == 'd' then
        menu.pages.current.selector.current.key.right()
    elseif key == 'return' then
        menu.pages.current.selector.current.key.enter()
    elseif key == 'backspace' or key == 'tab' or key == 'escape'then
        menu.pages.goBack()
    end
end

function menu.display(page)
    for k, v in ipairs(page) do
        menu.printf(v.selected == true and menu.highlight(v.text) or v.text, v.x, v.y, v.color, v.font)
    end
end

function menu.printf(text, x, y, color, font)
    love.graphics.setFont(font)
    love.graphics.setColor(color[1],color[2],color[3],color[4])
    love.graphics.printf(text, x, y, window.width, 'center')
end

function menu.highlight(text)
    return "-->   "..text.."   <--"
end