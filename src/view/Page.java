package view;


import javafx.event.EventHandler;
import javafx.scene.input.KeyEvent;
import view.pages.CloseWindowEventHandler;
import view.pages.screens.map.MapEventHandler;


public enum Page {
	MAIN_MENU("Main Menu", "pages/screens/main_menu/main_menu.fxml", null, false),
	NEW_GAME("New Game", "pages/screens/new_game/new_game.fxml", null, false),
	MAP("Map", "pages/screens/map/map_screen.fxml", new MapEventHandler(), false),

	INVENTORY("Inventory", "pages/dialogs/inventory/inventory_screen.fxml", new CloseWindowEventHandler("Inventory"), true),
	PICKUP_MENU("Pickup Menu", "pages/dialogs/pickup_menu/pickup_menu.fxml", new CloseWindowEventHandler("Pickup Menu"), true),
	TRADE_MENU("Trade Menu", "pages/dialogs/trade_menu/trade_menu.fxml", new CloseWindowEventHandler("Trade Menu"), true);

	private String name;
	private String resource;
	private EventHandler<KeyEvent> eventHandler;
	private boolean isDialog;

	Page(String name, String resource, EventHandler<KeyEvent> eventHandler, boolean isDialog) {
		this.name = name;
		this.resource = resource;
		this.eventHandler = eventHandler;
		this.isDialog = isDialog;
	}

	public String getName() {
		return name;
	}

	public String getResource() {
		return resource;
	}

	public EventHandler<KeyEvent> getEventHandler() {
		return eventHandler;
	}

	public boolean isDialog() {
		return isDialog;
	}
}
