-- SIO II Clock Widget: Horizon, Version 1.0.0(Beta)
local sunIcon, moonIcon, smallSunIcon, smallMoonIcon, icon, clockTime, xLength, yLength, xCenter
local timeNow = {h = 12, m = 20}
local yBegin, xBegin, xPlus = 25, 30, 100
local clockStyle = TheoTown.getGlobalFunVar("!Sio2GlobalClockStyle", 1)
local lineStyle = TheoTown.getGlobalFunVar("!Sio2GlobalLineStyle", 1)
local lineColor = {{12, 200, 38}, {255, 155, 0}, {175, 175, 175}, {120, 130, 220}}

local function drawLine(xBegin)
    Drawing.setColor(255, 255, 255)
    Drawing.drawLine(xBegin, yBegin + 16, xBegin+xPlus, yBegin + 16)
    Drawing.setColor(lineColor[lineStyle][1], lineColor[lineStyle][2], lineColor[lineStyle][3])
    Drawing.drawLine(xBegin, yBegin + 16, xBegin+(xPlus*Drawing.getDaytime()), yBegin + 16)
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
        Drawing.drawImage(smallSunIcon, xBegin + Drawing.getDaytime()*xPlus, sunY)
    else
        Drawing.drawImage(smallMoonIcon, xBegin + Drawing.getDaytime()*xPlus, moonY)
    end
end

local function showHorizonClock()
    if clockStyle == 1 then
        drawLine(xBegin)
	    drawSunAndMoon(xBegin-5)
        
        -- Draw the text clock
        clockTime = tostring(string.format("%02d", timeNow.h)) .. ":" .. tostring(string.format("%02d", timeNow.m))
	    Drawing.setColor(0, 0, 0)
	    Drawing.drawText(clockTime, xBegin + xPlus+6, yBegin+7)
	    Drawing.setColor(255, 255, 255)
	    Drawing.drawText(clockTime, xBegin + xPlus+5, yBegin+6)
	end
end

function script:update()
	daytime = math.floor(Drawing.getDaytime() * 1440) -- Turn the daytime to minutes
	timeNow.h = math.floor(daytime / 60)
	timeNow.m = daytime - (timeNow.h * 60) -- Update the time
	xLength, yLength = Drawing.getSize()
    showHorizonClock()
    
    -- Update the settings
    clockStyle = TheoTown.getGlobalFunVar("!Sio2GlobalClockStyle", 1)
    lineStyle = TheoTown.getGlobalFunVar("!Sio2GlobalLineStyle", 1)
end

function script:init()
    smallSunIcon = Draft.getDraft("$sio2_dnswodn48_clock_IconSmallSun00"):getFrame(1)
    smallMoonIcon = Draft.getDraft("$sio2_dnswodn48_clock_IconSmallMoon00"):getFrame(1)
end