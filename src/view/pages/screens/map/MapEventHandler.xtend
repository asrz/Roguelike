package view.pages.screens.map

import javafx.event.EventHandler
import javafx.scene.input.KeyEvent
import model.ai.PlayerAi
import view.GameController

class MapEventHandler implements EventHandler<KeyEvent> {
	
	override handle(KeyEvent event) {
		val context = GameController::context
		val player = context.player
		val playerAi = player.ai as PlayerAi
		val acted = playerAi.handleEvent(event)
		
		if (acted) {
			GameController::context.update()
		}
	}
	
}