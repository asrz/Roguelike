package view

import java.io.IOException
import javafx.application.Application
import javafx.scene.Group
import javafx.scene.Scene
import javafx.stage.Stage
import org.eclipse.xtend.lib.annotations.Accessors
import util.Context

class GameController extends Application {
	@Accessors(PUBLIC_GETTER) static Stage stage
	@Accessors static Context context

	def override start(Stage primaryStage) throws IOException {
		val ScreensController screensController = ScreensController.getScreensController()
		screensController.screen = Page.MAIN_MENU
		val Group root = new Group()
		root.children.add(screensController)
		val Scene scene = new Scene(root)
		stage = primaryStage
		primaryStage.width = 415
		primaryStage.scene = scene
		primaryStage.show()
	}

	def static void main(String[] args) throws IOException {
		launch()
	}

	def static void close() {
		stage.close()
	}

	def static Context getContext() {
		return context
	}

	def static void setContext(Context context) {
		GameController.context = context
	}

	def static Stage getStage() {
		return stage
	}
}
