
interface = {}

buildingButtons = {}

function interface.load()

	--load the images that create the interface
	bottomInterface = love.graphics.newImage("images/bottomInterface.png")

	--These images are for the minimap in the lower right hand corner
	miniMapBorder = love.graphics.newImage("images/miniMapBorder.png")
	miniMapCorner = love.graphics.newQuad(0, 0, 100, 100, miniMapBorder:getDimensions())
	miniMapTop = love.graphics.newQuad(100, 0, 100, 100, miniMapBorder:getDimensions())
	miniMapLeft = love.graphics.newQuad(0, 100, 100, 100, miniMapBorder:getDimensions())
	miniMapBlank = love.graphics.newQuad(100, 100, 100, 100, miniMapBorder:getDimensions())

	--Load all the buildings that can be built
	buildingIcons = love.graphics.newImage("images/buildingIcons.png")
	healthRegenUpgrade = love.graphics.newQuad(0, 0, 42, 42, buildingIcons:getDimensions())
	attackBuff = love.graphics.newQuad(42, 0, 42, 42, buildingIcons:getDimensions())
	attackUpgrade = love.graphics.newQuad(42 * 2, 0, 42, 42, buildingIcons:getDimensions())
	defenseBuff = love.graphics.newQuad(42 * 3, 0, 42, 42, buildingIcons:getDimensions())
	defenseUpgrade = love.graphics.newQuad(42 * 4, 0, 42, 42, buildingIcons:getDimensions())
	healthBuff = love.graphics.newQuad(42 * 5, 0, 42, 42, buildingIcons:getDimensions())
	healthUpgrade = love.graphics.newQuad(42 * 6, 0, 42, 42, buildingIcons:getDimensions())
	specialBuff = love.graphics.newQuad(42 * 7, 0, 42, 42, buildingIcons:getDimensions())
	specialUpgrade = love.graphics.newQuad(42 * 8, 0, 42, 42, buildingIcons:getDimensions())
	townHall = love.graphics.newQuad(42 * 9, 0, 42, 42, buildingIcons:getDimensions())

	healthRegenBuff = love.graphics.newQuad(0, 42, 42, 42, buildingIcons:getDimensions())
	criticalBuff = love.graphics.newQuad(42, 42, 42, 42, buildingIcons:getDimensions())
	criticalUpgrade = love.graphics.newQuad(42 * 2, 42, 42, 42, buildingIcons:getDimensions())
	rangeBuff = love.graphics.newQuad(42 * 3, 42, 42, 42, buildingIcons:getDimensions())
	rangeUpgrade = love.graphics.newQuad(42 * 4, 42, 42, 42, buildingIcons:getDimensions())
	accuracyBuff = love.graphics.newQuad(42 * 5, 42, 42, 42, buildingIcons:getDimensions())
	accuracyUpgrade = love.graphics.newQuad(42 * 6, 42, 42, 42, buildingIcons:getDimensions())

	interfaceBuildTile = love.graphics.newQuad(42 * 7, 42, 42, 42, buildingIcons:getDimensions())

	--Create the canvas that contains all of the interface images
	interfaceCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	buildInterfaceCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())


	local buildTiles = 0
	local x = love.graphics.getWidth() - (love.graphics.getWidth() / 20) * 4 - 10 - 42
	local y = love.graphics.getHeight() - 152
	local img = ""

	while buildTiles <= 16 do
		love.graphics.draw(buildingIcons, interfaceBuildTile, x, y)

		if buildTiles == 0 then img = healthRegenUpgrade
		elseif buildTiles == 1 then img = specialUpgrade
		elseif buildTiles == 2 then img = criticalUpgrade
		elseif buildTiles == 3 then img = rangeUpgrade
		elseif buildTiles == 4 then img = accuracyUpgrade
		elseif buildTiles == 5 then img = healthUpgrade
		elseif buildTiles == 6 then img = defenseUpgrade
		elseif buildTiles == 7 then img = attackUpgrade
		elseif buildTiles == 8 then img = healthRegenBuff
		elseif buildTiles == 9 then img = specialBuff
		elseif buildTiles == 10 then img = criticalBuff
		elseif buildTiles == 11 then img = rangeBuff
		elseif buildTiles == 12 then img = accuracyBuff
		elseif buildTiles == 13 then img = healthBuff
		elseif buildTiles == 14 then img = defenseBuff
		elseif buildTiles == 15 then img = attackBuff
		elseif buildTiles == 16 then img = townHall
		end

		local noUse, noUse, w, h = img:getViewport()

		table.insert(buildingButtons,
					{buttonNum = buildTiles,
					x = x,
					y = y,
					size = w,
					sheet = buildingIcons,
					img = img})

		x = x - 42 - 10
		buildTiles = buildTiles + 1
	end
	--Draw the images onto the canvas
	interface.drawCanvas()
end

function interface.drawCanvas()

	--Set the interface canvas to start being drawn on
	love.graphics.setCanvas(interfaceCanvas)

		--Set a local X and Y location on the canvas
		local x = 0
		local y = 0

		while x <= love.graphics.getWidth() do
			--Draw the lower portion of interface
			love.graphics.draw(bottomInterface, x, love.graphics.getHeight() - bottomInterface:getHeight())
			x = x + bottomInterface:getWidth()
		end

		--Set the new starting location for X and Y
		--Local variables to make a grid for the mini map border
		x = love.graphics.getWidth() - (love.graphics.getWidth() / 20) * 4
		y = love.graphics.getHeight() - (love.graphics.getWidth() / 20) * 4
		local column = 0 
		local row = 0

		--Repeat until the border goes outside the width and height of the screen
		repeat

			--Make sure that the X value is on the screen
			if x < love.graphics.getWidth() then
				--Test which row is currently being drawn
				--Test which column is currently being drawn
				if row == 0 then
					if column == 0 then
						--Draw the corner of the border
						love.graphics.draw(miniMapBorder, miniMapCorner, x, y)
					else
						--Draw the top of the border
						love.graphics.draw(miniMapBorder, miniMapTop, x, y)
					end
				else
					if column == 0 then
						--Draw the left side of the border
						love.graphics.draw(miniMapBorder,miniMapLeft, x, y)
					else
						--Draw the infill of the border, so no blank space
						love.graphics.draw(miniMapBorder, miniMapBlank, x, y)
					end
				end

				--Set the new X position
				--Increase the column that is being drawn to
				x = x + 100
				column = column + 1
			else
				--Reset the X X and column variables
				--Set the new Y value and increase the row that is currently being drawn
				x = love.graphics.getWidth() - (love.graphics.getWidth() / 20) * 4
				y = y + 100
				column = 0
				row = row + 1
			end

		until x > love.graphics.getWidth() and y > love.graphics.getHeight()

	--Unset the interface canvas from being drawn to
	love.graphics.setCanvas()

	--Set the canvas to start to be drawn on
	love.graphics.setCanvas(buildInterfaceCanvas)

		for i, v in ipairs(buildingButtons) do
			love.graphics.draw(v.sheet, interfaceBuildTile, v.x, v.y)
			love.graphics.draw(v.sheet, v.img, v.x, v.y)
		end
	love.graphics.setCanvas()
end

function interface.mousepressed(x, y, button)
	if button == 1 then
		for i, v in ipairs(buildingButtons) do
			if x >= v.x and
			x <= v.x + v.size and
			y >= v.y and
			y <= v.y + v.size then
				buildBuilding = v.img
			end
		end
	end
end

function interface.draw()
	--Draw the interface canvas
	love.graphics.draw(interfaceCanvas, 0 - love.graphics.getWidth() / 2, 0 - love.graphics.getHeight() / 2)
	
	for i, v in ipairs(troops) do

		if v.selected == true and
		buildBuilding == "" then
			love.graphics.draw(buildInterfaceCanvas, 0 - love.graphics.getWidth() / 2, 0 - love.graphics.getHeight() / 2)
		end
	end
end