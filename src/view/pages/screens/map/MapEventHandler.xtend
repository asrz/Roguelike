package view.pages.screens.map

import javafx.event.EventHandler
import javafx.scene.input.KeyCode
import javafx.scene.input.KeyEvent
import map.Map
import modelX.ActorX
import modelX.Direction
import view.GameController
import view.Page
import view.ScreensController

class MapEventHandler implements EventHandler<KeyEvent> {
	
	enum Mode {
		MOVE,
		INTERACT,
		ATTACK,
		EXAMINE
	}
	
	Mode mode = Mode.MOVE
	
	def toDirection(KeyCode keyCode) {
		return switch keyCode {
			case NUMPAD1 : Direction.SOUTHWEST
			case NUMPAD2, case DOWN : Direction.SOUTH
			case NUMPAD3 : Direction.SOUTHEAST
			case NUMPAD4, case LEFT : Direction.WEST
			case NUMPAD5 : Direction.ZERO
			case NUMPAD6, case RIGHT : Direction.EAST
			case NUMPAD7 : Direction.NORTHWEST 
			case NUMPAD8, case UP : Direction.NORTH
			case NUMPAD9 : Direction.NORTHEAST
			default : null
		}
	}
	
	override handle(KeyEvent event) {
		val context = GameController::context
		val player = context.player
		val map = context.map
		var acted = true
		val direction = event.code.toDirection()
		
		if (direction !== null) {
			mode = act(mode, map, player, direction)
		} else {
			switch code : event.code {
				case ESCAPE : GameController::close()
				case E : {
					mode = Mode.INTERACT
					acted = false
				}
				// TODO : should these count as a turn?
				case G : ScreensController.screensController.openWindow(Page.PICKUP_MENU)
				case I : ScreensController.screensController.openWindow(Page.INVENTORY)
			}
		}
		
		if (acted) {
			val mapController = ScreensController.screensController.getController(Page.MAP) as MapController
			mapController.takeTurn()
		}
	}
	
	def act(Mode mode, Map map, ActorX player, Direction direction) {
		switch mode {
			case INTERACT : map.interact(player, direction)
			case MOVE : map.moveActor(player, direction)
		}
		return Mode.MOVE
	}
	
}