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

    -- Convert data to string safely
    if type(data) == "table" then
        data = textutils.serialize(data)
    else
        data = tostring(data)
    end

    -- Split string into lines and write them
    local y = 1
    for line in data:gmatch("[^\r\n]+") do
        target.setCursorPos(1, y)
        target.write(line)
        y = y + 1
    end
end

-- Function to get data from the source display
function netlib.GetData()
    local width, height = source.getSize()
    local lines = {}
    for y = 1, height do
        local line = source.getLine(y)
        table.insert(lines, line)
    end
    return table.concat(lines, "\n")
end

return netlib
