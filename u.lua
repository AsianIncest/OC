--[[
Update and run
--]]

function rm()
  os.execute('rm 5v2.lua')
 end
 
 function go()
  os.execute('5v2.lua')
 end
 
 local a,b = pcall(rm)
 print(a,b)
 a,b = pcall(go)
 print(a,b)
 
 print('==================================')
