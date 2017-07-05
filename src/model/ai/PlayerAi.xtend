package model.ai

import javafx.scene.input.KeyCode
import javafx.scene.input.KeyEvent
import map.Map
import model.Actor
import model.Direction
import view.GameController
import view.Page
import view.ScreensController

class PlayerAi extends Ai {
	
	Mode mode = Mode.MOVE
	
	new(Actor owner) {
		super(owner)
	}
	
	new(Actor owner, int turnsLeft, Ai oldAi) {
		super(owner, turnsLeft, oldAi)
	}
	
	def boolean handleEvent(KeyEvent event) {
		val context = GameController::context;
		val map = context.map
		var acted = true
		val direction = event.code.toDirection()
		
		if (direction !== null) {
			mode = act(mode, map, owner, direction)
		} else {
			switch event.code {
				case ESCAPE : GameController::close()
				case E : {
					mode = Mode.INTERACT
					acted = false
				}
				case A : {
					mode = Mode.ATTACK
					acted = false
				}
				// TODO : should these count as a turn?
				case G : ScreensController.screensController.openWindow(Page.PICKUP_MENU)
				case I : ScreensController.screensController.openWindow(Page.INVENTORY)
				case Q : ScreensController.screensController.openWindow(Page.ABILITY_MENU)
				default : acted = false
			}
		}
		return acted
	}
	
	def act(Mode mode, Map map, Actor player, Direction direction) {
		switch mode {
			case INTERACT : map.interact(player, direction)
			case MOVE : map.moveActor(player, direction)
			case ATTACK: map.attackMove(player, direction)
		}
		return Mode.MOVE
	}
	
	enum Mode {
		MOVE,
		INTERACT,
		ATTACK,
		EXAMINE
	}
	
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
}