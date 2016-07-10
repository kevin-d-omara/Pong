--[[
A helper utility for menu.lua.
Each page owns a selector containing the selectable elements on that page.
--]]

Selector = {}

function Selector:new(page)
    local obj = {}
    obj.current = nil
    obj.index = nil
    
    -- selector gets all selectable entries on the page
    for k, v in ipairs(page) do
        if v.selected ~= nil then
            table.insert(obj, v)
        end
    end
    
    -- point selector to currently selected entry
    for k, v in ipairs(obj) do
        if v.selected == true then
            obj.current = v
            obj.index = k
        end
    end
        
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Selector:next()
    self.current.selected = false
    self.index = self.index + 1
    self.current = self[self.index]
    if self.index > #self then
        self.current = self[1]
        self.index = 1
    end
    self.current.selected= true
end

function Selector:previous()
    self.current.selected = false
    self.index = self.index - 1
    self.current = self[self.index]
    if self.index < 1 then
        self.current = self[#self]
        self.index = #self
    end
    self.current.selected = true
end