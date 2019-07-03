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

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
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

--Finds the tile position of x,y on the map given the current viewport

-- x, y is the position we want to find out in tile coordinates
-- xTop, yTop is the position of the top left portion of the game screen (view), relative to the  0, 0 position of the map
-- tilesize is the size of the tiles of the map
-- mapwidth and mapheight are the width and height of a map in terms of amount of tiles in x or y direction
function getTileCoords(x, y, xTop, yTop, tSize, mapW, mapH) 
    
    local xTop = xTop or x 
    local yTop = yTop or y   
    local tSize = tSize or 32
    local mapW = mapW or math.ceil(gw / tSize)
    local mapH = mapH or math.ceil(gh / tSize)
    local xCoords = nil
    local yCoords = nil
    
    --top and left are the pixel position of the view (whats visible in the game) vs the map
    --get the tile coordinates relative to the coordinates of the top left part of the game map. 
    --if the x and y position is not within bounds of the view then clamp it along the respective axis. 
    if(x > xTop + (mapW*tSize)) then xCoords = mapW
    elseif(x < xTop) then xCoords = 1
    else 
    	if x == xTop + (mapW*tSize) then xCoords = math.floor((x-xTop)/tSize) 
    	else xCoords = math.floor((x-xTop)/tSize)+1 end
   	end
    
    if(y > yTop + (mapH*tSize)) then yCoords = mapH
    elseif(y < yTop) then yCoords = 1
    else 
    	if y == yTop + (mapH*tSize) then yCoords = math.floor((y-yTop)/tSize) 
    	else yCoords = math.floor((y-yTop)/tSize)+1	 end
    end

    return xCoords, yCoords
end

    
    
    
    
    
