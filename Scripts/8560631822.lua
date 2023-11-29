-- Bedwars solos and duels

local startTick = tick()

if isfile("Mana/Scripts/6872274481.lua") == true then
    loadstring(readfile("Mana/Scripts/6872274481.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MankaUser/ManaV2ForReblox/main/Scripts/6872274481.lua"))()
end

print("Mode: Solo or duels")
print("[Mana/Scripts/8560631822.lua]: Loaded in " .. tostring(tick() - startTick) .. ".")