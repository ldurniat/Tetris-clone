local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

system.setTapDelay( 0.02 )
 
-- local forward references should go here

local ALLOWED_MOVE = 1
local OFF_BOARD = 2
local OVERLAP_BLOCKS = 3
local OFF_BOTTOM_EDGE_OF_BOARD = 4
local board = {
    rows    = 22,
    columns = 10,
    side    = 50
}
board.offset_x = ( display.contentWidth - board.columns * board.side ) * 0.5
board.offset_y = display.contentHeight - board.rows * board.side
board.width    = board.columns * board.side
board.height   = board.rows * board.side
local blocks_patterns = {
   {  { 1, 1, 1 },
      { 0, 0, 1 },
      { 0, 0, 0 }
   },
   {  { 1, 1, 1 },
      { 0, 1, 0 },
      { 0, 0, 0 }
   },
   {  { 1, 1 },
      { 1, 1 }
   },
   {  { 0, 1, 1 },
      { 0, 1, 0 },
      { 1, 1, 0 }
   },
   {  { 0, 1, 0, 0 },
      { 0, 1, 0, 0 },
      { 0, 1, 0, 0 },
      { 0, 1, 0, 0 }
   },
}
local createNewBlock 
local was_swipe_done = false
local new_block
---------------------------------------------------------------------------------
local function canPlace( block )
    local block_size = block.grid_size

    for i=1, block_size do
        for j=1, block_size do
            if block[i] and block[i][j] then
                if block.grid_x - 1 + j < 1 then return OFF_BOARD end
                if block.grid_x - 1 + j > board.columns then return OFF_BOARD end
                if block.grid_y - 1 + i > board.rows then return OFF_BOTTOM_EDGE_OF_BOARD end
                if board[block.grid_y + i - 1] and 
                    board[block.grid_y + i - 1][block.grid_x + j - 1] then return OVERLAP_BLOCKS end
            end   
        end
    end  

    return ALLOWED_MOVE

end 

local function rotateBlock()
    if new_block then
        local falling_block  = new_block
        local block = {}
        local block_size = falling_block.grid_size

        block.grid_size = block_size
        block.grid_x = falling_block.grid_x
        block.grid_y = falling_block.grid_y

        for i=1, block_size do
            for j=1, block_size do
                if falling_block[block_size + 1 - i] and falling_block[block_size + 1 - i][j] then
                    if not block[j] then block[j] = {} end

                    block[j][i] = 1

                end   
            end
        end 

        local result = canPlace( block )

        if result == ALLOWED_MOVE then

            block.timer = falling_block.timer

            for i=1, block_size do
                for j=1, block_size do
                    if falling_block[block_size + 1 - i] and falling_block[block_size + 1 - i][j] then

                        block[j][i] = falling_block[block_size + 1 - i][j]
                        block[j][i].x = board.offset_x + ( i - 2 + block.grid_x ) * board.side  
                        block[j][i].y = board.offset_y + ( j - 2 + block.grid_y ) * board.side  

                    end 
                end
            end

            new_block = block
        end
    end    
end         

local function moveDownAsMuchAsPossible()
    if new_block then
        local falling_block  = new_block
        local block = {}
        local block_size = falling_block.grid_size

        block.grid_size = block_size

        for i=1, block_size do
            for j=1, block_size do
                if falling_block[i] and falling_block[i][j] then
                    if not block[i] then block[i] = {} end

                    block[i][j] = 1

                end   
            end
        end 

        local max_units_move_block_down = 0

        for i=1, 22 do
            max_units_move_block_down = max_units_move_block_down + 1

            block.grid_x = falling_block.grid_x 
            block.grid_y = falling_block.grid_y + max_units_move_block_down

            local result = canPlace( block )

            if result ~= ALLOWED_MOVE then break end
        end        

        falling_block.grid_y = falling_block.grid_y + max_units_move_block_down - 1 

        for i=1, block_size do
            for j=1, block_size do
                if falling_block[i] and falling_block[i][j] then
                    local rect = falling_block[i][j]
                    if  rect then

                        rect.y = rect.y + ( max_units_move_block_down - 1 )* board.side
                        rect.isVisible = true

                    end   
                end  
            end
        end
  
    end    
end         

local function moveBlockInLeft()
    if new_block then
        local falling_block  = new_block
        local block = {}
        local block_size = falling_block.grid_size

        block.grid_size = block_size

        for i=1, block_size do
            for j=1, block_size do
                if falling_block[i] and falling_block[i][j] then
                    if not block[i] then block[i] = {} end

                    block[i][j] = 1

                end   
            end
        end 

        block.grid_x = falling_block.grid_x - 1
        block.grid_y = falling_block.grid_y 

        local result = canPlace( block )

        if result == ALLOWED_MOVE then

            falling_block.grid_x = falling_block.grid_x - 1 

            for i=1, block_size do
                for j=1, block_size do
                    if falling_block[i] and falling_block[i][j] then
                        local rect = falling_block[i][j]
                        if  rect then

                            rect.x = rect.x - board.side

                        end   
                    end  
                end
            end
        end
    end    
end        

local function moveBlockInRight()
    if new_block then
        local falling_block  = new_block
        local block = {}
        local block_size = falling_block.grid_size

        block.grid_size = block_size

        for i=1, block_size do
            for j=1, block_size do
                if falling_block[i] and falling_block[i][j] then
                    if not block[i] then block[i] = {} end

                    block[i][j] = 1

                end   
            end
        end 

        block.grid_x = falling_block.grid_x + 1
        block.grid_y = falling_block.grid_y 

        local result = canPlace( block )

        if result == ALLOWED_MOVE then

            falling_block.grid_x = falling_block.grid_x + 1 

            for i=1, block_size do
                for j=1, block_size do
                    if falling_block[i] and falling_block[i][j] then
                        local rect = falling_block[i][j]
                        if  rect then

                            rect.x = rect.x + board.side

                        end   
                    end  
                end
            end
        end
    end    
end        

local function tap( event )
    rotateBlock() 
    return true
end    

local function touch( event )
    local phase = event.phase

    if phase == "moved" then
        if not was_swipe_done then
            local distance_x = event.x - event.xStart
            local distance_y = event.y - event.yStart

            if distance_x > 50 then
                was_swipe_done = true
                moveBlockInRight()
                print( 'swipe in right' )
             
            elseif  distance_x < -50  then
                was_swipe_done = true
                moveBlockInLeft()
                print( 'swipe in left' )

            elseif  distance_y > 50  then
                was_swipe_done = true  
                moveDownAsMuchAsPossible()
                print( 'swipe in down' )    
            end
        end
    elseif phase == "ended" or phase == "cancelled" then
        was_swipe_done = false        
    end

    return true
end

local function removeLines()

    for i=1, board.rows do
        local need_move_down_row = true
        for j=1, board.columns do
            if  not board[i] or not board[i][j] then
                need_move_down_row = false 
                break
            end
        end  

        if need_move_down_row then
            for j=1, board.columns do
                local rect = board[i][j]
                if rect then
                    display.remove( rect )
                    board[i][j] = nil
                end    
            end   

            for j=1, board.columns do 
                for k=i-1, 1, -1 do 
                    if board[k] then
                        local rect_to_move = board[k][j]
                        if rect_to_move then
                            board[k + 1][j] = rect_to_move
                            board[k][j] = nil
                            rect_to_move.y = rect_to_move.y + board.side
                        end    
                    end    
                end
            end  
        end    
    end

    createNewBlock()   
end

local function moveDownBlock( event )

    local falling_block  = new_block
    local block = {}
    local block_size = falling_block.grid_size

    block.grid_size = block_size
    
    for i=1, block_size do
        for j=1, block_size do
            if falling_block[i] and falling_block[i][j] then
                if not block[i] then block[i] = {} end

                block[i][j] = 1
                
            end   
        end
    end 

    block.grid_x = falling_block.grid_x
    block.grid_y = falling_block.grid_y + 1

    local result = canPlace( block )

    if result == ALLOWED_MOVE then

        falling_block.grid_y = falling_block.grid_y + 1

        for i=1, block_size do
            for j=1, block_size do
                if falling_block[i] and falling_block[i][j] then
                    local rect = falling_block[i][j]
                    if  rect then

                        rect.y = rect.y + board.side

                        if falling_block.grid_y + i - 1 > 0 then rect.isVisible = true end

                    end   
                end  
            end
        end  
    elseif result == OFF_BOTTOM_EDGE_OF_BOARD or result == OVERLAP_BLOCKS then
        for i=1, block_size do
            for j=1, block_size do
                if falling_block[i] and falling_block[i][j] then

                    if not board[falling_block.grid_y + i - 1] then board[falling_block.grid_y + i - 1] = {} end

                        board[falling_block.grid_y + i - 1][falling_block.grid_x + j - 1] = falling_block[i][j]
                        falling_block[i][j] = nil

                end
            end
        end

        timer.cancel( falling_block.timer )

        removeLines()
    end   
end   

function createNewBlock()

    local index = math.random( #blocks_patterns )
    local pattern = blocks_patterns[ index ]
    new_block = { grid_x = 4, grid_y = 1 - #pattern }

    for j=1, #pattern do
        for i=1, #pattern do
            if pattern[i][j] == 1 then
                if not new_block[i] then new_block[i] = {} end

                local x = board.offset_x + ( j - 2 + new_block.grid_x ) * board.side  
                local y = board.offset_y + ( i - 2 + new_block.grid_y ) * board.side  
                new_block[i][j] = display.newRect( scene.view, x, y, board.side, board.side )
                new_block[i][j].anchorX = 0
                new_block[i][j].anchorY = 0
                new_block[i][j].isVisible = false

            end   
        end
    end 

    new_block.grid_size = #pattern

    new_block.timer = timer.performWithDelay( 300, moveDownBlock, -1 )    

end
 
local function drawBoard()

    local sceneGroup = scene.view
    local x1, y1, x2, y2
    local hline
    -- Draw horizontal lines
    for i=0, board.rows do

        x1, y1      = board.offset_x, board.offset_y + i * board.side
        x2, y2      = board.offset_x + board.width, y1
        hline       = display.newLine( sceneGroup, x1, y1, x2, y2 )
        hline.width = 2

    end   
    -- Draw vertical lines
    for i=0, board.columns do

        x1, y1      = board.offset_x + i * board.side, board.offset_y 
        x2, y2      = x1, board.offset_y + board.height
        hline       = display.newLine( sceneGroup, x1, y1, x2, y2 )
        hline.width = 2

    end 

end   

-- "scene:create()"
function scene:create( event )
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.  

    --[[
    board[22] = {}

    for i=1, board.columns do
        local x = board.offset_x + ( i - 1 ) * board.side  
        local y = board.offset_y + 21 * board.side  
        board[22][i] = display.newRect( scene.view, x, y, board.side, board.side )
        board[22][i].anchorX = 0
        board[22][i].anchorY = 0
    end
    --]]

    drawBoard()
end
 
-- "scene:show()"
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
        createNewBlock()

        Runtime:addEventListener( "touch", touch )
        Runtime:addEventListener( "tap", tap )
    end
end
 
-- "scene:hide()"
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.

        Runtime:removeEventListener( "touch", touch )
        Runtime:removeEventListener( "tap", tap )
    end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene