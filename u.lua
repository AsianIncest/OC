--[[
Update and run
--]]
local filesystem = require("filesystem")
local script = "5v2.lua"
local url = "https://github.com/AsianIncest/OC/raw/master/5v2.lua"

function main()
	
	print("")
	while filesystem.exists(script) do
		print(">> Script exists .. remove")
		local a,b = filesystem.remove(script)
		if a then print(">> File " .. script .. " removed .. ok") end
	end
	print('>> Request to GitHub ..')
	a,b = os.execute('wget ' .. url)
	if a then print(">> Download .. ok") end
	print(">> Run")
	os.execute(script)
end

a,b = pcall(main)
print("<<<<< Updater for 5v5 script >>>>> \n\n\n", a, b)