require "Selector"

menu = {}

-- TODO: update this comment block
--[[ format for each page (i.e. menu.pages.menu, menu.pages.options, etc):
    {string, x position, y position, color {r,g,b,a}, font, *true/false/nil}
    true = currently selected
    false = not currently selected
    nil   = not selectable (i.e. title of page)
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

-- menu
table.insert(menu.pages.menu, menu.entry("Menu", 0, 80, {255,255,255,255}, titleFont, nil))
table.insert(menu.pages.menu, menu.entry("Start", 0, 170, {255,255,255,255}, optionFont, true))
    menu.pages.menu[2].key.enter = function()
        gamestate = "ingame"
        music.fadeTo(music.ingameAmbience, .6, .6)
    end
table.insert(menu.pages.menu, menu.entry("Options", 0, 240, {255,255,255,255}, optionFont, false))
    menu.pages.menu[3].key.enter = menu.pages.goTo(menu.pages.options)
menu.pages.menu.selector = Selector:new(menu.pages.menu)

-- options
table.insert(menu.pages.options, menu.entry("Options", 0, 80, {255,255,255,255}, titleFont, nil))
table.insert(menu.pages.options, menu.entry("Volume: 100", 0, 170, {255,255,255,255}, optionFont, true))
table.insert(menu.pages.options, menu.entry("Player 1 Controls", 0, 240, {255,255,255,255}, optionFont, false))
table.insert(menu.pages.options, menu.entry("Player 2 Controls", 0, 310, {255,255,255,255}, optionFont, false))
menu.pages.options.selector = Selector:new(menu.pages.options)

menu.pages.previous = {}  -- this is a stack
menu.pages.current = menu.pages.menu

function menu.keypressed(key)
    if key == 'up' or key == 'w' then
        menu.pages.current.selector:previous()
    elseif key == 'down' or key == 's' or key == 'tab' then
        menu.pages.current.selector:next()
    elseif key == 'left' or key == 'a' then
        menu.pages.current.selector.current.key.left()
    elseif key == 'right' or key == 'd' then
        menu.pages.current.selector.current.key.right()
    elseif key == 'return' then
        menu.pages.current.selector.current.key.enter()
    elseif key == 'backspace' then
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

function menu.changePage()
end

--local score = string.format("%.2d   %.2d", player1.score, player2.score)