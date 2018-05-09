--[[
//      MADE BY...: Plazter
//      Date......: 29. April 2017
//		Edited....: 18 April 2018
//      Mod:......: OpenComputers
//    Credit to.: Brain_Corbec for color table ( Note u can allways add more colors (hex code))
//      Note: This program contains a debug tool, thats intented for you to use
//            to figure out where to get your clicks, incase a button or something
//            is not working correctly. if you use this program, i hope you will
//            Enjoy it.
--]]
------------------------------------------------------------------------------------------------------------------
                                                 --[[ WRAPPINGS ]]--
------------------------------------------------------------------------------------------------------------------
component = require("component")
--reactor = component.draconic_reactor
--FluxGateOutput = component.proxy(component.get("7a7511a5-e91d-40cf-ae46-ee387377ae71")) -- Output Flux gate
--FluxGateShield = component.proxy(component.get("86ff77aa-b209-4e95-8b3e-cd33e21289a8")) -- Input flux gate
term = require("term")
gpu = component.gpu
event = require("event")
keyboard = require("keyboard")
screen = component.screen
------------------------------------------------------------------------------------------------------------------
                                                 --[[  TABLES  ]]--
------------------------------------------------------------------------------------------------------------------

args = {...}

colors = { black = 0x000000, white = 0xf8f8ff, blue = 0x0000ff, lightGray = 0xd9d9d9, red = 0xff0000,
purple = 0x9b30ff, carrot = 0xffa500, magenta = 0xcd00cd, lightBlue = 0x87cefa, yellow = 0xffff00,
lime = 0x32cd32, pink = 0xffc0cb, gray = 0x696969, brown = 0x8b4500, green = 0x006400, cyan = 0x008b8b,
olive = 0x6b8e23, gold = 0x8b6914, orangered = 0xdb4e02, diamond = 0x0fa7c7,crimson = 0xaf002a,fuchsia = 0xfd3f92,
folly = 0xff004f, frenchBlue = 0x0072bb, lilac = 0x86608e, flax = 0xeedc82, darkGray = 0x563c5c,
englishGreen = 0x1b4d3e, eggplant = 0x614051, deepPink  = 0xff1493, ruby = 0x843f5b, orange = 0xf5c71a,
lemon = 0xffd300, darkBlue = 0x002e63, bitterLime = 0xbfff00 }
------------------------------------------------------------------------------------------------------------------
                                                 --[[ VARIABLES ]]--
------------------------------------------------------------------------------------------------------------------
Border_bg = colors.white
Default_bg = colors.gray
text_col = colors.white
status_col = colors.black
failsafe = true
failSafeTemp = 6400
auto = failSafeTemp
startt = nil
------------------------------------------------------------------------------------------------------------------
                                                 --[[ FUNCTIONS ]]--
------------------------------------------------------------------------------------------------------------------
function guiBorders(x,y,len,height,str) -- BORDER FUNC FOR GUI
  gpu.setBackground(Border_bg)
  gpu.fill(x,y,len,height,str)
  gpu.setBackground(Default_bg)
end
 
function GUI() -- SETS THE GUI LAYOUT (GRAPHICAL USER INTERFACE)
  gpu.setBackground(Default_bg)
  term.clear()
  w,  h = gpu.getResolution()
  guiBorders(1,1,w,1," ")
    for i = 1,h do
      --guiBorders(1,i,1,1," ")
      --guiBorders(w,i,1,1," ")
    end
  guiBorders(1,h,w,1," ")
  gpu.setForeground(text_col)
end

function Center(y,text) -- CENTERS TEXT   
  w, h = gpu.getResolution()
  term.setCursor((w-string.len(text))/2+1, y)
  term.write(text)
end

function info(title,x,y) -- Rewriting of gpu.set
  gpu.set(x,y,title)
end

function InfoUpdate(y, text) -- Text for function UPDATE
  w, h = gpu.getResolution()
      place = (w-string.len(text))-2
    gpu.set(place, y, text)
end

function display() -- Text to load onto screen on launch
  -- TITLE
  Center(2, "{{  Draconic Reactor  }}")
  -- Info Title
  info("Temperature.....................................:",2,4)
  info("Shield..........................................:",2,6)
  info("Generation Rate.................................:", 2,8)
  info("RF Output.......................................:", 2, 10)
  info("RF Net gain.....................................:", 2,12)
  info("Energy Saturation...............................:", 2, 14)
  info("Fuel Conversion Rate............................:", 2,16)
  -- Button Panel
  Center(18, "Set Output")
  Center(19, "<<< << < = > >> >>>")
  Center(21, "Set State")
  Center(22, "Charge - Online - Offline")
  gpu.set(2,21,"Toggle Auto")
  gpu.set(2,22,"On - Off")
end

function com(n) -- credit http://richard.warburton.it
  local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function UPDATE() -- The Information we want to keep update
  --if reactorInfo.
  InfoUpdate(5, "  "..string.format("%.2f",tostring(temperature)).." C") -- Temperature
  InfoUpdate(7,"  "..string.format("%2.f",perc*100).." %   ") -- Shield %
  InfoUpdate(9,"  "..com(tostring(gen)).." RF/T") -- Generating
  InfoUpdate(11, "  "..com(tostring(666)).." RF/T") -- What the Current output is set to.
  InfoUpdate(13,"  ".. com(tostring( gen  - 999)).." RF/T") -- The total gain in rf
  if 0 > 0 then
  --InfoUpdate(15, "  "..string.format("%.3f",tostring(reactorInfo.energySaturation / reactorInfo.maxEnergySaturation * 100)).." %   ") -- The     
  end  
--energy Saturation
  InfoUpdate(17, tostring(22).." nB/T")  -- Fuel use
    --if temperature >= 6000 then
      --startt = true
      --gpu.set(2,19,"Auto On")
    --end
end



function getPress(line) -- Reads where we press, and set it as we wishes it
  if x ~= nil and y ~= nil then
    if x >= 32 and x <= 37 and y == 22 then -- Online
      --reactor.activateReactor()
      gpu.setBackground(colors.green)
      gpu.set(32,22, "Online")
      gpu.setBackground(Default_bg)
      gpu.set(23,22, "Charge")
      gpu.set(41,22,"Offline")
    elseif x >= 23 and x <= 28 and y == 22 then -- Charge
      --reactor.chargeReactor()
      gpu.setBackground(colors.blue)
      gpu.set(23,22, "Charge")
      gpu.setBackground(Default_bg)
      gpu.set(32,22, "Online")
      gpu.set(41,22, "Offline")
    elseif x >= 41 and x <= 47 and y == 22 then --Ofline
      --reactor.stopReactor()
      gpu.setBackground(colors.red)
      gpu.set(41,22, "Offline")
      gpu.setBackground(Default_bg)
      gpu.set(23,22, "Charge")
      gpu.set(32,22,"Online")
    end

    if x >= 23 and x <= 29 and y == line then -- <<<
      --FluxGateOutput.setFlowOverride(currOut - 10000)
    elseif x >= 30 and x <= 32 and y == line then -- <<
      --FluxGateOutput.setFlowOverride(currOut - 1000)
    elseif x >= 33 and x <= 34 and y == line then -- <
      --FluxGateOutput.setFlowOverride(currOut - 100)
    end

    if x >= 36 and x <= 37 and y == line then -- >
      --FluxGateOutput.setFlowOverride(currOut + 100)
    elseif x >= 38 and x <= 41 and y == line then -- >>
      --FluxGateOutput.setFlowOverride(currOut + 1000)
    elseif x >= 42 and x <= 46 and y == line then -- >>>
      --FluxGateOutput.setFlowOverride(currOut + 10000)
    end 
  end
end

function tog()
  if x ~= nil and y ~= nil then     
    if x >= 2 and x <= 3  and y == 22 then
        startt = true
        gpu.setBackground(Default_bg)
        gpu.set(7,22,"Off")
        gpu.setBackground(colors.green)
        gpu.set(2,22,"On")
        gpu.setBackground(Default_bg)
     elseif x >= 6 and x <= 8 and y == 22 then
        startt = false
        gpu.setBackground(colors.red)
        gpu.set(7,22,"Off")
        gpu.setBackground(Default_bg)
        gpu.set(2,22,"On")
    end -- if x >=
  end -- If x ~=
end -- Function


function FailSafe()
  if failsafe then
    if temperature > failSafeTemp then
          --reactor.stopReactor()
          gpu.setBackground(colors.red)
          gpu.set(41,22, "Offline")
          gpu.setBackground(Default_bg)
          gpu.set(23,22, "Charge")
          gpu.set(32,22,"Online")
          gpu.setBackground(colors.red)
          Center(11,"FAIL SAFE MODE!")
          gpu.setBackground(Default_bg)
          fail = true
          startt = false
        --  failCount = failCount + 1
    elseif fail and temperature < 5800 then
          --reactor.activateReactor()
          gpu.setBackground(colors.lime)
          gpu.set(32,22, "Online")
          gpu.setBackground(Default_bg)
          gpu.set(41,22,"Offline")
          gpu.set(23,22,"Charge")
          Center(11,"               ")
          fail = false
            if failCount == 50 then
              failCount = 0
            end
    end
  end
end

-- TESTING 
function autoo() -- THIS FUNCTION NEEDS TO BE UPDATED FOR SAFE STARTUP
  if startt == true then
   if math.floor((400/900*100)) >= 25 and math.floor((55 / 77 * 100)) <= 50 and  temperature <= 6000 then
      --FluxGateOutput.setFlowOverride(FluxGateOutput.getFlow()+150)
   end
  elseif startt == false then
    --
  end
end
------------------------------------------------------------------------------------------------------------------
                                              --[[ PROGRAM INITATION ]]--
------------------------------------------------------------------------------------------------------------------

gpu.setResolution(70,23)
--FluxGateShield.setOverrideEnabled(true)
--FluxGateShield.setFlowOverride(230000)
--FluxGateOutput.setOverrideEnabled(true)
--if FluxGateOutput.getFlow() >= 430000 then
	--
--	else
--	FluxGateOutput.setFlowOverride(430000)
--end

screen.setTouchModeInverted(true)
GUI() -- Loads screen layout
display() -- Loads Text Layout
------------------------------------------------------------------------------------------------------------------
                                                 --[[ MAIN LOOP ]]--
------------------------------------------------------------------------------------------------------------------

while true do
    --UPDATING VARS THAT NEEDS TO BE HERE --
    --reactorInfo = reactor.getReactorInfo()  
    target = 0.30
    currShield = 228 --reactorInfo.fieldStrength
    maxShield = 777 -- reactorInfo.maxFieldStrength
    perc = (currShield/maxShield)
    shieldDrain = 123 --reactorInfo.fieldDrainRate
    shieldStr = 555--reactorInfo.fieldStrength
    temperature = 450--reactorInfo.temperature
    currOut = 111--FluxGateOutput.getFlow()
    gen = 122--reactorInfo.generationRate
    -- FUNCTIONS TO KEEP LOOKING UP --    
    UPDATE()
    getPress(19)
    FailSafe()
    autoo()
    --tog()
    -- EVENT LISTENER 
    _,_,x,y = event.pull(1, "touch")    
      tog()
      -- DEBUG TOOL
      if args[1] == "debug" then
        if x ~= nil and y~= nil then
          Center(16,"X: ".. x .." Y: "..y)
        end
      elseif args[1] == "test" then
        startt = true
      end
      -- TERMINATE PROGRAM AND RESTORE RESOLUTION
      if keyboard.isKeyDown(keyboard.keys.w) and keyboard.isControlDown() then
          term.clear()
          w,h = gpu.maxResolution()
          gpu.setResolution(w,h)
		  screen.setTouchModeInverted(false)
          os.exit()
    end

end