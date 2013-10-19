-- Declare the visible width and height of the screen as constants
_W = display.viewableContentWidth;
_H = display.viewableContentHeight;

print(_W)
print(_H)

--Because they are global, these variables will be accessible throughout the entire app
--Load external libraries
local storyboard = require("storyboard");--Include the storyboard library

local mydata = require("mydata")

mydata.lvl = 1
mydata.lvlUnlocked = 5
mydata.shot = 0
mydata.restart = 0
mydata.score = 0
mydata.collision = 0
mydata.star = {}
mydata.deviceUnlocked = 1
mydata.startMusic = nil
mydata.lvlMusic = nil
mydata.time = 60

display.setStatusBar(display.HiddenStatusBar);

-- load first scene
storyboard.gotoScene("IntroLogo");
