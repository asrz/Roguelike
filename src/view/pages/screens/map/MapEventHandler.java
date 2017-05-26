package view.pages.screens.map;


import javafx.event.EventHandler;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import map.Map;
import model.Actor;
import model.Direction;
import util.Context;
import view.GameController;
import view.Page;
import view.ScreensController;


public class MapEventHandler implements EventHandler<KeyEvent> {

	private Mode mode = Mode.MOVE;

	@Override
	public void handle(KeyEvent keyEvent) {
		Context context = GameController.getContext();
		Actor player = context.getPlayer();
		Map map = context.getMap();
		KeyCode keyCode = keyEvent.getCode();
		boolean acted = true;
		switch (keyCode) {
			case NUMPAD1:
				mode = act(mode, map, player, Direction.SOUTHWEST);
				break;
			case DOWN:
			case NUMPAD2:
				mode = act(mode, map, player, Direction.SOUTH);
				break;
			case NUMPAD3:
				mode = act(mode, map, player, Direction.SOUTHEAST);
				break;
			case LEFT:
			case NUMPAD4:
				mode = act(mode, map, player, Direction.WEST);
				break;
			case NUMPAD5:
				mode = act(mode, map, player, Direction.ZERO);
				break;
			case RIGHT:
			case NUMPAD6:
				mode = act(mode, map, player, Direction.EAST);
				break;
			case NUMPAD7:
				mode = act(mode, map, player, Direction.NORTHWEST);
				break;
			case UP:
			case NUMPAD8:
				mode = act(mode, map, player, Direction.NORTH);
				break;
			case NUMPAD9:
				mode = act(mode, map, player, Direction.NORTHEAST);
				break;
			case ESCAPE:
				GameController.close();
				break;
			case E:
				mode = Mode.INTERACT;
				acted = false;
				break;
			case G:
				ScreensController.getScreensController().openWindow(Page.PICKUP_MENU);
				break;
			case I:
				ScreensController.getScreensController().openWindow(Page.INVENTORY);
				break;
			default:
				break;
		}
		if (acted) {
			MapController mapController = (MapController) ScreensController.getScreensController().getController(Page.MAP);
			mapController.takeTurn();
		}
	}

	enum Mode {
		MOVE,
		INTERACT,
		ATTACK,
		EXAMINE;
	}

	private Mode act(Mode mode, Map map, Actor player, Direction direction) {
		switch (mode) {
			case ATTACK:
				break;
			case EXAMINE:
				break;
			case INTERACT:
				map.interact(player, direction);
				break;
			case MOVE:
				map.moveActor(player, direction);
				break;
			default:
				break;
		}
		return Mode.MOVE;
	}
}
