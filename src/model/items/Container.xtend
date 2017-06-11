package model.items

import java.util.Map
import javafx.collections.FXCollections
import javafx.collections.MapChangeListener
import javafx.collections.MapChangeListener.Change
import javafx.collections.ObservableMap
import org.eclipse.xtend.lib.annotations.Accessors
import model.helper.ActorStack
import model.Actor
import model.Component

class Container extends Component {
	@Accessors(PUBLIC_GETTER) ObservableMap<String, ActorStack> inventory
	@Accessors(PUBLIC_GETTER) ObservableMap<String, ActorStack> equipables
	@Accessors(PUBLIC_GETTER) ObservableMap<String, ActorStack> nonEquipables
	
	MapChangeListener<String, ActorStack> inventoryChangeListener
	MapChangeListener<String, ActorStack> nonEquipablesChangeListener
	MapChangeListener<String, ActorStack> equipablesChangeListener
	
	new(Actor owner) {
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
	
	def onSubMapChange(Change<? extends String, ? extends ActorStack> change) {
		inventory.removeListener(inventoryChangeListener)
		if (change.wasRemoved()) {
			inventory.remove(change.getKey())
		}
		if (change.wasAdded()) {
			inventory.put(change.getKey(), change.getValueAdded())
		}
		inventory.addListener(inventoryChangeListener)
	}
	
	def onInventoryChange(Change<? extends String, ? extends ActorStack> change) {
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
	
	def addItem(Actor actor) {
		addToMap(actor, inventory)
		actor.pickable.container = owner
	}
	
	def addItems(ActorStack actors) {
		actors.actors.forEach[ 
			pickable.container = owner
		]
		addStackToMap(actors, inventory)
	}
	
	def addStackToMap(ActorStack actors, Map<String, ActorStack> map) {
		if (map.containsKey(actors.name)) {
			val actorStack = map.remove(actors.name)
			actorStack.addAll(actors)
			map.put(actors.name, actorStack)
		} else {
			map.put(actors.name, actors)
		}
	}
	
	def addToMap(Actor actor, Map<String, ActorStack> map) {
		if (map.containsKey(actor.name)) {
			val actorStack = map.remove(actor.name)
			actorStack.add(actor)
			map.put(actor.name, actorStack)
		} else {
			map.put(actor.name, new ActorStack(FXCollections.observableArrayList(actor)))
		}
	}
	
	def removeItem(Actor actor) {
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