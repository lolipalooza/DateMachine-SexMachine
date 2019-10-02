local module = {}

--[[===============================================================
===================================================================]]
module.Timer = {}

module.Timer.set = function(miliseconds)
	module.Timer.current_time = getGameTimer()
	module.Timer.previous_time = getGameTimer() - miliseconds
end

module.Timer.run = function()
	module.Timer.current_time = getGameTimer()
end

module.Timer.get = function()
	module.Timer.run()
	local curr = module.Timer.current_time
	local prev = module.Timer.previous_time
	return curr - prev
end

--[[===============================================================
PulseButtonMachine
===================================================================]]
module.PulseButtonMachine = {}

module.PulseButtonMachine.stat = 0

module.PulseButtonMachine.states = {
	NOT_PULSED=0,			PULSED_UP=10,			PULSED_DOWN=20,
	PULSED_ENTER_VEH=30,	PULSED_SPRINT=40,		PULSED_UP_F=19,
	PULSED_DOWN_F=29,		PULSED_ENTER_VEH_F=39,	PULSED_SPRINT_F=49
}

module.PulseButtonMachine.init = function()
	module.PulseButtonMachine.stat = 0
end

module.PulseButtonMachine.run = function()
	local pad = require("lib.game.keys").player
	local stat = module.PulseButtonMachine.stat
	local states = module.PulseButtonMachine.states
	
	moveAxisX, moveAxisY, specialAxisX, specialAxisY = getPositionOfAnalogueSticks(0)

	if stat == states.NOT_PULSED then
		if moveAxisY > 100 -- UP
		then stat = states.PULSED_UP
		end
		if moveAxisY < -100 -- DOWN
		then stat = states.PULSED_DOWN
		end
		if isButtonPressed(playerchar, pad.SPRINT)
		then stat = states.PULSED_SPRINT
		end
		if isButtonPressed(playerchar, pad.ENTERVEHICLE)
		then stat = states.PULSED_ENTER_VEH
		end
	end
	
	if stat <= states.PULSED_UP_F and stat > states.PULSED_UP then
		if moveAxisY <= 100 -- UP
		then stat = states.NOT_PULSED
		end
	end
	
	if stat <= states.PULSED_DOWN_F and stat > states.PULSED_DOWN then
		if moveAxisY >= -100 -- DOWN
		then stat = states.NOT_PULSED
		end
	end
	
	if stat <= states.PULSED_SPRINT_F and stat > states.PULSED_SPRINT then
		if not isButtonPressed(playerchar, pad.SPRINT)
		then stat = states.NOT_PULSED
		end
	end

	if stat <= states.PULSED_ENTER_VEH_F and stat > states.PULSED_ENTER_VEH then
		if not isButtonPressed(playerchar, pad.ENTERVEHICLE)
		then stat = states.NOT_PULSED
		end
	end
	
	module.PulseButtonMachine.stat = stat
end

module.PulseButtonMachine.check = function(pulsedState)
	return module.PulseButtonMachine.stat == pulsedState
end

module.PulseButtonMachine.increaseStat = function()
	module.PulseButtonMachine.stat = module.PulseButtonMachine.stat + 1
end

module.PulseButtonMachine.control = function ()
	local states = module.PulseButtonMachine.states
	
	if module.PulseButtonMachine.check(states.PULSED_UP)
	or module.PulseButtonMachine.check(states.PULSED_DOWN)
	or module.PulseButtonMachine.check(states.PULSED_SPRINT)
	or module.PulseButtonMachine.check(states.PULSED_ENTER_VEH) then
		module.PulseButtonMachine.increaseStat()
	end
end

--[[===============================================================
===================================================================]]
local VMIN = require("lib.sex-machine.utils").INT32_MIN
local VMAX = require("lib.sex-machine.utils").INT32_MAX

local IncreaseTimedVar = function (var, amount, stat, msecs, percentage_flag, last_event_time, current_event_time)
	if stat == 0 then
		last_event_time = getGameTimer() + msecs
		stat = 1
	elseif stat == 1 then
		current_event_time = getGameTimer()
		if current_event_time >= last_event_time then
			if percentage_flag then		var = require("lib.sex-machine.utils").Inc(var, amount, 1, 100, false)
			else						var = require("lib.sex-machine.utils").Inc(var, amount, VMIN, VMAX, false)
			end
			stat = 0
		end
	end
	return var, stat, last_event_time, current_event_time
end

--[[===============================================================
Pleasure Machine
===================================================================]]
module.pleasure = {}

module.pleasure.stat = 0
module.pleasure.value = 0

module.pleasure.last_event_time = 0
module.pleasure.current_event_time = 0

module.pleasure.machine = function ()
	local gain = math.random(1,4)
	local val, stat, last, current = module.pleasure.value, module.pleasure.stat, module.pleasure.last_event_time, module.pleasure.current_event_time
	val, stat, last, current = IncreaseTimedVar(val, gain, stat, 800, false, last, current)
	module.pleasure.value, module.pleasure.stat, module.pleasure.last_event_time, module.pleasure.current_event_time = val, stat, last, current
end

--[[===============================================================
Climax Machine
===================================================================]]
--[[
	Speed: min: 13 - max: 100
	steps: 0.3 - min: 1 - max: 250
	steps: 0.4 - min: 1 - max: 500
	Ecuacion de la recta: Time (ms) = -5,7356321839080459770114942528736 * Speed + 574,56321839080459770114942528736
]]
module.climax = {}

module.climax.stat = 0
module.climax.value = 0

module.climax.last_event_time = 0
module.climax.current_event_time = 0

module.climax.machine = function (speed_val)
	local time_ms, gain
	if speed_val > 13 then
		time_ms = math.floor( -5.735 * speed_val + 574.563 )
		gain = 0.4
	else
		time_ms = 100
		gain = -0.4
	end
	local val, stat, last, current = module.climax.value, module.climax.stat, module.climax.last_event_time, module.climax.current_event_time
	val, stat, last, current = IncreaseTimedVar(val, gain, stat, time_ms, true, last, current)
	module.climax.value, module.climax.stat, module.climax.last_event_time, module.climax.current_event_time = val, stat, last, current
end

--[[===============================================================
Speed Machine
===================================================================]]
module.speed = {}

module.speed.stat = 0
module.speed.value = 0

module.speed.thresholds = {
	SPD_THRESHOLD1 = 13, -- Threshold to stop
	SPD_THRESHOLD2 = 52, -- Threshold to pass from slow to normal
	SPD_THRESHOLD3 = 88, -- Threshold to pass from normal to fast
}

module.speed.states = {
	SPD_IDLE   = 0,
	SPD_SLOW   = 1,
	SPD_NORMAL = 2,
	SPD_FAST   = 3,
}

module.speed.machine = function (female, male, pose, place)
	if doesCharExist(female) and doesCharExist(male) then
		local SPD_THRESHOLD1, SPD_THRESHOLD2, SPD_THRESHOLD3 = 13, 52, 88
		local states = module.speed.states
		local loadSexualPose = require("lib.sex-machine.actors-poses").LoadSexualPose
		
		local val, stat = module.speed.value, module.speed.stat
		if not(stat == states.SPD_FAST) then
			if val >= SPD_THRESHOLD3 then
				module.speed.stat = states.SPD_FAST
				loadSexualPose(female, male, pose, place, states.SPD_FAST)
			end
		end
		if not(stat == states.SPD_NORMAL) then
			if val < SPD_THRESHOLD3 and val >= SPD_THRESHOLD2 then
				module.speed.stat = states.SPD_NORMAL
				loadSexualPose(female, male, pose, place, states.SPD_NORMAL)
			end
		end
		if not(stat == states.SPD_SLOW) then
			if val < SPD_THRESHOLD2 and val >= SPD_THRESHOLD1 then
				module.speed.stat = states.SPD_SLOW
				loadSexualPose(female, male, pose, place, states.SPD_SLOW)
			end
		end
		if not(stat == states.SPD_IDLE) then
			if val < SPD_THRESHOLD1 then
				module.speed.stat = states.SPD_IDLE
				loadSexualPose(female, male, pose, place, states.SPD_IDLE)
			end
		end
	end
end

module.speed.control = function (menu_stat, fpv_edit_mode, fpv_moveable)
	local pad = require("lib.game.keys").player
	local Inc = require("lib.sex-machine.utils").Inc
	local Dec = require("lib.sex-machine.utils").Dec

	-- Increase / Decrease Speed (keyboard / mouse wheel)
	if menu_stat == 2 or (
		menu_stat == 8 -- state when the camera is free or when in edit mode
		and not fpv_edit_mode -- not in Edit Mode
	) then
		if		isButtonPressed(playerchar, pad.CYCLEWEAPONLEFT_SNIPERZOOMIN)	then	module.speed.value = Inc(module.speed.value, 4, 1, 100, false)
		elseif	isButtonPressed(playerchar, pad.CYCLEWEAPONRIGHT_SNIPERZOOMOUT)	then	module.speed.value = Dec(module.speed.value, 4, 1, 100, false)
		end
	end

	-- Increase / Decrease Speed (Clickable bar)
	if not fpv_moveable then -- not in Edit Mode (FPV/Fixed)
		if menu_stat == 2 -- Having sex
		or menu_stat == 3 -- Changing actors offsets
		or menu_stat == 6 -- Changing cameras offsets
		then module.speed.value = module.speed.GetSpeedStatFromBarClick(module.speed.value)
		end
	end
end

module.speed.GetSpeedStatFromBarClick = function (speed_val)
	local c = require("lib.sex-machine.cursor-control")
	if c.clickCheck(296.0, 436.0, 114.0, 12.0) then
		local clickX, clickY = c.getClickPosition()
		local xmax, xmin = 296.0 + 114.0/2.0, 296.0 - 114.0/2.0
		xmax = c.conversion(xmax, 0)
		xmin = c.conversion(xmin, 0)
		local percentage = math.floor( (clickX - xmin)*100.0/(xmax - xmin) )
		percentage = (percentage < 1) and 1 or percentage
		return percentage
	else return speed_val
	end
end -- speed_val: (Int) Min: 1 - Max 100

--[[===============================================================
===================================================================]]

return module