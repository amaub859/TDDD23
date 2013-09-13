--requires

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

--Background

function scene:createScene(event)

	local screenGroup = self.view
	background = display.newImage("bkg_bricks.png") 
	screenGroup:insert(background)
	
end

function start(event)
	if event.phase == "began" then
	--print("start")
	storyboard.gotoScene("game", "fade", 400)
	end
end


function scene:enterScene(event)

	background:addEventListener("touch", start)

end

function scene:exitScene(event)
	background:removeEventListener("touch", start)
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene


