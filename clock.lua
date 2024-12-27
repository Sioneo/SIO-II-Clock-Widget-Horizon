-- SIO II Clock Widget: Horizon, Version 1.2.0
local smallSunIcon, smallMoonIcon, clockTime, daytime
local timeNow = {h = 12, m = 20}
local yBegin, xBegin, xPlus = 25, 30, 100 -- xPlus defines the length of the line
local lineStyle = TheoTown.getGlobalFunVar("!Sio2GlobalLineStyle", 1)
local lineColor = {{12, 200, 38}, {255, 155, 0}, {175, 175, 175}, {120, 130, 220}}
local whetherShowRealTime = TheoTown.getGlobalFunVar("!Sio2GlobalAlwaysRealTime", 0)
local whetherShowDate = TheoTown.getGlobalFunVar("!Sio2GlobalShowDate", 0)
local whetherShowSeconds = TheoTown.getGlobalFunVar("!Sio2GlobalShowSeconds", 0)

local function drawLine(xBegin)
    Drawing.setColor(255, 255, 255)
    Drawing.drawLine(xBegin, yBegin + 16, xBegin+xPlus, yBegin+16)
    Drawing.setColor(lineColor[lineStyle][1], lineColor[lineStyle][2], lineColor[lineStyle][3])
    Drawing.drawLine(xBegin, yBegin + 16, xBegin+(xPlus*daytime), yBegin+16)
end

local function drawSunAndMoon(xBegin)
    local x = timeNow.h*60 + timeNow.m -- Current time in minutes
    -- Calculate the y coordinate of the sun and moon
    local radian = (x/(24*60))*2*3.1415
    local cosY = 15*(math.cos(radian))
    local sunY = cosY + 9 + yBegin
    local sinY = 15*(math.sin(radian-3.1415*1.5))
    local moonY = (-sinY) + 9 + yBegin
    
    Drawing.setColor(255, 255, 255)
    -- If cosY <= 0 (Means it is day now), draw the sun, otherwise draw the moon 
    if cosY <= 0 then
        Drawing.drawImage(smallSunIcon, xBegin + daytime*xPlus, sunY)
    else
        Drawing.drawImage(smallMoonIcon, xBegin + daytime*xPlus, moonY)
    end
end

local function showDate(whetherShow)
    Drawing.setScale(0.85, 0.85)
    if whetherShow == 1 then
        local date = os.date("%Y/%m/%d")
        Drawing.setColor(0, 0, 0)
        Drawing.drawText(date, xBegin+1, yBegin+16)
        Drawing.setColor(255, 255, 255)
        Drawing.drawText(date, xBegin, yBegin+15)
        
        local day = os.date("%a.")
        Drawing.setColor(0, 0, 0)
        Drawing.drawText(day, xBegin+xPlus-18, yBegin+16)
        Drawing.setColor(255, 255, 255)
        Drawing.drawText(day, xBegin+xPlus-19, yBegin+15)
    end
    Drawing.setScale(1.0, 1.0)
end

local function showHorizonClock()
    drawLine(xBegin)
    showDate(whetherShowDate)
	drawSunAndMoon(xBegin-5)
    
    -- Draw the text clock
    clockTime = tostring(string.format("%02d", timeNow.h)) .. ":" .. tostring(string.format("%02d", timeNow.m))
    if whetherShowSeconds == 1 and whetherShowRealTime == 1 then
        local second = tostring(os.date("%S"))
        clockTime = clockTime .. ":" .. second
    end
	Drawing.setColor(0, 0, 0)
	Drawing.drawText(clockTime, xBegin + xPlus+6, yBegin+7)
	Drawing.setColor(255, 255, 255)
	Drawing.drawText(clockTime, xBegin + xPlus+5, yBegin+6)
end

function script:update()
    if whetherShowRealTime == 1 then
        timeNow.h = os.date("%H")
	    timeNow.m = os.date("%M") -- Update the time
	    daytime = (timeNow.h*60 + timeNow.m) / 1440
    else
    	daytime = Drawing.getDaytime()
	    local minutes = math.floor(daytime * 1440) -- Turn the daytime to minutes
	    timeNow.h = math.floor(minutes / 60)
	    timeNow.m = minutes - (timeNow.h * 60) -- Update the time
	end
    showHorizonClock()
end

function script:enterCity()
    -- Update the settings
    clockStyle = TheoTown.getGlobalFunVar("!Sio2GlobalClockStyle", 1)
    lineStyle = TheoTown.getGlobalFunVar("!Sio2GlobalLineStyle", 1)
    whetherShowRealTime = TheoTown.getGlobalFunVar("!Sio2GlobalAlwaysRealTime", 0)
    whetherShowDate = TheoTown.getGlobalFunVar("!Sio2GlobalShowDate", 0)
    whetherShowSeconds = TheoTown.getGlobalFunVar("!Sio2GlobalShowSeconds", 0)
end

function script:init()
    smallSunIcon = Draft.getDraft("$sio2_dnswodn48_clock_IconSmallSun00"):getFrame(1)
    smallMoonIcon = Draft.getDraft("$sio2_dnswodn48_clock_IconSmallMoon00"):getFrame(1)
end