local module = {}

local DrawText = {}

--[[===============================================================
DrawText.set(int font, float linewidth, float posx, float posy, float sizex, float sizey, GxtString gxt_text, table data = {bool use_number, int number, bool use_center, float center_linewidth, bool align_right, bool enable_outline, int outline, int outl_r, int outl_g, int outl_b, int outl_a, bool customize_rgba, int r, int g, int b, int a, bool customize_shadow, int shadow_size, int sh_r, int sh_g, int sh_b, int sh_a, bool background})
===================================================================]]
function DrawText.set(font, linewidth, posx, posy, sizex, sizey, gxt_text, data)
	local d = data or {}
	
	local number, use_center, center_linewidth = d.number or nil, d.use_center or false, d.center_linewidth or 0.0
	local align_right, enable_outline, outline = d.align_right or false, d.enable_outline or false, d.outline or 0
	local outl_r, outl_g, outl_b, outl_a = d.outl_r or 0, d.outl_g or 0, d.outl_b or 0, d.outl_a or 0
	local r, g, b, a, customize_shadow, shadow_size = d.r or 255, d.g or 255, d.b or 255, d.a or 255, d.customize_shadow or false, d.shadow_size or 0
	local sh_r, sh_g, sh_b, sh_a, background = d.sh_r or 0, d.sh_g or 0, d.sh_b or 0, d.sh_a or 0, d.background or false
	
	setTextBackground(background)
	setTextColour(r, g, b, a)
	setTextFont(font)
	
	if use_center then
		setTextCentre(true)
		setTextCentreSize(center_linewidth)
	else setTextWrapx(linewidth)
	end
	
	setTextScale(sizex, sizey)
	setTextRightJustify(align_right)
	
	if enable_outline
	then setTextEdge(outline, outl_r, outl_g, outl_b, outl_a)
	else setTextEdge(0, 0, 0, 0, 255)
	end
	
	if customize_shadow
	then setTextDropshadow(shadow_size, sh_r, sh_g, sh_b, sh_a)
	else setTextDropshadow(2, 0, 0, 0, 255)
	end
	
	if number == nil
	then displayText(posx, posy, gxt_text)
	else displayTextWithNumber(posx, posy, gxt_text, number)
	end
end

--[[===============================================================
===================================================================]]
-- Lua implementation of PHP scandir function
-- https://www.gammon.com.au/scripts/doc.php?lua=io.popen
function module.scandir(directory)
    local i, t, popen = 0, {}, io.popen
	local linux_command = 'ls -a "%s"'
	local windows_command1 = 'dir "%s" /b /ad'	-- only directories
	local windows_command2 = 'dir "%s" /b'		-- directories and files
	local windows_command3 = 'dir "%s" /b /a-d'	-- only files
    local pfile = popen(string.format(windows_command2, getGameDirectory()..directory))
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

--[[===============================================================
===================================================================]]
-- https://www.gammon.com.au/scripts/doc.php?lua=os.execute
function module.scandir2(dir)
	local n = os.tmpname ()						-- get a temporary file name
	local command1 = 'dir "%s" /b /ad > %s'
	local command2 = 'dir "%s" /b > %s'
	local command3 = 'dir "%s" /b /a-d > %s'
	local path = getGameDirectory()..dir
	local i,t = 0,{}
	os.execute ( string.format(command3, path, n) )			-- execute a command
	for line in io.lines (n) do					-- display output
        i = i + 1
        t[i] = line
	end
	os.remove (n)								-- remove temporary file
	return t
end

--[[===============================================================
===================================================================]]
module.INT32_MIN = -((2^32)/2-1)
module.INT32_MAX = (2^32)/2

function module.Inc(var, step, vmin, vmax, loop_flag)
	step, vmin, vmax = step or 1, vmin or module.INT32_MIN, vmax or module.INT32_MAX
	
	-- loop_flag is true by default (when is not specified)
	if not(loop_flag==nil) then		loop_flag = loop_flag and true			else		loop_flag = true		end
	
	var = var + step
	if		var > vmax	then	--var = loop_flag and vmin or vmax
		if loop_flag then var = vmin
		else var = vmax
		end
	elseif	var < vmin	then	--var = loop_flag and vmax or vmin
		if loop_flag then var = vmax
		else var = vmin
		end
	end
	return var
end

function module.Dec(var, step, vmin, vmax, loop_flag)
	return module.Inc(var, -step, vmin, vmax, loop_flag)
end

--[[===============================================================
===================================================================--]]
local sexfiles = {}

--[[===============================================================
===================================================================--]]
sexfiles.generate = function (pose, place, bodytype)
	local BT_LOLI = require "lib.sex-machine.sex".bodyTypes.BT_LOLI
	local scm = require "lib.sex-machine.scm"
	local files = require "lib.sex-machine.data".files
	local orig_path = string.format("%s/%s%s", files.orig_path, files.subfolders[place][pose], bodytype == BT_LOLI and " (loli)" or "")
	local dest_path = files.dest_path
	scm.deleteDirectory(dest_path)
	wait (0)
	scm.copyDirectory(orig_path, dest_path)
end

module.DrawText = DrawText
module.sexfiles = sexfiles

return module