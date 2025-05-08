-- netlib.lua
local netlib = {}

-- Function to find a peripheral by type
local function findPeripheral(peripheralType)
    local p = peripheral.find(peripheralType)
    if not p then
        error("Peripheral of type '" .. peripheralType .. "' not found.")
    end
    return p
end

-- Discover Source and Target peripherals
local source = findPeripheral("create_source")
local target = findPeripheral("create_target")

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
