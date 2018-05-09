local computer = require("computer");
local comp = require("component")
local gpu = comp.gpu
local sides = require('sides')

if not comp.isAvailable("redstone") then
  print("No redstone Found, fuck you niger!")
  os.exit()
end

if not comp.isAviable("batterybuffer_16_tier_04") then
	print("Ой всё, нет буфера, иди нахуй")
	os.exit()
end

local red = comp.redstone
local bat = comp.batterybuffer_16_tier_04
local genOn = false

repeat
	signal = red.getInput(sides.south)
	if signal < 3 then genOn = true end
	if signal > 13 then genOn = false end
	red.setOutput(sides.bottom, genOn and 15 or 0)
	print(genOn, signal)
	os.sleep(0.8)
until false