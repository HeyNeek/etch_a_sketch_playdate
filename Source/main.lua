import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

local positionX, positionY = 200, 120
local pencilRadiusOptions = {2.5, 5, 10}
local currentPencilRadius = pencilRadiusOptions[1]
local drawSpeed = 1.5

drawingStopped = false

function pd.update()
	local crankAngle = math.rad(pd.getCrankPosition())

	--if statement to check for a input, if pressed it will clear screen and reset penicil positionX and positionY
	if pd.buttonJustPressed("a") then
		positionX, positionY = 200, 120
		gfx.clear()
	end

	--[[
	three if statements that will check for right input and the currentPencilRadius,
	and based on the value of the currentPencilRadius, it will move to the right in the
	array and reassign the value of the currentPencilRadius to that index value
	]]
	if pd.buttonJustPressed("right") then
        if currentPencilRadius == pencilRadiusOptions[1] then
            currentPencilRadius = pencilRadiusOptions[2]
        elseif currentPencilRadius == pencilRadiusOptions[2] then
            currentPencilRadius = pencilRadiusOptions[3]
        elseif currentPencilRadius == pencilRadiusOptions[3] then
            currentPencilRadius = pencilRadiusOptions[1]
        end
    end

	--[[
	if statement checking if player hits the b button, and based on the state of drawingStopped, 
	it will reassign the drawingStopped value to the opposite of that
	]]
	if pd.buttonJustPressed("b") then
		drawingStopped = not drawingStopped
	end

	--[[
	if statement checking if the drawingStopped value is false, and if so it will draw a line in the current direction
	of the crankAngle times the drawSpeed
	]]
	if drawingStopped == false then
		positionX += math.sin(crankAngle) * drawSpeed
		positionY -= math.cos(crankAngle) * drawSpeed
	end

	gfx.fillCircleAtPoint(positionX, positionY, currentPencilRadius)
end