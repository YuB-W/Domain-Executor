-- Bedwars 30v30

local startTick = tick()

if isfile("Mana/Scripts/6872274481.lua") == true then
    loadstring(readfile("Mana/Scripts/6872274481.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MankaUser/ManaV2ForReblox/main/Scripts/6872274481.lua"))()
end

print("Mode: 30v30")
print("[Mana/Scripts/8444591321.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")