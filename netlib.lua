-- netlib.lua
local netlib = {}

-- Utility: Find a peripheral whose name contains a given substring
local function findPeripheralByNamePattern(pattern)
    for _, name in ipairs(peripheral.getNames()) do
        if name:find(pattern) then
            return peripheral.wrap(name)
        end
    end
    error("Peripheral with pattern '" .. pattern .. "' not found.")
end

-- Automatically discover the source and target
local source = findPeripheralByNamePattern("create_source")
local target = findPeripheralByNamePattern("create_target")

-- Function to send data to the target display
function netlib.SendData(data)
    target.clear()

-- Send data to the display via source block (the one with terminal methods)
function netlib.SendData(data)
    source.clear()

    if type(data) == "table" then
        data = textutils.serialize(data)
    else
        data = tostring(data)
    end

    local y = 1
    for line in data:gmatch("[^\r\n]+") do
        source.setCursorPos(1, y)
        source.write(line)
        y = y + 1
    end
end

-- Read from the target block (if needed — optional use)
function netlib.GetData()
    local width, height = target.getSize()
    local lines = {}
    for y = 1, height do
        table.insert(lines, target.getLine(y))
    end
    return table.concat(lines, "\n")
end


return netlib
