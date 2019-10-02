local module = {}

--[[===============================================================
===================================================================]]
module.constants = {
	CC_SIZE_X = 22.0,
	CC_SIZE_Y = 22.0,
}

--[[===============================================================
===================================================================]]
module.init = function()
	--loadTextureDictionary('ftend')
	--module.texture_id = loadSprite("smouse")
	module.texture = renderLoadTextureFromFile("modloader/Date&Sex/models/txd/smouse.png")
	setTextDrawBeforeFade(true) -- draw_text_behind_textures
	local resX, resY = getScreenResolution()
	module.posX = resX / 2.0
	module.posY = resY / 2.0
	module.show_cursor = true
	module.clickX, module.clickY = 0.0, 0.0
	module.clicked = false
	module.enable = true
end

--[[===============================================================
===================================================================]]
module.finalize = function ()
	renderReleaseTexture(module.texture)
end

--[[===============================================================
===================================================================]]
module.control = function()
	if module.enable then
		local pad = require("lib.game.keys").player
		local resX, resY = getScreenResolution()
		local SIZE_X, SIZE_Y = module.constants.CC_SIZE_X, module.constants.CC_SIZE_Y
		local x, y = getPcMouseMovement()
		
		module.posX = module.posX + x
		if		module.posX < 0.0		then	module.posX = 0.0
		elseif	module.posX > resX		then	module.posX = resX
		end
		
		module.posY = module.posY - y
		if		module.posY < 0.0		then	module.posY = 0.0
		elseif	module.posY > resY		then	module.posY = resY
		end
		
		setSpritesDrawBeforeFade(true) -- set_texture_to_be_drawn_antialiased
		if module.show_cursor then
			x, y = module.posX+SIZE_X/2.0-10.0, module.posY+SIZE_Y/2.0-10.0
			--drawSprite(1, x, y, SIZE_X, SIZE_Y, 255, 255, 255, 255)
			renderDrawTexture(module.texture, x, y, SIZE_X, SIZE_Y, 0.0, -1)
		end
		
		if isButtonPressed(playerchar, pad.FIREWEAPON) then -- click
			module.clickX, module.clickY = module.posX, module.posY
		elseif module.clicked then
			module.clicked = false
		end
	end
end

--[[===============================================================
===================================================================]]
module.terminate = function()
	renderReleaseTexture(module.texture)
	module.show_cursor = false
end

--[[===============================================================
===================================================================]]
module.getCorners = function(centerX, centerY, sizeX, sizeY)
	local upLeftX, upLeftY, downRightX, downRightY = centerX-sizeX/2.0, centerY-sizeY/2.0, centerX+sizeX/2.0, centerY+sizeY/2.0
	return upLeftX, upLeftY, downRightX, downRightY
end

--[[===============================================================
===================================================================]]
module.clickCheck = function(x, y, w, h, disable_shadow, r, g, b, a)
	local pad = require("lib.game.keys").player
	disable_shadow, r, g, b, a = disable_shadow or false, r or 0, g or 0, b or 0, a or 100
	local void = function() end
	
	(module.positionCheck(x, y, w, h) and not disable_shadow and drawRect or void)(x,y,w,h,r,g,b,a)
	
	if module.clicked or not isButtonPressed(playerchar, pad.FIREWEAPON) then
		return false
	end
	if module.positionCheck(x, y, w, h) then
		module.clicked = true
		return true
	else return false
	end
end

--[[===============================================================
===================================================================]]
module.getClickPosition = function()
	if module.clicked or not isButtonPressed(playerchar, pad.FIREWEAPON) then
	end -- dude what the hell i was doing here??
	return module.clickX, module.clickY
end

--[[===============================================================
===================================================================]]
module.positionCheck = function (x, y, w, h)
	x, y = module.conversion(x, y)
	w, h = module.conversion(w, h)
	local upLeftX, upLeftY, downRightX, downRightY = module.getCorners(x, y, w, h)
	return module.posX >= upLeftX and module.posX <= downRightX and module.posY >= upLeftY and module.posY <= downRightY
end

--[[===============================================================
===================================================================]]
module.conversion = function (x, y)
	local resX, resY = getScreenResolution()
	local convX, convY = resX/640.0, resY/448.0
	return x*convX, y*convY
end

--[[===============================================================
===================================================================]]
module.waitUntilReleaseClickButton = function()
	local pad = require("lib.game.keys").player
	repeat
	wait (0)
	until not isButtonPressed(playerchar, pad.FIREWEAPON) -- CLICK
end

return module