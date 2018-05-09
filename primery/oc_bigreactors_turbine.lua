local term = require("term")
local component = require("component")
local computer = require("computer")
local math = require("math")
local event = require("event")
local string = require("string")
local unicode = require("unicode")
local os = require("os") 
local fs = require('filesystem')
local gpu = component.gpu
gpu.setResolution(100,50)
br = component.getPrimary("br_turbine")
tur = component.br_turbine
local maxgetsteam = 2000
local mingetsteam = 0
local steam = 2000
local rate = tur.getFluidFlowRateMax()
local speed = 0
local block = 1
local block2 = 1
local eng23 = 0


local function sig(a)
 return math.floor(a)
end

local function englimit()
  if br.getEnergyStored() >= eng23 then
    br.setInductorEngaged(false)  
  elseif br.getEnergyStored() < eng23 then
    br.setInductorEngaged(true) 
end
end

local function speedlimit()
   if br.getRotorSpeed() < speed then
    tur.setFluidFlowRateMax(maxgetsteam)
   elseif br.getRotorSpeed() > speed then
    tur.setFluidFlowRateMax(mingetsteam)
 end
 end

local function loadbar(x,y,width,cur,text,bg,fg)
  local raw = " " .. text ..string.rep(" ", width - unicode.len(text) - 2) .. " "
  local oldbg = gpu.setBackground(bg)
  local oldfg = gpu.setForeground(fg)
  gpu.set(x,y,unicode.sub(raw,1,cur))
  gpu.setBackground(oldbg)
  gpu.setForeground(oldfg)
  gpu.set(x+cur,y,unicode.sub(raw,cur+1,width))
end 

local function setColor(bg,fg)
  gpu.setBackground(bg)
  gpu.setForeground(fg)
end

local function bargraph(x,y,length,am,cap,na,col,colpol)
  local amount = am
  local capacity = cap
  local pct = amount / capacity
  local cur = math.floor(pct * length)
  local color = col
  local color2 = colpol
  local name = na
  local textfrac = string.format("%s / %s", amount, capacity)
  local textpct = string.format("%.02f%%", pct*100)
  local text = textfrac .. string.rep(" ", length - string.len(textfrac) - string.len(textpct) - 6) .. "   " .. textpct .. " "
  local text1 = "              Уровень заполнения : ("..name..")"
  loadbar(x,y,length,cur,text1,color,color2)
  loadbar(x,y+1,length,cur,text,color,color2)
end

local function drawbars()
  amFuel = br.getInputAmount()
  capFuel = 4000
  naFuel = "ПАР"
  colFuel = 0xFFFF00
  colpolFuel = 0x0000FF
  bargraph(2,13,98,amFuel,capFuel,naFuel,colFuel,colpolFuel)
  amWaste = br.getOutputAmount()
  capWaste = 4000
  naWaste = "ВОДА"
  colWaste = 0x00FFFF
  colpolWaste = 0xFF00FF
  bargraph(2,16,98,amWaste,capWaste,naWaste,colWaste,colpolWaste)
  amSteam = br.getRotorSpeed()
  capSteam = 3000
  naSteam = "СКОРОСТЬ РОТОРА"
  colSteam = 0x8F8F8F
  colpolSteam = 0xFFFF00
  bargraph(2,19,98,amSteam,capSteam,naSteam,colSteam,colpolSteam)
  amWater = br.getEnergyStored()
  capWater = 1000000
  naWater = "НАКОПЛЕННАЯ ЭНЕРГИЯ"
  colWater = 0x71b6cb
  colpolWater = 0x0000FF
  bargraph(2,22,98,amWater,capWater,naWater,colWater,colpolWater)
  en = tur.getEnergyProducedLastTick()
  en2 = en * 20
  en3 = en2 * 60
  en4 = en3 * 60
  gpu.set(3,43,string.format("%10f",sig(en)))
  gpu.set(25,43,string.format("%10f",sig(en2)))
  gpu.set(49,43,string.format("%10f",sig(en3)))
  gpu.set(74,43,string.format("%10f",sig(en4)))
  amstel = tur.getFluidFlowRate()
  gpu.set(19,33, string.format("%10d", speed))
  gpu.set(64,32, string.format("%10d", eng23))
   if block == 2 then 
    speedlimit()
	gpu.set(13,6, "         ")
   elseif block == 2 then
    tur.setFluidFlowRateMax(steam)
    gpu.set(13,6, string.format("%10d",steam))
   end
   if block2 == 2 then 
    englimit()
   end
end

local function work(h,m)
  gpu.set(h,m,"            ")
gpu.set(h,m+1,"  ВКЛЮЧИТЬ  ")
gpu.set(h,m+2,"            ")
end

local function nwork(h,m)
  gpu.set(h,m,"            ")
gpu.set(h,m+1," ВЫКЛЮЧИТЬ  ")
gpu.set(h,m+2,"            ")
end

local function POWER()
     local ON = br.getActive()
        if ON == true then
          setColor(0x00FF00,0x000000)
          work(87,2)
          setColor(0x000000,0xFF0000)
          nwork(87,6)
          setColor(0x000000,0xFFFFFF)
        elseif ON == false then
          setColor(0x000000,0x00FF00)
          work(87,2)
          setColor(0xFF0000,0xFFFFFF)
          nwork(87,6)
          setColor(0x000000,0xFFFFFF)
      end

end

local function INGUCKTOR()
     local ONLINE = br.getInductorEngaged()
        if ONLINE == true then
          setColor(0x00FF00,0x000000)
          work(55,2)
          setColor(0x000000,0xFF0000)
          nwork(55,6)
          setColor(0x000000,0xFFFFFF)
        elseif ONLINE == false then
          setColor(0x000000,0x00FF00)
          work(55,2)
          setColor(0xFF0000,0xFFFFFF)
          nwork(55,6)
          setColor(0x000000,0xFFFFFF)
      end

end

local function SPEEDINDICATOR()
        if block == 2 then
          setColor(0x00FF00,0x000000)
          work(33,28)
          setColor(0x000000,0xFF0000)
          nwork(3,28)
          setColor(0x000000,0xFFFFFF)
        elseif block == 1 then
          setColor(0x000000,0x00FF00)
          work(33,28)
          setColor(0xFF0000,0xFFFFFF)
          nwork(3,28)
          setColor(0x000000,0xFFFFFF)
      end
end

local function ENGINDICATOR()
        if block2 == 2 then
          setColor(0x00FF00,0x000000)
          work(78,28)
          setColor(0x000000,0xFF0000)
          nwork(48,28)
          setColor(0x000000,0xFFFFFF)
        elseif block2 == 1 then
          setColor(0x000000,0x00FF00)
          work(78,28)
          setColor(0xFF0000,0xFFFFFF)
          nwork(48,28)
          setColor(0x000000,0xFFFFFF)
      end
end

term.clear()
 gpu.set(1,1,"╔══════════════════════════════════╦════════════════╦══════════════╦════════════════╦══════════════╗")
 gpu.set(1,2,"║                                  ║                ║ ████████████ ║                ║ ████████████ ║")
 gpu.set(1,3,"║                                  ║                ║ █ ВКЛЮЧИТЬ █ ║                ║ █ ВКЛЮЧИТЬ █ ║")
 gpu.set(1,4,"║                                  ║ УПРАВЛЕНИЕ     ║ ████████████ ║ УПРАВЛЕНИЕ     ║ ████████████ ║")
 gpu.set(1,5,"║                                  ║             -->╠══════════════╣             -->╠══════════════╣")
 gpu.set(1,6,"║                                  ║ КАТУШКАМИ      ║ ████████████ ║  ТУРБИНОЙ      ║ ████████████ ║")
 gpu.set(1,7,"║                                  ║                ║ █ВЫКЛЮЧИТЬ █ ║                ║ █ВЫКЛЮЧИТЬ █ ║")
 gpu.set(1,8,"║                                  ║                ║ ████████████ ║                ║ ████████████ ║")
 gpu.set(1,9,"╠══════════════════════════════════╩════════════════╩══════════════╩════════════════╩══════════════╣")
gpu.set(1,10,"║                                                                                                  ║")
gpu.set(1,11,"║                                                                                                  ║")
gpu.set(1,12,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,13,"║                                                                                                  ║")
gpu.set(1,14,"║                                                                                                  ║")
gpu.set(1,15,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,16,"║                                                                                                  ║")
gpu.set(1,17,"║                                                                                                  ║")
gpu.set(1,18,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,19,"║                                                                                                  ║")
gpu.set(1,20,"║                                                                                                  ║")
gpu.set(1,21,"╠══════════════════════════════════════════════════════════════════════════════════════════════════╣")
gpu.set(1,22,"║                                                                                                  ║")
gpu.set(1,23,"║                                                                                                  ║")
gpu.set(1,24,"╠════════════════════════════════════════════╦════════════════════════════════════════════╦════════╣")
gpu.set(1,25,"║ АВТОМАТИЧЕСКОЕ УПРАВЛЕНИЕ СКОРОСТЬЮ ТУРБИНЫ║ АВТОМАТИЧЕСКОЕ УПРАВЛЕНИЕ ЭНЕРГИЕЙ В       ║        ║")
gpu.set(1,26,"║ (УПРАВЛЕНИЕ ПОДАЧЕЙ ПАРА ОТКЛЮЧИТСЯ)       ║ БАТАРЕИ                                    ║        ║")
gpu.set(1,27,"╠══════════════╦══════════════╦══════════════╣══════════════╦══════════════╦══════════════╣        ║")  
gpu.set(1,28,"║ ████████████ ║              ║ ████████████ ║ ████████████ ║              ║ ████████████ ║        ║")
gpu.set(1,29,"║ █ ВКЛЮЧИТЬ █ ║              ║ █ВЫКЛЮЧИТЬ █ ║ █ ВКЛЮЧИТЬ █ ║              ║ █ВЫКЛЮЧИТЬ █ ║        ║")
gpu.set(1,30,"║ ████████████ ║              ║ ████████████ ║ ████████████ ║              ║ ████████████ ║        ║")
gpu.set(1,31,"╠══════════════╝              ╚══════════════╠══════════════╝              ╚══════════════╣        ║")
gpu.set(1,32,"║    +1000     |              |     -1000    ║    +100000   |              |     -100000  ║        ║")
gpu.set(1,33,"║    +100      |              |     -100     ║    +10000    |              |     -10000   ║        ║")
gpu.set(1,34,"║    +10       |              |     -10      ║    +1000     |              |     -1000    ║        ║")
gpu.set(1,35,"║    +1        |              |     -1       ║    +100      |              |     -100     ║        ║")
gpu.set(1,36,"╠════════════════════════════════════════════╩════════════════════════════════════════════╩════════╣")
gpu.set(1,37,"║ КОЛИЧЕСТВА ВЫРАБАТЫВАЕМОЙ ЭНЕРГИИ ЗА ПРОМЕЖУТОК ВЕМЕНИ                                           ║")
gpu.set(1,38,"╠═════════════════════╦═══════════════════════╦════════════════════════╦═══════════════════════════╣")
gpu.set(1,39,"║ REDSTONEFLUX/TICK   ║ REDSTONEFLUX/SECOND   ║ REDSTONEFLUX/MINUTS    ║ REDSTONEFLUX/HOURSE       ║")
gpu.set(1,40,"║                     ║                       ║                        ║                           ║")
gpu.set(1,41,"║ RF/T                ║ RF/SEC                ║ RF/M                   ║ RF/H                      ║")
gpu.set(1,42,"║                     ║                       ║                        ║                           ║")
gpu.set(1,43,"║                     ║                       ║                        ║                           ║")
gpu.set(1,44,"╠═════════════════════╩═══════════════════════╩════════════════════════╩═══════════════════════════╣")
gpu.set(1,45,"║                                                                                                  ║")
gpu.set(1,46,"║                                                                                                  ║")
gpu.set(1,47,"║                                                                                                  ║")
gpu.set(1,48,"║                                                                                                  ║")
gpu.set(1,49,"║                                                                                                  ║")
gpu.set(1,50,"╚══════════════════════════════════════════════════════════════════════════════════════════════════╝")

POWER()
INGUCKTOR()
SPEEDINDICATOR()
ENGINDICATOR()

local function onTouch(event,adress,x,y,clic,pseudo)
if x==1 and y==1 then
      computer.pushSignal("quit")
      term.setCursor(1,1)
      return false
	 elseif x > 85 and x < 100 and y > 1 and y < 5 then
	  br.setActive(true)
	  POWER()
	 elseif x > 85 and x < 100 and y > 5 and y < 9 then
	  br.setActive(false)
	  POWER()
	 elseif x > 54 and x < 67 and y > 1 and y < 5 then
	  br.setInductorEngaged(true)
	  INGUCKTOR()
	 elseif x > 54 and x < 67 and y > 5 and y < 9 then
	  br.setInductorEngaged(false)
	  INGUCKTOR()
	 elseif x > 2 and x < 15 and y > 28 and y < 30 then
	   block = 1
	   SPEEDINDICATOR()
	 elseif x > 32 and x < 45 and y > 28 and y < 30 then
	   block = 2
	   SPEEDINDICATOR()
	  elseif x > 47 and x < 60 and y > 28 and y < 30 then
	   block2 = 1
	   ENGINDICATOR()
	    br.setInductorEngaged(false)
	  INGUCKTOR()
	 elseif x > 77 and x < 90 and y > 28 and y < 30 then
	   block2 = 2
	   ENGINDICATOR()
	    br.setInductorEngaged(false)
	  INGUCKTOR()
	  elseif x > 50 and x < 57 and y == 32 then                       -- скорость +1000
	  if eng23 >= 900000 then
	   eng23 = 1000000
	  else
       eng23 = eng23 + 100000
	  end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 50 and x < 57 and y == 33 then                       -- скорость +100
      if eng23 >= 990000 then
	   eng23 = 1000000
	  else
       eng23 = eng + 10000
	  end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 50 and x < 57 and y == 34 then                       -- скорость +10
      if eng23 >= 999000 then
	   eng23 = 1000000
	  else
       eng23 = eng23 + 1000
	  end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 50 and x < 57 and y == 35 then                       -- скорость +1
      if eng23 >= 999900 then
	   eng23 = 1000000
	  else
       eng23 = eng23 + 100
	  end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 80 and x < 87 and y == 32 then                       -- скорость -1000
	  if eng23 <= 100000 then
         eng23 = 0
      else
         eng23 = eng23 - 100000	  
      end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 80 and x < 87 and y == 33 then                       -- скорость -100
	  if eng23 <= 10000 then
         eng23 = 0
      else
         eng23 = eng23 - 10000	  
      end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 80 and x < 87 and y == 34 then                       -- скорость -10
	  if eng23 <= 1000 then
         eng23 = 0
      else
         eng23 = eng23 - 1000  
      end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 80 and x < 87 and y == 35 then                       -- скорость -1
	  if eng23 <= 100 then
         eng23 = 0
      else
         eng23 = eng23 - 100  
      end
	  gpu.set(64,32, string.format("%10d", eng23))
	 elseif x > 2 and x < 15 and y == 32 then                       -- скорость +1000
	  if speed >= 2000 then
	   speed = 3000
	  else
       speed = speed + 1000
	  end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 2 and x < 15 and y == 33 then                       -- скорость +100
      if speed >= 2900 then
	   speed = 3000
	  else
       speed = speed + 100
	  end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 2 and x < 15 and y == 34 then                       -- скорость +10
      if speed >= 2990 then
	   speed = 3000
	  else
       speed = speed + 10
	  end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 2 and x < 15 and y == 35 then                       -- скорость +1
      if speed >= 2999 then
	   speed = 3000
	  else
       speed = speed + 1
	  end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 31 and x < 44 and y == 32 then                       -- скорость -1000
	  if speed <= 1000 then
         speed = 0
      else
         speed = speed - 1000	  
      end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 31 and x < 44 and y == 33 then                       -- скорость -100
	  if speed <= 100 then
         speed = 0
      else
         speed = speed - 100	  
      end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 31 and x < 44 and y == 34 then                       -- скорость -10
	  if speed <= 10 then
         speed = 0
      else
         speed = speed - 10	  
      end
	  gpu.set(19,33, string.format("%10d", speed))
	 elseif x > 31 and x < 44 and y == 35 then                       -- скорость -1
	  if speed <= 1 then
         speed = 0
      else
         speed = speed - 1	  
      end
	  gpu.set(19,33, string.format("%10d", speed))
end
end

local function onTimer(_,timer)
  drawbars()
  return true
end

event.listen("touch",onTouch)
local timer = event.timer(0,onTimer,math.huge)
event.pull("quit")
event.cancel(timer)
event.ignore("touch",onTouch)
component.gpu.setResolution(100,50)
term.clear()