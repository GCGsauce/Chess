function generateQuads(image_path, tile_width, tile_height) --generate quads for an image for a selected tile size, e.g. 32x32, 64,32
    local image = love.graphics.newImage(image_path)
	local quadMap = {}

	local cols = image:getWidth()/tile_width
	local rows = image:getHeight()/tile_height
	local count = 1
	for i = 1, rows do
		for j = 1, cols do
			quadMap[count] = {(j-1)*tile_width, (i-1)*tile_height, tile_width, tile_height} --gives the x, y, width, height needed to generate a quad
			count = count + 1
		end
	end
	return quadMap
end

function round(num, numDecimalPlaces) -- taken from http://lua-users.org/wiki/SimpleRound
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end  

function abs(num)
    if num < 0 then return num*-1 else return num end
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.getInfo(file, "file") then
            table.insert(file_list, file)
        elseif love.filesystem.getInfo(file, "directory") then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local f = file:sub(1, -5)
        require(f)
    end
end
    
    
    
    
