local rs = component.redstone
local term = require("term")
b1p=0.0001
b1n=0.0001
b2p=0.0001
b2n=0.0001
s1=0
s2=0
t = os.time()
while true do
  b = component.mcp_mobius_betterbarrel.getStoredCount()
  b1p=math.floor((b1p+component.batterybuffer_09_tier_03.getAverageElectricInput())/2)
  b1n=math.floor((b1n+component.batterybuffer_09_tier_03.getAverageElectricOutput())/2)
  b2p=math.floor((b2p+component.batterybuffer_09_tier_02.getAverageElectricInput())/2)
  b2n=math.floor((b2n+component.batterybuffer_09_tier_02.getAverageElectricOutput())/2)
  if (os.time() - t) > 150 then
    t = os.time()
    term.clear()
component.setPrimary(component.get("f9c"))
a = component.redstone.getInput(2)
    if b1p==0 then
      print("BUF 512 [GEN OFF]:" .. " " .. component.redstone.getInput(2)/16*100 .. "%")
      print("IN:".." ".. b1p, "OUT:".." ".. b1n .. " " ..  "DIF:" .. " " .. math.ceil(b1p-b1n))
    else
      print("BUF 512 [GEN ON]:" .. " " .. component.redstone.getInput(2)/16*100 .. "%")
      print("IN:".." "..b1p,"OUT:" .. " " .. b1n .. " " ..  "DIF:" .. b1p-b1n)
    end
    print("=========================")
    print("BUF 128:")
    print("IN:" .. " " .. b2p, "OUT:" .. " " .. b2n .. " " ..  "DIF:" .. b2p-b2n)
    print("=========================")
    print("Накопление:" .. " " .. b1p-b2n)
    print("Угля в бочке:" .. " " .. b)
component.setPrimary(component.get("0ca"))
      if b > 4000 then
        component.redstone.setOutput(1, 0)
      else
        component.redstone.setOutput(1, 255)
      end
  end
  os.sleep(0.01)
end