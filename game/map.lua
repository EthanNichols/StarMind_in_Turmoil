
map = {}

--The size of the map = (platformAmount * platformAmount)
--Table that holds all the platforms information
platformAmount = 100
platforms = {}

--Table that holds information about the building plots
--Table that connects the building plots on different platforms together
plots = {}
paths = {}

function map.load()

	--Load platform images
	largePlatform1 = love.graphics.newImage("images/largePlatform1.png")
	largePlatform2 = love.graphics.newImage("images/largePlatform2.png")

	mediumPlatform1 = love.graphics.newImage("images/mediumPlatform1.png")
	mediumPlatform2 = love.graphics.newImage("images/mediumPlatform2.png")

	smallPlatform1 = love.graphics.newImage("images/smallPlatform1.png")
	smallPlatform2 = love.graphics.newImage("images/smallPlatform2.png")

	tinyPlatform = love.graphics.newImage("images/tinyPlatform.png")

	--Load building plots images
	largePlot = love.graphics.newImage("images/bigPlot.png")
	mediumPlot = love.graphics.newImage("images/mediumPlot.png")
	smallPlot = love.graphics.newImage("images/smallPlot.png")
	tinyPlot = love.graphics.newImage("images/tinyPlot.png")

	--Local information about the platforms
	local platformNum = 0
	local x = 0
	local y = 0
	local img = nil
	
	repeat

		--Randomly generate a platform size
		--Randomly set the X and Y values for the platform
		local platform = math.floor(math.random() * 100 + 1)
		x = math.floor(math.random() * 505 * 5)
		y = math.floor(math.random() * 505)

		--Set the images of the platform
		if platform == 1 then
			img = largePlatform1
		elseif platform == 2 then
			img = largePlatform2
		elseif platform >= 3 and
		platform < 13 then
			img = mediumPlatform1
		elseif platform >= 13 and
		platform < 23 then
			img = mediumPlatform2
		elseif platform >= 23 and
		platform < 33 then
			img = smallPlatform1
		elseif platform >= 33 and
		platform < 43 then
			img = smallPlatform2
		elseif platform >= 43 then
			img = tinyPlatform
		end

		--Insert information about the platforms into the table
		table.insert(platforms,
					{platformNum = platformNum,
					x = x,
					y = y,
					w = img:getWidth(),
					h = img:getHeight(),
					r = 255,
					g = 255,
					b = 255,
					img = img,})

		--Increase the amount of platforms created
		--Repeat until the amount of platforms is equal to the map size
		platformNum = platformNum + 1
	until platformNum == platformAmount
end


--Local timer for how long to delay the canvas drawing
local timer = 0

function map.update(dt)

	--Keep adding one to the timer
	--Prevent the timer from continuing to count
	if timer < 15 then
		timer = timer + 1
	end
	
	--Check for the timer and if the canvases have been drawn
	if timer < 10 then
		--Keep updaing the platform information
		--Keep updating the map information
		map.movePlatforms()
		map.dimensions()
	elseif platformCanvas1 == nil and
	timer > 10 then
		--Update the map information one more time
		--(True) draw the canvases after the map update
		map.dimensions(true)
		player.moveCamera()
	end
end

function map.movePlatforms()

	--Get information about the platforms
	for i, v in ipairs(platforms) do
		for i, b in ipairs(platforms) do

			--Local variable to see if two platforms are colliding
			local collided = false

			--Only test different platforms together
			if v.platformNum ~= b.platformNum then
				collided = CheckCollision(v.x, v.y, v.w, v.h, b.x, b.y, b.w, b.h)
			end

			--Test if the platforms are colliding
			if collided == true then

				--Set the movement distance for the platforms
				--Set which direction the platform will move in
				local movement = 300
				local directionX = math.floor(math.random() * 3 + 1)
				local directionY = math.floor(math.random() * 3 + 1)

				--Reset the timer, because platforms are moving
				timer = 0

				--Test the X and Y direction the platform is moving in
				--Move the platform in that direction
				if directionX == 1 then
					v.x = v.x + movement
				elseif directionX == 2 then
					v.x = v.x - movement
				end

				if directionY == 1 then
					v.y = v.y + movement
				elseif directionY == 2 then
					v.y = v.y - movement
				end
			end
		end
	end
end

function map.dimensions(drawCanvas)

	--Local variables abou the map's information
	local mapX = 0
	local mapY = 0
	local mapW = 0
	local mapH = 0

	--Get information about the platforms
	for i, v in ipairs(platforms) do

		--Compare the platform locations with the map dimensions
		--Set the X position and width of the map
		--Add a buff of 50 to the edge
		if v.x - 50 < mapX then
			mapX = v.x - 50
		elseif v.x + 50 + v.w > mapW then
			mapW = v.x + v.w + 50
		end
		--Set the Y position and height of the map
		--Add a buff of 50 to the edge
		if v.y - 50 < mapY then
			mapY = v.y - 50
		elseif v.y + v.h > mapH then
			mapH = v.y + v.h + 50
		end
	end

	--Get information about the platforms
	for i, v in ipairs(platforms) do
		--Move all the platforms to keep the X Y values positive
		v.x = v.x + math.abs(mapX)
		v.y = v.y + math.abs(mapY)
	end

	--Test if the canvas is being drawn
	if drawCanvas == true then
		--Make the Width and height of the canvas to an even number
		if mapW % 2 ~= 0 then
			mapW = mapW + 1
		end
		
		if mapH % 2 ~= 0 then
			mapH = mapH + 1
		end

		--Create the building plots that are on the platforms
		--Send map information to create the canvases
		map.createPlots()
		map.platformCanvas(mapX, mapY, mapW, mapH)

		map.paths()
	end
end

function map.createPlots()

	--Local  variable to keep track of how many plots are created
	local createdPlots = 0

	--Get information about the platforms
	for i, v in ipairs(platforms) do

		--Local variables
		--How many plots are needed for the platform
		--How many plots have been created on the platform
		--How many layers from the center need to be created
		--X and Y positions and the plot image
		local plotsNeeded = 0
		local plotsCreated = 0
		local plotLayers = 0
		local edge = false
		local x = v.x + v.w / 2
		local y = v.y + v.h / 2
		local img = nil
		local resources = 0

		--Test which platform is having plots built
		--Set the amount of plots needed
		--The center (starting) image for the platfomr
		--The amount of building plot layers that should be created
		if v.img == largePlatform1 or
		v.img == largePlatform2 then
			plotsNeeded = 25
			img = largePlot
			plotLayers = 3
		elseif v.img == mediumPlatform1 or
		v.img == mediumPlatform2 then
			plotsNeeded = 17
			img = mediumPlot
			plotLayers = 2
		elseif v.img == smallPlatform1 or
		v.img == smallPlatform2 then
			plotsNeeded = 5
			img = smallPlot
			plotLayers = 1
		elseif v.img == tinyPlatform then
			edge = true
			plotsNeeded = 1
			img = tinyPlot
			plotLayers = 0
			resources = math.floor(math.random() * 100 + 100)
		end

		repeat

			--Check if the outter layer is being created
			--Change the image of the outter layer
			--If the outter layer isn't being created set the image
			if plotsCreated % plotLayers == 0 and
			plotsCreated > 1 then
				img = mediumPlot
				edge = true
			elseif plotsCreated ~= 0 then
				img = smallPlot
				edge = false
			end

			--Test if the platfrom is a small platform
			if v.img == smallPlatform1 or
			v.img == smallPlatform2 then

				--Set the image for the building plots
				img = smallPlot

				--Test which plot is being created
				--Move the plot to the respective corner or the platform
				if plotsCreated == 1 then
					x = x - 50
					y = y - 50
					edge = true
				elseif plotsCreated == 2 then
					x = x + 50
					y = y - 50
					edge = true
				elseif plotsCreated == 3 then
					x = x - 50
					y = y + 50
					edge = true
				elseif plotsCreated == 4 then
					x = x + 50
					y = y + 50
					edge = true
				end
			else

				--Test the plot number being created
				--Change the X Y values for the plot
				if plotsCreated <= plotLayers and
				plotsCreated ~= 0 then
					x = x - 75
				elseif plotsCreated > plotLayers and
				plotsCreated <= plotLayers * 2 then
					x = x + 75
				elseif plotsCreated > plotLayers * 2 and
				plotsCreated <= plotLayers * 3 then
					y = y - 75
				elseif plotsCreated > plotLayers * 3 and
				plotsCreated <= plotLayers * 4 then
					y = y + 75
				elseif plotsCreated > plotLayers * 4 and
				plotsCreated <= plotLayers * 5 then
					x = x - 50
					y = y - 50
				elseif plotsCreated > plotLayers * 5 and
				plotsCreated <= plotLayers * 6 then
					x = x + 50
					y = y - 50
				elseif plotsCreated > plotLayers * 6 and
				plotsCreated <= plotLayers * 7 then
					x = x - 50
					y = y + 50
				elseif plotsCreated > plotLayers * 7 and
				plotsCreated <= plotLayers * 8 then
					x = x + 50
					y = y + 50
				end
			end
			
			--Test if there is an image to draw
			--Put information into a table
			if img ~= nil then
				table.insert(plots,
							{plotNum = createdPlots,
							platformNum = v.platformNum,
							edge = edge,
							x = x - img:getWidth() / 2,
							y = y - img:getHeight() / 2,
							img = img,
							resources = resources,
							building = false,
							r = 255,
							g = 255,
							b = 255})
			end

			--Check if the outter layer has been created
			--Reset the X Y position back to the center of the platform
			if plotsCreated % plotLayers == 0 then
				x = v.x + v.w / 2
				y = v.y + v.h / 2
			end

			--Add 1 to the amount of plots created
			--Add 1 the the total amount of plots created
			plotsCreated = plotsCreated + 1
			createdPlots = createdPlots + 1

			--Repeat until all the plots on the platform have been created
		until plotsCreated >= plotsNeeded
	end
end

function map.platformCanvas(mapX, mapY, mapW, mapH)

	--Check if the canvases have been created
	if platformCanvas1 == nil then
		--Create the four quadrant canvases
		platformCanvas1 = love.graphics.newCanvas(mapW / 2, mapH / 2)
		platformCanvas2 = love.graphics.newCanvas(mapW / 2, mapH / 2)
		platformCanvas3 = love.graphics.newCanvas(mapW / 2, mapH / 2)
		platformCanvas4 = love.graphics.newCanvas(mapW / 2, mapH / 2)
		--Set the filter of each of the canvases to pizxel perfect
		platformCanvas1:setFilter("nearest", "nearest")
		platformCanvas2:setFilter("nearest", "nearest")
		platformCanvas3:setFilter("nearest", "nearest")
		platformCanvas4:setFilter("nearest", "nearest")
	end

	--Local variables for the width and height of the screen
	--This is to negate the translation that is done
	local width = love.graphics.getWidth() / 2
	local height = love.graphics.getHeight() / 2

	--Get information about the platforms
	for i, v in ipairs(platforms) do

		--Set the color of the platform
		love.graphics.setColor(v.r, v.g, v.b)

		--Set the canvas and draw the platforms
		--Offset the X and Y value with 'Width' and 'Height'
		--Offset the quadrant with 'mapW / 2' and 'mapH / 2'
		love.graphics.setCanvas(platformCanvas1)
			love.graphics.draw(v.img, v.x - width, v.y - height)
		love.graphics.setCanvas()

		love.graphics.setCanvas(platformCanvas2)
			love.graphics.draw(v.img, v.x - width - platformCanvas2:getWidth(), v.y - height)
		love.graphics.setCanvas()

		love.graphics.setCanvas(platformCanvas3)
			love.graphics.draw(v.img, v.x - width, v.y - height - platformCanvas3:getHeight())
		love.graphics.setCanvas()

		love.graphics.setCanvas(platformCanvas4)
			love.graphics.draw(v.img, v.x - width - platformCanvas4:getWidth(), v.y - height - platformCanvas4:getHeight())
		love.graphics.setCanvas()
	end

	for i, v in ipairs(plots) do

		--Set the color of the plots
		love.graphics.setColor(v.r, v.g, v.b)

		--Set the canvas and draw the platforms
		--Offset the X and Y value with 'Width' and 'Height'
		--Offset the quadrant with 'mapW / 2' and 'mapH / 2'
		love.graphics.setCanvas(platformCanvas1)
			love.graphics.draw(v.img, v.x - width, v.y - height)
		love.graphics.setCanvas()

		love.graphics.setCanvas(platformCanvas2)
			love.graphics.draw(v.img, v.x - width - platformCanvas2:getWidth(), v.y - height)
		love.graphics.setCanvas()

		love.graphics.setCanvas(platformCanvas3)
			love.graphics.draw(v.img, v.x - width, v.y - height - platformCanvas3:getHeight())
		love.graphics.setCanvas()

		love.graphics.setCanvas(platformCanvas4)
			love.graphics.draw(v.img, v.x - width - platformCanvas4:getWidth(), v.y - height - platformCanvas4:getHeight())
		love.graphics.setCanvas()
	end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	--Check is two platforms are intersecting return true if true
	return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function map.paths()

	--Local variable to keep track of how many paths have been made
	local pathNum = 0

	--Get information about the building plots
	for i, v in ipairs(plots) do

		--Local variables for the testing area's postions
		--Local variable for the amount of paths created from one plot
		--Local variable to set the amount of paths to make from the plot
		--Local variable to set which platform was the last platform connected to
		local x = v.x + v.img:getWidth() / 2
		local y = v.y + v.img:getHeight() / 2
		local x1 = x
		local y1 = y
		local pathsCreated = 0
		local amountOfPaths = math.floor(math.random() * 5 + 1)
		local lastPlatform = -1

		--Test to make sure the plot is on the edge of the platform
		if v.edge == true then

			repeat

				--Get information about the building plots
				for i, b in ipairs(plots) do

					--Make sure to not test the same platforms
					--Make sure not to not make another path to the last platform
					--Make sure the second building plot is on the edge
					if v.platformNum ~= b.platformNum and
					lastPlatform ~= b.platformNum and
					b.edge == true then

						--Test if the building plot is inside the testing area
						if b.x + b.img:getWidth() / 2 >= x and
						b.x + b.img:getWidth() / 2 <= x1 and
						b.y + b.img:getHeight() / 2 >= y and
						b.y + b.img:getHeight() / 2 <= y1 then

							--Insert information into the paths table
							table.insert(paths,
										{pathNum = pathNum,
										platformNum = v.platformNum,
										platformNum2 = b.platformNum,
										x = v.x + v.img:getWidth() / 2,
										y = v.y + v.img:getHeight() / 2,
										x1 = b.x + b.img:getWidth() / 2,
										y1 = b.y + b.img:getHeight() / 2,
										draw = true,})

							--Set the last platfrom connected to
							--Increase the amount of paths that have been created
							--Increase the amount of paths made from the plot
							lastPlatform = b.platformNum
							pathNum = pathNum + 1
							pathsCreated = pathsCreated + 1
						end
					end
				end

				--Increase the testing range from the building plot
				x = x - 10
				x1 = x1 + 10
				y = y - 10
				y1 = y1 + 10

				--Repeat until the amount of paths created from the platform is met
			until pathsCreated >= amountOfPaths
		end
	end

	--Get information about the paths
	for i, v in ipairs(paths) do

		--Local variable to determin the paths length (pathagreum therum)
		local length = math.sqrt(math.abs(v.x1 - v.x) * math.abs(v.x1 - v.x) + math.abs(v.y1 - v.y) * math.abs(v.y1 - v.y))

		--Get information about the paths
		for i, b in ipairs(paths) do

			--Local variable to determin the paths length (pathagreum therum)
			--Local variable to see if a line needs to be deleted
			local length1 = math.sqrt(math.abs(b.x1 - b.x) * math.abs(b.x1 - b.x) + math.abs(b.y1 - b.y) * math.abs(b.y1 - b.y))
			local deleteLine = false

			--Make sure you aren't comparing a path to itself
			--Make sure that both paths are being drawn
			if v.pathNum ~= b.pathNum and
			v.draw == true and
			b.draw == true then

				--Test if the paths are connecting the same platforms
				--Declare that a platform needs to be deleted
				if v.platformNum == b.platformNum and
				v.platformNum2 == b.platformNum2 then
					deleteLine = true
				elseif v.platformNum == b.platformNum2 and
				v.platformNum2 == b.platformNum then
					deleteLine = true
				end
			end

			--Make sure a platform needs to be deleted
			--Test for the shortest path
			--Delete the longer path, of the two
			if deleteLine == true then
				if length > length1 then
					v.draw = false
				else
					b.draw = false
				end
			end
		end
	end

	--This part of the pathing process doesn't currently work
	--An algorithm to remove intersecting path needs to be made
	--Problem with checking the collision:
		--Paths that are close to each other think that are intersecting each other
	--Proble with testing Y postion with the X and slope:
		--It's to slow and not accurate enought to determing intersecting paths

	--This will stay commented out, until a new solution has been created
	--Or until this code has been fixed, and works properly
	--ATM this code doesn't do anything
	--It has been left here to provoke thought in the future
	--[[for i, v in ipairs(paths) do

		local x = 0
		local y = 0
		local y1 = 0
		local slope = (v.y1 - v.y) / (v.x1 - x)

		for i, b in ipairs(paths) do
			local slope1 = (v.y1 - v.y) / (v.x1 - x)

			if v.pathNum ~= b.pathNum and
			v.draw == true and
			b.draw == true then

			repeat
				y = x - v.x * slope
				y1 = x - b.x * slope1

				if y + 1 > y1 and
				y - 1 < y1 then
					b.draw = false
				end

				x = x + 1
			until x > 16000
			end
		end
	end]]
end

function map.draw()

	--Get information about the platforms
	--Draw the platforms
	if platformCanvas1 == nil then
		for i, v in ipairs(platforms) do
			v.img:setFilter("nearest", "nearest")
			love.graphics.draw(v.img, v.x, v.y)
		end
	else
		--Draw the four quadrant canvases for the map
		love.graphics.draw(platformCanvas1, 0, 0)
		love.graphics.draw(platformCanvas2, platformCanvas2:getWidth(), 0)
		love.graphics.draw(platformCanvas3, 0, platformCanvas3:getHeight())
		love.graphics.draw(platformCanvas4, platformCanvas4:getWidth(), platformCanvas4:getHeight())
	end

	--Get information about the paths
	for i, v in ipairs(paths) do

		--Make sure the path is being drawn
		--Draw the path
		--!!!!!THE COLOR IS A TEMPERAY FEATURE, REMOVE!!!!!--
		if v.draw == true then
			love.graphics.setColor(120, 120, 120)
			love.graphics.line(v.x, v.y, v.x1, v.y1)

		--!!!!!These elseif statements are for debugging only!!!!!--
		--They are here to show paths that are intersecting
		--Or if the paths have been delted becuase of other paths going to the same place
		--Remove this after all the path generation code has been finished
		--elseif v.draw == false then
			--love.graphics.setColor(255, 0, 0)
			--love.graphics.line(v.x + 10, v.y + 10, v.x1, v.y1)
		end
	end

	love.graphics.setColor(255, 255, 255)
end