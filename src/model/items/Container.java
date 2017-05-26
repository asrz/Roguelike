package model.items;


import java.util.Map;

import javafx.collections.FXCollections;
import javafx.collections.MapChangeListener;
import javafx.collections.MapChangeListener.Change;
import javafx.collections.ObservableMap;
import model.Actor;
import model.helper.ActorStack;


public class Container {

	private ObservableMap<String, ActorStack> inventory2;
	private ObservableMap<String, ActorStack> equipables;
	private ObservableMap<String, ActorStack> nonEquipables;
	
	private MapChangeListener<String, ActorStack> equipablesChangeListener;
	private MapChangeListener<String, ActorStack> nonEquipablesChangeListener;
	private MapChangeListener<String, ActorStack> inventoryChangeListener;
	
	protected Actor owner;

	public Container(Actor owner) {
		this.owner = owner;
		owner.setContainer(this);

		inventory2 = FXCollections.observableHashMap();
		equipables = FXCollections.observableHashMap();
		nonEquipables = FXCollections.observableHashMap();
		
		equipablesChangeListener = this::onSubMapChange;
		nonEquipablesChangeListener = this::onSubMapChange;
		inventoryChangeListener = this::onInventoryChange;
		
		equipables.addListener(equipablesChangeListener);
		nonEquipables.addListener(nonEquipablesChangeListener);
		inventory2.addListener(inventoryChangeListener);
	}

	private void onSubMapChange(Change<? extends String, ? extends ActorStack> change) {
		inventory2.removeListener(inventoryChangeListener);
		if (change.wasRemoved()) {
			inventory2.remove(change.getKey());
		}
		if (change.wasAdded()) {
			inventory2.put(change.getKey(), change.getValueAdded());
		}
		inventory2.addListener(inventoryChangeListener);
	}
	
	private void onInventoryChange(Change<? extends String, ? extends ActorStack> change) {
		equipables.removeListener(equipablesChangeListener);
		nonEquipables.removeListener(nonEquipablesChangeListener);
		
		if (change.wasAdded()) {
			ActorStack valueAdded = change.getValueAdded();
			if (valueAdded.peek().getEquipable().isPresent()) {
				equipables.put(change.getKey(), valueAdded);
			} else {
				nonEquipables.put(change.getKey(), valueAdded);
			}
		}
		
		if (change.wasRemoved()) {
			ActorStack valueRemoved = change.getValueRemoved();
			if (valueRemoved.peek().getEquipable().isPresent()) {
				equipables.remove(change.getKey());
			} else {
				nonEquipables.remove(change.getKey());
			}
		}
		
		equipables.addListener(equipablesChangeListener);
		nonEquipables.addListener(nonEquipablesChangeListener);
	}
	
	public void addItem(Actor actor) {
		addToMap(actor, inventory2);
	}

	public void addItems(ActorStack equipped) {
		addStackToMap(equipped, inventory2);
	}
	
	private void addStackToMap(ActorStack actors, Map<String, ActorStack> map) {
		if (map.containsKey(actors.getName())) {
			ActorStack actorStack = map.remove(actors.getName());
			actorStack.addAll(actors.getActors());
			map.put(actors.getName(), actorStack);
		} else {
			map.put(actors.getName(), actors);
		}
	}
	
	private void addToMap(Actor actor, Map<String, ActorStack> map) {
		if (map.containsKey(actor.getName())) {
			ActorStack actorStack = map.remove(actor.getName());
			actorStack.add(actor);
			map.put(actor.getName(), actorStack);
		} else {
			map.put(actor.getName(), new ActorStack(FXCollections.observableArrayList(actor)));
		}
	}
	
	public void removeItem(Actor actor) {
		ActorStack actorStack = inventory2.remove(actor.getName());
		actorStack.remove(actor);
		if (!actorStack.isEmpty()) {
			inventory2.put(actor.getName(), actorStack);
		}
	}
	
	public void removeAllByName(String name) {
		inventory2.remove(name);
	}

	public ObservableMap<String, ActorStack> getInventory2() {
		return inventory2;
	}

	public void setInventory2(ObservableMap<String, ActorStack> inventory2) {
		this.inventory2 = inventory2;
	}
	
	public ObservableMap<String, ActorStack> getEquipables() {
		return equipables;
	}
	
	public ObservableMap<String, ActorStack> getNonEquipables() {
		return nonEquipables;
	}
}
