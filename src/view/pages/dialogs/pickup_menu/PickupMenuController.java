package view.pages.dialogs.pickup_menu;


import java.util.stream.Collectors;

import org.controlsfx.control.CheckListView;
import org.controlsfx.control.IndexedCheckModel;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import map.Tile;
import model.Actor;
import util.Context;
import view.ControlledScreen;
import view.Page;
import view.ScreensController;


public class PickupMenuController implements ControlledScreen {

	private Actor player;

	@FXML
	private CheckListView<Actor> checkListView;

	@FXML
	private Button takeSelectedItemsButton;

	@FXML
	private Button takeAllItemsButton;

	@FXML
	public void pickupAllItems() {
		IndexedCheckModel<Actor> checkModel = checkListView.getCheckModel();
		checkModel.checkAll();
		pickupItems(checkModel.getCheckedItems());
	}

	private void pickupItems(ObservableList<Actor> items) {
		items.forEach(a -> a.getPickable().get().pickup(player));
		ScreensController.getScreensController().closeWindow(Page.PICKUP_MENU);
	}

	@FXML
	public void pickupSelectedItems() {
		ObservableList<Actor> selectedItems = checkListView.getCheckModel().getCheckedItems();
		pickupItems(selectedItems);
	}

	@Override
	public void onLoad(Context context) {
		player = context.getPlayer();
		Tile tile = player.getTile();

		checkListView.setItems(tile.getActors().stream().filter(a -> a.getPickable().isPresent())
				.collect(Collectors.toCollection(() -> FXCollections.<Actor> observableArrayList())));
	}
}
