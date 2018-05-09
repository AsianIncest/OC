--[[
Update and run
--]]

function rm()
  os.execute('rm 5v2.lua')
 end
 
 function go()
  os.execute('wget https://github.com/AsianIncest/OC/raw/master/5v2.lua')
  os.execute('5v2.lua')
 end
 
 local a,b = pcall(rm)
 print(a,b)
 a,b = pcall(go)
 print(a,b)
 
 print('==================================')
