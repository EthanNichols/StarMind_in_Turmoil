require "camera"
require "game/map"
require "game/player"

function love.load()
	--Randomization seed
	math.randomseed(os.time())

	--Load functions
	map.load()
	player.load()
end

function love.update(dt)
	--Update functions
	camera.movement(dt)
	map.update(dt)
	player.update(dt)
end

function love.wheelmoved(x, y)
	--Change the camera scaling
	camera.zoom(x, y)
end

function love.mousepressed(x, y, button)

	--Set the X and Y mouse positions relative to the camera scale and position
	x = (x - love.graphics.getWidth() / 2) * camera.scaleX + camera.x
	y = (y - love.graphics.getHeight() / 2) * camera.scaleY + camera.y

	--Send mouse information to the functions
	player.mousepressed(x, y, button)
end

function love.keypressed(button)
	--Test if the escape buttons has been pressed
	--exit the game
	if button == "escape" then
		love.event.quit()
	end
end

function love.draw()
	--Set the background color
	love.graphics.setBackgroundColor(46, 52, 61)

	--Tanslate so the center of the scrren is 0, 0
	love.graphics.translate(math.floor(love.graphics.getWidth() / 2), math.floor(love.graphics.getHeight() / 2))
	
	--Set the camera
	--Anything inside this will move when the camera is moved
	camera:set()

		--Draw the functions
		map.draw()
		player.draw()
	camera:unset()
	
	player.interfaceDraw()

	--Print the FPS
	--Temperary, only for debugging purposes
	love.graphics.print(love.timer.getFPS(), 0, 0)
end

--C:\Users\Ethan Nichols\AppData\Roaming\LOVE\Testing