package view

import java.io.IOException
import java.util.HashMap
import java.util.Map
import javafx.fxml.FXMLLoader
import javafx.scene.Parent
import javafx.scene.Scene
import javafx.scene.input.KeyEvent
import javafx.scene.layout.StackPane
import javafx.stage.Modality
import javafx.stage.Stage
import javafx.stage.StageStyle
import view.pages.screens.map.MapController
import model.Colour

class ScreensController extends StackPane {
	static ScreensController screensController
	
	Map<Page, Parent> screens = new HashMap()
	Map<Page, ControlledScreen> controllers = new HashMap()
	Map<Page, Stage> windows = new HashMap()
	Page currentPage

	private new() {
		Page.values().forEach[loadScreen]
	}

	def Parent getScreen(Page page) {
		return screens.get(page)
	}

	def private boolean loadScreen(Page page) {
		try {
			val FXMLLoader loader = new FXMLLoader()
			loader.location = getClass().getResource(page.resource)
			val Parent loadScreen = (loader.load() as Parent)
			screens.put(page, loadScreen)
			controllers.put(page, loader.getController())
			if (page.isDialog()) {
				loadWindow(page)
			}
			return true
		} catch (IOException e) {
			e.printStackTrace()
			return false
		}

	}

	def boolean setScreen(Page page) {
		val Stage stage = GameController.stage
		if (!children.isEmpty()) {
			if (currentPage.getEventHandler() !== null) {
				stage.removeEventHandler(KeyEvent.KEY_PRESSED, currentPage.getEventHandler())
			}
			children.remove(0)
		}
		children.add(screens.get(page))
		if (page.getEventHandler() !== null) {
			stage.addEventHandler(KeyEvent.KEY_PRESSED, page.getEventHandler())
		}
		var ControlledScreen controller = controllers.get(page)
		controller.onLoad(GameController.context)
		currentPage = page
		return true
	}

	def private void loadWindow(Page page) {
		var Stage stage = new Stage(StageStyle.DECORATED)
		stage.initModality(Modality.WINDOW_MODAL)
		stage.initOwner(GameController.getStage())
		stage.scene = new Scene(getScreen(page))
		stage.hide()
		if (page.getEventHandler() !== null) {
			stage.addEventHandler(KeyEvent.KEY_PRESSED, page.getEventHandler())
		}
		windows.put(page, stage)
	}

	def void openWindow(Page page) {
		windows.get(page).show()
		var ControlledScreen controller = controllers.get(page)
		controller.onLoad(GameController.getContext())
	}

	def void closeWindow(Page page) {
		var Stage stage = windows.get(page)
		stage?.close()
	}

	def ControlledScreen getController(Page page) {
		return controllers.get(page)
	}

	def static ScreensController getScreensController() {
		if (screensController === null) {
			screensController = new ScreensController()
		}
		return screensController
	}

	def static void addMessage(Colour colour, String message) {
		var MapController mapController = (screensController.getController(Page.MAP) as MapController)
		mapController.addMessage(colour.getColor(), message)
	}
}
