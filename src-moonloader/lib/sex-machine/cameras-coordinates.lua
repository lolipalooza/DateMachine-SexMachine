local module = {}

module.coordinates = {}

module.coordinates.player			= { x=0, y=0, z=0, a=0 }
module.coordinates.player_offset	= { x=0, y=0, z=0, a=0 }

module.coordinates.female			= { x=0, y=0, z=0, a=0 }
module.coordinates.male				= { x=0, y=0, z=0, a=0 }

-- Female
module.coordinates.getFemOffsets = function()
	return module.coordinates.female.x, module.coordinates.female.y, module.coordinates.female.z, module.coordinates.female.a
end
module.coordinates.setFemOffsets = function(x, y, z, a)
	a = a or module.coordinates.female.a
	module.coordinates.female.x, module.coordinates.female.y, module.coordinates.female.z = x,y,z
	module.coordinates.female.a = a
end

-- Male
module.coordinates.getMaleOffsets = function()
	return module.coordinates.male.x, module.coordinates.male.y, module.coordinates.male.z, module.coordinates.male.a
end
module.coordinates.setMaleOffsets = function(x, y, z, a)
	a = a or module.coordinates.male.a
	module.coordinates.male.x, module.coordinates.male.y, module.coordinates.male.z = x, y, z
	module.coordinates.male.a = a
end

-- Player
module.coordinates.getPlayerPos = function()
	return module.coordinates.player.x, module.coordinates.player.y, module.coordinates.player.z, module.coordinates.player.a
end
module.coordinates.setPlayerPos = function(x, y, z, a)
	a = a or module.coordinates.player.a
	module.coordinates.player.x, module.coordinates.player.y, module.coordinates.player.z = x,y,z
	module.coordinates.player.a = a
end

-- Player Offset
module.coordinates.getPlayerOffsets = function()
	return module.coordinates.player_offset.x, module.coordinates.player_offset.y, module.coordinates.player_offset.z, module.coordinates.player_offset.a
end
module.coordinates.setPlayerOffsets = function(x, y, z, a)
	a = a or module.coordinates.player_offset.a
	module.coordinates.player_offset.x, module.coordinates.player_offset.y, module.coordinates.player_offset.z = x,y,z
	module.coordinates.player_offset.a = a
end

--[[===============================================================
===================================================================]]
module.camera = {}

module.camera.mode = 0
module.camera.id = 0

module.camera.modes = {
	FREE_CAM = 0,
	FIXED_CAM = 1,
	FPV_CAM = 2,
}

module.camera.fpv = {}
module.camera.fixed = {}

--[[===============================================================
===================================================================]]
function module.camera.ToggleSexualCamera_Alt(pose, place)
	local FREE_CAM, FIXED_CAM, FPV_CAM = module.camera.modes.FREE_CAM, module.camera.modes.FIXED_CAM, module.camera.modes.FPV_CAM
	local cam = module.camera.mode
	if cam == FREE_CAM then
		module.camera.fpv.removeFirstPersonPoint()
		module.camera.relocateFreeCamCenter()
		restoreCameraJumpcut()
	elseif cam == FIXED_CAM then
		module.camera.fpv.removeFirstPersonPoint()
		local x, y, z, a, rot, tx = module.camera.fixed.get(module.camera.id)
		x, y, z, a, tx = module.camera.fixed.init(x, y, z, a, rot, tx)
		module.camera.fpv.createFirstPersonPoint(x, y, z, a, tx)
	elseif cam == FPV_CAM then
		module.camera.fpv.removeFirstPersonPoint()
		local x, y, z, a, rot, tx = module.camera.fpv.get()
		x, y, z, a, tx = module.camera.fpv.init(x, y, z, a, rot, tx)
		module.camera.fpv.createFirstPersonPoint(x, y, z, a, tx)
	end
end

--[[===============================================================
===================================================================]]
function module.camera.freezeCamera()
	local FREE_CAM, FIXED_CAM, FPV_CAM = module.camera.modes.FREE_CAM, module.camera.modes.FIXED_CAM, module.camera.modes.FPV_CAM
	local cam = module.camera.mode
	if cam == FREE_CAM then
		local x,y,z = getActiveCameraCoordinates()
		setFixedCameraPosition(x,y,z,0,0,0)
		x,y,z = getActiveCameraPointAt()
		pointCameraAtPoint(x,y,z,2)
	elseif cam == FPV_CAM then
		module.camera.fpv.moveable = false
	end
end

--[[===============================================================
===================================================================]]
function module.camera.restoreCamera(reset, pose, place)
	local FREE_CAM, FIXED_CAM, FPV_CAM = module.camera.modes.FREE_CAM, module.camera.modes.FIXED_CAM, module.camera.modes.FPV_CAM
	local cam = module.camera.mode
	if cam == FREE_CAM then
		setCameraInFrontOfPlayer()
		restoreCameraJumpcut()
	elseif cam == FREE_CAM then
		module.camera.ToggleSexualCamera_Alt(pose, place)
	elseif cam == FREE_CAM then
		if reset then
			module.camera.ToggleSexualCamera_Alt(pose, place)
			module.camera.fpv.moveable = true
		end
	end
end

--[[===============================================================
===================================================================]]
function module.camera.setFreeCamera(free_mode, edit_mode, pose, place)
	local cursor = require("lib.sex-machine.cursor-control")
	local FREE_CAM, FIXED_CAM, FPV_CAM = module.camera.modes.FREE_CAM, module.camera.modes.FIXED_CAM, module.camera.modes.FPV_CAM
	local cam = module.camera.mode
	if free_mode or edit_mode then
		module.camera.fpv.moveable = true
		cursor.show_cursor = false
	else
		module.camera.fpv.moveable = false
		cursor.show_cursor = true
	end
	if cam == FREE_CAM and not free_mode then
		module.camera.mode = FIXED_CAM
		module.camera.ToggleSexualCamera_Alt(pose, place)
	end
	if cam == FIXED_CAM and free_mode then
		module.camera.mode = FREE_CAM
		module.camera.ToggleSexualCamera_Alt(pose, place)
	end
	if cam == FIXED_CAM or cam == FPV_CAM then
		module.camera.fpv.edit_mode = edit_mode
		module.camera.ToggleSexualCamera_Alt(pose, place)
	end
end

--[[===============================================================
===================================================================]]
function module.camera.relocateFreeCamCenter(plyX, plyY, plyZ, offsX, offsY, offsZ)
	local coords = module.coordinates
	local plyX, plyY, plyZ = coords.getPlayerPos()
	local offsX, offsY, offsZ = coords.getPlayerOffsets()
	setCharCoordinates(playerPed, plyX+offsX, plyY+offsY, plyZ+offsZ)
	--taskPlayAnim(playerPed, "sex_pose", "ped", 4.0, true, false, false, false, -1)
end

--[[===============================================================
===================================================================]]
--[[function module.camera.fpv.control1() -- FirstPersonCameraControl
	if doesCharExist(module.camera.fpv.actor) then
		if module.camera.mode == module.camera.modes.FPV_CAM then
			local x, y = getPcMouseMovement()
			local a = getCharHeading(module.camera.fpv.actor)
			local min_a, max_a = module.camera.fpv.min_angle, module.camera.fpv.max_angle
			local rot, min_rot, max_rot = module.camera.fpv.rotation, module.camera.fpv.min_rotation, module.camera.fpv.max_rotation
			a = a - x
			rot = rot + y/200.0
			if	rot > max_rot	then	rot = max_rot	end
			if	rot < min_rot	then	rot = min_rot	end
			if	a > max_a		then	a = max_a		end
			if	a < min_a		then	a = min_a		end
			setCharHeading(module.camera.fpv.actor, a)
			attachCameraToChar(module.camera.fpv.actor, 0.0, 0.0, -1.0, 0.0, 0.5, rot, 0.0, 2)
			module.camera.fpv.rotation = rot
		end
	end
end]]

--[[===============================================================
===================================================================]]
function module.camera.fpv.init(x, y, z, angle, rotation, trgt_x) -- InitFirstPersonCameraVars_Alt
	if x == 0.0 and y == 0.0 and z == 0.0 and angle == 0.0 and rotation == 0.0 and trgt_x == 0.0 then
		x, y, z, angle, rotation = 0.15, 0.8, 0.65, 165.0, -1.25
	end
	local coords = module.coordinates
	local plyX, plyY, plyZ = coords.getPlayerPos()
	x, y, z = x+plyX, y+plyY, z+plyZ
	module.camera.fpv.rotation = rotation
	module.camera.fpv.min_rotation = rotation - 0.4
	module.camera.fpv.max_rotation = rotation + 0.4
	module.camera.fpv.min_angle = angle - 45.0
	module.camera.fpv.max_angle = angle + 45.0
	--module.camera.fpv.edit_mode = false
	--module.camera.fpv.moveable = false
	return x, y, z, angle, trgt_x
end

--[[===============================================================
===================================================================]]
function module.camera.fpv.control(cam_mode) --FirstPersonCameraControl_Alt
	local FREE_CAM, FIXED_CAM, FPV_CAM = module.camera.modes.FREE_CAM, module.camera.modes.FIXED_CAM, module.camera.modes.FPV_CAM
	if cam_mode == FIXED_CAM or cam_mode == FPV_CAM then
		if doesCharExist(module.camera.fpv.actor) then
			local rotation, min_rot, max_rot = module.camera.fpv.rotation, module.camera.fpv.min_rotation, module.camera.fpv.max_rotation
			local min_a, max_a = module.camera.fpv.min_angle, module.camera.fpv.max_angle
			local angle = 0
			if module.camera.fpv.moveable then
				local x, y = getPcMouseMovement()
				angle = getCharHeading(module.camera.fpv.actor)
				angle = angle - x
				rotation = rotation + y/200.0
			end
			if	not module.camera.fpv.edit_mode		and		cam_mode == FPV_CAM		then
				if	rotation > max_rot	then	rotation = max_rot	end
				if	rotation < min_rot	then	rotation = min_rot	end
				if	angle > max_a		then	angle = max_a		end
				if	angle < min_a		then	angle = min_a		end
			end
			if module.camera.fpv.moveable then
				setCharHeading(module.camera.fpv.actor, angle)
			end
			attachCameraToChar(module.camera.fpv.actor, 0.0, 0.0, -1.0, 0.0, 0.5, rotation, 0.0, 2)
			module.camera.fpv.rotation = rotation
		end
	end
end

--[[===============================================================
===================================================================]]
module.camera.fpv.CamsOffsetsMenu_FPVCamPosition = {0,0,0}
module.camera.fpv.CamsOffsetsMenu_FPVCamAngle = 0
module.camera.fpv.CamsOffsetsMenu_FPVCamRotation = 0
module.camera.fpv.CamsOffsetsMenu_FPVCamTrgtX = 0

module.camera.fpv.store = function (x, y, z, a, rot, tx) -- storeFPVCamData
	local fpv = module.camera.fpv
	fpv.CamsOffsetsMenu_FPVCamPosition[1] = x
	fpv.CamsOffsetsMenu_FPVCamPosition[2] = y
	fpv.CamsOffsetsMenu_FPVCamPosition[3] = z
	fpv.CamsOffsetsMenu_FPVCamAngle = a
	fpv.CamsOffsetsMenu_FPVCamRotation = rot
	fpv.CamsOffsetsMenu_FPVCamTrgtX = z
end

module.camera.fpv.get = function () -- getFPVCamData
	local fpv = module.camera.fpv
	local x, y, z = fpv.CamsOffsetsMenu_FPVCamPosition[1], fpv.CamsOffsetsMenu_FPVCamPosition[2], fpv.CamsOffsetsMenu_FPVCamPosition[3]
	local a, rot, tx = fpv.CamsOffsetsMenu_FPVCamAngle, fpv.CamsOffsetsMenu_FPVCamRotation, fpv.CamsOffsetsMenu_FPVCamTrgtX
	return x, y, z, a, rot, tx
end

--[[===============================================================
===================================================================]]
function module.camera.fpv.createFirstPersonPoint(x, y, z, a, tx)
	if not doesCharExist(module.camera.fpv.actor) then
		local model = require("lib.game.models")
		local pedtype = {MISSION1 = 24}
		requestModel(model.NULL)
		repeat
		wait (0)
		until hasModelLoaded(model.NULL)
		module.camera.fpv.actor = createChar(pedtype.MISSION1, model.NULL, x, y, z)
		setCharHealth(module.camera.fpv.actor, 2000)
		setCharProofs(module.camera.fpv.actor, true, true, true, true, true)
		setCharHeading(module.camera.fpv.actor, a)
		setCharVisible (module.camera.fpv.actor, false)
		setCharCollision(module.camera.fpv.actor, false)
		markModelAsNoLongerNeeded(model.NULL)
	else
		setCharCoordinates(module.camera.fpv.actor, x, y, z)
		setCharHeading(module.camera.fpv.actor, a)
	end
end

--[[===============================================================
===================================================================]]
function module.camera.fpv.removeFirstPersonPoint()
	local x, y, z = getActiveCameraCoordinates()
	local tx, ty, tz = getActiveCameraPointAt()
	setFixedCameraPosition(x, y, z, 0.0, 0.0, 0.0)
	pointCameraAtPoint(tx, ty, tz, 2)
	if	doesCharExist(module.camera.fpv.actor)	then	deleteChar(module.camera.fpv.actor)		end
end

--[[===============================================================
===================================================================]]
function module.camera.fpv.moveFirstPersonPoint(cam_mode, cam_id, sides, front, height, speed)
	if doesCharExist(module.camera.fpv.actor) then
		sides, front, height = sides*speed, front*speed, height*speed - 1.0
		local x, y, z = getOffsetFromCharInWorldCoords(module.camera.fpv.actor, sides, front, height)
		setCharCoordinates(module.camera.fpv.actor, x, y, z)
		
		local cx, cy, cz = getActiveCameraCoordinates()
		local tx, ty, tz = getActiveCameraPointAt()
		local a = getCharHeading(module.camera.fpv.actor)
		local rot = module.camera.fpv.rotation
		
		local coords = module.coordinates
		local plyX, plyY, plyZ = coords.getPlayerPos()
		x, y, z = x-plyX, y-plyY, z-plyZ
		
		local FREE_CAM, FIXED_CAM, FPV_CAM = module.camera.modes.FREE_CAM, module.camera.modes.FIXED_CAM, module.camera.modes.FPV_CAM
		if cam_mode == FIXED_CAM then
			local femX, femY, femZ = coords.getFemOffsets()
			x, y, z = x-femX, y-femY, z-femZ
			module.camera.fixed.store(cam_id, x, y, z, a, rot, tx)
		elseif cam_mode == FPV_CAM then
			module.camera.fpv.store(x, y, z, a, rot, tx)
		end
	end
end

--[[===============================================================
===================================================================]]
module.camera.fixed.points = {
	{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0},
}

function module.camera.fixed.get(cam_id) -- GetFixedCam
	local cam = module.camera.fixed.points[cam_id + 1]
	local cx, cy, cz = cam[1], cam[2], cam[3]
	local tx, ty, tz = cam[4], cam[5], cam[6]
	return cx, cy, cz, tx, ty, tz -- x, y, z, a, rot, tx
end

--[[===============================================================
===================================================================]]
function module.camera.fixed.store(cam_id, x, y, z, a, rot, tx) -- StoreFixedCam
	local cam = module.camera.fixed.points[cam_id + 1]
	cam[1], cam[2], cam[3] = x, y, z
	cam[4], cam[5], cam[6] = a, rot, tx
end

--[[===============================================================
===================================================================]]
function module.camera.fixed.init(x, y, z, a, rot, tx) -- InitFixedCam
	if x==0 and y==0 and z==0 and a==0 and rot==0 and tx==0 then
		x, y, z, a, rot = 0.8, -1.22, 1.0, 30.0, -1.32
	end
	
	local coords = module.coordinates
	local plyX, plyY, plyZ = coords.getPlayerPos()
	local femX, femY, femZ = coords.getFemOffsets()
	
	x, y, z = x+plyX+femX, y+plyY+femY, z+plyZ+femZ
	module.camera.fpv.rotation = rot
	return x, y, z, a, tx
end

--[[===============================================================
===================================================================]]
--[[function module.camera.fixed.move(cam_id, sides, front, height, speed) -- MoveFixedCamPoint
	if doesCharExist(module.camera.fpv.actor) then
		sides, front, height = sides*speed, front*speed, height*speed - 1.0
		local x, y, z = getOffsetFromCharInWorldCoords(module.camera.fpv.actor, sides, front, height)
		setCharCoordinates(module.camera.fpv.actor, x, y, z)
		
		local cx, cy, cz = getActiveCameraCoordinates()
		local tx, ty, tz = getActiveCameraPointAt()
		local a = getCharHeading(playerPed)
		local rot = module.camera.fpv.rotation
		
		local coords = module.coordinates
		local plyX, plyY, plyZ = coords.getPlayerPos()
		local femX, femY, femZ = coords.getFemOffsets()
		x, y, z = x-plyX-femX, y-plyY-femY, z-plyZ-femZ
		module.camera.fixed.store(cam_id, x, y, z, a, rot, tx)
	end
end]]

--[[===============================================================
===================================================================]]
module.camera.fpv.joystickOffset = {x=0,y=0}

function module.camera.fpv.keyscontrol(cam_mode, cam_id) -- FirstPersonCameraMoveable_KeysControl
	if module.camera.fpv.edit_mode then
		local KEY_F6, KEY_F3, KEY_W, KEY_A, KEY_S, KEY_D, KEY_Q, KEY_E, KEY_SHIFT = 117, 114, 87, 65, 83, 68, 81, 69, 16
		local speed = isKeyDown(KEY_SHIFT) and 0.05 or 0.01
		local move_point, do_nothing = module.camera.fpv.moveFirstPersonPoint, function(n,u,l,l,e,d) end

		-- Player moved the mouse cursor?
		local joyOffsX0, joyOffsY0 = module.camera.fpv.joystickOffset.x, module.camera.fpv.joystickOffset.y
		local joyOffsX, joyOffsY = getPcMouseMovement()
		local cursor_moved_flag = not (joyOffsX==joyOffsX0) or not (joyOffsY==joyOffsY0)
		
		--local pressedW, pressedS, pressedD, pressedA, pressedE, pressedQ = isKeyDown(KEY_W), isKeyDown(KEY_S), isKeyDown(KEY_D), isKeyDown(KEY_A), isKeyDown(KEY_E), isKeyDown(KEY_Q)
		
		if isKeyDown(KEY_W)		then	move_point(cam_mode, cam_id,  0,  1,  0, speed)		end
		if isKeyDown(KEY_S)		then	move_point(cam_mode, cam_id,  0, -1,  0, speed)		end
		if isKeyDown(KEY_D)		then	move_point(cam_mode, cam_id,  1,  0,  0, speed)		end
		if isKeyDown(KEY_A)		then	move_point(cam_mode, cam_id, -1,  0,  0, speed)		end
		if isKeyDown(KEY_E)		then	move_point(cam_mode, cam_id,  0,  0,  1, speed)		end
		if isKeyDown(KEY_Q)		then	move_point(cam_mode, cam_id,  0,  0, -1, speed)		end
		if cursor_moved_flag	then	move_point(cam_mode, cam_id,  0,  0,  0, speed)		end
		
		--[[
		( pressedW			and move_point or do_nothing )(cam_mode, cam_id,  0,  1,  0, speed)
		( pressedS			and move_point or do_nothing )(cam_mode, cam_id,  0, -1,  0, speed)
		( pressedD			and move_point or do_nothing )(cam_mode, cam_id,  1,  0,  0, speed)
		( pressedA  		and move_point or do_nothing )(cam_mode, cam_id, -1,  0,  0, speed)
		( pressedE  		and move_point or do_nothing )(cam_mode, cam_id,  0,  0,  1, speed)
		( pressedQ  		and move_point or do_nothing )(cam_mode, cam_id,  0,  0, -1, speed)
		( cursor_moved_flag and move_point or do_nothing )(cam_mode, cam_id,  0,  0,  0, speed)
		]]
	end
end

--[[===============================================================
===================================================================]]
function module.camera.freeCamEditMode_Controls()
	local KEY_F6, KEY_F3, KEY_W, KEY_A, KEY_S, KEY_D, KEY_Q, KEY_E, KEY_SHIFT = 117, 114, 87, 65, 83, 68, 81, 69, 16
	local speed = isKeyDown(KEY_SHIFT) and 0.05 or 0.01
	local move_point, do_nothing = module.camera.moveFreeCamCenter_Alt, function(v,o,i,d) end
		
	if isKeyDown(KEY_W)		then	move_point(  0,  1,  0, speed)		end
	if isKeyDown(KEY_S)		then	move_point(  0, -1,  0, speed)		end
	if isKeyDown(KEY_D)		then	move_point(  1,  0,  0, speed)		end
	if isKeyDown(KEY_A)		then	move_point( -1,  0,  0, speed)		end
	if isKeyDown(KEY_E)		then	move_point(  0,  0,  1, speed)		end
	if isKeyDown(KEY_Q)		then	move_point(  0,  0, -1, speed)		end
	
	--[[
	( isKeyDown(KEY_W) and move_point or do_nothing )(  0,  1,  0, speed )
	( isKeyDown(KEY_S) and move_point or do_nothing )(  0, -1,  0, speed )
	( isKeyDown(KEY_D) and move_point or do_nothing )(  1,  0,  0, speed )
	( isKeyDown(KEY_A) and move_point or do_nothing )( -1,  0,  0, speed )
	( isKeyDown(KEY_E) and move_point or do_nothing )(  0,  0,  1, speed )
	( isKeyDown(KEY_Q) and move_point or do_nothing )(  0,  0, -1, speed )
	]]
end

--[[===============================================================
===================================================================]]
function module.camera.freeCamEditMode()
	local DrawText = require("lib.sex-machine.utils").DrawText
	local cursor = require("lib.sex-machine.cursor-control")
	local menu = require("lib.sex-machine.sex-menu")
	local angle = menu.GetFrontLookAngle(0.313)
	angle = menu.RoundAngle(angle)
	setCharHeading(playerPed, angle)
	
	menu.AttachActorTo(3, playerPed) -- object
	module.camera.freeCamEditMode_Controls()
	DrawText.set(2, 600.0, 330.0, 390.0, 0.2, 1.0, 'CFSV_7') -- Back
	if cursor.clickCheck(340.0, 395.0, 26.0, 11.0) then -- Close or Back
		return true
	else return false
	end
end

--[[===============================================================
===================================================================]]
module.camera.free = {}

function module.camera.createFreeCamCenter()
	if not doesObjectExist(module.camera.free.center) then
		local INFO, DIAMOND_3, CAMERAPICKUP = 1239, 1559, 1253
		requestModel(CAMERAPICKUP)
		loadAllModelsNow()
		repeat
		wait (0)
		until hasModelLoaded(CAMERAPICKUP)
		local coords = module.coordinates
		local plyX, plyY, plyZ = coords.getPlayerPos()
		local offsX, offsY, offsZ = coords.getPlayerOffsets()
		module.camera.free.center = createObjectNoOffset(CAMERAPICKUP, plyX+offsX, plyY+offsY, plyZ+offsZ+1.0)
		markModelAsNoLongerNeeded(CAMERAPICKUP)
	end
end

--[[===============================================================
===================================================================]]
function module.camera.removeFreeCamCenter()
	if	doesObjectExist(module.camera.free.center)	then	deleteObject(module.camera.free.center)		end
end

--[[===============================================================
===================================================================]]
--[[function module.camera.moveFreeCamCenter(step_x, step_y, step_z)
	local menu = require("lib.sex-machine.sex-menu")

	local coords = module.coordinates
	local plyX, plyY, plyZ = coords.getPlayerPos()
	local offsX, offsY, offsZ = coords.getPlayerOffsets()

	offsX, offsY, offsZ = offsX+step_x, offsY+step_y, offsZ+step_z
	local x, y, z = plyX+offsX+step_x, plyY+offsY+step_y, plyZ+offsZ+step_z+1.0	

	setObjectCoordinates(module.camera.free.center, x, y, z)
	menu.ActorsOffsets_SetFixedCamera(object)
	
	coords.setPlayerOffsets(offsX, offsY, offsZ)
end]]

--[[===============================================================
===================================================================]]
function module.camera.setFreeCamCenter(x, y, z)
	setObjectCoordinates(module.camera.free.center, x, y, z+1.0)
end

--[[===============================================================
===================================================================]]
function module.camera.moveFreeCamCenter_Alt(sides, front, height, speed)
	local x, y, z = getOffsetFromCharInWorldCoords(playerPed, sides*speed, front*speed, height*speed-1.0)
	module.camera.setFreeCamCenter(x, y, z)
	
	local coords = module.coordinates
	local plyX, plyY, plyZ = coords.getPlayerPos()
	
	local offsX, offsY, offsZ = x-plyX, y-plyY, z-plyZ
	coords.setPlayerOffsets(offsX, offsY, offsZ)
end

--[[===============================================================
===================================================================]]
return module


--[[===============================================================
===================================================================]]
--[[
:ARC_SIN // 0@
if 0@ == 1.0
then 31@ = 90.0
end
if 0@ == -1.0
then 31@ = -90.0
end
if and
0@ > -1.0
1.0 > 0@
then
    1@ = 51.0 // The greater this number, the better (i guess)
    31@ = 0.0
    for 10@ = 1.0 to 1@ step 2.0
        2@ = 1.0
        for 3@ = 1.0 to 10@ step 2.0
            006B: 2@ *= 3@  // (float)
        end
        
        4@ = 1.0
        0087: 5@ = 10@ // (float)
        5@ += 1.0
        for 3@ = 2.0 to 5@ step 2.0
            006B: 4@ *= 3@  // (float)
        end
        
        0087: 30@ = 0@ // (float)
        0AEE: 30@ = 30@ exp 10@ //all floats
        0073: 30@ /= 10@ // (float)
        006B: 30@ *= 2@  // (float)
        0073: 30@ /= 4@ // (float)
        
        005B: 31@ += 30@  // (float)
    end
    const
        NUM_PI = 3.14159265359
    end
    31@ *= 180.0
    31@ /= NUM_PI
else 31@ = 0.0 // ??
end
0AB2: ret 1 31@




:ARC_TAN // value 0@
1@ = 10 // This number is supposed to be as big as possible
31@ = 0.0
for 2@ = 0 to 1@
    0093: 3@ = integer 1@ to_float
    
    4@ = -1.0
    0AEE: 4@ = 4@ exp 3@ //all floats
    
    0087: 5@ = 3@ // (float)
    5@ *= 2.0
    5@ += 1.0
    
    0AEE: 30@ = 0@ exp 5@ //all floats
    006B: 30@ *= 4@  // (float)
    0073: 30@ /= 5@ // (float)
    
    005B: 31@ += 30@  // (float)
end
0AB2: ret 1 result 31@]]

