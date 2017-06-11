package modelX.itemsX

import java.util.Map
import javafx.collections.FXCollections
import javafx.collections.MapChangeListener
import javafx.collections.MapChangeListener.Change
import javafx.collections.ObservableMap
import modelX.ActorX
import modelX.ComponentX
import modelX.helperX.ActorStackX
import org.eclipse.xtend.lib.annotations.Accessors


class ContainerX extends ComponentX {
	@Accessors(PUBLIC_GETTER) ObservableMap<String, ActorStackX> inventory
	@Accessors(PUBLIC_GETTER) ObservableMap<String, ActorStackX> equipables
	@Accessors(PUBLIC_GETTER) ObservableMap<String, ActorStackX> nonEquipables
	
	MapChangeListener<String, ActorStackX> inventoryChangeListener
	MapChangeListener<String, ActorStackX> nonEquipablesChangeListener
	MapChangeListener<String, ActorStackX> equipablesChangeListener
	
	new(ActorX owner) {
		super(owner)
		
		inventory = FXCollections.observableHashMap()
		equipables = FXCollections.observableHashMap()
		nonEquipables = FXCollections.observableHashMap()
		
		equipablesChangeListener = [ onSubMapChange ]
		nonEquipablesChangeListener = [ onSubMapChange ]
		inventoryChangeListener = [ onInventoryChange ]
		
		inventory.addListener(inventoryChangeListener)
		equipables.addListener(equipablesChangeListener)
		nonEquipables.addListener(nonEquipablesChangeListener)
	}
	
	def onSubMapChange(Change<? extends String, ? extends ActorStackX> change) {
		inventory.removeListener(inventoryChangeListener)
		if (change.wasRemoved()) {
			inventory.remove(change.getKey())
		}
		if (change.wasAdded()) {
			inventory.put(change.getKey(), change.getValueAdded())
		}
		inventory.addListener(inventoryChangeListener)
	}
	
	def onInventoryChange(Change<? extends String, ? extends ActorStackX> change) {
		equipables.removeListener(equipablesChangeListener)
		nonEquipables.removeListener(nonEquipablesChangeListener)
		
		if (change.wasRemoved()) {
			if (change.getValueRemoved().peek().equipable !== null) {
				equipables.remove(change.getKey())
			} else {
				nonEquipables.remove(change.getKey())
			}
		}
		if (change.wasAdded()) {
			val  valueAdded = change.valueAdded
			if (valueAdded.peek().equipable !== null) {
				equipables.put(change.getKey(), valueAdded)
			} else {
				nonEquipables.put(change.getKey(), valueAdded)
			}
		}
		
		equipables.addListener(equipablesChangeListener)
		nonEquipables.addListener(nonEquipablesChangeListener)
	}
	
	def addItem(ActorX actor) {
		addToMap(actor, inventory)
		actor.pickable.container = owner
	}
	
	def addItems(ActorStackX actors) {
		actors.actors.forEach[ 
			pickable.container = owner
		]
		addStackToMap(actors, inventory)
	}
	
	def addStackToMap(ActorStackX actors, Map<String, ActorStackX> map) {
		if (map.containsKey(actors.name)) {
			val actorStack = map.remove(actors.name)
			actorStack.addAll(actors)
			map.put(actors.name, actorStack)
		} else {
			map.put(actors.name, actors)
		}
	}
	
	def addToMap(ActorX actor, Map<String, ActorStackX> map) {
		if (map.containsKey(actor.name)) {
			val actorStack = map.remove(actor.name)
			actorStack.add(actor)
			map.put(actor.name, actorStack)
		} else {
			map.put(actor.name, new ActorStackX(FXCollections.observableArrayList(actor)))
		}
	}
	
	def removeItem(ActorX actor) {
		val actorStack = inventory.remove(actor.name)
		actorStack.remove(actor)
		if (!actorStack.isEmpty) {
			inventory.put(actor.name, actorStack)
		}
	}
	
	def removeAllByName(String name) {
		return inventory.remove(name)
	}
}