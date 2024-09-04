import "CoreLibs/graphics"

--playdate SDK variables
local pd <const> = playdate
local gfx <const> = pd.graphics
local screenWidth = pd.display.getWidth()
local screenHeight = pd.display.getHeight()

--variables for the state the game is in
local gameState = {
	title = "title",
	help = "help",
	drawing = "drawing"
}
local currentGameState = gameState.title

--variables for drawing screen
local positionX, positionY = 200, 120
local pencilRadiusOptions = {2.5, 5, 10}
local currentPencilRadius = pencilRadiusOptions[1]
local drawSpeed = 1.25

--variables for start screen
local startScreenTitle = "Etch-A-Sketch Playdate Edition"
local startScreenHeader1 = "Press A to start drawing!"
local startScreenHeader2 = "Press B to view controls."
local creditsText = "Program by Nicholas Aguirre"

--variables for controls screen
local controlsHeaderText = "Controls"
local drawControlText = "Crank: Adjust direction of pencil"
local pencilSizeText = "Right: Change Pencil Size"
local drawText = "Up: Draw"
local clearScreenText = "A: Clear Screen"
local titleNavText = "Press B to go back to the Title Screen"

function checkCollisionWithScreenEdges(x, y, width, height)
    if x < 0 then
        return "left"
    elseif x + width > screenWidth then
        return "right"
    elseif y < 0 then
        return "top"
    elseif y + height > screenHeight then
        return "bottom"
    else
        return nil
    end
end

function pd.update()
	if currentGameState == gameState.title then
		gfx.clear()

		gfx.drawText(startScreenTitle, 80, 40)
		gfx.drawText(startScreenHeader1, 100, 100)
		gfx.drawText(startScreenHeader2, 100, 120)

		gfx.drawText(creditsText, 90, 215)

		if pd.buttonJustPressed("a") then
			gfx.clear()
			currentGameState = gameState.drawing
		elseif pd.buttonJustPressed("b") then
			gfx.clear()
			currentGameState = gameState.help
		end
	elseif currentGameState == gameState.help then
		gfx.clear()

		gfx.drawText(controlsHeaderText, 60, 20)
		gfx.drawText("-----------", 60, 35)

		gfx.drawText(drawControlText, 100, 80)
		gfx.drawText(pencilSizeText, 100, 100)
		gfx.drawText(drawText, 100, 120)
		gfx.drawText(clearScreenText, 100, 140)

		gfx.drawText(titleNavText, 60, 215)

		if pd.buttonJustPressed("b") then
			gfx.clear()
			currentGameState = gameState.title
		end
	elseif currentGameState == gameState.drawing then
		local crankAngle = math.rad(pd.getCrankPosition())
		local isCollidingWithScreenEdge = checkCollisionWithScreenEdges(positionX, positionY, currentPencilRadius, currentPencilRadius)

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
		if the user is holding up on the dPad, it will draw a line in the current direction
		of the crankAngle times the drawSpeed
		]]
		if pd.buttonIsPressed("up") then
			positionX += math.sin(crankAngle) * drawSpeed
			positionY -= math.cos(crankAngle) * drawSpeed
		end

		--if statement checking for screen edge collision and not
		--letting user draw out of bounds
		if isCollidingWithScreenEdge ~= nil then
			if isCollidingWithScreenEdge == "left" then
				positionX = math.max(0, positionX)
			elseif isCollidingWithScreenEdge == "right" then
				positionX = math.min(400, positionX)
			elseif isCollidingWithScreenEdge == "top" then
				positionY = math.max(0, positionY)
			elseif isCollidingWithScreenEdge == "bottom" then
				positionY = math.min(240, positionY)
			end
		end

		gfx.fillCircleAtPoint(positionX, positionY, currentPencilRadius)
	end
end