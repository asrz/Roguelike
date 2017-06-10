package view.pages.screens.main_menu

import java.io.IOException
import javafx.event.ActionEvent
import javafx.fxml.FXML
import view.ControlledScreen
import view.Page
import view.ScreensController

class MainMenuController implements ControlledScreen {
	@FXML def protected void handleNewGameButtonAction(ActionEvent event) throws IOException {
		ScreensController.getScreensController().setScreen(Page.NEW_GAME)
	}
}
