-- More scripts available at:
-- https://lambra.tebex.io

Config = {}

Config.timeYoga = 15000 -- time in ms
Config.reliefAmount = math.random(1, 2)

Config.Delay = {
    enabled = true, --Set this to true if you don't want people to spam
    amount = 3000-- time in ms
}

Config.Anims = {
    --Anims will be picked randomly once the player starts the "yoga"
    --You can add more
    [1] = {dict = "mini@triathlon", anim = "idle_e"},
    [2] = {dict = "mini@triathlon", anim = "idle_f"},
    [3] = {dict = "mini@triathlon", anim = "idle_d"},
    [4] = {dict = "rcmfanatic1maryann_stretchidle_b", anim = "idle_e"}
}

Config.staticMats = {
    --You can add more locations to spawn mats
    {coords = vector4(-574.55, -1082.19, 21.35, 97.77)},
    {coords = vector4(-573.44, -1081.21, 21.35, 129.58)},
    {coords = vector4(-572.91, -1079.42, 21.35, 158.27)}
}

Locales = {
    ["startYoga"] = "[~g~E~w~] do some yoga",
    ["pickupMat"] = "[~g~G~w~] Pickup mat",
    ["rollMat"] = "[~g~G~w~] Roll up mat",
    ["isDelayed"] = "Take a deep breath...",
    ["makingYoga"] = "Relieving stress",
    ["alreadyOwnMat"] = "You already set a mat",
}