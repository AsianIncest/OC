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
	
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$$  ИДЕИ   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	Если в слоте буфера есть незаряженный предмет, включить генерацию
	до полной его зарядки)
--]]

--------------------------------------------------------------------------
function pattern()--[[

	--]]
end

local VER = 100
local REV = 12
-- ПК
local computer = 1 
-- компоненты
local com
-- карта
local gpu
-- стороны (прим. sides.top, sides.bottom, sides.south)
local sides
-- красный куб
local red
-- буферило
local bat
-- включить генератор
local genOn
-- контролёр инвентаря
local ic
-- ружим отладки
local DBG = true
-- сколько батареек
local bat_count
-- текущая ёмкость
local bat_total_capacity
-- полная ёмкость
local bat_max_capacity
-- таблица с батарейками
local all_bat = {}
local sX, sY = 100, 30
--------------------------------------------------------------------------
function init() --[[
	Подключает компоненты и выполняет настройку 
	--]]
	computer = require("computer")
	com = require("component")
	gpu = com.gpu
	-- выставим разрешение дисплея
	gpu.setResolution(sX, sY)
	-- стороны света (bottom, top, west, east, north, south)
	sides = require('sides')
	red = com.redstone
	genOn = false
	-- ищем первый попавшийся буфер из списка компонентов
	for address, componentType in com.list() do 
		if DBG then print(address, componentType) end
		if string.find(componentType,'battery') ~= nil then
			bat = com.proxy(address)
			-- break
		end
	end


	if bat == 1 then
		print("#Ёбана рот цыгане буфер спиздили!")
		print(" иди ищи нахуй")
		os.exit()
	end

	ic = com.inventory_controller
	
	local f, msg = pcall(initBat)
	if DBG then print(">> initBat.. ", f, msg) end
	-- пауза после инициализации
	if DBG then os.sleep(1) end
end

--------------------------------------------------------------------------
function final()--[[
	деинициализация
	--]]
	gpu.setResolution(160, 50)
	os.exit()
end
--------------------------------------------------------------------------
--- new brench
function getBat()--[[
	Считывает инфу по батарейкам
	--]]
	bat_total_capacity = 0
	bat_max_capacity = 0
	for i = 1, #all_bat do
		bat_total_capacity = bat_total_capacity + all_bat[i].charge
		bat_max_capacity = bat_max_capacity + all_bat[i].maxCharge
	end
end

--------------------------------------------------------------------------
function initBat()--[[
	Перебор всех батареек и запись в массив
	--]]
	if DBG then print(">> Проверяю слоты в буфере..") end
	for i = 1,16 do
		local bat = ic.getStackInSlot(sides.top, i)
		-- если слот пустой bat=nil !
		if bat then
			-- для другого буфера надо будет поправить ..
			if bat.name == "IC2:itemBatLamaCrystal" then
				if DBG then print(">> Слот [", i, "]: IC2:itemBatLamaCrystal") end
				bat_count = bat_count + 1
				all_bat[bat_count] = bat
			end
		else
			if DBG then print(">> Слот [", i, "]: ---------------") end
			all_bat[i] = nil
		end
	end
	
	if DBG then print(">> Итог: " .. bat_count .. " батареек") end
	if DBG then print(">> Wait 2 sec") end
	if DBG then os.sleep(3) end
end
initBat()
local tmr1 = os.time()
repeat 
	getBat()
	if (os.time() - tmr1) > (3 * 72) then
		CLS()
		print("battery total ", bat_total_capacity)
		print("battery max ", bat_max_capacity)
		tmr1 = os.time()
	end
	os.sleep(1/5)
until false
--------------------------------------------------------------------------
function CLS()--[[
	очистка дисплея
	--]]
	gpu.fill(1, 1, sX, sY, ' ')
end

--------------------------------------------------------------------------
function main()--[[
	главная функция типа как в С
	--]]
	local sec = 72
	local timer1 = os.time()

	if DBG then os.sleep(5) end -- пауза если отладка ВКЛ
	repeat
		--[[
			Раз в 2 секунды считываем текущий заряд и выводим
			--]]
		if os.time() - timer1 >= 2 * sec then
			getBat()
			if DBG then print("BTC " .. bat_total_capacity) end
			if DBG then print("BTM " .. bat_max_capacity) end
			if bat_total_capacity and bat_max_capacity then
				local proc = math.floor(bat_total_capacity / bat_max_capacity * 100 + 0.5)
				gpu.set(1,29, "BTC " .. bat_total_capacity)
				gpu.set(1,30, "BMC " .. bat_max_capacity)
			end
			
			CLS()
			--assert(type(proc) == "number")
			if DBG then print(">> Type proc: ", type(proc)) end
			if proc then
				gpu.set(1,1, "Заряд: " .. proc .. "%")
			else
				gpu.set(1,1, "баг с зарядом")
			end
			
		end

		gpu.set(50,30, "VERSION " .. VER .. "#" .. REV)

		-- NOOP 5 тиков, чтобы не висло
		os.sleep(5/20)
	until false
	os.exit()
	
end
------
-- безопасный запуск функций, при ошибке програ продолжает работать
-- первый возвращаемый параметр - это флаг успеха
-- второй - описание ошибки или nil
-- local r, msg = pcall(init)
-- if DBG then print(">> inint .. ", r, msg) end

-- local f, msg = pcall(main)
-- if DBG then print(">> main .. ", f, msg) end

-- final()


