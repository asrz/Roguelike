package view.pages

import javafx.event.EventHandler
import javafx.scene.input.KeyEvent
import view.Page
import view.ScreensController

class CloseWindowEventHandler implements EventHandler<KeyEvent>{
	Page page
	
	new(Page page) {
		this.page = page 
	}
	override void handle(KeyEvent event) {
		
		switch event.code {
			case ESCAPE: ScreensController.getScreensController().closeWindow(page)
		}
	}
}