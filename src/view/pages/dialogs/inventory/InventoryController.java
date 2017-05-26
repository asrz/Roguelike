package view.pages.dialogs.inventory;


import java.net.URL;
import java.util.Comparator;
import java.util.Map.Entry;
import java.util.ResourceBundle;
import java.util.function.Function;

import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.transformation.SortedList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.util.Callback;
import model.Actor;
import model.helper.ActorStack;
import model.helper.ObservableMapList;
import model.items.Container;
import model.items.Pickable;
import model.items.equipment.Equipable;
import model.items.equipment.Equipment;
import model.items.usable.Usable;
import util.Context;
import util.ControlUtil;
import util.Predicates;
import view.ControlledScreen;


public class InventoryController implements ControlledScreen, Initializable {

	@FXML
	private TabPane tabPane;

	@FXML
	private Tab allTab;

	@FXML
	private Tab equipmentTab;

	// inventory table (keys are name)
	@FXML
	private TableView<Entry<String, ActorStack>> inventoryTable;

	@FXML
	private TableColumn<Entry<String, ActorStack>, Integer> itemQuantityColumn;
	
	@FXML
	private TableColumn<Entry<String, ActorStack>, String> itemNameColumn;
	
	@FXML
	private TableColumn<Entry<String, ActorStack>, Button> dropItemColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, Button> useItemColumn;

	// equipped equipment table (keys are slot)
	@FXML
	private TableView<Entry<String, ActorStack>> equippedEquipmentTable;

	@FXML
	private TableColumn<Entry<String, ActorStack>, String> equippedSlotColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, String> equippedNameColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, Button> equippedUnequipColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, Button> equippedUseColumn;

	// unequipped equipment column (keys are name)
	@FXML
	private TableView<Entry<String, ActorStack>> unequippedEquipmentTable;

	@FXML
	private TableColumn<Entry<String, ActorStack>, String> unequippedSlotColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, String> unequippedNameColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, Button> unequippedEquipColumn;

	@FXML
	private TableColumn<Entry<String, ActorStack>, Button> unequippedDropColumn;

	Actor player;

	@Override
	public void onLoad(Context context) {
		player = context.getPlayer();

		// populate items table
		Container container = player.getContainer().get();
		ObservableMapList<String, ActorStack> inventoryMapList = new ObservableMapList<>(container.getNonEquipables());
		SortedList<Entry<String, ActorStack>> sortedInventory = inventoryMapList.getList().sorted(Comparator.comparing(Entry::getKey));
		sortedInventory.comparatorProperty().bind(inventoryTable.comparatorProperty());
		inventoryTable.setItems(sortedInventory);
		
		// populate equipped equipment table
		ObservableMapList<String, ActorStack> equippedMapList = new ObservableMapList<>(player.getEquipment().get().getEquipment());
		SortedList<Entry<String, ActorStack>> sortedEquippedEquipment = equippedMapList.getList().sorted(Comparator.comparing(Entry::getKey));
		sortedEquippedEquipment.comparatorProperty().bind(equippedEquipmentTable.comparatorProperty());
		equippedEquipmentTable.setItems(sortedEquippedEquipment);

		// populate unequipped equipment table
		ObservableMapList<String, ActorStack> unequippedEquipmentMapList = new ObservableMapList<>(container.getEquipables());
		SortedList<Entry<String, ActorStack>> sortedUnequippedEquipment = unequippedEquipmentMapList.getList().sorted(Comparator.comparing(Entry::getKey));
		sortedUnequippedEquipment.comparatorProperty().bind(unequippedEquipmentTable.comparatorProperty());
		unequippedEquipmentTable.setItems(sortedUnequippedEquipment);
	}

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// inventory table
		itemQuantityColumn.setCellValueFactory(cdf -> new SimpleObjectProperty<>(cdf.getValue().getValue().size()));
		itemNameColumn.setCellValueFactory(cdf -> new SimpleStringProperty(cdf.getValue().getKey()));
		dropItemColumn.setCellValueFactory(
			ControlUtil.getButtonFactory(
				dropItemColumn, 
				"Drop", 
				this::dropButtonOnClick, 
				Predicates.constant(true)
			)
		);
		useItemColumn.setCellValueFactory(
			ControlUtil.getButtonFactory(
				useItemColumn, 
				"Use", 
				this::useButtonOnClick, 
				this::inventoryUseButtonDisplay
			)
		);

		// equipped equipment table
		equippedSlotColumn.setCellValueFactory(cdf -> new SimpleStringProperty(cdf.getValue().getKey()));
		equippedNameColumn.setCellValueFactory(InventoryController::getNameLabel);
		equippedUnequipColumn.setCellValueFactory(
			ControlUtil.getButtonFactory(
				equippedUnequipColumn, 
				"Unequip",
				this::unequipButtonOnClick, 
				this::unequipButtonDisplay
			)
		);
		equippedUseColumn.setCellValueFactory(
			ControlUtil.getButtonFactory(
				equippedUseColumn, 
				"Use",
				this::useButtonOnClick,
				this::equippedUseButtonDisplay
			)
		);

		// unequipped equipment table
		unequippedSlotColumn.setCellValueFactory(p -> p.getValue().getValue().peek().getEquipable().get().slotProperty());
//		unequippedNameColumn.setCellValueFactory(p -> p.getValue().getValue().fullNameBinding());
		setCellValueFactory(unequippedNameColumn, entry -> entry.getValue().fullNameBinding());
		unequippedEquipColumn.setCellValueFactory(
			ControlUtil.getButtonFactory(
				unequippedEquipColumn, 
				"Equip", 
				this::unequippedEquipButtonOnClick,
				this::unequippedEquipButtonDisplay
			)
		);
		unequippedDropColumn.setCellValueFactory(
			ControlUtil.getButtonFactory(
				unequippedDropColumn, 
				"Drop", 
				this::unequippedDropButtonOnClick, 
				Predicates.constant(true)
			)
		);
	}
	
	private <T, C> Callback<CellDataFeatures<T, C>, ObservableValue<C>> setCellValueFactory(TableColumn<T, C> tableColumn, Function<T, ObservableValue<C>> function) {
		return new Callback<TableColumn.CellDataFeatures<T,C>, ObservableValue<C>>() {
			@Override
			public ObservableValue<C> call(CellDataFeatures<T, C> param) {
				return function.apply(param.getValue());
			}
		};
		
	}

	private void unequippedDropButtonOnClick(Entry<String, ActorStack> entry) {
		ActorStack actorstack = entry.getValue();
		Actor actor = actorstack.peek();
		Pickable pickable = actor.getPickable().get();
		pickable.drop();
	}

	private boolean unequippedEquipButtonDisplay(Entry<String, ActorStack> entry) {
		Equipment equipment = player.getEquipment().get();
		ActorStack actorstack = entry.getValue();
		Actor actor = actorstack.peek();
		Equipable equipable = actor.getEquipable().get();
		return equipment.hasSlot(equipable.getSlot());
	}

	private void unequippedEquipButtonOnClick(Entry<String, ActorStack> entry) {
		Equipment equipment = player.getEquipment().get();
		ActorStack actorstack = entry.getValue();
		equipment.equip(actorstack);
	}

	private boolean equippedUseButtonDisplay(Entry<String, ActorStack> entry) {
		ActorStack actorStack = entry.getValue();
		if (actorStack == null || actorStack.isEmpty()) {
			return false;
		}
		
		Actor actor = actorStack.peek();
		return actor.getUsable().isPresent();
	}

	private boolean unequipButtonDisplay(Entry<String, ActorStack> entry) {
		ActorStack actorStack = entry.getValue();
		if (actorStack == null || actorStack.isEmpty()) {
			return false;
		}
		
		Actor actor = actorStack.peek();
		
		Equipable equipable = actor.getEquipable().get();
		return !equipable.isCursed();
	}

	private void unequipButtonOnClick(Entry<String, ActorStack> entry) {
		Equipment equipment = player.getEquipment().get();
		ActorStack actorstack = entry.getValue();
		equipment.unequip(actorstack);
	}

	private boolean inventoryUseButtonDisplay(Entry<String, ActorStack> entry) {
		ActorStack actorstack = entry.getValue();
		Actor actor = actorstack.peek();
		return actor.getUsable().isPresent();
	}

	private void useButtonOnClick(Entry<String, ActorStack> entry) {
		ActorStack actorstack = entry.getValue();
		Actor actor = actorstack.peek();
		Usable usable = actor.getUsable().get();
		usable.use(player);
	}

	private static ObservableValue<String> getNameLabel(CellDataFeatures<Entry<String, ActorStack>, String> cdf) {
		Entry<String, ActorStack> entry = cdf.getValue();
		ActorStack actorstack = entry.getValue();
		return actorstack != null ? actorstack.fullNameBinding() : new SimpleStringProperty("");
	}
	
	private void dropButtonOnClick(Entry<String, ActorStack> entry) {
		ActorStack actorstack = entry.getValue();
		Actor actor = actorstack.peek();
		Pickable pickable = actor.getPickable().get();
		pickable.drop();
	}
}
