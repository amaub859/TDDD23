--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

local mydata = require("mydata")

local myFont = (platform ~= "Android") and "Manteka" or system.nativeFont;


function scene:createScene(e)
	local view = self.view
	
	function reload(e)
		if e.phase == "began" then
			mydata.restart = mydata.restart + 1
			storyboard.removeScene("level"..mydata.lvl)
			storyboard.gotoScene("level"..mydata.lvl)
		end
	end
	
	--------------Background----------------
	background = display.newImageRect("images/lvlBackground" .. mydata.lvl .. ".png",_W,_H)
	background.x = _W * 0.5;
	background.y = _H * 0.5;
	view:insert(background);
	background:addEventListener("touch", reload)
	----------------------------------------
	
	---------------textGroup----------------
    lvlText = display.newText(string.format("Level %1d", mydata.lvl),0,0,myFont,24)
    lvlText:setTextColor(255,156,0)
    
    lvlText.x = _W * 0.5
    lvlText.y = _H * 0.3
   
    view:insert(lvlText)
    --------------------------------------

end

function scene:enterScene(e)
	local view = self.view
	

end

function scene:exitScene(e)
	local view = self.view
	
	display.remove(lvlText)
	lvlText = nil
	
	background:removeEventListener("touch", reload)
	display.remove(background)
	background = nil
	
	physics.stop()
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);


return scene