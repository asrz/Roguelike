package view.pages.dialogs.inventory

import java.net.URL
import java.util.Map.Entry
import java.util.ResourceBundle
import javafx.beans.property.SimpleObjectProperty
import javafx.beans.property.SimpleStringProperty
import javafx.beans.value.ObservableValue
import javafx.collections.transformation.SortedList
import javafx.fxml.FXML
import javafx.fxml.Initializable
import javafx.scene.control.Button
import javafx.scene.control.Tab
import javafx.scene.control.TabPane
import javafx.scene.control.TableColumn
import javafx.scene.control.TableColumn.CellDataFeatures
import javafx.scene.control.TableView
import modelX.ActorX
import modelX.helperX.ActorStackX
import modelX.helperX.ObservableMapList
import modelX.itemsX.PickableX
import modelX.itemsX.equipmentX.EquipableX
import modelX.itemsX.equipmentX.EquipmentX
import modelX.itemsX.usableX.UsableX
import util.Context
import util.ControlUtil
import util.Predicates
import view.ControlledScreen

import static util.CollectionsUtil.newSortedList

class InventoryController implements ControlledScreen, Initializable {
	@FXML TabPane tabPane
	@FXML Tab allTab
	@FXML Tab equipmentTab
	
	// inventory table (keys are name)
	@FXML TableView<Entry<String, ActorStackX>> inventoryTable
	@FXML TableColumn<Entry<String, ActorStackX>, Integer> itemQuantityColumn
	@FXML TableColumn<Entry<String, ActorStackX>, String> itemNameColumn
	@FXML TableColumn<Entry<String, ActorStackX>, Button> dropItemColumn
	@FXML TableColumn<Entry<String, ActorStackX>, Button> useItemColumn
	
	// equipped equipment table (keys are slot)
	@FXML TableView<Entry<String, ActorStackX>> equippedEquipmentTable
	@FXML TableColumn<Entry<String, ActorStackX>, String> equippedSlotColumn
	@FXML TableColumn<Entry<String, ActorStackX>, String> equippedNameColumn
	@FXML TableColumn<Entry<String, ActorStackX>, Button> equippedUnequipColumn
	@FXML TableColumn<Entry<String, ActorStackX>, Button> equippedUseColumn
	
	// unequipped equipment column (keys are name)
	@FXML TableView<Entry<String, ActorStackX>> unequippedEquipmentTable
	@FXML TableColumn<Entry<String, ActorStackX>, String> unequippedSlotColumn
	@FXML TableColumn<Entry<String, ActorStackX>, String> unequippedNameColumn
	@FXML TableColumn<Entry<String, ActorStackX>, Button> unequippedEquipColumn
	@FXML TableColumn<Entry<String, ActorStackX>, Button> unequippedDropColumn
	
	ActorX player
	
	override void onLoad(Context context) {
		player = context.getPlayer()
		
		// populate items table
		val container = player.container
		var ObservableMapList<String, ActorStackX> inventoryMapList = new ObservableMapList(container.nonEquipables)
		var SortedList<Entry<String, ActorStackX>> sortedInventory = newSortedList(inventoryMapList.list, [ key ])
		sortedInventory.comparatorProperty().bind(inventoryTable.comparatorProperty())
		inventoryTable.setItems(sortedInventory)
		
		// populate equipped equipment table
		var ObservableMapList<String, ActorStackX> equippedMapList = new ObservableMapList(player.equipment.equipment)
		var SortedList<Entry<String, ActorStackX>> sortedEquippedEquipment = newSortedList(equippedMapList.list, [ key ])
		sortedEquippedEquipment.comparatorProperty().bind(equippedEquipmentTable.comparatorProperty())
		equippedEquipmentTable.setItems(sortedEquippedEquipment)
		
		// populate unequipped equipment table
		var ObservableMapList<String, ActorStackX> unequippedEquipmentMapList = new ObservableMapList(container.equipables)
		var SortedList<Entry<String, ActorStackX>> sortedUnequippedEquipment = newSortedList(unequippedEquipmentMapList.list, [ key ])
		sortedUnequippedEquipment.comparatorProperty().bind(unequippedEquipmentTable.comparatorProperty())
		unequippedEquipmentTable.setItems(sortedUnequippedEquipment)
	}

	override void initialize(URL location, ResourceBundle resources) {
		// inventory table
		itemQuantityColumn.setCellValueFactory([ new SimpleObjectProperty(value.value.size())])
		itemNameColumn.setCellValueFactory([new SimpleStringProperty(value.key)])
		dropItemColumn.setCellValueFactory(
			ControlUtil::getButtonFactory(dropItemColumn, "Drop", [dropButtonOnClick], Predicates::constant(true))
		)
		useItemColumn.setCellValueFactory(
			ControlUtil::getButtonFactory(useItemColumn, "Use", [useButtonOnClick], [inventoryUseButtonDisplay])
		)
		// equipped equipment table
		equippedSlotColumn.setCellValueFactory([new SimpleStringProperty(value.key)])
		equippedNameColumn.setCellValueFactory([getNameLabel])
		equippedUnequipColumn.setCellValueFactory(
			ControlUtil::getButtonFactory(equippedUnequipColumn, "Unequip", [unequipButtonOnClick], [unequipButtonDisplay])
		)
		equippedUseColumn.setCellValueFactory(
			ControlUtil::getButtonFactory(equippedUseColumn, "Use", [useButtonOnClick], [equippedUseButtonDisplay])
		)
		// unequipped equipment table
		unequippedSlotColumn.setCellValueFactory([value.value.peek().equipable.slotProperty()])
		unequippedNameColumn.setCellValueFactory([value.value.fullNameBinding]);
		unequippedEquipColumn.setCellValueFactory(
			ControlUtil::getButtonFactory(unequippedEquipColumn, "Equip", [unequippedEquipButtonOnClick], [unequippedEquipButtonDisplay])
		)
		unequippedDropColumn.setCellValueFactory(
			ControlUtil::getButtonFactory(unequippedDropColumn, "Drop", [unequippedDropButtonOnClick], [ true ])
		)
	}

	def private void unequippedDropButtonOnClick(Entry<String, ActorStackX> entry) {
		var ActorStackX ActorStackX = entry.value
		var ActorX actor = ActorStackX.peek()
		var PickableX pickable = actor.pickable
		pickable.drop()
	}

	def private boolean unequippedEquipButtonDisplay(Entry<String, ActorStackX> entry) {
		var EquipmentX equipment = player.equipment
		var ActorStackX ActorStackX = entry.value
		var ActorX actor = ActorStackX.peek()
		var EquipableX equipable = actor.equipable
		return equipment.hasSlot(equipable.slot)
	}

	def private void unequippedEquipButtonOnClick(Entry<String, ActorStackX> entry) {
		var EquipmentX equipment = player.equipment
		var ActorStackX ActorStackX = entry.value
		equipment.equip(ActorStackX)
	}

	def private boolean equippedUseButtonDisplay(Entry<String, ActorStackX> entry) {
		return entry.value?.peek()?.usable !== null
	}

	def private boolean unequipButtonDisplay(Entry<String, ActorStackX> entry) {
		val equipable = entry.value?.peek()?.equipable
		return equipable !== null && !equipable.isCursed()
	}

	def private void unequipButtonOnClick(Entry<String, ActorStackX> entry) {
		val EquipmentX equipment = player.equipment
		val ActorStackX actorStack = entry.value
		equipment.unequip(actorStack)
	}

	def private boolean inventoryUseButtonDisplay(Entry<String, ActorStackX> entry) {
		var ActorStackX ActorStackX = entry.value
		var ActorX actor = ActorStackX.peek()
		return actor.usable !== null
	}

	def private void useButtonOnClick(Entry<String, ActorStackX> entry) {
		var ActorStackX ActorStackX = entry.value
		var ActorX actor = ActorStackX.peek()
		var UsableX usable = actor.usable
		usable.use(player)
	}

	def private static ObservableValue<String> getNameLabel(CellDataFeatures<Entry<String, ActorStackX>, String> cdf) {
		var Entry<String, ActorStackX> entry = cdf.value
		var ActorStackX ActorStackX = entry.value
		return if(ActorStackX !== null) ActorStackX.fullNameBinding() else new SimpleStringProperty("")
	}

	def private void dropButtonOnClick(Entry<String, ActorStackX> entry) {
		var ActorStackX ActorStackX = entry.getValue()
		var ActorX actor = ActorStackX.peek()
		var PickableX pickable = actor.pickable
		pickable.drop()
	}
}
