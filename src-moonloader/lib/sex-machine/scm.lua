local module = {}

--[[===============================================================
===================================================================--]]
function module.copyDirectory(origdir, destdir)
	startNewCustomScript(
		"opcode.s",
	--							0B05: copy_dir	0E + string length	origin path		0E string length	dest path	0A93: end_custom_script		NOP instructions
		module.convertToSCM({	0x05,0x0B,		0x0E,#origdir,		origdir,		0x0E,#destdir,		destdir,	0x93,0x0A,					0x00,0x00,0x00,0x00	})
	)
end

--[[===============================================================
function deleteDirectory(string path [, int include_subdirs_flag])
===================================================================--]]
function module.deleteDirectory(path, flag)
	flag = flag or 1 -- for some reason, setting flag as "0" don't remove the directory, so let's establish it as 1 by default!
	startNewCustomScript(
		"opcode.s",
	--							0B01: delete_dir	0E + string length	path string		04 include_subdirs_flag		0A93: end_custom_script		NOP instructions
		module.convertToSCM({	0x01,0x0B,			0x0E,#path,			path,			0x04,flag,					0x93,0x0A,					0x00,0x00,0x00,0x00	})
	)
end

--[[===============================================================
function loadTexture(GxtString dictionary, string texture, int slot)
===================================================================--]]
function module.loadTexture(dictionary, texture, slot)
	local d = module.convertGxtStringToBytes(dictionary)
	startNewCustomScript(
		"opcode.s",
	--							0390: load_txd_dictionary	09		dictionary(gxt)								038F: load_texture	04 + slot		0E + string length		texture_name		0A93: end_custom_script		NOP instructions
		module.convertToSCM({	0x90,0x03,					0x09,	d[1],d[2],d[3],d[4],d[5],d[6],d[7],d[8],	0x8F,0x03,			0x04,slot,		0x0E,#texture,			texture,			0x93,0x0A,					0x00,0x00,0x00,0x00	})
	)
end

--[[===============================================================
function drawTexture(int slot, float posX, float posY, float width, float height, int r, int g, int b, int a)
===================================================================--]]
function module.drawTexture(slot, posX, posY, width, height, r, g, b, a)
	local x = module.convertFloatToBytes(posX)
	local y = module.convertFloatToBytes(posY)
	local w = module.convertFloatToBytes(width)
	local h = module.convertFloatToBytes(height)
	startNewCustomScript(
		"opcode.s",
	--							038D: draw_texture	04 slot			06 (float) pos_x			06 (float) pos_y			06 (float) size_x			06 (float) size_y					0A93: end_custom_script		NOP instructions
		module.convertToSCM({	0x8D,0x03,			0x04,slot,		0x06,x[1],x[2],x[3],x[4],	0x06,y[1],y[2],y[3],y[4],	0x06,w[1],w[2],w[3],w[4],	0x06,h[1],h[2],h[3],h[4],			0x93,0x0A,					0x00,0x00,0x00,0x00	})
	)
end

--[[===============================================================
===================================================================--]]
function module.convertToSCM(arr) -- rules: array must be only numbers <= 255 (0xFF), or strings (large as you want!)
	local i,j,b
	local output = {} -- will be dword (byte32) numbers array (warning!: output shouldn't be larger than 32 elements!)
	local arr2 = {}
	for i=1,#arr do
		if ( type(arr[i]) == "number" ) then
			table.insert(arr2, arr[i])
		elseif ( type(arr[i]) == "string" ) then
			for j=1,#arr[i] do
				table.insert( arr2, string.byte(arr[i]:sub(j,j)) )
			end
		end
	end
	j,b=0,0
	for i=1,#arr2 do
		b = b + arr2[i]*2^(8*j)
		j=j+1
		if (j == 4) then
			table.insert( output, b )
			j,b=0,0
		end
	end
	--[[for i=1,#output do
	WriteLineInLog("moonloader/test.log", string.format( "0x%X", output[i] ))
	end]]
	return output
end

--[[===============================================================
===================================================================--]]
function module.convertStringToByte32(str)
	local b,i = 0,0
	for i=1,4 do
		local c = string.byte(str:sub(i,i))
		b = b + c * 2^(8*(i-1))
	end
	return b
end

--[[===============================================================
table b = function convertGxtStringToBytes(GxtString gxt)
===================================================================--]]
function module.convertGxtStringToBytes(gxt_string) --  gxt strings are strings with 7 characters as maximum length
	if #gxt_string <= 7 then
		local i,b = 0,{}
		for i=1,8 do
			local c = string.byte(gxt_string:sub(i,i))
			table.insert( b, not(c==nil) and c or 0 )
		end
		return b
	end
end

function module.convertFloatToBytes(flt) --  gxt strings are strings with 7 characters as maximum length
	local n = float2hex (flt)
	return { n%0x100, (n/0x100)%0x100, (n/0x10000)%0x100, n/0x1000000 }
end

-- If this holy shiet really works, it came from here:
-- https://stackoverflow.com/questions/18886447/convert-signed-ieee-754-float-to-hexadecimal-representation
function float2hex (n)
    if n == 0.0 then return 0.0 end

    local sign = 0
    if n < 0.0 then
        sign = 0x80
        n = -n
    end

    local mant, expo = math.frexp(n)
    local hext = {}

    if mant ~= mant then
        hext[#hext+1] = string.char(0xFF, 0x88, 0x00, 0x00)
    elseif mant == math.huge or expo > 0x80 then
        if sign == 0 then
            hext[#hext+1] = string.char(0x7F, 0x80, 0x00, 0x00)
        else
            hext[#hext+1] = string.char(0xFF, 0x80, 0x00, 0x00)
        end
    elseif (mant == 0.0 and expo == 0) or expo < -0x7E then
        hext[#hext+1] = string.char(sign, 0x00, 0x00, 0x00)
    else
        expo = expo + 0x7E
        mant = (mant * 2.0 - 1.0) * math.ldexp(0.5, 24)
        hext[#hext+1] = string.char(sign + math.floor(expo / 0x2),
                                    (expo % 0x2) * 0x80 + math.floor(mant / 0x10000),
                                    math.floor(mant / 0x100) % 0x100,
                                    mant % 0x100)
    end

    return tonumber(string.gsub(table.concat(hext),"(.)",
                                function (c) return string.format("%02X%s",string.byte(c),"") end), 16)
end

return module