--Playdate Life Tracker: A simple little app to keep track of stats during a game of commander
--
-- Design by: Cameron Shelton
-- Code by: Cameron Shelton
-- Version: 1.2.2
--
-- NEXT Release: Better Graphics, mess with fonts
--
-- Future Plans: 
--      -relative instead of absolute coords
--      -much better art
--      -continue code cleanup as I learn


--Known Bugs: 
-- -Negative Commander Damage, Commander Tax & Poison Counters
-- -Low-resolution text 
--

------pdxinfo------
--name=LifeTracker
--author=Cam
--description=A Simple Commander Life Tracker
--bundleID=com.cam.LifeTracker
--version=1.2.1
--buildNumber=124


--Default Playdate imports
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"   




--Define scale, refresh rate & other graphics options
playdate.display.setScale(1)
playdate.display.setRefreshRate(10)
playdate.graphics.setLineWidth(3)
bigFont = playdate.graphics.font.new("Roobert-24-Medium")

--Add item to Playdate menu to reset tracker
local menu = playdate.getSystemMenu()
menu:addMenuItem("Reset Tracker", function() initalizeTracker() end)

--define some things about the game state, whether we are in title screen, in-game, or death mode
gameState = 2 -- 0 = death, 1 = in-game, 2 = show title screen
--also whether we are adding or subtracting (this is used to save on multiple functions for adding and subtracting based on button presses)

addorsub = 1 -- 1 = add, 2 = subtract

--define information about the menu's cursor
--Defines the length of the cursor when we draw it, this gets added to the first defined coordinate to get the second one
cursorLength = 30
--Array used to place coordinates in the cursor drawing function
cursorLocation = {1,1}
--locations for the cursor to be drawn on & their corresponding indices
lifeCursorLocation = {80,120} --cursor index 1
cmdr1CursorLocation = {180,140} --cursor index 2
cmdr2CursorLocation = {255,140} --cursor index 3
cmdr3CursorLocation = {320,140} --cursor index 4
poisonCursorLocation = {50,170} --cursor index 5
taxCursorLocation = {50,220} --cursor index 6
--this determines what we do (based on where the cursor is) when a button is pressed
cursorIndex = 1

--Draw the cursor, our main means of navigation and action selection
function drawCursor()
    --first, wrap the cursor if needed
    if cursorIndex == 0 then cursorIndex = 6 end
    if cursorIndex == 7 then cursorIndex = 1 end

    --set the cursorLocation based on the cursorIndex
    if cursorIndex == 1 then
        cursorLocation[1] = lifeCursorLocation[1]
        cursorLocation[2] = lifeCursorLocation[2]
    elseif cursorIndex == 2 then
        cursorLocation[1] = cmdr1CursorLocation[1]
        cursorLocation[2] = cmdr1CursorLocation[2]
    elseif cursorIndex == 3 then
        cursorLocation[1] = cmdr2CursorLocation[1]
        cursorLocation[2] = cmdr2CursorLocation[2]
    elseif cursorIndex == 4 then
        cursorLocation[1] = cmdr3CursorLocation[1]
        cursorLocation[2] = cmdr3CursorLocation[2]
    elseif cursorIndex == 5 then
        cursorLocation[1] = poisonCursorLocation[1]
        cursorLocation[2] = poisonCursorLocation[2]
    elseif cursorIndex == 6 then
        cursorLocation[1] = taxCursorLocation[1]
        cursorLocation[2] = taxCursorLocation[2]
    end

    --draw the cursor based on our defined location, add cursorLength to the 2nd X coord)
    playdate.graphics.drawLine(cursorLocation[1],cursorLocation[2],(cursorLocation[1] + cursorLength),cursorLocation[2])    
end



 --Define default values for Life total & damage taken -- function also used to reset the tracker
function initalizeTracker()
    --cursorLocation[1] = 1
    --cursorLocation[2] = 1
    lifeCounter = 40
    commanderTax = 0
    poisonCounters = 0
    commanderDamage1 = 0
    commanderDamage2 = 0
    commanderDamage3 = 0    
    playdate.graphics.clear()
end

--Draw a 'You Died' Screen
function youDied()
    playdate.graphics.image.new("death"):draw(0,0)
end

--Draw the title screen
function titleScreen()
    playdate.graphics.image.new("title"):draw(0,0)
end

function drawUI()
    --Draw Background image
    playdate.graphics.image.new("tracker"):draw(0,0)
    --Draw UI element for tracking Life Total
    bigFont:drawText(lifeCounter,70,50)
    --Draw UI element for tracking 3 quantities of commander damage
    bigFont:drawText(commanderDamage1,190,60)
    bigFont:drawText(commanderDamage2,260,60)
    bigFont:drawText(commanderDamage3,330,60)
    --Draw UI element for tracking poison counters
    bigFont:drawText(poisonCounters,110,140)
    --draw UI element for tracking commander tax
    bigFont:drawText((commanderTax * 2),110,195)
end
 
--GROSS - this function handles what happens when the user presses the a button, there's gotta be a better way to do this
function doSomething()
    --Life Total
    if cursorIndex == 1 then
        if addorsub == 1 then lifeCounter = lifeCounter + 1 end
        if addorsub == 2 then lifeCounter = lifeCounter - 1 end
    --Commander Damage 1
    elseif cursorIndex == 2 then
        if addorsub == 1 then 
            lifeCounter = lifeCounter - 1 
            commanderDamage1 = commanderDamage1 + 1
        end
        if addorsub == 2 then 
            lifeCounter = lifeCounter + 1 
            commanderDamage1 = commanderDamage1 - 1
        end
    --commander Damage 2
    elseif cursorIndex == 3 then
        if addorsub == 1 then 
            lifeCounter = lifeCounter - 1 
            commanderDamage2 = commanderDamage2 + 1
        end
        if addorsub == 2 then 
            lifeCounter = lifeCounter + 1 
            commanderDamage2 = commanderDamage2 - 1
        end
    --commander damage 3
    elseif cursorIndex == 4 then
        if addorsub == 1 then 
            lifeCounter = lifeCounter - 1 
            commanderDamage3 = commanderDamage3 + 1
        end
        if addorsub == 2 then 
            lifeCounter = lifeCounter + 1 
            commanderDamage3 = commanderDamage3 - 1
        end
    --Poison Counters
    elseif cursorIndex == 5 then
        if addorsub == 1 then poisonCounters = poisonCounters + 1 end
        if addorsub == 2 then poisonCounters = poisonCounters - 1 end
    --Commander Tax    
    elseif cursorIndex == 6 then
        if addorsub == 1 then commanderTax = commanderTax + 1 end
        if addorsub == 2 then commanderTax = commanderTax - 1 end        
    end
end

--Check and see if the player has lost the game. haha, you lost the game.
function checkFordeath()
    if lifeCounter<=0 then
        gameState = 0
    end
    if commanderDamage1==21 then
        gameState = 0
    end
    if commanderDamage2==21 then
        gameState = 0
    end
    if commanderDamage3==21 then
        gameState = 0
    end
    if poisonCounters>9 then
        gameState = 0
    end
end


--done defining things, let's start our tracker, then move on to the main function
initalizeTracker()

------------------------------------------------------------------------------------------
--Main Playdate function, runs when the screen refreshes. Tracks user input & draws the UI
------------------------------------------------------------------------------------------    
function playdate.update()

--First, check to see if the player has lost the game. haha, you lost the game.
    checkFordeath()
    playdate.graphics.clear()

--If the player hasn't lost, draw the main UI, otherwise show the death screen
    if gameState == 0 then youDied()
        elseif gameState == 1 then  
        --Draw a fresh copy of the UI using functions defined above
            drawUI()
            drawCursor()
        elseif gameState == 2 then titleScreen()
    end

    --UP BUTTON FUNCTION
    if playdate.buttonJustPressed( playdate.kButtonUp ) then

    end

    --RIGHT BUTTON FUNCTION
    if playdate.buttonJustPressed( playdate.kButtonRight ) then
        cursorIndex = cursorIndex + 1
    end

    --DOWN BUTTON FUNCTION  
    if playdate.buttonJustPressed( playdate.kButtonDown ) then

    end

    --LEFT BUTTON FUNCTION
    if playdate.buttonJustPressed( playdate.kButtonLeft ) then
        cursorIndex = cursorIndex - 1
    end
    
    --A BUTTON FUNCTION
    if playdate.buttonJustPressed(playdate.kButtonA) then
        --If gamestate is 'Title Screen', reset gamestate, initialize tracker & show tracker
        if gameState == 2 then
            gameState = gameState - 1
            initalizeTracker()
        --if gamestate is 'in-game', 'add' to currently highlited tracker item
        elseif gameState == 1 then
            addorsub = 1
            doSomething()
        --if gamestate is 'death', show death screen
        elseif gameState == 0 then
            youDied()
            initalizeTracker()
            gameState = 1
        end               
    end
    if playdate.buttonJustPressed(playdate.kButtonB) then
        --if gamestate is 'in-game', 'subtract' from currently highlighted tracker item
        if gameState == 1 then
        addorsub = 2
        doSomething()
        end
    end
end