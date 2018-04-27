local component = require('component')
local gpu = component.gpu
local color1, color2, text = 0xff00ff, 0x0000ff, 'Hello, OpenComputers!'
for i = 1, 10 do
  gpu.setForeground(color1)
  gpu.setBackground(color2)
  gpu.set(10, 5, text)
  color1, color2 = color2, color1
  os.sleep(0.5)
end
gpu.setForeground(0xffffff)
gpu.setBackground(0)