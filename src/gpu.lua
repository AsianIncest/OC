local gpu = require('component').gpu
local pull_e = require('event').pull
local b_color = gpu.getBackground()
local color = {[0] = 0x00ff00, 0x0000ff}
while true do
  local tEvent = {pull_e('touch')}
  if tEvent[3] == 1 and tEvent[4] == 1 then
    gpu.setBackground(b_color)
    os.exit()
  end
  gpu.setBackground(color[tEvent[5]])
  gpu.set(tEvent[3], tEvent[4], ' ')
  gpu.set(1, 1, 'x: '..tEvent[3]..' y: '..tEvent[4]..'    ')
end