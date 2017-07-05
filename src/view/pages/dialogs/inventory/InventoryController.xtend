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
import model.Actor
import model.helper.ActorStack
import model.helper.Context
import model.helper.ObservableMapList
import model.items.Pickable
import model.items.equipment.Equipable
import model.items.equipment.Equipment
import model.items.usable.Usable
import util.ControlUtil
import util.Predicates
import view.ControlledScreen

import static util.CollectionsUtil.newSortedList

class InventoryController implements ControlledScreen, Initializable {
	@FXML TabPane tabPane
	@FXML Tab allTab
	@FXML Tab equipmentTab
	
	// inventory table (keys are name)
	@FXML TableView<Entry<String, ActorStack>> inventoryTable
	@FXML TableColumn<Entry<String, ActorStack>, Integer> itemQuantityColumn
	@FXML TableColumn<Entry<String, ActorStack>, String> itemNameColumn
	@FXML TableColumn<Entry<String, ActorStack>, Button> dropItemColumn
	@FXML TableColumn<Entry<String, ActorStack>, Button> useItemColumn
	
	// equipped equipment table (keys are slot)
	@FXML TableView<Entry<String, ActorStack>> equippedEquipmentTable
	@FXML TableColumn<Entry<String, ActorStack>, String> equippedSlotColumn
	@FXML TableColumn<Entry<String, ActorStack>, String> equippedNameColumn
	@FXML TableColumn<Entry<String, ActorStack>, Button> equippedUnequipColumn
	@FXML TableColumn<Entry<String, ActorStack>, Button> equippedUseColumn
	
	// unequipped equipment column (keys are name)
	@FXML TableView<Entry<String, ActorStack>> unequippedEquipmentTable
	@FXML TableColumn<Entry<String, ActorStack>, String> unequippedSlotColumn
	@FXML TableColumn<Entry<String, ActorStack>, String> unequippedNameColumn
	@FXML TableColumn<Entry<String, ActorStack>, Button> unequippedEquipColumn
	@FXML TableColumn<Entry<String, ActorStack>, Button> unequippedDropColumn
	
	Actor player
	
	override void onLoad(Context context) {
		player = context.getPlayer()
		
		// populate items table
		val container = player.container
		var ObservableMapList<String, ActorStack> inventoryMapList = new ObservableMapList(container.nonEquipables)
		var SortedList<Entry<String, ActorStack>> sortedInventory = newSortedList(inventoryMapList.list, [ key ])
		sortedInventory.comparatorProperty().bind(inventoryTable.comparatorProperty())
		inventoryTable.setItems(sortedInventory)
		
		// populate equipped equipment table
		var ObservableMapList<String, ActorStack> equippedMapList = new ObservableMapList(player.equipment.equipment)
		var SortedList<Entry<String, ActorStack>> sortedEquippedEquipment = newSortedList(equippedMapList.list, [ key ])
		sortedEquippedEquipment.comparatorProperty().bind(equippedEquipmentTable.comparatorProperty())
		equippedEquipmentTable.setItems(sortedEquippedEquipment)
		
		// populate unequipped equipment table
		var ObservableMapList<String, ActorStack> unequippedEquipmentMapList = new ObservableMapList(container.equipables)
		var SortedList<Entry<String, ActorStack>> sortedUnequippedEquipment = newSortedList(unequippedEquipmentMapList.list, [ key ])
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

	def private void unequippedDropButtonOnClick(Entry<String, ActorStack> entry) {
		var ActorStack ActorStackX = entry.value
		var Actor actor = ActorStackX.peek()
		var Pickable pickable = actor.pickable
		pickable.drop()
	}

	def private boolean unequippedEquipButtonDisplay(Entry<String, ActorStack> entry) {
		var Equipment equipment = player.equipment
		var ActorStack ActorStackX = entry.value
		var Actor actor = ActorStackX.peek()
		var Equipable equipable = actor.equipable
		return equipment.hasSlot(equipable.slot)
	}

	def private void unequippedEquipButtonOnClick(Entry<String, ActorStack> entry) {
		var Equipment equipment = player.equipment
		var ActorStack ActorStackX = entry.value
		equipment.equip(ActorStackX)
	}

	def private boolean equippedUseButtonDisplay(Entry<String, ActorStack> entry) {
		return entry.value?.peek()?.usable !== null
	}

	def private boolean unequipButtonDisplay(Entry<String, ActorStack> entry) {
		val equipable = entry.value?.peek()?.equipable
		return equipable !== null && !equipable.isCursed()
	}

	def private void unequipButtonOnClick(Entry<String, ActorStack> entry) {
		val Equipment equipment = player.equipment
		val ActorStack actorStack = entry.value
		equipment.unequip(actorStack)
	}

	def private boolean inventoryUseButtonDisplay(Entry<String, ActorStack> entry) {
		var ActorStack ActorStackX = entry.value
		var Actor actor = ActorStackX.peek()
		return actor.usable !== null
	}

	def private void useButtonOnClick(Entry<String, ActorStack> entry) {
		var ActorStack ActorStackX = entry.value
		var Actor actor = ActorStackX.peek()
		var Usable usable = actor.usable
		usable.use(player)
	}

	def private static ObservableValue<String> getNameLabel(CellDataFeatures<Entry<String, ActorStack>, String> cdf) {
		var Entry<String, ActorStack> entry = cdf.value
		var ActorStack ActorStackX = entry.value
		return if(ActorStackX !== null) ActorStackX.fullNameBinding() else new SimpleStringProperty("")
	}

	def private void dropButtonOnClick(Entry<String, ActorStack> entry) {
		var ActorStack ActorStackX = entry.getValue()
		var Actor actor = ActorStackX.peek()
		var Pickable pickable = actor.pickable
		pickable.drop()
	}
}
