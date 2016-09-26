
troops = {}

areaSelect = {}

function troops.load()
	troop = love.graphics.newImage("images/troop.png")
	troop:setFilter("nearest", "nearest")

	table.insert(areaSelect,
				{x = 0,
				y = 0,
				x1 = 0,
				y1 = 0,
				display = false})
end

function troops.start()

	local troopNum = 0

	for i, v in ipairs(player.platforms) do

		local troopAmount = 5
		local x = v.x + v.w / 2 - troop:getWidth() / 2 - 14
		local y = v.y + v.h / 2 - troop:getHeight() / 2 - 20

		repeat
			table.insert(troops,
						{troopNum = troopNum,
						x = x,
						y = y,
						w = troop:getWidth(),
						h = troop:getHeight(),
						speed = 2,
						selected = false,
						move = false,
						moveX = 0,
						moveY = 0})

			x = x + 7
			troopNum = troopNum + 1
			troopAmount = troopAmount - 1
		until troopAmount == 0
	end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	--Check is two platforms are intersecting return true if true
	return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function troops.update(dt)

	--Local variable to get the mouse locations
	local mouseX, mouseY = love.mouse.getPosition()

	--Local equation to fix the mouse position to the camera location
	mouseX = (mouseX - love.graphics.getWidth() / 2) * camera.scaleX + camera.x
	mouseY = (mouseY - love.graphics.getHeight() / 2) * camera.scaleY + camera.y

	local newAreaSelect = true

	--Test if the left mouse button is down
	if love.mouse.isDown(1) then

		local GUImouseX, GUImouseY = love.mouse.getPosition()

		for i, v in ipairs(troops) do
			if v.selected == true and
			GUImouseY > love.graphics.getHeight() - (love.graphics.getWidth() / 20) * 1.8 then
				newAreaSelect = false
				break
			end
		end


		if newAreaSelect == true then
			--Get information about the selection area
			for i, v in ipairs(areaSelect) do
				--Test if the first corner has been selected
				--Set the first corner locatio
				if v.x == 0 then
					v.x = mouseX
					v.y = mouseY
					else
					--Set the width and height of the rectangle
					--This is derterminate of the X and Y location
					v.x1 = mouseX - v.x
					v.y1 = mouseY - v.y
				end
			end
		end

		if newAreaSelect == true then
			--Function to see if troops have been selected
			troops.select()
		end

	elseif love.mouse.isDown(2) then
		for i, v in ipairs(troops) do

			local GUImouseX, GUImouseY = love.mouse.getPosition()

			if GUImouseX < love.graphics.getWidth() - (love.graphics.getWidth() / 20) * 4 or
			GUImouseY < love.graphics.getHeight() - (love.graphics.getWidth() / 20) * 4 then
				if v.selected == true and
				GUImouseY < love.graphics.getHeight() - (love.graphics.getWidth() / 20) * 1.8 then
					v.moveX = math.floor(mouseX)
					v.moveY = math.floor(mouseY)
					v.move = true
				end
			end
		end

	else
		if newAreaSelect == true then
			for i, v in ipairs(areaSelect) do
				v.x = 0
				v.y = 0
				v.x1 = 0
				v.y1 = 0
			end
		end
	end

	for i, v in ipairs(troops) do
		if v.move == true then
			if v.x < v.moveX then
				v.x = v.x + v.speed
			elseif v.x > v.moveX then
				v.x = v.x - v.speed
			end

			if v.y < v.moveY then
				v.y = v.y + v.speed
			elseif v.y > v.moveY then
				v.y = v.y - v.speed
			end
	
			if v.x == v.moveX and
			v.y == v.moveY then
				v.move = false
				v.moveX = 0
				v.moveY = 0
			end
		end

		for i, b in ipairs(troops) do
			local collide = CheckCollision(v.x, v.y, v.w, v.h, b.x, b.y, b.w, b.h)

			if v.troopNum ~= b.troopNum and
			collide == true then

				local randomX = math.floor(math.random() * 2 + 1)
				local randomY = math.floor(math.random() * 2 + 1)

				if randomX == 1 then
					b.x = b.x - 1
					v.x = v.x + 1
				end

				if randomY == 1 then
					b.y = b.y - 1
					v.y = v.y + 1
				end
			end
		end
	end
end

function troops.select()

	--Get iformation about the selection area
	--Get information about the troops
	for i, v in ipairs(areaSelect) do
		for i, b in ipairs(troops) do

			--Test if the center of the troops is in the selectio area
			--Set the troop to be selected
			--Else don't set the troop to be selected
			if v.x < b.x + b.w / 2 and
			v.x + v.x1 > b.x + b.w / 2 and
			v.y < b.y + b.h / 2 and
			v.y + v.y1 > b.y + b.h / 2 then
				b.selected = true
			elseif v.x > b.x + b.w / 2 and
			v.x + v.x1 < b.x + b.w / 2 and
			v.y > b.y + b.h / 2 and
			v.y + v.y1 < b.y + b.h / 2 then
				b.selected = true
			elseif v.x < b.x + b.w / 2 and
			v.x + v.x1 > b.x + b.w / 2 and
			v.y > b.y + b.h / 2 and
			v.y + v.y1 < b.y + b.h / 2 then
				b.selected = true
			elseif v.x > b.x + b.w / 2 and
			v.x + v.x1 < b.x + b.w / 2 and
			v.y < b.y + b.h / 2 and
			v.y + v.y1 > b.y + b.h / 2 then
				b.selected = true
			else
				b.selected = false
			end
		end
	end
end

function troops.draw()
	for i, v in ipairs(troops) do
		love.graphics.draw(troop, v.x, v.y)

		if v.selected == true then
			love.graphics.setColor(0, 0, 255)
			love.graphics.rectangle("line", v.x, v.y, troop:getWidth(), troop:getHeight())
			love.graphics.setColor(255, 255, 255)
		end
	end

	for i, v in ipairs(areaSelect) do
		love.graphics.rectangle("line", v.x, v.y, v.x1, v.y1)
	end
end