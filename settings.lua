-- SIO II Clock Widget: Horizon, Version 1.2.0
local settings
local function getIndex(list, target)
	for i = 1, #list do
		if list[i] == target then
			return i
		end
	end
end

local lineStyles = {"Green(Default)[zh]绿色(默认)", "Orange[zh]橙色", "Grey[zh]灰色", "Lavender[zh]淡紫色"}

function script:init()
    settings = Util.optStorage(TheoTown.getStorage(), self:getDraft():getId()..':settings')
    settings.note = TheoTown.translateInline("Changes will be applied after reentering a city.[zh]设置将会在重进城市后生效")
    settings.lineStyle = settings.lineStyle or "Green(Default)"
    
    if settings.alwaysShowRealTime == nil then
        settings.alwaysShowRealTime = false
    else
        settings.alwaysShowRealTime = settings.alwaysShowRealTime
    end
    if settings.showDate == nil then
        settings.showDate = false
    else
        settings.showDate = settings.showDate
    end
     if settings.showSeconds == nil then
        settings.showSeconds = false
    else
        settings.showSeconds = settings.showSeconds
    end
    -- Address the translation
    for i = 1, #lineStyles do
        lineStyles[i] = TheoTown.translateInline(lineStyles[i])
    end
end

function script:settings()
    return {
        {
            name = TheoTown.translateInline("Note[zh]提示"),
            value = settings.note,
            values = {TheoTown.translateInline("Changes will be applied after reentering a city.[zh]设置将会在重进城市后生效")},
            onChange = function(newState) 
	            settings.note = newState
	        end
        },
        {
            name = TheoTown.translateInline("Line Style[zh]进度条样式"),
            value = settings.lineStyle,
            values = lineStyles,
            onChange = function(newState) 
	            settings.lineStyle = newState      
	            local condition = getIndex(lineStyles, newState)
	            TheoTown.setGlobalFunVar("!Sio2GlobalLineStyle", condition)
	        end
        },
        {
            name = TheoTown.translateInline("Always show the real time(SRT)[zh]显示现实时间"),
            value = settings.alwaysShowRealTime,
            onChange = function(newState) 
                settings.alwaysShowRealTime = newState 
                local condition = newState and 1 or 0
                TheoTown.setGlobalFunVar("!Sio2GlobalAlwaysRealTime", condition)
            end
        },
        {
            name = TheoTown.translateInline("Show seconds(Requires SRT is enable)[zh]显示秒数(需要启用显示现实时间)"),
            value = settings.showSeconds,
            onChange = function(newState) 
                settings.showSeconds = newState 
                local condition = newState and 1 or 0
                TheoTown.setGlobalFunVar("!Sio2GlobalShowSeconds", condition)
            end
        },
        {
            name = TheoTown.translateInline("Show the date[zh]显示日期"),
            value = settings.showDate,
            onChange = function(newState) 
                settings.showDate = newState 
                local condition = newState and 1 or 0
                TheoTown.setGlobalFunVar("!Sio2GlobalShowDate", condition)
            end
        }
    }
end