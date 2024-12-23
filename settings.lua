-- SIO II Clock Widget: Horizon, Version 1.0.0
local settings
local function getIndex(list, target)
	for i = 1, #list do
		if list[i] == target then
			return i
		end
	end
end
local clockStyles = {"Horizon"}
local lineStyles = {"Green(Default)", "Orange", "Grey", "Lavender"}

function script:init()
    settings = Util.optStorage(TheoTown.getStorage(), self:getDraft():getId()..':settings')
    settings.enegrySaving = settings.enegrySaving == nil and false or settings.enegrySaving
    settings.note = settings.clockStyle or "Changes will be applied after reentering a city."
    settings.clockStyle = settings.clockStyle or "Horizon"
    settings.lineStyle = settings.lineStyle or "Green(Default)"
end

function script:settings()
    return {
        {
            name = "Note",
            value = settings.note,
            values = {"Changes will be applied after reentering a city."},
            onChange = function(newState) 
	            settings.note = newState
	        end
        },
        {
            name = "Clock Style",
            value = settings.clockStyle,
            values = clockStyles,
            onChange = function(newState) 
	            settings.clockStyle = newState      
	            condition = getIndex(clockStyles, newState)
	            TheoTown.setGlobalFunVar("!Sio2GlobalClockStyle", condition)
	        end
        },
        {
            name = "Line Style",
            value = settings.lineStyle,
            values = lineStyles,
            onChange = function(newState) 
	            settings.lineStyle = newState      
	            condition = getIndex(lineStyles, newState)
	            TheoTown.setGlobalFunVar("!Sio2GlobalLineStyle", condition)
	        end
        }
    }
end