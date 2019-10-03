--[[===============================================================
===================================================================]]
local sex = {}

sex.poses = {
	SEX_FUCKING	= 1,
	SEX_BJ		= 2,
	SEX_ANAL	= 3,
	SEX_HJ		= 4,
	SEX_CUNNI	= 5,
	SEX_69		= 6,
	SEX_TJ		= 7,
	SEX_FJ		= 8,
}

sex.places = {
	PL_BED		= 1,
	PL_SOFA		= 2,
	PL_TABLE	= 3,
	PL_CHAIR	= 4,
	PL_FLOOR	= 5,
	PL_BATH		= 6,
	PL_KITCHEN	= 7,
	PL_WALL		= 8,
	PL_FOOT		= 9,
}

sex.speedIds = {
	SPD_IDLE	= 0,
	SPD_SLOW	= 1,
	SPD_NORMAL	= 2,
	SPD_FAST	= 3,
}

sex.bodyTypes = {
	BT_NORMAL	= 0,
	BT_LOLI		= 1,
	BT_BIG		= 2,
}

local SEXFILES_MINIMUM_WAIT_TIME = 1200

--[[===============================================================
===================================================================]]
sex.run = function(pose, place, speed, female_gxt, male_gxt)
	local SX_MENU_LEFT_FIRST_ELEM, SX_MENU_LEFT_LAST_ELEM = 1, 3
	
	local mission	= require "lib.sex-machine.mission"

	local pulsed	= require("lib.sex-machine.machines").PulseButtonMachine
	local timer		= require("lib.sex-machine.machines").Timer
	local pad		= require("lib.game.keys").player
	local cam		= require("lib.sex-machine.cameras-coordinates").camera
	local coords	= require("lib.sex-machine.cameras-coordinates").coordinates
	local actors	= require("lib.sex-machine.actors-poses")
	local genders	= require("lib.sex-machine.actors-poses").genders
	local menu		= require("lib.sex-machine.sex-menu")
	local cursor	= require("lib.sex-machine.cursor-control")
	local sexfiles	= require("lib.sex-machine.utils").sexfiles
	local file		= require("lib.sex-machine.save-load")
	
	local pleasure	= require("lib.sex-machine.machines").pleasure
	local climax	= require("lib.sex-machine.machines").climax
	local speed		= require("lib.sex-machine.machines").speed
	
	mission.setOnMission(1)
	
	-- Initialize Machine
	displayRadar(false)
	displayHud(false)
	useRenderCommands(true) -- 03F0: enable_text_draw 1
	setTextDrawBeforeFade(true) -- 03E0: draw_text_behind_textures 1
	disableAllEntryExits(true)
	
	sex.pose, sex.place, sex.bodytype = pose, place, sex.bodyTypes.BT_NORMAL
	
	-- Menu init
	menu.slot, menu.pose, menu.place = 0, require("lib.sex-machine.data").getMenuPose(pose, place), place
    
	file.data.Load(sex.pose, sex.place)
    sexfiles.generate(sex.pose, sex.place, sex.bodytype)
	timer.set(0)
	
	cam.mode = cam.modes.FREE_CAM
	sex.showSexualStats = true
	sex.stat = 0
	menu.stat = 0
	
	speed.value, speed.stat = 0, 0
	climax.value, climax.stat = 0, 0
	pleasure.value, pleasure.stat = 0, 0
	
	setPlayerEnterCarButton(playerchar, false)
	
	cursor.init()
	pulsed.init()
	
	sex.female, sex.male = nil, nil

	-- Initialize offset to 0.0
	coords.setPlayerOffsets(0.0, 0.0, 0.0, 0.0)

	actors.ChangeGenderSkin(female_gxt, male_gxt, genders.MALE)
	
	while true do
	wait (0)
		-- Buttons UP - DOWN - ACCEPT - CANCEL acknowledge
		pulsed.run()
		
		if menu.stat > 0 then	-- 0 is the only state when player can move
			cursor.control()		-- so is best to activate cursor when player can't!
		end
		
		sex.machine()
		
		if menu.stat == 0 then
			if pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				break -- End Sex Activity
			end
			if isButtonPressed(playerchar, pad.ANSWERPHONE_FIREWEAPONALT) then -- TAB
				menu.stat = 1
				setPlayerControl(playerchar, false)
			end
		end
		
		if menu.stat == 1 then
			local highlightedPose, highlightedPlace = menu.showSexualMenu(sex.pose, sex.place, true)
			if cursor.clickCheck(542.0, 416.0, 162.0, 48.0) then -- Change Button Click
				local gxt_entry = require("lib.sex-machine.data").places[highlightedPlace][highlightedPose]
				local newPose, newBodyType = require("lib.sex-machine.data").GetPoseFromGXT(gxt_entry)
				sex.pose = newPose
				sex.place = highlightedPlace
				sex.bodytype = newBodyType
				speed.value = 40
				sex.female, sex.male = actors.ChangePoseAndPlace(female_gxt, male_gxt, sex.female, sex.male, sex.pose, sex.place, speed.stat, menu.slot, SEXFILES_MINIMUM_WAIT_TIME)
				menu.stat = 2
			end
			if cursor.clickCheck(76.0, 436.0, 143.0, 13.0) then -- Cancel Button
				cursor.waitUntilReleaseClickButton()
				menu.stat = 0
				setPlayerControl(playerchar, true)
			end
			if pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				setPlayerControl(playerchar, true)
			end
		end
		if menu.stat == 5 then
			local highlightedPose, highlightedPlace = menu.showSexualMenu(sex.pose, sex.place, false)
			if cursor.clickCheck(542.0, 416.0, 162.0, 48.0) then -- Change Button Click
				local gxt_entry = require "lib.sex-machine.data".places[highlightedPlace][highlightedPose]
				local newPose, newBodyType = require("lib.sex-machine.data").GetPoseFromGXT(gxt_entry)
				if	newPose ~= sex.pose		or	highlightedPlace ~= sex.place	or	newBodyType ~= sex.bodytype		then
					doFade(false, 750)
					wait (750)
					sex.pose, sex.place, sex.bodytype = newPose, highlightedPlace, newBodyType
					actors.RemovePosesAndActors(sex.female, sex.male)
					speed.value = 0
					sexfiles.generate(sex.pose, sex.place, sex.bodytype)
					timer.set(0) -- give the sexfiles.generate() enough time
					speed.value = 40
					sex.female, sex.male = actors.ChangePoseAndPlace(female_gxt, male_gxt, sex.female, sex.male, sex.pose, sex.place, speed.stat, menu.slot, SEXFILES_MINIMUM_WAIT_TIME)
					menu.stat = 2
					wait (0)
					doFade(true, 750)
				elseif newPose == sex.pose and highlightedPlace == sex.place then
					if sex.slot ~= 0 then
						menu.stat = 2
						--0AB1: @RetrieveInformationFromInternalStorage 6 slot Dummy3 PornActress PornActor SexPoseInt SexPlace SpeedState
						cam.restoreCamera(true, pose, place)
					end
				end
			end
			if cursor.clickCheck(76.0, 436.0, 143.0, 13.0) then -- Cancel Button
				cursor.waitUntilReleaseClickButton()
				menu.stat = 2
				cam.restoreCamera(false, 0, 0)
			end
			if pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				menu.stat = 2
				pulsed.increaseStat()
				cam.restoreCamera(false, 0, 0)
			end
		end
		if menu.stat == 2 then
			if cursor.clickCheck(130.0, 398.0, 64.0, 12.0) then -- Poses button
				cam.freezeCamera()
				menu.stat=5
			end
			if cursor.clickCheck(130.0, 411.0, 64.0, 12.0) then -- Offsets button
				file.data.Load(sex.pose, sex.place)
				menu.InitFrontLookAngle()
				--actors.ChangeGenderSkin(female_gxt, male_gxt, genders.MALE)
				menu.ActorsOffsetsMenu_OffsetToModify = 0 -- Edit Female
				menu.stat = 3
			end
			if cursor.clickCheck(130.0, 424.0, 64.0, 12.0) then -- Save/Load button
				file.data.Load(sex.pose, sex.place)
				menu.stat = 4
			end
			if cursor.clickCheck(130.0, 437.0, 64.0, 12.0) -- Back button
			or pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				cam.mode = cam.modes.FREE_CAM
				actors.RemovePosesAndActors(sex.female, sex.male)
				speed.value = 0
				actors.ChangeGenderSkin(female_gxt, male_gxt, genders.MALE)
				menu.stat=0
			end
		end
		if menu.stat == 3 then
			menu.stat = menu.ActorsOffsetsMenu(menu.stat, sex.female, sex.male, sex.pose, sex.place, speed.stat)
			if menu.stat == 0 -- Clicked on back button from @ActorsOffsetsMenu
			or pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				menu.stat = 2
				if pulsed.check(pulsed.states.PULSED_ENTER_VEH)
				then pulsed.increaseStat()
				end
				local plyX, plyY, plyZ = coords.getPlayerPos()
				local femX, femY, femZ, femA = coords.getFemOffsets()
				local maleX, maleY, maleZ, maleA = coords.getMaleOffsets()
				actors.RelocateActor_Alt(sex.female, plyX, plyY, plyZ, femX, femY, femZ, femA, genders.FEM, sex.pose, sex.place)
				actors.RelocateActor_Alt(sex.male, plyX, plyY, plyZ, maleX, maleY, maleZ, maleA, genders.MALE, sex.pose, sex.place)
				actors.LoadSexualPose(sex.female, sex.male, sex.pose, sex.place, speed.stat)
				cam.removeFreeCamCenter()
				cam.relocateFreeCamCenter()
			end
		end
		if menu.stat == 4 then
			menu.stat = menu.SaveLoadMenu(menu.stat, sex.female, sex.male, sex.pose, sex.place, speed.stat)
			if menu.stat == 0 -- Clicked on back (from @SaveLoadMenu)
			or pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				if pulsed.check(pulsed.states.PULSED_ENTER_VEH)
				then pulsed.increaseStat()
				end
				menu.stat = 2
			end
		end
		if sex.showSexualStats then
			menu.showSexualStats(climax.value, speed.value, pleasure.value)
			menu.ShowSettingTexts(menu.stat, speed.stat, sex.pose, sex.place, true)
		end
		
		-- Is current selector on left menu items ?
		if menu.stat >= SX_MENU_LEFT_FIRST_ELEM and menu.stat <= SX_MENU_LEFT_LAST_ELEM then
			if pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				menu.stat = 0 -- Close Sexual Menu
			end
		end
		
		pulsed.control() -- increase the pulsed stat in case some of the buttons were pulsed, in order to avoid false pulsed detections!
	end
	
	displayRadar(true)
	displayHud(true)
	useRenderCommands(false)
	setTextDrawBeforeFade(false)
	disableAllEntryExits(false)
	
	cursor.finalize()
	
	actors.ChangeGenderSkin(female_gxt, male_gxt, genders.MALE)
	
	repeat -- Avoid the false "enter car" effect when you end the SexMachine
	wait (0)
	until not isButtonPressed(playerchar, pad.ENTERVEHICLE)
	setPlayerEnterCarButton(playerchar, true)
	
	mission.setOnMission(0)
end

--[[===============================================================
===================================================================]]
sex.machine = function()
	local pad		= require("lib.game.keys").player
	local menu		= require("lib.sex-machine.sex-menu")
	local cam		= require("lib.sex-machine.cameras-coordinates").camera
	local cursor	= require("lib.sex-machine.cursor-control")
	local pulsed	= require("lib.sex-machine.machines").PulseButtonMachine
	
	local pleasure	= require("lib.sex-machine.machines").pleasure
	local climax	= require("lib.sex-machine.machines").climax
	local speed		= require("lib.sex-machine.machines").speed
	
	local Increase, Decrease = require("lib.sex-machine.utils").Inc, require("lib.sex-machine.utils").Dec
	local do_nothing = function() end
	
	if sex.stat == 0 then
		if menu.stat == 2 then
			if cursor.clickCheck(203.0, 395.0, 72.0, 11.0) then -- Camera mode Button
				cam.mode = Increase(cam.mode, 1, 1, 2)
				cam.ToggleSexualCamera_Alt(sex.pose, sex.place)
			end
			if cursor.clickCheck(310.0, 395.0, 26.0, 11.0) then -- 'Free' Button
				menu.stat = 8
				cam.setFreeCamera(true, false, sex.pose, sex.place)
			end
			if cursor.clickCheck(340.0, 395.0, 26.0, 11.0) then -- 'Edit' Button
				menu.stat = 8
				cam.setFreeCamera(false, true, sex.pose, sex.place)
			end
		end
		--	Regular sex mode		Offsets mode
		if	menu.stat == 2	or	menu.stat == 3 then
			menu.ManageAnimationsMenu(speed.stat, sex.pose, sex.place, sex.female, sex.male)
		end
		if menu.stat == 8 then
			if cursor.clickCheck(320.0, 224.0, 640.0, 448.0, true) -- Clicked on Full screen box
			or pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				menu.stat = 2
				cam.setFreeCamera(false, false, sex.pose, sex.place)
				if pulsed.check(pulsed.states.PULSED_ENTER_VEH)
				then pulsed.increaseStat()
				end
			end
			if cam.mode == cam.modes.FREE_CAM then
				if isButtonPressed(playerchar, pad.ANSWERPHONE_FIREWEAPONALT) then
					menu.stat = 9
					cursor.show_cursor = true
					cam.fpv.removeFirstPersonPoint()
					cam.createFreeCamCenter()
					menu.InitFrontLookAngle()
				end
			end
		end
		if menu.stat == 9 then
			if cam.freeCamEditMode() -- @FreeCamEditMode ended (clicked on back)
			or pulsed.check(pulsed.states.PULSED_ENTER_VEH) then
				menu.stat = 8
				cam.removeFreeCamCenter()
				cam.ToggleSexualCamera_Alt(sex.pose, sex.place)
				cursor.show_cursor = false
				clearCharTasks(playerPed)
			end
		end

		if menu.stat == 2 then
			if cam.mode == cam.modes.FIXED_CAM then
				local moveAxisX, moveAxisY, specialAxisX, specialAxisY = getPositionOfAnalogueSticks(0)
				if specialAxisX > 100 then -- RIGHT
					sex.stat = 4
					cam.id = Increase(cam.id, 1, 0, 11)
					cam.ToggleSexualCamera_Alt(sex.pose, sex.place)
				end
				if specialAxisX < -100 then -- LEFT
					sex.stat = 5
					cam.id = Decrease(cam.id, 1, 0, 11)
					cam.ToggleSexualCamera_Alt(sex.pose, sex.place)
				end
				if cursor.clickCheck(247.0, 395.0, 13.0, 12.0) then
					cam.id = Decrease(cam.id, 1, 0, 11)
					cam.ToggleSexualCamera_Alt(sex.pose, sex.place)
				elseif cursor.clickCheck(263.0, 395.0, 13.0, 12.0) then
					cam.id = Increase(cam.id, 1, 0, 11)
					cam.ToggleSexualCamera_Alt(sex.pose, sex.place)
				end
			end
		end
	end
	if sex.stat == 1 then
		if not isButtonPressed(playerchar, pad.CHANGECAMERAVIEW)
		then sex.stat = 0
		end
	elseif sex.stat == 2 then
		if not isButtonPressed(playerchar, pad.ANSWERPHONE_FIREWEAPONALT)
		then sex.stat = 0
		end
	elseif sex.stat == 4 then
		if specialAxisX < 100
		then sex.stat = 0
		end
	elseif sex.stat == 5 then
		if specialAxisX > -100
		then sex.stat = 0
		end
	end
	
	-- Increase / Decrease Speed (Keypresses / Clickable bar)
	speed.control(menu.stat, cam.fpv.edit_mode, cam.fpv.moveable)

	-- Increase Pleasure
	local pleasure_machine = (speed.value > 13) and pleasure.machine or do_nothing
	pleasure_machine()

	-- Increase Climax
	climax.machine(speed.value)

	-- Change from stopped to slow or fast
	speed.machine(sex.female, sex.male, sex.pose, sex.place)

	-- First Person Camera control
	if not(menu.stat == 3) then
		cam.fpv.control(cam.mode) -- FirstPersonCameraControl_Alt
	end

	-- Keys Control for Edit Mode
	if not(menu.stat == 3) then
		cam.fpv.keyscontrol(cam.mode, cam.id) -- 0AB1: @FirstPersonCameraMoveable_KeysControl 2 camera Dummy2 cam_id Dummy3
	end
end

return sex