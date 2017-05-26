package view;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import model.Colour;
import view.pages.screens.map.MapController;


public class ScreensController extends StackPane {

	private static ScreensController screensController;

	private Map<String, Parent> screens = new HashMap<>();
	private Map<String, ControlledScreen> controllers = new HashMap<>();
	private Map<String, Stage> windows = new HashMap<>();
	private Page currentPage;

	private ScreensController() {
		for (Page page : Page.values()) {
			loadScreen(page);
		}
	}

	public Parent getScreen(Page page) {
		return screens.get(page.getName());
	}

	private boolean loadScreen(Page page) {
		String name = page.getName();
		try {
			FXMLLoader loader = new FXMLLoader();
			loader.setLocation(getClass().getResource(page.getResource()));
			Parent loadScreen = (Parent) loader.load();
			screens.put(name, loadScreen);
			controllers.put(name, loader.getController());
			if (page.isDialog()) {
				loadWindow(page);
			}
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean setScreen(final Page page) {
		Stage stage = GameController.getStage();
		String name = page.getName();
		if (!getChildren().isEmpty()) {
			if (currentPage.getEventHandler() != null) {
				stage.removeEventHandler(KeyEvent.KEY_PRESSED, currentPage.getEventHandler());
			}
			getChildren().remove(0);
		}
		getChildren().add(screens.get(name));
		if (page.getEventHandler() != null) {
			stage.addEventHandler(KeyEvent.KEY_PRESSED, page.getEventHandler());
		}
		ControlledScreen controller = controllers.get(page.getName());
		controller.onLoad(GameController.getContext());
		currentPage = page;
		return true;
	}

	private void loadWindow(Page page) {
		Stage stage = new Stage(StageStyle.DECORATED);
		stage.initModality(Modality.WINDOW_MODAL);
		stage.initOwner(GameController.getStage());
		stage.setScene(new Scene(getScreen(page)));
		stage.hide();
		if (page.getEventHandler() != null) {
			stage.addEventHandler(KeyEvent.KEY_PRESSED, page.getEventHandler());
		}
		windows.put(page.getName(), stage);
	}

	public void openWindow(Page page) {
		windows.get(page.getName()).show();
		ControlledScreen controller = controllers.get(page.getName());
		controller.onLoad(GameController.getContext());
	}

	public void closeWindow(final String pageName) {
		Stage stage = windows.get(pageName);
		if (stage != null) {
			stage.close();
		}
	}

	public ControlledScreen getController(Page page) {
		return controllers.get(page.getName());
	}

	public static ScreensController getScreensController() {
		if (screensController == null) {
			screensController = new ScreensController();
		}
		return screensController;
	}

	public void closeWindow(Page page) {
		closeWindow(page.getName());
	}

	public static void addMessage(Colour colour, String message) {
		MapController mapController = (MapController) screensController.getController(Page.MAP);
		mapController.addMessage(message, colour);
	}

	public static void addMessage(Colour colour, String format, Object... args) {
		String message = String.format(format, args);
		addMessage(colour, message);
	}
}
