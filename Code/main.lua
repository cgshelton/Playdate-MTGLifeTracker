--Playdate Life Tracker: A simple little app to keep track of stats during a game of commander
--
-- Design by: Cameron Shelton
-- Code by: Cameron Shelton
-- Version: 1.0 - Initial Release
--
-- NEXT Release: Replace life total +/- with just 1 row and use a and b button for +/-
--             then add a row for poison, commander tax, and something else...
--
-- Future Plans: 
--      -Art instead of text - relative instead of absolute coords
--      -Clean up logic for the menu & integrate it into exisitng UI instead of taking up half the screen for it
--      -Add menu item to reset
--      -Add title card & Failure state

--Default Playdate imports
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"   

--Define scale, refresh rate & other graphics options
playdate.display.setScale(2)
playdate.display.setRefreshRate(10)
playdate.graphics.setLineWidth(3)

--define information about the menu's cursor
--Cursor's Grid location, defines what the cursor will 'do' when we press a button
cursorLocation = {1,1}
--Defines the length of the cursor when we draw it, this gets added to the first defined coordinate to get the second one
cursorLength = 10
--X and Y coordinates for the cursor, these are the defaults, is overwritten when Up, Down, Left or Right are pushed
cursorX = 130
cursorY = 72
--X and Y Coordinates for the location to draw the cursor
col1_x = 130
col2_x = 160
col3_x = 190
row1_y = 72
row2_y = 92
row3_y = 112

 --Define default values for Life total & damage taken -- function also used to reset the tracker
function initalizeTracker()
    lifeCounter = 40
    commanderTax = 0
    poisonCounters = 0
    commanderDamage1 = 0
    commanderDamage2 = 0
    commanderDamage3 = 0    
end

--Draw UI element for tracking Life Total
function drawMainLife()
    playdate.graphics.drawRoundRect(5, 5, 60,40,10)
    playdate.graphics.drawText(lifeCounter,25,10)
    playdate.graphics.drawText("*life*",20,27)
end

--Draw UI element for tracking 3 quantities of commander damage
function drawCommanderDamage()
    playdate.graphics.drawRoundRect(75, 5,120,40,10)
    playdate.graphics.drawText(commanderDamage1,80,10)
    playdate.graphics.drawText(commanderDamage2,120,10)
    playdate.graphics.drawText(commanderDamage3,160,10)
    playdate.graphics.drawText("*cmdr. damage*",80,27)
end

--Draw UI element for tracking poison counters
function drawPoison()
    playdate.graphics.drawRoundRect(5,50,60,40,10)
    playdate.graphics.drawText(poisonCounters,30,55)
    playdate.graphics.drawText("*psn.*",20,72)
end

--draw UI element for tracking commander tax
function drawTax()
    playdate.graphics.drawRoundRect(5,95,60,20,10)
    playdate.graphics.drawText("*tax:*" .. (commanderTax * 2),10,97)
end

--Draw UI element for the menu (yes, this is very gross currently, i'm doing the best I can right now)
function drawNav()
    playdate.graphics.drawRoundRect(75,50,120,65,10)
    playdate.graphics.drawText("life-     1  5  10",80,55)
    playdate.graphics.drawText("life+     1  5  10",80,75)
    playdate.graphics.drawText("cmdr.  1  2   3",80,95)
end

--Move the cursor around
function moveCursor()
    --Bounding the cursor within our 3 rows/columns, these statements push the cursor from the top item to the bottom item
    --and vice versa, same for left to right & right to left
    if cursorX > 170 then cursorX = 130 end
    if cursorX < 130 then cursorX = 170 end
    if cursorY > 112 then cursorY = 72 end
    if cursorY < 72 then cursorY = 112 end
    --Same thing except this defines our button function instead of the UI elements
    if cursorLocation[1] > 3 then cursorLocation[1] = 1 end
    if cursorLocation[1] < 1 then cursorLocation[1] = 3 end
    if cursorLocation[2] > 3 then cursorLocation[2] = 1 end
    if cursorLocation[2] < 1 then cursorLocation[2] = 3 end
    --Finally drawing the cursor based on it's defined location
    playdate.graphics.drawLine(cursorX,cursorY,(cursorX + cursorLength),cursorY)    
end
 
--GROSS - this function handles what happens when the user presses the a button, there's gotta be a better way to do this
function doSomething()
    --Action Index 1 - deccrement life total by 1 
    if cursorLocation[1]==1 and cursorLocation[2]==1 then
        lifeCounter = lifeCounter - 1
    end
    --Action Index 2 - deccrement life total by 5 
    if cursorLocation[1]==2 and cursorLocation[2]==1 then
        lifeCounter = lifeCounter - 5
    end
    --Action Index 3 - deccrement life total by 10 
    if cursorLocation[1]==3 and cursorLocation[2]==1 then
        lifeCounter = lifeCounter - 10
    end
    --Action Index 4 - inccrement life total by 1 
    if cursorLocation[1]==1 and cursorLocation[2]==2 then
        lifeCounter = lifeCounter + 1
    end
    --Action Index 5 - inccrement life total by 5 
    if cursorLocation[1]==2 and cursorLocation[2]==2 then
        lifeCounter = lifeCounter + 5
    end
    --Action Index 6 - inccrement life total by 10 
    if cursorLocation[1]==3 and cursorLocation[2]==2 then
        lifeCounter = lifeCounter + 10
    end
    --Action Index 7 - inccrement commander damage 1 by 1
    if cursorLocation[1]==1 and cursorLocation[2]==3 then
        commanderDamage1 = commanderDamage1 + 1
        lifeCounter = lifeCounter - 1
    end
    --Action Index 8 - inccrement commander damage 2 by 1
    if cursorLocation[1]==2 and cursorLocation[2]==3 then
        commanderDamage2 = commanderDamage2 + 1
        lifeCounter = lifeCounter - 1
    end
    --Action Index 9 - inccrement commander damage 3 by 1
    if cursorLocation[1]==3 and cursorLocation[2]==3 then
        commanderDamage3 = commanderDamage3 + 1
        lifeCounter = lifeCounter - 1
    end
end


--Call the initalizeTracker function to start the app
initalizeTracker()

--Main Playdate function, runs when the screen refreshes. Tracks user input & draws the UI
function playdate.update()
    --move cursor up and update action index when user presses the Up Button
        if playdate.buttonIsPressed( playdate.kButtonUp ) then
            cursorY = cursorY - 20
            cursorLocation[2] = cursorLocation[2] - 1
        end

    --move cursor Right and update action index when user presses the Right Button
        if playdate.buttonIsPressed( playdate.kButtonRight ) then
            cursorX = cursorX + 20
            cursorLocation[1] = cursorLocation[1] + 1
        end

    --move cursor down and update action index when user presses the down button    
        if playdate.buttonIsPressed( playdate.kButtonDown ) then
            cursorY = cursorY + 20
            cursorLocation[2] = cursorLocation[2] + 1
        end

    --move cursor left and update action index when user presses the left Button
        if playdate.buttonIsPressed( playdate.kButtonLeft ) then
            cursorX = cursorX - 20
            cursorLocation[1] = cursorLocation[1] - 1
        end
    
    --take the selected action based on the cursor location / action index
        if playdate.buttonIsPressed( playdate.kButtonA) then
            doSomething()
        end

    --Clear the screen - otherwise stuff just stacks on top
        playdate.graphics.clear()
    --Draw a fresh copy of the UI using functions defined above
        drawMainLife()
        drawCommanderDamage()
     --   drawPoison()
     --   drawTax()
        drawNav()
        moveCursor()
    end
    
    