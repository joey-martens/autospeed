-- netlib.lua
local netlib = {}

-- Function to find a peripheral by type
local function findPeripheral(peripheralType)
    local peripheral = peripheral.find(peripheralType)
    if not peripheral then
        error("Peripheral of type '" .. peripheralType .. "' not found.")
    end
    return peripheral
end

-- Discover Source and Target peripherals
local source = findPeripheral("create_source")
local target = findPeripheral("create_target")

-- Function to send data to the target display
function netlib.SendData(data)
    -- Clear the target display
    target.clear()

    -- Split the data into lines
    local lines = {}
    for line in data:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Write each line to the target display
    for i, line in ipairs(lines) do
        target.setCursorPos(1, i)
        target.write(line)
    end
end

-- Function to retrieve data from the source display
function netlib.GetData()
    local width, height = source.getSize()
    local data = {}

    -- Read each line from the source display
    for y = 1, height do
        local line = source.getLine(y)
        table.insert(data, line)
    end

    -- Combine lines into a single string
    return table.concat(data, "\n")
end

return netlib
