package view.pages.dialogs.trade_menu;


import java.net.URL;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.stream.Collectors;

import org.controlsfx.glyphfont.FontAwesome;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.ObservableMap;
import javafx.collections.transformation.SortedList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TableView.TableViewSelectionModel;
import model.Actor;
import model.helper.ActorStack;
import model.helper.ObservableMapList;
import util.Context;
import view.ControlledScreen;
import view.Page;
import view.ScreensController;


public class TradeMenuController implements ControlledScreen, Initializable {

	@FXML
	private Label sourceLabel;
	
	@FXML
	private TableView<Map.Entry<String, ActorStack>> sourceTable;
	
	@FXML
	private TableColumn<Map.Entry<String, ActorStack>, Number> sourceQuantityColumn;
	
	@FXML
	private TableColumn<Map.Entry<String, ActorStack>, String> sourceNameColumn;
	
	@FXML
	private Label targetLabel;
	
	@FXML
	private TableView<Map.Entry<String, ActorStack>> targetTable;
	
	@FXML
	private TableColumn<Map.Entry<String, ActorStack>, Number> targetQuantityColumn;
	
	@FXML
	private TableColumn<Map.Entry<String, ActorStack>, String> targetNameColumn;
	
	@FXML
	private Button moveToTargetButton;
	
	@FXML
	private Button moveAllToTargetButton;
	
	@FXML
	private Button moveToSourceButton;
	
	@FXML
	private Button moveAllToSourceButton;
//	
//	@FXML
//	private Button okButton;
//
//	@FXML
//	private Button cancelButton;
//
//	@FXML
//	private Button takeAllButton;

	private Actor target;
	private ObservableMapList<String, ActorStack> targetItems;

	private Actor source;
	private ObservableMapList<String, ActorStack> sourceItems;

	@Override
	public void onLoad(Context context) {
		source = context.getPlayer();
		sourceLabel.setText(context.getPlayer().getName());
		
		
		ObservableMap<String, ActorStack> sourceCopy = deepCopy(source.getContainer().get().getInventory2());
		sourceItems = new ObservableMapList<>(sourceCopy);
		
		SortedList<Entry<String, ActorStack>> sortedSource = new SortedList<>(sourceItems.getList(), Comparator.comparing(Entry::getKey));
		sourceTable.setItems(sortedSource);


		ObservableMap<String, ActorStack> targetCopy = deepCopy(target.getContainer().get().getInventory2());
		targetItems = new ObservableMapList<>(targetCopy);
		
		SortedList<Entry<String, ActorStack>> sortedTarget = new SortedList<>(targetItems.getList(), Comparator.comparing(Entry::getKey));
		targetTable.setItems(sortedTarget);
	}

	private ObservableMap<String, ActorStack> deepCopy(ObservableMap<String, ActorStack> original) {
		ObservableMap<String, ActorStack> copy = FXCollections.observableHashMap();
		original.entrySet().forEach(e -> copy.put(e.getKey(), new ActorStack(e.getValue())));
		return copy;
	}

	public void setTarget(Actor target) {
		this.target = target;
		targetLabel.setText(target.getName());
	}

	@FXML
	public void handleOkButton() {
		ObservableMap<String, ActorStack> sourceInventory = source.getContainer().get().getInventory2();
		sourceInventory.clear();
		sourceInventory.putAll(sourceItems.getMap());
		for (Entry<String, ActorStack> entry : sourceItems.getList()) {
			for (Actor actor : entry.getValue().getActors()) {
				actor.getPickable().ifPresent(pickable -> pickable.setContainer(source));
			}
		}
		
		ObservableMap<String, ActorStack> targetInventory = target.getContainer().get().getInventory2();
		targetInventory.clear();
		targetInventory.putAll(targetItems.getMap());
		for (Entry<String, ActorStack> entry : targetItems.getList()) {
			for (Actor actor : entry.getValue().getActors()) {
				actor.getPickable().ifPresent(pickable -> pickable.setContainer(target));
			}
		}
		
		close();
	}

	@FXML
	public void handleCancelButton() {
		close();
	}

	@FXML
	public void handleTakeAllButton() {
		List<String> names = targetTable.getItems().stream().map(Entry::getKey).collect(Collectors.toList());
		names.forEach(name -> moveAll(name, targetItems, sourceItems));
	}

	private void close() {
		ScreensController.getScreensController().closeWindow(Page.TRADE_MENU);
	}

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		sourceTable.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
		targetTable.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
		
		sourceQuantityColumn.setCellValueFactory(cdf -> cdf.getValue().getValue().sizeBinding());
		sourceNameColumn.setCellValueFactory(cdf -> cdf.getValue().getValue().nameProperty());
		
		targetQuantityColumn.setCellValueFactory(cdf -> cdf.getValue().getValue().sizeBinding());
		targetNameColumn.setCellValueFactory(cdf -> cdf.getValue().getValue().nameProperty());
		
		
		FontAwesome fontAwesome = new FontAwesome();
		
		moveToTargetButton.setGraphic(fontAwesome.create(FontAwesome.Glyph.ANGLE_RIGHT));
		moveAllToTargetButton.setGraphic(fontAwesome.create(FontAwesome.Glyph.ANGLE_DOUBLE_RIGHT));
		
		moveToSourceButton.setGraphic(fontAwesome.create(FontAwesome.Glyph.ANGLE_LEFT));
		moveAllToSourceButton.setGraphic(fontAwesome.create(FontAwesome.Glyph.ANGLE_DOUBLE_LEFT));
	}
	
	@FXML
	private void moveToTarget() {
		TableViewSelectionModel<Entry<String, ActorStack>> selectionModel = sourceTable.getSelectionModel();
		ObservableList<Entry<String, ActorStack>> selectedItems = selectionModel.getSelectedItems();
		Set<String> selectedKeys = selectedItems.stream().map(Entry::getKey).collect(Collectors.toSet());
		
		for (String key : selectedKeys) {
			move(key, sourceItems, targetItems);
		}
		
		selectionModel.clearSelection();
		sourceItems.getMap().entrySet().stream().filter(e -> selectedKeys.contains(e.getKey())).forEach(e -> selectionModel.select(e));
	}
	
	@FXML
	private void moveToSource() {
		TableViewSelectionModel<Entry<String, ActorStack>> selectionModel = targetTable.getSelectionModel();
		ObservableList<Entry<String, ActorStack>> selectedItems = selectionModel.getSelectedItems();
		Set<String> selectedKeys = selectedItems.stream().map(Entry::getKey).collect(Collectors.toSet());
		
		for (String key : selectedKeys) {
			move(key, targetItems, sourceItems);
		}
		
		selectionModel.clearSelection();
		targetItems.getMap().entrySet().stream().filter(e -> selectedKeys.contains(e.getKey())).forEach(e -> selectionModel.select(e));
	}
	
	@FXML
	private void moveAllToTarget() {
		Set<String> selectedKeys = sourceTable.getSelectionModel().getSelectedItems().stream().map(Entry::getKey).collect(Collectors.toSet());
		selectedKeys.forEach(key -> moveAll(key, sourceItems, targetItems));
	}
	
	@FXML
	private void moveAllToSource() {
		Set<String> selectedKeys = targetTable.getSelectionModel().getSelectedItems().stream().map(Entry::getKey).collect(Collectors.toSet());
		selectedKeys.forEach(key -> moveAll(key, targetItems, sourceItems));
	}

	private void move(String key, ObservableMapList<String, ActorStack> srcMapList, ObservableMapList<String, ActorStack> destMapList) {
		ActorStack src = srcMapList.getMap().remove(key);
		ActorStack dest = destMapList.getMap().remove(key);
		if (dest == null) {
			dest = new ActorStack(key);
		}
		dest.add(src.pop());
		if (!src.isEmpty()) {
			srcMapList.getMap().put(key, new ActorStack(src));
		}
		destMapList.getMap().put(key, dest);
	}
	
	private void moveAll(String key, ObservableMapList<String, ActorStack> srcMapList, ObservableMapList<String, ActorStack> destMapList) {
		ActorStack src = srcMapList.getMap().remove(key);
		ObservableMap<String, ActorStack> destMap = destMapList.getMap();
		ActorStack dest = destMap.remove(key);
		if (dest == null) {
			dest = new ActorStack(src.getActors());
		} else {
			dest.addAll(src.getActors());
		}
		destMap.put(key, dest);
	}
}
