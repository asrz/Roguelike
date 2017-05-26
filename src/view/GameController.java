package view;


import java.io.IOException;

import javafx.application.Application;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.stage.Stage;
import util.Context;


public class GameController extends Application {

	private static Stage stage;
	private static Context context;

	@Override
	public void start(Stage primaryStage) throws IOException {
		ScreensController screensController = ScreensController.getScreensController();
		screensController.setScreen(Page.MAIN_MENU);
		Group root = new Group();
		root.getChildren().add(screensController);
		Scene scene = new Scene(root);
		primaryStage.setWidth(415);
		primaryStage.setScene(scene);
		primaryStage.show();
		stage = primaryStage;
	}

	public static void main(String[] args) throws IOException {
		launch();
	}

	public static void close() {
		stage.close();
	}

	public static Context getContext() {
		return context;
	}

	public static void setContext(Context context) {
		GameController.context = context;
	}

	public static Stage getStage() {
		return stage;
	}
}
