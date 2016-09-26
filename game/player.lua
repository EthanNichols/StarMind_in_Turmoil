require "game/interface"
require "game/troops"
require "game/buildings"

player = {}

player.platforms = {}

player.platformSelected = -1
player.plotSelected = -1

function player.load()
	--Load functions
	interface.load()
	troops.load()
end

function player.update(dt)
	--Update function
	troops.update(dt)
	buildings.update(dt)
end

function player.moveCamera()

	--Get information about the platforms
	for i, v in ipairs(platforms) do

		--Test What type of platform is being looked at
		--Make sure that the platform is being drawn
		if v.img == mediumPlatform1 or
		v.img == mediumPlatform2 and
		v.drawn == true then

			--Random value to determine the player's starting location
			local start = math.floor(math.random() * 2 + 1)

			--If the random value is true then set the platform equal to the start
			if start == 1 then
				table.insert(player.platforms,
							{x = v.x,
							y = v.y,
							w = v.w,
							h = v.h,
							platformNum = v.platformNum,
							r = 255,
							g = 0,
							b = 0})

				--Move the camera to center on the starting platform
				camera.x = v.x + v.w / 2
				camera.y = v.y + v.h / 2
				break
			end
		end
	end

	--Set the color of the platforms and plots
	player.color()
end

function player.color()

	--Get information about the platforms the players owns
	for i, v in ipairs(player.platforms) do

		--Get information about all the platforms
		for i, b in ipairs(platforms) do

			--Test to make sure the player owns the platform
			if v.platformNum == b.platformNum then

				--Set the player's color to the platform
				b.r = v.r
				b.g = v.g
				b.b = v.b
			end
		end

		--Get information about all the plots
		for i, b in ipairs(plots) do

			--Test to make sure the player owns the plots
			if v.platformNum == b.platformNum then

				--Set the player's color to the plots
				b.r = v.r
				b.g = v.g
				b.b = v.b
			end
		end
	end

	--Redraw the map canvas to factor in the player's color
	map.platformCanvas()
	troops.start()
end

function player.mousepressed(x, y, button)

	--Test if the left mouse button has been pressed
	if button == 1 then

		--Get information about the platforms
		for i, v in ipairs(platforms) do

			--Test to see if the mouse clicked on a platform
			if x > v.x and
			x < v.x + v.w and
			y > v.y and
			y < v.y + v.h then

				--Set that platform to be selected by the player
				player.platformSelected = v.platformNum
				break
			else
				--Set that the player is not selecting a platform
				player.platformSelected = -1
			end
		end

		--Get information about the plots
		for i, v in ipairs(plots) do

			--Test to see if the mouse clicked on a plot
			if x > v.x and
			x < v.x + v.img:getWidth() and
			y > v.y and
			y <= v.y + v.img:getHeight() then

				--Set that plot to be selected by the player
				player.plotSelected = v.plotNum
				break
			else
				--Set that the player isn't selecting a platform
				player.plotSelected = -1
			end
		end
	else
		--Set that a player isn't selecting anything
		player.platformSelected = -1
		player.plotSelected = -1
	end

	x, y = love.mouse.getPosition()

	interface.mousepressed(x, y, button)
	buildings.mousepressed(x, y, button)
end

function player.draw()

	--Get information about the platforms
	for i, v in ipairs(platforms) do

		--Test if the platfrom is being selected by the player
		if v.platformNum == player.platformSelected then

			--Draw a box around the platform
			love.graphics.rectangle("line", v.x, v.y, v.w, v.h)

			--Get information about the plots
			for i, b in ipairs(plots) do

				--Make sure the plot selected is on the selected platform
				if b.plotNum == player.plotSelected and
				v.platformNum == b.platformNum then

					--Draw a box around the selected plot
					love.graphics.rectangle("line", b.x, b.y, b.img:getWidth(), b.img:getHeight())
				end
			end
		end
	end

	buildings.draw()
	troops.draw()
end

function player.interfaceDraw()

	--Get information about the plots
	for i, v in ipairs(plots) do
		--Test if the plot is being selected by the player
		if v.plotNum == player.plotSelected and
		v.platformNum == player.platformSelected then

			--Write the amount of resourcest that are on that plot
			love.graphics.print(v.resources, 10, 10)
		end
	end

	--Draw the interface that overlays on top of the map
	interface.draw()
end