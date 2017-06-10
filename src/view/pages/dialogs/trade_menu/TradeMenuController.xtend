package view.pages.dialogs.trade_menu

import java.net.URL
import java.util.Map
import java.util.Map.Entry
import java.util.ResourceBundle
import java.util.Set
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import javafx.collections.ObservableMap
import javafx.collections.transformation.SortedList
import javafx.fxml.FXML
import javafx.fxml.Initializable
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.SelectionMode
import javafx.scene.control.TableColumn
import javafx.scene.control.TableView
import javafx.scene.control.TableView.TableViewSelectionModel
import modelX.ActorX
import modelX.helperX.ActorStackX
import modelX.helperX.ObservableMapList
import org.controlsfx.glyphfont.FontAwesome
import util.Context
import view.ControlledScreen
import view.Page
import view.ScreensController

import static util.CollectionsUtil.newSortedList

class TradeMenuController implements ControlledScreen, Initializable {
	@FXML Label sourceLabel
	@FXML TableView<Map.Entry<String, ActorStackX>> sourceTable
	@FXML TableColumn<Map.Entry<String, ActorStackX>, Number> sourceQuantityColumn
	@FXML TableColumn<Map.Entry<String, ActorStackX>, String> sourceNameColumn
	@FXML Label targetLabel
	@FXML TableView<Map.Entry<String, ActorStackX>> targetTable
	@FXML TableColumn<Map.Entry<String, ActorStackX>, Number> targetQuantityColumn
	@FXML TableColumn<Map.Entry<String, ActorStackX>, String> targetNameColumn
	@FXML Button moveToTargetButton
	@FXML Button moveAllToTargetButton
	@FXML Button moveToSourceButton
	@FXML Button moveAllToSourceButton
	//
	// @FXML
	// private Button okButton;
	//
	// @FXML
	// private Button cancelButton;
	//
	// @FXML
	// private Button takeAllButton;
	ActorX target
	ObservableMapList<String, ActorStackX> targetItems
	ActorX source
	ObservableMapList<String, ActorStackX> sourceItems

	override void onLoad(Context context) {
		source = context.getPlayer()
		sourceLabel.setText(source.name)
		val ObservableMap<String, ActorStackX> sourceCopy = source.container.inventory.deepCopy()
		sourceItems = new ObservableMapList(sourceCopy)
		val SortedList<Entry<String, ActorStackX>> sortedSource = newSortedList(sourceItems.list, [ key ])
		sourceTable.setItems(sortedSource)
		val ObservableMap<String, ActorStackX> targetCopy = target.container.inventory.deepCopy()
		targetItems = new ObservableMapList(targetCopy)
		val SortedList<Entry<String, ActorStackX>> sortedTarget = newSortedList(targetItems.list, [ key ])
		targetTable.setItems(sortedTarget)
	}

	def private ObservableMap<String, ActorStackX> deepCopy(ObservableMap<String, ActorStackX> original) {
		val ObservableMap<String, ActorStackX> copy = FXCollections::observableHashMap()
		original.entrySet().forEach([copy.put(key, new ActorStackX(value))])
		return copy
	}

	def void setTarget(ActorX target) {
		this.target = target
		targetLabel.text = target.name
	}

	@FXML def void handleOkButton() {
		var ObservableMap<String, ActorStackX> sourceInventory = source.container.inventory
		sourceInventory.clear()
		sourceInventory.putAll(sourceItems.map)
		sourceItems.list.map [ value.actors ].flatten.forEach[ pickable.container = source ]

		var ObservableMap<String, ActorStackX> targetInventory = target.container.inventory
		targetInventory.clear()
		targetInventory.putAll(targetItems.map)
		targetItems.list.map[ value.actors].flatten.forEach[ pickable.container = target ]
		close()
	}

	@FXML def void handleCancelButton() {
		close()
	}

	@FXML def void handleTakeAllButton() {
		val allKeys = targetTable.items.map[ key ].clone
		allKeys.forEach[ moveAll(targetItems, sourceItems)]
	}

	def private void close() {
		ScreensController::getScreensController().closeWindow(Page::TRADE_MENU)
	}

	override void initialize(URL location, ResourceBundle resources) {
		sourceTable.selectionModel.selectionMode = SelectionMode::MULTIPLE
		targetTable.selectionModel.selectionMode = SelectionMode::MULTIPLE
		
		sourceQuantityColumn.cellValueFactory = [ value.value.sizeBinding ]
		sourceNameColumn.cellValueFactory = [ value.value.nameProperty ]
		
		targetQuantityColumn.cellValueFactory = [value.value.sizeBinding()]
		targetNameColumn.cellValueFactory = [value.value.nameProperty()]
		
		var FontAwesome fontAwesome = new FontAwesome()
		moveToTargetButton.graphic = fontAwesome.create(FontAwesome.Glyph::ANGLE_RIGHT)
		moveAllToTargetButton.graphic = fontAwesome.create(FontAwesome.Glyph::ANGLE_DOUBLE_RIGHT)
		moveToSourceButton.graphic = fontAwesome.create(FontAwesome.Glyph::ANGLE_LEFT)
		moveAllToSourceButton.graphic = fontAwesome.create(FontAwesome.Glyph::ANGLE_DOUBLE_LEFT)
	}

	@FXML def private void moveToTarget() {
		val TableViewSelectionModel<Entry<String, ActorStackX>> selectionModel = sourceTable.selectionModel
		val ObservableList<Entry<String, ActorStackX>> selectedItems = selectionModel.selectedItems
		val Set<String> selectedKeys = selectedItems.map([ key ]).toSet
		selectedKeys.forEach[ move(sourceItems, targetItems) ]
		selectionModel.clearSelection()
		sourceItems.list.filter[ selectedKeys.contains(key) ].forEach[ selectionModel.select(it) ]
	}
	
	@FXML def private void moveToSource() {
		val TableViewSelectionModel<Entry<String, ActorStackX>> selectionModel = targetTable.selectionModel
		val ObservableList<Entry<String, ActorStackX>> selectedItems = selectionModel.selectedItems
		val Set<String> selectedKeys = selectedItems.map([ key ]).toSet
		selectedKeys.forEach[ move(targetItems, sourceItems) ]
		selectionModel.clearSelection()
		sourceItems.list.filter[ selectedKeys.contains(key) ].forEach[ selectionModel.select(it) ]
	}

	@FXML def private void moveAllToTarget() {
		sourceTable.selectionModel.selectedItems.map[ key ].toSet.forEach[ moveAll(sourceItems, targetItems) ]
	}
	
	@FXML def private void moveAllToSource() {
		targetTable.selectionModel.selectedItems.map[ key ].toSet.forEach[ moveAll(targetItems, sourceItems) ]
	}

	def private void move(String key, ObservableMapList<String, ActorStackX> srcMapList,
		ObservableMapList<String, ActorStackX> destMapList) {
		var ActorStackX src = srcMapList.map.remove(key)
		var ActorStackX dest = destMapList.map.remove(key) ?: new ActorStackX(key)
		
		dest.add(src.pop())
		if (!src.isEmpty()) {
			srcMapList.map.put(key, new ActorStackX(src))
		}
		destMapList.map.put(key, dest)
	}

	def private void moveAll(String key, ObservableMapList<String, ActorStackX> srcMapList, ObservableMapList<String, ActorStackX> destMapList) {
		val ActorStackX src = srcMapList.map.remove(key)
		val ObservableMap<String, ActorStackX> destMap = destMapList.map
		val ActorStackX dest = destMap.remove(key) ?: new ActorStackX(src.name)
		dest.addAll(src)
		destMap.put(key, dest)
	}
}
