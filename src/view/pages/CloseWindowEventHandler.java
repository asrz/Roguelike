package view.pages;


import javafx.event.EventHandler;
import javafx.scene.input.KeyEvent;
import view.ScreensController;


public class CloseWindowEventHandler implements EventHandler<KeyEvent> {

	private String pageName;

	public CloseWindowEventHandler(String pageName) {
		this.pageName = pageName;
	}

	@Override
	public void handle(KeyEvent event) {
		switch (event.getCode()) {
			case ESCAPE:
				ScreensController.getScreensController().closeWindow(pageName);
				break;
			default:
				break;
		}
	}

}
