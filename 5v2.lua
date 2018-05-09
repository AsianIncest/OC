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

local buffer_out_now = 0
local buffer_in_now = 0

local buffer_average_input = {}
local buffer_average_output = {}

local flag_statistic_ok = false
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

function getBat()
	for address, componentType in com.list() do 
		if string.find(componentType,'battery') ~= nil then
			bat = com.proxy(address)
			break
		end
	end
	
	for i = 1,16 do
		local _bat = ic.getStackInSlot(sides.top, i)
		-- если слот пустой bat=nil !
		if _bat then
			-- для другого буфера надо будет поправить ..
			if _bat.name == "IC2:itemBatLamaCrystal" then
				bat_count = bat_count + 1
				all_bat[bat_count] = _bat
			end
		else
			break
		end
	end
	

	for i = 1, #all_bat do
		bat_total_capacity = (bat_total_capacity or 0) + all_bat[i].charge
		bat_max_capacity = (bat_max_capacity or 0) + all_bat[i].maxCharge
	end
	
	buffer_in_now = bat.getAverageElectricInput()
	buffer_out_now = bat.getAverageElectricOutput()
end

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
	local counter = 0
	-- флаг говорит что статистика готова
	

	if DBG then os.sleep(5) end -- пауза если отладка ВКЛ
	repeat
		--[[
			Раз в 2 секунды считываем текущий заряд и выводим
			--]]
		if os.time() - timer1 >= 2 * sec then
			getBat()
			counter = counter + 1
			if counter <= 30  then
				buffer_average_input[counter] = buffer_in_now
				buffer_average_output[counter] = buffer_out_now
			elseif flag_statistic_ok == false then
				flag_statistic_ok = true
				counter = 0
			end
			
			timer1 = os.time()
		end


		-- NOOP 5 тиков, чтобы не висло
		os.sleep(5/20)
	until false
	os.exit()
	
end

function buffer_calc_average_input()
	local res = 0
	for i = 1, #buffer_average_input do
		res = (res + buffer_average_input[i]) / 2
	end
	return math.floor(res + 0.5)
end

function buffer_calc_average_output()
	local res = 0
	for i = 1, #buffer_average_output do
		res = (res + buffer_average_output[i]) / 2
	end
	return math.floor(res + 0.5)
end
-- безопасный запуск функций, при ошибке програ продолжает работать
-- первый возвращаемый параметр - это флаг успеха
-- второй - описание ошибки или nil
local r, msg = pcall(init)
if DBG then print(">> inint .. ", r, msg) end

local f, msg = pcall(main)
if DBG then print(">> main .. ", f, msg) end

final()


