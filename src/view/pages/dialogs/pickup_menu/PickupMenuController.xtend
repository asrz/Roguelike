package view.pages.dialogs.pickup_menu

import javafx.collections.FXCollections
import javafx.collections.ObservableList
import javafx.fxml.FXML
import javafx.scene.control.Button
import map.Tile
import modelX.ActorX
import modelX.helperX.ActorStackX
import org.controlsfx.control.CheckListView
import org.controlsfx.control.IndexedCheckModel
import util.Context
import view.ControlledScreen
import view.Page
import view.ScreensController

class PickupMenuController implements ControlledScreen {
	ActorX player
	@FXML CheckListView<ActorStackX> checkListView
	@FXML Button takeSelectedItemsButton
	@FXML Button takeAllItemsButton

	@FXML def void pickupAllItems() {
		var IndexedCheckModel<ActorStackX> checkModel = checkListView.checkModel
		checkModel.checkAll()
		pickupItems(checkModel.getCheckedItems())
	}

	def private void pickupItems(ObservableList<ActorStackX> items) {
		items.map[ actors ].flatten.forEach[pickable.pickup(player)]
		ScreensController::getScreensController().closeWindow(Page::PICKUP_MENU)
	}

	@FXML def void pickupSelectedItems() {
		var ObservableList<ActorStackX> selectedItems = checkListView.checkModel.checkedItems
		pickupItems(selectedItems)
	}

	override void onLoad(Context context) {
		player = context.getPlayer()
		var Tile tile = player.getTile()
		checkListView.setItems(FXCollections.observableArrayList(tile.actors.filter[ peek().pickable !== null].toList))
	}
}
