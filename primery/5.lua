--[[
Авторы = Азиат и Репа
Версия = 0.3.1
Дата = 04.2018

Изменения:
	0.2{
		https://pastebin.com/nSaYa5Wj
		+ улучшен вывод
		+ больше полезной информации
	}
	
	0.3.1{
		https://pastebin.com/Uv7Xayn6
		+ обработка ошибок при отсутствии компонентов
	}

Планы:
	- поправить код, подчистить, замарафетить
--]]

component = require ("component")
gpu = component.gpu
rs = component.redstone
term = require("term")
start, coal, energy = true, true, true
function init()
	local a = component.proxy ("0ca6cf55-ccc0-4cfa-bbdc-1c6f8ddf5e18")
	if not a then
		print(">> Err: Угольная бочка недоступна!")
		os.sleep(3)
		start = false
	end
	
	local b = component.proxy ("9ef70301-129d-4378-bb49-d281cd6db5cc")
	if not b then
		print(">> Err: Буфер не подключен!")
		os.sleep(3)
		start = false
	end	
	
	coal, energy = a, b
end

local a,b = pcall(init)
if not a then
	print("#Kernel panic: init error..!!\n",b)
	start = false
end


gpu.setResolution(40, 16)
-- ёмкость литиевой батарейки
local emc_batt = 1600000
-- кол-во батареек в буфере
local cnt_batt = 6
-- 
local coal_limit = 32000
--
local nominal_gen = 200
b1p = 0.0001
b1n = 0.0001
s1 = 0
s2 = 0
t = os.time()

function main()
	while start do
	  b = component.mcp_mobius_betterbarrel.getStoredCount()
	  b1p=math.floor((b1p+component.batterybuffer_09_tier_03.getAverageElectricInput())/2)
	  b1n=math.floor((b1n+component.batterybuffer_09_tier_03.getAverageElectricOutput())/2)
	  if (os.time() - t) > 150 then
		t = os.time()
		term.clear()
		print("Генерация:")
		if b1p < nominal_gen then
		  print(">> состояние: разряд батарей")
		  print(">> выход: -" .. b1n .. " V")
		else
		  print(">> состояние: заряд батарей")
		  print(">> вход: +" .. b1p .. " V")
		end
		print("")
		
		print("Хранилище:")
		local proc = energy.getInput(2)/16*100
		local emc_now = (emc_batt*cnt_batt/100*proc)
		local emc_max = (emc_batt*cnt_batt)
		print(">> Ёмкость: " .. emc_now / 1000000 .. " / " .. emc_max / 1000000 .. " mEU")
		print(">> Заполнено: " .. proc .. "%")
		local E = math.floor(b1p - b1n)
		if E > 128 then
		  print(">> E = +" .. E .. " V")
		  eum = E * 20 * 60
		  t = (emc_max - emc_now)/eum
		  print(">> Время до полной зарядки: " .. math.floor(t) .. " мин")
		elseif E < 128 then
		  print(">> E = " .. E .. " V")
		  eum = E * 20 * 60 * -1
		  t = (emc_now / eum) > 1 and emc_now / eum or 0
		  print(">> Время до разряда: " .. math.floor(t) .. " мин")
		else
		  print(">>  E = 0!")
		  print("")
		end
		print("")
		print("Уголь:")
		print(">> Лимит " .. coal_limit .. " шт")
		print(">> Заполнение: " .. math.floor(b/coal_limit*100) .. " %")
		  if b > 32000 then
			coal.setOutput(1, 0)
		  else
			coal.setOutput(1, 255)
		  end
		  if b < 1000 then
			print(">> Состояние: на донышке")
		  elseif (b > 1000 and b < 10000) then
			print(">> Состояние: производится")
		  elseif b > 32000 then
			--print(">> Состояние: заполнено")
		  end
		  print("")
	  end
	  os.sleep(0.5)
	end
end

local x,y = pcall(main)
if (not x) and (y == "interrupted") then
	print("Ой, всё!!")
elseif not x then
	print(x,y)
end