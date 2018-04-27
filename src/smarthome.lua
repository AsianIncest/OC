--проверка работы
print("latin")
print("кириллица")

local comp = require("component")
--local inet = comp.internet
local inet = require("internet")
local b = inet.request("https://github.com/AsianIncest/OC/raw/master/src/smarthome.lua")
for line in b do
print(line)
end
