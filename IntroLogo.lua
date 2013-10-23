--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

--Forward references so that we can access objects accross functions
local logo;
local anim;
local background

function scene:createScene(e)	

	local view = self.view
	
	background = display.newImageRect("images/background/bg.png",_W,_H)
	background.x = _W * 0.5;
	background.y = _H * 0.5;
	
	local font = "HelveticaNeue" or native.systemFont;
    
    --Remember: this is local to the entire scene (line 6)
    logo = display.newImageRect("images/logo.png",165,60);
	logo.x = _W * 0.5 + 30;
	logo.y = _H * 0.5;
	
	view:insert(background);
    view:insert(logo);
end

function scene:enterScene(e)
	
	anim = transition.to(logo,
	{
		time = 5000,
		xScale = 3,
		yScale = 3,
		transition = easing.inQuad,
		onComplete = function() -- define a callback function to fire when the animation is completed
			--background:addEventListener("touch", startAnim)
		end
	})
	
	function goToNextFrame(e)
		if e.phase == "began" then
		storyboard.gotoScene("mainMeny", "fade", 400)
		end
	end
	
	background:addEventListener("touch", goToNextFrame)

end


function scene:exitScene(e)
	--Stop listeners, timers, and animations (transitions)
	
	storyboard.removeScene("IntroLogo")--Remove all scene1 display objects
	--background:removeEventListener("touch", goToNextFrame)

end

scene:addEventListener("createScene", scene);

scene:addEventListener("enterScene", scene);

scene:addEventListener("exitScene", scene);
--There are more events you can listen for;
--See the Corona docs

return scene