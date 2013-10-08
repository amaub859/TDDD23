-- Declare the visible width and height of the screen as constants
_W = display.viewableContentWidth;
_H = display.viewableContentHeight;
--Because they are global, these variables will be accessible throughout the entire app
--Load external libraries
local storyboard = require("storyboard");--Include the storyboard library

local mydata = require("mydata")

mydata.lvl = 1
mydata.lvlUnlocked = 1
mydata.reload = 0
mydata.score = 0
mydata.collision = 0

display.setStatusBar(display.HiddenStatusBar);

-- load first scene
storyboard.gotoScene("IntroLogo");
