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
import model.helper.ObservableMapList
import org.controlsfx.glyphfont.FontAwesome
import util.Context
import view.ControlledScreen
import view.Page
import view.ScreensController

import static util.CollectionsUtil.newSortedList
import model.helper.ActorStack
import model.Actor

class TradeMenuController implements ControlledScreen, Initializable {
	@FXML Label sourceLabel
	@FXML TableView<Map.Entry<String, ActorStack>> sourceTable
	@FXML TableColumn<Map.Entry<String, ActorStack>, Number> sourceQuantityColumn
	@FXML TableColumn<Map.Entry<String, ActorStack>, String> sourceNameColumn
	@FXML Label targetLabel
	@FXML TableView<Map.Entry<String, ActorStack>> targetTable
	@FXML TableColumn<Map.Entry<String, ActorStack>, Number> targetQuantityColumn
	@FXML TableColumn<Map.Entry<String, ActorStack>, String> targetNameColumn
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
	Actor target
	ObservableMapList<String, ActorStack> targetItems
	Actor source
	ObservableMapList<String, ActorStack> sourceItems

	override void onLoad(Context context) {
		source = context.getPlayer()
		sourceLabel.setText(source.name)
		val ObservableMap<String, ActorStack> sourceCopy = source.container.inventory.deepCopy()
		sourceItems = new ObservableMapList(sourceCopy)
		val SortedList<Entry<String, ActorStack>> sortedSource = newSortedList(sourceItems.list, [ key ])
		sourceTable.setItems(sortedSource)
		val ObservableMap<String, ActorStack> targetCopy = target.container.inventory.deepCopy()
		targetItems = new ObservableMapList(targetCopy)
		val SortedList<Entry<String, ActorStack>> sortedTarget = newSortedList(targetItems.list, [ key ])
		targetTable.setItems(sortedTarget)
	}

	def private ObservableMap<String, ActorStack> deepCopy(ObservableMap<String, ActorStack> original) {
		val ObservableMap<String, ActorStack> copy = FXCollections::observableHashMap()
		original.entrySet().forEach([copy.put(key, new ActorStack(value))])
		return copy
	}

	def void setTarget(Actor target) {
		this.target = target
		targetLabel.text = target.name
	}

	@FXML def void handleOkButton() {
		var ObservableMap<String, ActorStack> sourceInventory = source.container.inventory
		sourceInventory.clear()
		sourceInventory.putAll(sourceItems.map)
		sourceItems.list.map [ value.actors ].flatten.forEach[ pickable.container = source ]

		var ObservableMap<String, ActorStack> targetInventory = target.container.inventory
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
		val TableViewSelectionModel<Entry<String, ActorStack>> selectionModel = sourceTable.selectionModel
		val ObservableList<Entry<String, ActorStack>> selectedItems = selectionModel.selectedItems
		val Set<String> selectedKeys = selectedItems.map([ key ]).toSet
		selectedKeys.forEach[ move(sourceItems, targetItems) ]
		selectionModel.clearSelection()
		sourceItems.list.filter[ selectedKeys.contains(key) ].forEach[ selectionModel.select(it) ]
	}
	
	@FXML def private void moveToSource() {
		val TableViewSelectionModel<Entry<String, ActorStack>> selectionModel = targetTable.selectionModel
		val ObservableList<Entry<String, ActorStack>> selectedItems = selectionModel.selectedItems
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

	def private void move(String key, ObservableMapList<String, ActorStack> srcMapList,
		ObservableMapList<String, ActorStack> destMapList) {
		var ActorStack src = srcMapList.map.remove(key)
		var ActorStack dest = destMapList.map.remove(key) ?: new ActorStack(key)
		
		dest.add(src.pop())
		if (!src.isEmpty()) {
			srcMapList.map.put(key, new ActorStack(src))
		}
		destMapList.map.put(key, dest)
	}

	def private void moveAll(String key, ObservableMapList<String, ActorStack> srcMapList, ObservableMapList<String, ActorStack> destMapList) {
		val ActorStack src = srcMapList.map.remove(key)
		val ObservableMap<String, ActorStack> destMap = destMapList.map
		val ActorStack dest = destMap.remove(key) ?: new ActorStack(src.name)
		dest.addAll(src)
		destMap.put(key, dest)
	}
}
