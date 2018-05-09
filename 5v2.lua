--[[
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$$  INFO $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  Скрипт автоматизации домашней шляпы
  Авторы: 
    Asian_In4est avsv4@ya.ru
    Replic
  
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$$  ВЕРСИИ $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  
  Версии будут начинаться со 100, каждая следующая << ver++ >>
  
  == 100 ==
    Пробуем собрать рабочую тему из старых кусков.
    Стараемся использовать функции.
--]]

-- ПК
local computer = 1 
-- компоненты
local com = 1
-- карта
local gpu = 1
-- стороны (прим. sides.top, sides.bottom, sides.south)
local sides = 1 
-- красный куб
local red = 1
-- буферило
local bat = 1
-- включить генератор
local genOn = 1
-- ружим отладки
local ic = 1
local DBG = true
local bat_count = 0
local bat_total_capacity = 0
local bat_max_capacity = 0

--------------------------------------------------------------------------
function init() --[[
	Подключает компоненты и выполняет настройку 
	--]]
	computer = require("computer")
	com = require("component")
	gpu = com.gpu
	sides = require('sides')
	red = com.redstone
	genOn = false
	-- ищем первый попавшийся буфер из списка компонентов
	for address, componentType in com.list() do 
		if DBG then print(address, componentType) end
		if string.find(componentType,'battery') ~= nil then
			bat = com.proxy(address)
			break
		end
	end


	if bat == 1 then
		print("#Ёбана рот цыгане буфер спиздили!")
		print(" иди ищи нахуй")
		os.exit()
	end

	ic = com.inventory_controller
	-- пауза после инициализации
	if DBG then os.sleep(5) end
end

--------------------------------------------------------------------------
function getBat()--[[
	Считывает инфу по батарейкам
	--]]

	for i = 1,16 do
		if DBG then print(">> ", i) end
		local bat = ic.getStackInSlot(sides.top, i)
		if bat.name == "IC2:itemBatLamaCrystal" then
			bat_count = bat_count + 1
			bat_total_capacity = bat_total_capacity + bat.charge
			bat_max_capacity = bat_max_capacity + bat.maxCharge
		end
	end
end

--------------------------------------------------------------------------
function main()
	local r, msg = pcall(init)
	if DBG then print(">> inint .. ", r, msg) end
	getBat()
	print(bat_count, bat_total_capacity, bat_max_capacity)
	os.sleep(10)
	os.exit()
	
end



local f, msg = pcall(main)
if DBG then print(">> main .. ", f, msg) end




