local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here

local board = {
   rows    = 22,
   columns = 10,
   side    = 50
}
board.offset_x = ( display.contentWidth - board.columns * board.side ) * 0.5
board.offset_y = display.contentHeight - board.rows * board.side
board.width    = board.columns * board.side
board.height   = board.rows * board.side
 
---------------------------------------------------------------------------------
 
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