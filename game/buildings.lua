
buildings = {}

buildingHover = -1
buildBuilding = ""

buildingsBuilt = 0

function buildings.load()
	
end

function buildings.update(dt)

	local x = (love.mouse.getX() - love.graphics.getWidth() / 2) * camera.scaleX + camera.x
	local y = (love.mouse.getY() - love.graphics.getHeight() / 2) * camera.scaleY + camera.y

	for i, v in ipairs(plots) do
		if x >= v.x and
		x <= v.x + v.img:getWidth() and
		y >= v.y and
		y <= v.y + v.img:getHeight() then
			buildingHover = v.plotNum
			break
		else
			buildingHover = -1
		end
	end
end

function buildings.mousepressed(x, y, button)

	x = (x - love.graphics.getWidth() / 2) * camera.scaleX + camera.x
	y = (y - love.graphics.getHeight() / 2) * camera.scaleY + camera.y

	local buildingPlaced = false

	if button == 1 and
	buildBuilding ~= "" then
		for i, v in ipairs(plots) do
			if x >= v.x and
			x <= v.x + v.img:getWidth() and
			y >= v.y and
			y <= v.y + v.img:getHeight() and
			v.resources == 0 and
			v.building == false then
				table.insert(buildings,
							{buildingNum = buildingsBuilt,
							buildingImg = buildBuilding,
							x = v.x + v.img:getWidth() / 2 - 20.5, 
							y = v.y + v.img:getHeight() / 2 - 20.5,})
				v.building = true
				buildingsBuilt = buildingsBuilt + 1
				buildingPlaced = true

				buildBuilding = ""
				buildingHover = -1
				break
			end
		end
	end
end

function buildings.draw()
	if buildingHover >= 0 then
		for i, v in ipairs(plots) do
			if buildingHover == v.plotNum and
			buildBuilding ~= "" then
				buildingIcons:setFilter("nearest", "nearest")
				love.graphics.draw(buildingIcons, buildBuilding, v.x + v.img:getWidth() / 2 - 20.5, v.y + v.img:getHeight() / 2 - 20.5)
				break
			end
		end
	end

	for i, v in ipairs(buildings) do
		if v.buildingImg ~= nil then
			love.graphics.draw(buildingIcons, v.buildingImg, v.x, v.y)
		end
	end
end