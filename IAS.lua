-- install_speed_control.lua
-- This script generates autospeed.lua and startup.lua

-- autospeed.lua: Continuously adjusts speed safely
local autospeed = [[
-- autospeed.lua: continuously adjusts speed safely

local speedController, stressometer

for _, name in ipairs(peripheral.getNames()) do
    if string.find(name, "RotationSpeedController") then
        speedController = peripheral.wrap(name)
    elseif string.find(name, "Stressometer") then
        stressometer = peripheral.wrap(name)
    end
end

if not speedController or not stressometer then
    error("Autospeed: Required peripherals not found.")
end

print("Autospeed: Running...")

while true do
    local currentStress = stressometer.getStress()
    local capacity = stressometer.getStressCapacity()
    local currentSpeed = speedController.getTargetSpeed()

    if currentSpeed and currentSpeed ~= 0 then
        local stressPerSpeed = currentStress / math.abs(currentSpeed)

        if stressPerSpeed and stressPerSpeed ~= 0 then
            local maxSafeSpeed = math.floor(capacity / stressPerSpeed)
            if maxSafeSpeed < 1 then maxSafeSpeed = 1 end

            local targetSpeed = maxSafeSpeed * (currentSpeed < 0 and -1 or 1)
            speedController.setTargetSpeed(targetSpeed)
        end
    end

    sleep(0.1)
end
]]

-- startup.lua: Runs autospeed.lua in parallel
local startup = [[
-- startup.lua: runs autospeed in parallel

local function runAutoSpeed()
    shell.run("autospeed.lua")
end

parallel.waitForAll(runAutoSpeed)
]]

-- Write autospeed.lua
local file1 = fs.open("autospeed.lua", "w")
file1.write(autospeed)
file1.close()

-- Write startup.lua
local file2 = fs.open("startup.lua", "w")
file2.write(startup)
file2.close()

print("Created autospeed.lua and startup.lua.")
os.reboot()
