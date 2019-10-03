--[[===============================================================
===================================================================]]
local module = {}

module.stat = 0

module.pose = 0
module.place = 0
module.slot = 0

--[[===============================================================
===================================================================]]
module.showSexualMenu = function(pose, place, generate_sex_files)
	local DrawText = require("lib.sex-machine.utils").DrawText

	-- Pink Box Title
	drawRect(199.0, 106.0, 347.0, 43.0, 255, 147, 251, 80)
	drawRect(206.0, 111.0, 346.0, 43.0, 255, 147, 251, 40)
	drawRect(201.0, 105.0, 323.0, 52.0, 255, 147, 251, 70)
	drawRect(202.0, 115.0, 355.0, 11.0, 255, 147, 251, 80)
	DrawText.set(0, 600.0, 66.0, 92.0, 0.6, 2.5, 'CFG_T7') -- Change position
	
	-- Black boxes options
	drawRect(318.0, 250.0, 592.0, 262.0, 0, 0, 0, 80)
	drawRect(318.0, 250.0, 607.0, 275.0, 0, 0, 0, 50)
	drawRect(326.0, 250.0, 593.0, 288.0, 0, 0, 0, 80)
	drawRect(596.0, 250.0, 51.0, 276.0, 0, 0, 0, 100)
	drawRect(300.0, 369.0, 541.0, 23.0, 0, 0, 0, 100)
	drawRect(318.0, 350.0, 607.0, 16.0, 255, 255, 255, 10)
	drawRect(149.0, 223.0, 222.0, 179.0, 0, 0, 0, 100)
	drawRect(438.0, 236.0, 333.0, 204.0, 0, 0, 0, 100)
	
	-- The "choose" pose button box
	drawRect(545.0, 420.0, 154.0, 30.0, 255, 147, 251, 60)
	drawRect(538.0, 414.0, 154.0, 30.0, 255, 147, 251, 50)
	drawRect(541.0, 416.0, 139.0, 48.0, 255, 147, 251, 60)
	drawRect(542.0, 422.0, 161.0, 6.0, 255, 147, 251, 100)
	DrawText.set(2, 640.0, 524.0, 409.0, 0.3, 1.5, 'S_OPT4') -- Change!
	DrawText.set(2, 600.0, 10.0, 430.0, 0.2, 1.2, 'S_OPT5') -- Cancel
	
	-- Places Submenu
	local place_gxt = function (id)
		return string.format("S_PL_%d",id)
	end
	
	local places_buttons = function(i)
		module.pose, module.place, module.slot = 1, i, 0
		local pose_gxt = require("lib.sex-machine.data").places[module.place][module.pose]
		local pose, bodytype = require("lib.sex-machine.data").GetPoseFromGXT(pose_gxt)
		local place = module.place
		if generate_sex_files then
			require("lib.sex-machine.utils").sexfiles.generate(pose, place, bodytype)
		end
		require("lib.sex-machine.save-load").data.Load(pose, place)
	end
	
	module.showButtons({
		{{  1, place_gxt( 1),  1, places_buttons, function() return  1 end },	{  2, place_gxt( 2),  2, places_buttons, function() return  2 end },		{  3, place_gxt( 3),  3, places_buttons, function() return  3 end }},
		{{  4, place_gxt( 4),  4, places_buttons, function() return  4 end },	{  5, place_gxt( 5),  5, places_buttons, function() return  5 end },		{  6, place_gxt( 6),  6, places_buttons, function() return  6 end }},
		{{  7, place_gxt( 7),  7, places_buttons, function() return  7 end },	{  8, place_gxt( 8),  8, places_buttons, function() return  8 end },		{  9, place_gxt( 9),  9, places_buttons, function() return  9 end }},
	}, 56.0, 152.0, 0.2, 1.2, 64.0, 38.0, nil, nil, 85.0, 159.0, 62.0, 36.0, nil, {r=0,g=0,b=160,a=120}, module.place)
	
	-- Poses Submenu
	local pose_gxt = function(i)
		local pose_gxt = require("lib.sex-machine.data").places[module.place][i]
		if not(pose_gxt=="") then	return pose_gxt
		else						return nil			end
	end
	
	local poses_buttons = function(i)
		module.pose, module.slot = i, 0
		pose_gxt = require("lib.sex-machine.data").places[module.place][module.pose]
		local pose, bodytype = require("lib.sex-machine.data").GetPoseFromGXT(pose_gxt)
		local place = module.place
		if generate_sex_files then
			require("lib.sex-machine.utils").sexfiles.generate(pose, place, bodytype)
		end
		require("lib.sex-machine.save-load").data.Load(pose, place)
	end
	local get_poses_buttons = function(i)
		local pose_gxt = require("lib.sex-machine.data").places[module.place][i]
		if not(pose_gxt == "") then		return poses_buttons
		else							return nil				end
	end
	
	module.showButtons({
		{{  1, pose_gxt( 1),  1, get_poses_buttons( 1), function() return  1 end },	{  2, pose_gxt( 2),  2, get_poses_buttons( 2), function() return  2 end },	{  3, pose_gxt( 3),  3, get_poses_buttons( 3), function() return  3 end },	{  4, pose_gxt( 4),  4, get_poses_buttons( 4), function() return  4 end },	{  5, pose_gxt( 5),  5, get_poses_buttons( 5), function() return  5 end }},
		{{  6, pose_gxt( 6),  6, get_poses_buttons( 6), function() return  6 end },	{  7, pose_gxt( 7),  7, get_poses_buttons( 7), function() return  7 end },	{  8, pose_gxt( 8),  8, get_poses_buttons( 8), function() return  8 end },	{  9, pose_gxt( 9),  9, get_poses_buttons( 9), function() return  9 end },	{ 10, pose_gxt(10), 10, get_poses_buttons(10), function() return 10 end }},
		{{ 11, pose_gxt(11), 11, get_poses_buttons(11), function() return 11 end },	{ 12, pose_gxt(12), 12, get_poses_buttons(12), function() return 12 end },	{ 13, pose_gxt(13), 13, get_poses_buttons(13), function() return 13 end },	{ 14, pose_gxt(14), 14, get_poses_buttons(14), function() return 14 end },	{ 15, pose_gxt(15), 15, get_poses_buttons(15), function() return 15 end }},
		{{ 16, pose_gxt(16), 16, get_poses_buttons(16), function() return 16 end },	{ 17, pose_gxt(17), 17, get_poses_buttons(17), function() return 17 end },	{ 18, pose_gxt(18), 18, get_poses_buttons(18), function() return 18 end },	{ 19, pose_gxt(19), 19, get_poses_buttons(19), function() return 19 end },	{ 20, pose_gxt(20), 20, get_poses_buttons(20), function() return 20 end }},
		{{ 21, pose_gxt(21), 21, get_poses_buttons(21), function() return 21 end },	{ 22, pose_gxt(22), 22, get_poses_buttons(22), function() return 22 end },	{ 23, pose_gxt(23), 23, get_poses_buttons(23), function() return 23 end },	{ 24, pose_gxt(24), 24, get_poses_buttons(24), function() return 24 end },	{ 25, pose_gxt(25), 25, get_poses_buttons(25), function() return 25 end }},
	}, 276.0, 152.0, 0.2, 1.2, 66.0, 38.0, nil, nil, 306.0, 159.0, 62.0, 36.0, nil, {r=0,g=0,b=160,a=120}, module.pose)
	
	-- Memory slots Submenu
	local at_least_one_data_found = false
	
	local slot_gxt = function(i)
		local data = require("lib.sex-machine.save-load").data
		if not(data[i].interior == "") then
			at_least_one_data_found = true
			return 'CFSV_4'
		else return nil
		end
	end
	
	local slot_buttons = function(i)
		module.slot = i
	end
	
	local get_slot_buttons = function(i)
		local data = require("lib.sex-machine.save-load").data
		if not(data[i].interior == "") then
			at_least_one_data_found = true
			return slot_buttons
		else return nil
		end
	end
	
	module.showButtons({
		{{  1, slot_gxt( 1),  1, get_slot_buttons( 1), function() return  1 end },	{  2, slot_gxt( 2),  2, get_slot_buttons( 2), function() return  2 end },	{  3, slot_gxt( 3),  3, get_slot_buttons( 3), function() return  3 end },	{  4, slot_gxt( 4),  4, get_slot_buttons( 4), function() return  4 end }},
		{{  5, slot_gxt( 5),  5, get_slot_buttons( 5), function() return  5 end },	{  6, slot_gxt( 6),  6, get_slot_buttons( 6), function() return  6 end },	{  7, slot_gxt( 7),  7, get_slot_buttons( 7), function() return  7 end },	{  8, slot_gxt( 8),  8, get_slot_buttons( 8), function() return  8 end }},
		{{  9, slot_gxt( 9),  9, get_slot_buttons( 9), function() return  9 end },	{ 10, slot_gxt(10), 10, get_slot_buttons(10), function() return 10 end },	{ 11, slot_gxt(11), 11, get_slot_buttons(11), function() return 11 end },	{ 12, slot_gxt(12), 12, get_slot_buttons(12), function() return 12 end }},
	}, 460.0, 33.0, 0.2, 1.2, 40.0, 28.0, nil, nil, 474.0, 39.0, 38.0, 26.0, nil, {r=0,g=0,b=160,a=120}, module.slot)
	
	if at_least_one_data_found then -- At least one data found?
		local DrawText = require("lib.sex-machine.utils").DrawText
		DrawText.set(2, 610.0, 460.0, 114.0, 0.2, 1.2, 'CFSV_8') -- Current Position
		drawRect(518.0, 67.0, 243.0, 134.0, 0, 0, 0, 120) -- Decoration bar
		if require("lib.sex-machine.cursor-control").clickCheck(500.0, 122.0, 90.0, 25.0) then
			module.slot = 0
		end
		if module.slot == 0 then
			drawRect(500.0, 122.0, 90.0, 25.0, 0, 0, 160, 120) -- highlight 'Current Position' button
		end
	end
	
	return module.pose, module.place
end
	
--[[===============================================================
===================================================================]]

--[[===============================================================
    Orgasm-o-meter bar                        Speed-o-meter bar
    min -> posX 170.5 sizeX 1.0               min -> posX 243.5 sizeX 1.0
    min+1 -> posX 171.0 sizeX 2.0             min+1 -> posX 244.0 sizeX 2.0
    min+2 -> posX 171.5 sizeX 3.0             min+2 -> posX 244.5 sizeX 3.0
    min+3 -> posX 172.0 sizeX 4.0             min+3 -> posX 245.0 sizeX 4.0
    100% -> posX 260.0 sizeX 180.0            100% -> posX 296.0 sizeX 106.0
===================================================================]]

--[[===============================================================
void showSexualStats(float climax, int speed, int pleasure)
===================================================================]]
module.showSexualStats = function(climax, speed, pleasure)
	local DrawText = require("lib.sex-machine.utils").DrawText
	
	local climaxBar = {}
	climaxBar.sizeX = 1.8 * climax
	climaxBar.posX = climaxBar.sizeX/2.0 + 170.0
	
	local speedBar = {}
	speedBar.sizeX = 1.06 * speed
	speedBar.posX = speedBar.sizeX/2.0 + 243.0
	
	-- Black styled climax bar
	--[[drawRect(260.0, 414.0, 186.0, 23.0, 0, 0, 0, 100)
	drawRect(260.0, 414.0, 180.0, 16.0, 0, 0, 0, 100)
	drawRect(261.0, 419.0, 186.0, 13.0, 0, 0, 0, 80)
	drawRect(climaxBar.posX, 414.0, climaxBar.sizeX, 16.0, 0, 0, 0, 250)]]
	
	-- Pink styled climax bar
	drawRect(260.0, 414.0, 186.0, 23.0, 238, 71, 181, 100)
	drawRect(260.0, 414.0, 180.0, 16.0, 0, 0, 0, 100)
	drawRect(260.0, 419.0, 186.0, 13.0, 0, 0, 0, 150)
	drawRect(climaxBar.posX, 414.0, climaxBar.sizeX, 16.0, 238, 71, 181, 60) -- the orgasm-o-meter bar
	drawRect(climaxBar.posX, 411.0, climaxBar.sizeX, 3.0, 255, 255, 255, 50) -- the orgasm-o-meter bar 2
	
	-- Speedometer
	drawRect(257.0, 436.0, 1.0, 15.0, 153, 153, 153, 180) -- Medium Gray
	drawRect(298.0, 436.0, 1.0, 15.0, 153, 153, 153, 180)
	drawRect(337.0, 436.0, 1.0, 15.0, 153, 153, 153, 180)
	drawRect(296.0, 436.0, 114.0, 12.0, 238, 71, 181, 80) -- Pink
	drawRect(296.0, 436.0, 110.0, 8.0, 0, 0, 0, 140) -- Black
	drawRect(speedBar.posX, 436.0, speedBar.sizeX, 4.0, 255, 0, 0, 250) -- Red -- the speed-o-meter bar
	
	-- Shadow on text "pleasure"
	drawRect(203.0, 436.0, 72.0, 12.0, 0, 0, 0, 120)
	
	DrawText.set(2, 600.0, 179.0, 409.0, 0.2, 1.0, 'S_HUD1') -- Climax
	DrawText.set(1, 600.0, 171.0, 430.0, 0.2, 1.0, 'S_HUD2', {number=pleasure}) -- Pleasure: ~1~%
end

--[[===============================================================
===================================================================]]
local modifyActorsOffset = function (female, male, gender_flag, sides, front, height, speed)
	if not(gender_flag==-1) then
		sides, front, height = sides*speed, front*speed, height*speed - 1.0
		local coords = require("lib.sex-machine.cameras-coordinates").coordinates
		local x, y, z
		if gender_flag == 2 then -- Both
			x, y, z = getCharCoordinates(playerPed) -- save player position
			z = z - 1.0
		end
		local fX, fY, fZ = getOffsetFromCharInWorldCoords(playerPed, sides, front, height)
		local plyX, plyY, plyZ = coords.getPlayerPos()
		fX, fY, fZ = fX-plyX, fY-plyY, fZ-plyZ
		if gender_flag == 2 then -- Both
			local mX, mY, mZ = getCharCoordinates(male)
			mZ = mZ - 1.0
			setCharCoordinates(playerPed, mX, mY, mZ)
			mX, mY, mZ = getOffsetFromCharInWorldCoords(playerPed, sides, front, height)
			setCharCoordinates(playerPed, x, y, z) -- return player to original position
			mX, mY, mZ = mX-plyX, mY-plyY, mZ-plyZ
			coords.setFemOffsets(fX, fY, fZ)
			coords.setMaleOffsets(mX, mY, mZ)
		elseif gender_flag == 0 then -- female
			coords.setFemOffsets(fX, fY, fZ)
		elseif gender_flag == 1 then -- male
			coords.setMaleOffsets(fX, fY, fZ)
		end
		return true
	else return false
	end
end

--[[===============================================================
===================================================================]]
local incDecActorOffset = function (gender_flag, inc_amount, pos_offset)
	local coords = require("lib.sex-machine.cameras-coordinates").coordinates
	if gender_flag == 0 or gender_flag == 2 then -- female or both
		local x, y, z, a = coords.getFemOffsets()
		a = a + inc_amount
		coords.setFemOffsets(x, y, z, a)
	end
	if gender_flag == 1 or gender_flag == 2 then -- male or both
		local x, y, z, a = coords.getMaleOffsets()
		a = a + inc_amount
		coords.setMaleOffsets(x, y, z, a)
	end
	return true
end

--[[===============================================================
===================================================================]]
module.ActorsOffsetsMenu_Action = 0
--module.ActorsOffsetsMenu_AngleOfView = 0.0

--[[module.ActorsOffsets_SetFixedCamera = function(input) -- input can be actor or object
	local x, y, z, dummy
	if doesCharExist(input) then
		x, y, z = getCharCoordinates(input)
	elseif doesObjectExist(input) then
		dummy, x, y, z = getObjectCoordinates(input)
	end
	local angle = module.ActorsOffsetsMenu_AngleOfView
	local camPosX, camPosY, camPosZ = x - 2.0*sin(angle), y + 2.0*cos(angle), z + 1.0
	setFixedCameraPosition(camPosX, camPosY, camPosZ, 0.0, 0.0, 0.0)
	pointCameraAtPoint(x, y, z, 2)
end]]

--[[===============================================================
===================================================================]]
module.SaveLoadMenu = function (stat, female, male, pose, place, speed)
	local action = module.ActorsOffsetsMenu_Action
	local DrawText = require("lib.sex-machine.utils").DrawText
	local cursor = require("lib.sex-machine.cursor-control")
	
	DrawText.set(2, 600.0, 10.0, 414.0, 0.2, 1.2, 'CFSV_1') -- Save
	DrawText.set(2, 600.0, 48.0, 414.0, 0.2, 1.2, 'CFSV_2') -- Load
	DrawText.set(2, 600.0, 83.0, 414.0, 0.2, 1.2, 'CFSV_3') -- Delete
	DrawText.set(2, 600.0, 10.0, 430.0, 0.2, 1.2, 'CFSV_7') -- Back
	
	if cursor.clickCheck(23.0, 421.0, 35.0, 12.0) then -- Save
		stat, action = 4, 0
	elseif cursor.clickCheck(60.0, 421.0, 35.0, 12.0) then -- Load
		stat, action = 4, 1
	elseif cursor.clickCheck(100.0, 421.0, 41.0, 12.0) then -- Delete
		stat, action = 4, 2
	elseif cursor.clickCheck(52.0, 436.0, 93.0, 12.0) then -- Close or Back
		stat = 0 -- Close Menu
	end
	
	-- Save/Load: Highlight selected option
	local x = 23.0 + action*37.0
	local posX, posY, sizeX, sizeY
	if action==2 then	posX, posY, sizeX, sizeY = 100.0, 421.0, 41.0, 12.0
	else				posX, posY, sizeX, sizeY = x, 421.0, 35.0, 12.0
	end
	drawRect(posX, posY, sizeX, sizeY, 25, 25, 255, 180)
	
	local slot = 0
	for posY = 332.0, 388.0, 28.0 do
		for posX = 11.0, 131.0, 40.0 do
			slot = slot + 1
			local data = require("lib.sex-machine.save-load").data
			
			DrawText.set(1, 600.0, posX, posY, 0.2, 1.2, 'CFSV_4', {number=slot}) -- Slot ~1~
			if not(data[slot].interior == "") then
				DrawText.set(2, 600.0, posX, posY+8.0, 0.2, 1.2, 'CFSV_5') -- Data!
			end
			if cursor.clickCheck(posX+14.0, posY+10.0, 38.0, 26.0) then
				if action == 0 then -- Save
					data.storeInfo(slot, pose, place)
					data.Save(pose, place)
					printHelpString("Saved!")
				elseif action == 1 then -- Load
					local cam = require("lib.sex-machine.cameras-coordinates").camera
					data.retrieveInfo(slot, female, male, pose, place, speed)
					cam.relocateFreeCamCenter()
					cam.mode = cam.modes.FIXED_CAM
					cam.ToggleSexualCamera_Alt(pose, place)
					printHelpString("Loaded!")
				elseif action == 2 then -- Delete
					data.clear(slot)
					data.Save(pose, place)
					printHelpString("Deleted!")
				end
			end
		end
	end
	module.ActorsOffsetsMenu_Action = action
	return stat
end

--[[===============================================================
===================================================================]]
module.ForcePlayerToLookFront = function(speed_factor)
	x,y = getPcMouseMovement()
	x = x*0.313
	local a = getCharHeading(playerPed) - x
	setCharHeading(playerPed, a)
end

--[[===============================================================
===================================================================]]
module.FrontLookAngle = 0.0

module.InitFrontLookAngle = function ()
	setCameraBehindPlayer()
	restoreCameraJumpcut()
	module.FrontLookAngle = getCharHeading(playerPed)
end

module.GetFrontLookAngle = function (speed_factor)
	x,y = getPcMouseMovement()
	local angle = module.FrontLookAngle - x*speed_factor
	if		angle < 0.0		then	angle = angle + 360.0
	elseif	angle > 360.0	then	angle = angle - 360.0
	end
	module.FrontLookAngle = angle
	return angle
end

--[[===============================================================
===================================================================]]
module.RoundAngle = function (angle, reference_angle)
	if angle < 45.0/2.0 or angle >= 15.0 * 45.0/2.0 then
		angle = 0.0
	else
		local a
		for a = 2.0, 14.0, 2.0 do
			if angle < (a - 1.0)/2.0 * 45.0 and angle >= (a - 1.0)/2.0 * 45.0 then
				return ((a + 1.0)/2.0 + (a - 1.0)/2.0)*45.0/2.0
			end
		end
	end
	return angle
end

--[[===============================================================
===================================================================]]
module.AttachActorTo = function (gender_flag, actor) -- gender_flag -> 0: fem, 1: male, 2: both, 3: free cam center, -1: none
	local coords = require("lib.sex-machine.cameras-coordinates").coordinates
	local x, y, z = coords.getPlayerPos()
	local ox, oy, oz = nil, nil, nil
	
	if gender_flag == 0 or gender_flag == 2 then
		ox, oy, oz = coords.getFemOffsets()
	elseif gender_flag == 1 then
		ox, oy, oz = coords.getMaleOffsets()
	elseif gender_flag == 3 then
		ox, oy, oz = coords.getPlayerOffsets()
	end
	x, y, z = x+ox, y+oy, z+oz
	setCharCoordinates(actor, x, y, z)
end

--[[===============================================================
===================================================================]]
--[[module.GetIncreaseSteps_Cam = function (step)
	cx, cy, cz = getActiveCameraCoordinates()
	tx, ty, tz = getActiveCameraPointAt()
	
	-- xpos += step * sin(a)		sin (a) = cam_trgt_x - cam_pos_x
	-- ypos += step * cos(a)		cos (a) = cam_trgt_y - cam_pos_y
	local step_x, step_y = (tx - cx)*step, (ty - cy)*step
	
	return step_x, step_y
end]]

--[[===============================================================
===================================================================]]
module.ActorsOffsetsMenu_OffsetToModify = 0

module.ActorsOffsetsMenu = function (stat, female, male, pose, place, speed)
	local DrawText = require("lib.sex-machine.utils").DrawText
	local cursor = require("lib.sex-machine.cursor-control")
	local cam = require("lib.sex-machine.cameras-coordinates").camera
	local coords = require("lib.sex-machine.cameras-coordinates").coordinates
	
	local offset, action = module.ActorsOffsetsMenu_OffsetToModify, module.ActorsOffsetsMenu_Action
	local angle = module.RoundAngle(module.GetFrontLookAngle(0.313))
	setCharHeading(playerPed, angle)
	module.AttachActorTo(offset, playerPed)
	
	DrawText.set(2, 600.0, 169.0, 390.0, 0.2, 1.0, 'DEBUG1') -- Reset move angle
	if cursor.clickCheck(203.0, 395.0, 72.0, 11.0) then		setCameraBehindPlayer()		end
	
	DrawText.set(2, 600.0, 124.0, 391.0, 0.2, 1.0, 'CF_OF1') -- Female
	DrawText.set(2, 600.0, 134.0, 404.0, 0.2, 1.0, 'CF_OF2') -- Male
	DrawText.set(2, 600.0, 134.0, 417.0, 0.2, 1.0, 'CF_OF3') -- Both
	DrawText.set(2, 600.0, 125.0, 430.0, 0.2, 1.0, 'CF_OF5') -- Center
	
	if offset == 0 then -- Female
		drawRect(130.0, 397.0, 64.0, 12.0, 0, 0, 160, 120) -- highlight female
	elseif offset == 1 then -- Male
		drawRect(130.0, 410.0, 64.0, 12.0, 0, 0, 160, 120) -- highlight male
	elseif offset == 1 then -- Both
		drawRect(130.0, 423.0, 64.0, 12.0, 0, 0, 160, 120) -- highlight both
	elseif offset == 1 then -- Center
		drawRect(130.0, 436.0, 64.0, 12.0, 0, 0, 160, 120) -- highlight center
	end
	
	if		cursor.clickCheck(130.0, 397.0, 64.0, 12.0) then	offset = 0		cam.removeFreeCamCenter()	-- Female
	elseif	cursor.clickCheck(130.0, 410.0, 64.0, 12.0) then	offset = 1		cam.removeFreeCamCenter()	-- Male
	elseif	cursor.clickCheck(130.0, 423.0, 64.0, 12.0) then	offset = 2		cam.removeFreeCamCenter()	-- Both
	elseif	cursor.clickCheck(130.0, 436.0, 64.0, 12.0) then	offset = 3		cam.createFreeCamCenter()	-- Center
	end
	
	local move_actors_flag = false
	
	DrawText.set(2, 600.0, 10.0, 415.0, 0.2, 1.0, 'CFG_O6') -- Reset
	if cursor.clickCheck(52.0, 421.0, 93.0, 12.0) then -- Reset
		if offset <= 2 then -- Actors offset
			coords.setFemOffsets(0, 0, 0, 0)
			coords.setMaleOffsets(0, 0, 0, 0)
			move_actors_flag=true
		elseif offset == 3 then -- Free cam center offset
			local x,y,z = coords.getFemOffsets()
			coords.setPlayerOffsets(x,y,z)
			cam.setFreeCamCenter(x,y,z)
		end
	end
	
	if offset <= 2 then
		module.ActorsOffsets_KeysControl(offset, female, male, pose, place, speed, move_actors_flag)
	elseif offset == 3 then
		cam.freeCamEditMode_Controls()
	end
	module.ActorsOffsetsMenu_OffsetToModify = offset
	
	DrawText.set(2, 600.0, 10.0, 430.0, 0.2, 1.0, 'S_OPT6') -- Close
	if cursor.clickCheck(52.0, 436.0, 93.0, 12.0) then stat = 0 end -- Close (Reset SexMenuState)
	return stat
end

--[[===============================================================
===================================================================]]
module.ActorsOffsets_KeysControl = function (gender_flag, female, male, pose, place, unused, move_actors_flag)
	local KEY_F6, KEY_F3, KEY_W, KEY_A, KEY_S, KEY_D, KEY_Q, KEY_E, KEY_SHIFT = 117, 114, 87, 65, 83, 68, 81, 69, 16
	local speed = isKeyDown(KEY_SHIFT) and 0.05 or 0.01
	local do_nothing = function() return false end
	local f1, f2, f3, f4, f5, f6, f7, f8 = nil, nil, nil, nil, nil, nil, nil, nil
	
	f1 = ( isKeyDown(KEY_W)	and modifyActorsOffset	or do_nothing )( female, male, gender_flag,  0,  1,  0, speed )	-- front +
	f2 = ( isKeyDown(KEY_S)	and modifyActorsOffset	or do_nothing )( female, male, gender_flag,  0, -1,  0, speed )	-- front -
	f3 = ( isKeyDown(KEY_D)	and modifyActorsOffset	or do_nothing )( female, male, gender_flag,  1,  0,  0, speed )	-- sides ->
	f4 = ( isKeyDown(KEY_A)	and modifyActorsOffset	or do_nothing )( female, male, gender_flag, -1,  0,  0, speed )	-- sides <-
	f5 = ( isKeyDown(KEY_E)	and modifyActorsOffset	or do_nothing )( female, male, gender_flag,  0,  0,  1, speed )	-- up
	f6 = ( isKeyDown(KEY_Q)	and modifyActorsOffset	or do_nothing )( female, male, gender_flag,  0,  0, -1, speed )	-- down
	f7 = ( isKeyDown(37)	and incDecActorOffset	or do_nothing )( gender_flag, -10.0, false )					-- left: angle
	f8 = ( isKeyDown(39)	and incDecActorOffset	or do_nothing )( gender_flag,  10.0, false )					-- right: angle
	
	if	move_actors_flag	or	f1	or	f2	or	f3	or	f4	or	f5	or	f6	or	f7	or	f8 then -- Should actors be moved?
		local coords = require("lib.sex-machine.cameras-coordinates").coordinates
		local actors = require("lib.sex-machine.actors-poses")
		local plyX, plyY, plyZ = coords.getPlayerPos()
		local femX, femY, femZ, femA = coords.getFemOffsets()
		local maleX, maleY, maleZ, maleA = coords.getMaleOffsets()
		
		actors.RelocateActor_Alt(female, plyX, plyY, plyZ, femX, femY, femZ, femA)
		actors.RelocateActor_Alt(male, plyX, plyY, plyZ, maleX, maleY, maleZ, maleA)
	end
end

--[[===============================================================
===================================================================]]
--[[module.CamsOffsetsMenu_Action = 0
module.CamsOffsetsMenu_OffsetToModify, module.CamsOffsetsMenu_OffsetToModify_prev = 0, 0
module.CamsOffsetsMenu_FixedId = 0

module.CameraOffsetsMenu = function (stat, female, male, pose, place, speed)
	local cam = require("lib.sex-machine.cameras-coordinates").camera
	local DrawText = require("lib.sex-machine.utils").DrawText
	local cursor = require("lib.sex-machine.cursor-control")
	local Increase, Decrease = require("lib.sex-machine.utils").Inc, require("lib.sex-machine.utils").Dec
	local coords = require("lib.sex-machine.cameras-coordinates").coordinates
	
	local action = module.CamsOffsetsMenu_Action
	
	if not cam.fpv.edit_mode then
		DrawText.set(2, 600.0, 10.0, 414.0, 0.2, 1.2, 'CFSV_1') -- Save
		DrawText.set(2, 600.0, 48.0, 414.0, 0.2, 1.2, 'CFSV_2') -- Load
		DrawText.set(2, 600.0, 83.0, 414.0, 0.2, 1.2, 'CFSV_3') -- Delete
		DrawText.set(2, 600.0, 10.0, 430.0, 0.2, 1.2, (stat==7) and 'CFSV_7' or 'S_OPT6') -- Back or Close
		
		if		cursor.clickCheck(23.0, 421.0, 35.0, 12.0)	then	stat, action = 7, 0 -- Save
		elseif	cursor.clickCheck(60.0, 421.0, 35.0, 12.0)	then	stat, action = 7, 1 -- Load
		elseif	cursor.clickCheck(100.0, 421.0, 41.0, 12.0)	then	stat, action = 7, 2 -- Delete
		elseif	cursor.clickCheck(52.0, 436.0, 93.0, 12.0)	then -- Close or Back
			if stat == 7 then	stat = 6	else
				stat = 0 -- Close (Reset SexMenuState)
				cam.removeFreeCamCenter()
				cam.mode = 0
				cam.relocateFreeCamCenter()
				cam.fpv.removeFirstPersonPoint()
				setCameraBehindPlayer()
				restoreCameraJumpcut()
			end
		end
	end
	
	if stat == 7 then
		-- Save/Load: Highlight selected option
		local x = 23.0 + action*37.0
		local posX, posY, sizeX, sizeY = (action==2) and 100.0 or x, 421.0, (action==2) and 41.0 or 35.0, 12.0
		drawRect(posX, posY, sizeX, sizeY, 25, 25, 255, 180) -- highlight selected
		
		local slot = 0
		for posY = 332.0, 388.0, 28.0 do
			for posX = 11.0, 131.0, 40.0 do
				slot = slot + 1
				local data = require("lib.sex-machine.save-load").data
				DrawText.set(1, 600.0, posX, posY, 0.2, 1.2, 'CFSV_4', {number=slot}) -- Slot ~1~
				if not(data[slot].interior=="") then
					DrawText.set(2, 600.0, posX, posY+8.0, 0.2, 1.2, 'CFSV_5') -- Data!
				end
				if cursor.clickCheck(posX+14.0, posY+10.0, 38.0, 26.0) then
					if action == 0 then -- Save
						data.storeInfo(slot, pose, place)
						printHelpString("Saved!")
					elseif action == 1 then -- Load
						data.retrieveInfo(slot, female, male, pose, place, speed)
						module.CamsOffsetsMenu_OffsetToModify = 0
						cam.removeFreeCamCenter()
						cam.fpv.removeFirstPersonPoint()
						cam.createFreeCamCenter()
						cam.mode = -1
						printHelpString("Loaded!")
					elseif action == 2 then -- Delete
						data.clear(slot)
						printHelpString("Deleted!")
					end
				end
			end
		end
		module.CamsOffsetsMenu_Action = action
		return stat
	else -- stat: 6
		local offset = module.CamsOffsetsMenu_OffsetToModify
		if offset == 0 then
			-- Change angle of view
			DrawText.set(2, 600.0, 170.0, 389.0, 0.2, 1.2, 'CFG_D7') -- <
			DrawText.set(2, 600.0, 183.0, 390.0, 0.2, 1.0, 'CFG_E3') -- Change Angle of View
			DrawText.set(2, 600.0, 286.0, 389.0, 0.2, 1.2, 'CFG_D8') -- >
			if cursor.clickCheck(175.0, 395.0, 16.0, 10.0) then -- <
				module.ActorsOffsetsMenu_AngleOfView = module.ActorsOffsetsMenu_AngleOfView + 90.0
				module.CamsOffsets_SetFixedCamera()
			elseif cursor.clickCheck() then -- >
				module.ActorsOffsetsMenu_AngleOfView = module.ActorsOffsetsMenu_AngleOfView - 90.0
				module.CamsOffsets_SetFixedCamera()
			end
		end
			
		-- FPV Cam Edit
		cam.fpv.control(cam.mode)
		if offset == 1 then
			DrawText.set(2, 600.0, 170.0, 389.0, 0.2, 1.0, cam.fpv.edit_mode and 'CFG_E6' or 'CFG_E5') -- FPV edit mode - Click anywhere to close		/		Enter FPV edit mode
			if not cam.fpv.edit_mode then
				if cursor.clickCheck(260.0, 395.0, 186.0, 11.0) then -- Move First Person View camera
					cam.fpv.edit_mode, fpv.moveable, cursor.show_cursor = true, true, false
				end
			else
				local resX, resY = getScreenResolution()
				if cursor.clickCheck(resX/2, resY/2, resX, resY, true) then -- Full screen box
					cam.fpv.edit_mode, fpv.moveable, cursor.show_cursor = false, false, true
				end
			end
		end
		
		-- Fixed Cam Edit
		if offset == 2 then
			local n = module.CamsOffsetsMenu_FixedId + 1
			if cam.fpv.edit_mode == 0 then
				DrawText.set(2, 600.0, 170.0, 389.0, 0.2, 1.2, 'CFG_D7') -- <
				DrawText.set(2, 600.0, 344.0, 389.0, 0.2, 1.2, 'CFG_D8') -- >
				DrawText.set(2, 600.0, 188.0, 390.0, 0.2, 1.0, 'CFG_E7', {number=n}) -- Enter Fixed camera ~1~ edit mode
				if cursor.clickCheck(175.0, 395.0, 16.0, 10.0) then -- <
					cam.fpv.removeFirstPersonPoint()
					module.CamsOffsetsMenu_FixedId = Decrease(module.CamsOffsetsMenu_FixedId, 1, 0, 11)
					local x, y, z, a, rot, tx = cam.fixed.get(module.CamsOffsetsMenu_FixedId)
					x, y, z, a, tx = cam.fixed.init(x, y, z, a, rot, tx)
					cam.fpv.createFirstPersonPoint(x, y, z, a, tx)
				end
				if cursor.clickCheck(345.0, 395.0, 16.0, 10.0) then -- >
					cam.fpv.removeFirstPersonPoint()
					module.CamsOffsetsMenu_FixedId = Increase(module.CamsOffsetsMenu_FixedId, 1, 0, 11)
					local x, y, z, a, rot, tx = cam.fixed.get(module.CamsOffsetsMenu_FixedId)
					x, y, z, a, tx = cam.fixed.init(x, y, z, a, rot, tx)
					cam.fpv.createFirstPersonPoint(x, y, z, a, tx)
				end
				if cursor.clickCheck(260.0, 395.0, 150.0, 11.0) then -- Text
					cam.fpv.edit_mode, cam.fpv.moveable, cursor.show_cursor = true, true, false
				end
			else
				DrawText.set(2, 600.0, 170.0, 389.0, 0.2, 1.0, 'CFG_E8', {number=n}) -- Fixed cam ~1~ edit mode - click to exit
				local resX, resY = getScreenResolution()
				if cursor.clickCheck(resX/2, resY/2, resX, resY) then -- Full screen box
					cam.fpv.edit_mode, cam.fpv.moveable, cursor.show_cursor = false, false, true
				end
			end
		end
		
		-- Manage the camera
		if not(module.CamsOffsetsMenu_OffsetToModify == module.CamsOffsetsMenu_OffsetToModify_prev) then -- State changed?
			if module.CamsOffsetsMenu_OffsetToModify == 0 then -- Free camera
				cam.fpv.removeFirstPersonPoint()
				cam.createFreeCamCenter()
				cam.mode = -1
			elseif module.CamsOffsetsMenu_OffsetToModify == 1 then -- First person camera
				cam.removeFreeCamCenter()
				cam.fpv.removeFirstPersonPoint()
				cam.mode = 2
				local x, y, z, a, rot, tx = cam.getFPVCamData()
				x, y, z, a, tx = cam.fpv.init(x, y, z, a, rot, tx)
				cam.fpv.createFirstPersonPoint(x, y, z, a, tx)
			elseif module.CamsOffsetsMenu_OffsetToModify == 2 then -- Fixed camera
				cam.removeFreeCamCenter()
				cam.fpv.removeFirstPersonPoint()
				cam.mode, module.CamsOffsetsMenu_FixedId = 2, 0
				local x, y, z, a, rot, tx = cam.fixed.get(0)
				x, y, z, a, tx = cam.fixed.init(x, y, z, a, rot, tx)
				cam.fpv.createFirstPersonPoint(x, y, z, a, tx)
			end
			module.CamsOffsetsMenu_OffsetToModify_prev = module.CamsOffsetsMenu_OffsetToModify -- Store current state in previous state slot
		end
		
		-- Change between camera modes
		if not cam.fpv.edit_mode then
			local offset = module.CamsOffsetsMenu_OffsetToModify
			if		module.CamsOffsetsMenu_OffsetToModify == 0 then DrawText.set(2, 600.0, 45.0, 399.0, 0.2, 1.2, 'CFG_E1') -- Free cam offset
			elseif	module.CamsOffsetsMenu_OffsetToModify == 1 then DrawText.set(2, 600.0, 45.0, 399.0, 0.2, 1.2, 'CFG_E2') -- FPV offset
			elseif	module.CamsOffsetsMenu_OffsetToModify == 2 then DrawText.set(2, 600.0, 45.0, 399.0, 0.2, 1.2, 'CFG_E4') -- Fixed offsets
			end
			DrawText.set(1, 600.0, 20.0, 400.0, 0.4, 1.2, 'CFG_D7') -- <
			DrawText.set(1, 600.0, 127.0, 400.0, 0.4, 1.2, 'CFG_D8') -- >
			if		cursor.clickCheck(25.0, 406.0, 19.0, 12.0)	then offset = Decrease(offset, 1, 0, 2) -- <
			elseif	cursor.clickCheck(132.0, 406.0, 19.0, 12.0)	then offset = Increase(offset, 1, 0, 2) -- >
			end
			module.CamsOffsetsMenu_OffsetToModify = offset
		end
		
		if not cam.fpv.edit_mode then
			DrawText.set(2, 600.0, 128.0, 414.0, 0.2, 1.2, 'CFG_O6') -- Reset
			if cursor.clickCheck(142.0, 421.0, 39.0, 12.0) then -- Reset
				if module.CamsOffsetsMenu_OffsetToModify == 0 then -- Free camera
					coords.setPlayerOffsets(0.0, 0.0, 0.0)
					cam.moveFreeCamCenter(0.0, 0.0, 0.0)
				elseif module.CamsOffsetsMenu_OffsetToModify == 1 then -- First person camera
					cam.fpv.removeFirstPersonPoint()
					cam.fpv.storeFPVCamData(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					local x, y, z, a, tx = cam.fpv.init(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					cam.fpv.createFirstPersonPoint(x, y, z, a, tx)
				elseif module.CamsOffsetsMenu_OffsetToModify == 2 then -- Fixed camera
					cam.fpv.removeFirstPersonPoint()
					cam.fixed.store(module.CamsOffsetsMenu_FixedId, 0, 0, 0, 0, 0, 0)
					local x, y, z, a, tx = camera.fixed.init(0, 0, 0, 0, 0, 0)
					cam.fpv.createFirstPersonPoint(x, y, z, a, tx)
				end
			end
		end
	end
	
	if module.CamsOffsetsMenu_OffsetToModify == 0 then -- Free Camera Edit
		local KEY_F6,KEY_F3,KEY_W,KEY_A,KEY_S,KEY_D,KEY_Q,KEY_E,KEY_SHIFT = 117,114,87,65,83,68,81,69,16
		local do_nothing = function () end
		local step_x, step_y = module.GetIncreaseSteps_Cam (0.01)
		local step_z, spd = 0.01, isKeyDown(KEY_SHIFT) and 5 or 1
		step_x, step_y, step_z = step_x*spd, step_y*spd, step_z*spd
		
		( isKeyDown(KEY_W) and cam.moveFreeCamCenter or do_nothing )(	 step_x,	 step_y,		0.0) -- front +
		( isKeyDown(KEY_S) and cam.moveFreeCamCenter or do_nothing )(	-step_x,	-step_y,		0.0) -- front -
		( isKeyDown(KEY_D) and cam.moveFreeCamCenter or do_nothing )(	 step_y,	-step_x,		0.0) -- sides ->
		( isKeyDown(KEY_A) and cam.moveFreeCamCenter or do_nothing )(	-step_y,	 step_x,		0.0) -- sides <-
		( isKeyDown(KEY_E) and cam.moveFreeCamCenter or do_nothing )(		0.0,		0.0,	 step_z) -- up
		( isKeyDown(KEY_Q) and cam.moveFreeCamCenter or do_nothing )(		0.0,		0.0,	-step_z) -- down
	elseif module.CamsOffsetsMenu_OffsetToModify == 1 then -- First Person Camera Edit
		if cam.fpv.edit_mode then	cam.fpv.keyscontrol(2, 0)	end
	elseif module.CamsOffsetsMenu_OffsetToModify == 2 then -- Fixed Camera Edit
		if cam.fpv.edit_mode then	cam.fpv.keyscontrol(1, module.CamsOffsetsMenu_FixedId)	end
	end
	
	return stat
end]]

--[[===============================================================
===================================================================]]
--[[module.CamsOffsets_SetFixedCamera = function ()
	local object = require("lib.sex-machine.cameras-coordinates").camera.free.center
	module.ActorsOffsets_SetFixedCamera(object)
end]]

--[[===============================================================
===================================================================]]
module.ShowSettingTexts = function (stat, speed, pose, place)
	local cam = require("lib.sex-machine.cameras-coordinates").camera
	local FREE_CAM, FIXED_CAM, FPV_CAM = cam.modes.FREE_CAM, cam.modes.FIXED_CAM, cam.modes.FPV_CAM
	local DrawText = require("lib.sex-machine.utils").DrawText
	
	DrawText.set(2, 600.0, 24.0, 12.0, 0.2, 1.2, 'CFG_T3') -- ~b~~k~~VEHICLE_ENTER_EXIT~: ~s~Go back.
	
	if		stat == 0	then	DrawText.set(2, 600.0, 24.0, 26.0, 0.2, 1.2, 'CFG_T9') -- ~b~~k~~PED_ANSWER_PHONE~~w~: Go to the desired place and press ~k~~PED_ANSWER_PHONE~ to select pose.
	elseif	stat == 8	then	DrawText.set(2, 600.0, 24.0, 26.0, 0.2, 1.2, 'CFG_I1') -- ~b~~k~~PED_ANSWER_PHONE~~w~: Edit the free camera rotation point.
	end
	
	if stat == 2 then
		if not(cam.mode == FREE_CAM) then
			if cam.mode == FIXED_CAM then
				DrawText.set(2, 600.0, 169.0, 390.0, 0.2, 1.0, 'CFG_C5', {number=cam.id+1}) -- Fixed Camera ~y~~1~
				DrawText.set(1, 600.0, 244.0, 390.0, 0.2, 1.0, 'CFG_T6') -- <  >
			elseif cam.mode == FPV_CAM then
				DrawText.set(2, 600.0, 169.0, 390.0, 0.2, 1.0, 'CFG_C6') -- First Person
			end
			DrawText.set(2, 600.0, 300.0, 390.0, 0.2, 1.0, 'CFG_C7') -- Free
			DrawText.set(2, 600.0, 330.0, 390.0, 0.2, 1.0, 'CFG_C8') -- Edit
		end
		
		DrawText.set(2, 600.0, 129.0, 391.0, 0.2, 1.2, 'CFG_M1') -- Poses
		DrawText.set(2, 600.0, 119.0, 404.0, 0.2, 1.2, 'CFG_M2') -- Offsets
		DrawText.set(2, 600.0, 108.0, 417.0, 0.2, 1.2, 'CFG_M4') -- Save/Load
		DrawText.set(2, 600.0, 135.0, 430.0, 0.2, 1.2, 'CFSV_7') -- Back
	end
end

--[[===============================================================
===================================================================]]
module.ManageAnimationsMenu = function (speed, pose, place, female, male)
	local dummy_gxt, max_anims = require("lib.sex-machine.actors-poses").ReadSexPosesInfo_short(speed, pose, place)
	local current_anim = require("lib.sex-machine.actors-poses").CurrentAnimation
	local loadPose = require("lib.sex-machine.actors-poses").LoadSexualPose
	local tsizeX, tsizeY = 0.2, 1.2
	local text_default, text_selected = {r=255,g=255,b=255,a=255}, {r=244,g=189,b=230,a=255}
	local box_default, box_selected = {r=105,g=25,b=90,a=150}, {r=46,g=20,b=46,a=150}
	
	if max_anims == 2 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
		}, 365.0, 402.0, tsizeX, tsizeY, 0.0, 23.0, text_default, text_selected, 368.0, 409.0, 24.0, 21.0, box_default, box_selected, current_anim)
	elseif max_anims ==  3 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
		}, 365.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 368.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
	elseif max_anims ==  4 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
								{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
		}, 360.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 363.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)
	elseif max_anims ==  5 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
		}, 365.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 368.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
								{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
		}, 391.0, 402.0, tsizeX, tsizeY, 0.0, 23.0, text_default, text_selected, 394.0, 409.0, 24.0, 21.0, box_default, box_selected, current_anim)
	elseif max_anims ==  6 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
		}, 365.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 368.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
								{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
								{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
		}, 391.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 394.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
	elseif max_anims ==  7 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
		}, 365.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 368.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
								{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
		}, 391.0, 402.0, tsizeX, tsizeY, 0.0, 23.0, text_default, text_selected, 394.0, 409.0, 24.0, 21.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
								{{  7, 'INT_1', 7, loadPose, function() return female, male, pose, place, speed, 7 end }},
		}, 417.0, 402.0, tsizeX, tsizeY, 0.0, 23.0, text_default, text_selected, 420.0, 409.0, 24.0, 21.0, box_default, box_selected, current_anim)
	elseif max_anims ==  8 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
		}, 365.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 368.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
								{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
								{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
		}, 391.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 394.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
    
		module.showButtons({	{{  7, 'INT_1', 7, loadPose, function() return female, male, pose, place, speed, 7 end }},
								{{  8, 'INT_1', 8, loadPose, function() return female, male, pose, place, speed, 8 end }},
		}, 417.0, 402.0, tsizeX, tsizeY, 0.0, 23.0, text_default, text_selected, 420.0, 409.0, 24.0, 21.0, box_default, box_selected, current_anim)
	elseif max_anims ==  9 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
		}, 365.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 368.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
								{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
								{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
		}, 391.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 394.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
		
		module.showButtons({	{{  7, 'INT_1', 7, loadPose, function() return female, male, pose, place, speed, 7 end }},
								{{  8, 'INT_1', 8, loadPose, function() return female, male, pose, place, speed, 8 end }},
								{{  9, 'INT_1', 9, loadPose, function() return female, male, pose, place, speed, 9 end }},
		}, 417.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 420.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
	elseif max_anims == 10 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
								{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
		}, 360.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 363.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
								{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
								{{  7, 'INT_1', 7, loadPose, function() return female, male, pose, place, speed, 7 end }},
		}, 381.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 384.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  8, 'INT_1', 8, loadPose, function() return female, male, pose, place, speed, 8 end }},
								{{  9, 'INT_1', 9, loadPose, function() return female, male, pose, place, speed, 9 end }},
								{{ 10, 'INT_1',10, loadPose, function() return female, male, pose, place, speed,10 end }},
		}, 407.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 410.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
	elseif max_anims == 11 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
								{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
		}, 360.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 363.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
								{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
								{{  7, 'INT_1', 7, loadPose, function() return female, male, pose, place, speed, 7 end }},
								{{  8, 'INT_1', 8, loadPose, function() return female, male, pose, place, speed, 8 end }},
		}, 376.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 379.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  9, 'INT_1', 9, loadPose, function() return female, male, pose, place, speed, 9 end }},
								{{ 10, 'INT_1',10, loadPose, function() return female, male, pose, place, speed,10 end }},
								{{ 11, 'INT_1',11, loadPose, function() return female, male, pose, place, speed,11 end }},
		}, 397.0, 399.0, tsizeX, tsizeY, 0.0, 14.0, text_default, text_selected, 400.0, 405.0, 24.0, 13.0, box_default, box_selected, current_anim)
	elseif max_anims == 12 then
		module.showButtons({	{{  1, 'INT_1', 1, loadPose, function() return female, male, pose, place, speed, 1 end }},
								{{  2, 'INT_1', 2, loadPose, function() return female, male, pose, place, speed, 2 end }},
								{{  3, 'INT_1', 3, loadPose, function() return female, male, pose, place, speed, 3 end }},
								{{  4, 'INT_1', 4, loadPose, function() return female, male, pose, place, speed, 4 end }},
		}, 360.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 363.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  5, 'INT_1', 5, loadPose, function() return female, male, pose, place, speed, 5 end }},
								{{  6, 'INT_1', 6, loadPose, function() return female, male, pose, place, speed, 6 end }},
								{{  7, 'INT_1', 7, loadPose, function() return female, male, pose, place, speed, 7 end }},
								{{  8, 'INT_1', 8, loadPose, function() return female, male, pose, place, speed, 8 end }},
		}, 376.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 379.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)

		module.showButtons({	{{  9, 'INT_1', 9, loadPose, function() return female, male, pose, place, speed, 9 end }},
								{{ 10, 'INT_1',10, loadPose, function() return female, male, pose, place, speed,10 end }},
								{{ 11, 'INT_1',11, loadPose, function() return female, male, pose, place, speed,11 end }},
								{{ 12, 'INT_1',12, loadPose, function() return female, male, pose, place, speed,12 end }},
		}, 392.0, 397.0, tsizeX, tsizeY, 0.0, 12.0, text_default, text_selected, 395.0, 404.0, 14.0, 10.0, box_default, box_selected, current_anim)
	end
end

--[[===============================================================
===================================================================]]
module.showButtons = function (data, tposX, tposY, tsizeX, tsizeY, offsX, offsY, text_default_style, text_selected_style,
	bposX, bposY, bsizeX, bsizeY, box_default_style, box_selected_style, selected_elem_id)
	
	text_default_style = text_default_style or {r=255,g=255,b=255,a=255}
	text_selected_style = text_selected_style or {r=255,g=255,b=255,a=255}
	box_default_style = box_default_style or {r=0,g=0,b=0,a=0}
	box_selected_style = box_selected_style or {r=0,g=0,b=0,a=0}
	
	local cursor = require("lib.sex-machine.cursor-control")
	local DrawText = require("lib.sex-machine.utils").DrawText
	local x, y = nil, nil
	
	for y=1,#data do
		for x=1,#data[y] do
			
			local elem_id = data[y][x][1]
			local sel = elem_id==selected_elem_id --cursor.positionCheck(bposX+offsX*(x-1), bposY+offsY*(y-1), bsizeX, bsizeY)
			local r, g, b, a = sel and tsel_r or tr, sel and tsel_g or tg, sel and tsel_b or tb, sel and tsel_a or ta
			local gxt_entry, gxt_num = data[y][x][2], data[y][x][3]
			local style = sel and text_selected_style or text_default_style
			style.number = gxt_num
			
			-- Texts
			if not(gxt_entry==nil) then
				DrawText.set(2, 620.0, tposX+offsX*(x-1), tposY+offsY*(y-1), tsizeX, tsizeY, gxt_entry, style)
			end
			
			-- Boxes
			if not(gxt_entry==nil) then
				style = sel and box_selected_style or box_default_style
				drawRect(bposX+offsX*(x-1), bposY+offsY*(y-1), bsizeX, bsizeY, style.r, style.g, style.b, style.a)
			end
			
			-- Actions
			local button_action, params = data[y][x][4], data[y][x][5] or void
			if not(button_action==nil) then
				local do_nothing, void = function() end, function() end
				( cursor.clickCheck(bposX+offsX*(x-1), bposY+offsY*(y-1), bsizeX, bsizeY) and button_action or do_nothing)( params() )
			end
			
		end
	end
end

return module