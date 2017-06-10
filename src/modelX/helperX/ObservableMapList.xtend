package modelX.helperX

import java.util.AbstractMap
import java.util.Map
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.collections.MapChangeListener
import javafx.collections.ObservableList
import javafx.collections.ObservableMap

class ObservableMapList<K, V> {
	final ObservableList<Map.Entry<K, V>> obsList
	final ObservableMap<K, V> map
	MapChangeListener<K, V> mapChange = null
	ListChangeListener<Map.Entry<K, V>> listChange = null
	
	new(ObservableMap<K, V> map) {
		this.map = map 
		obsList = FXCollections.observableArrayList(map.entrySet()) 
		mapChange = [ MapChangeListener.Change<? extends K, ? extends V> change | 
			obsList.removeListener(listChange)
			if (change.wasAdded()) {
				obsList.add(new AbstractMap.SimpleEntry(change.key, change.valueAdded))
			}
			if (change.wasRemoved()) {
				// obsList.remove(new AbstractMap.SimpleEntry(change.getKey(),change.getValueRemoved()));
				// ^ doesn't work always, use loop instead
				val match = obsList.findFirst[ key == change.key ]
				obsList.remove(match)
			}
			obsList.addListener(listChange)
		]
		listChange = [ ListChangeListener.Change<? extends Map.Entry<K, V>> change | {
			map.removeListener(mapChange) 
			while (change.next()) {
				// maybe check for uniqueness here
				if (change.wasRemoved()) {
					for (Map.Entry<K, V> me : change.getRemoved()) {
						map.remove(me.getKey()) 
					}
				}
				if (change.wasAdded()) {
					for (Map.Entry<K, V> me : change.getAddedSubList()) {
						map.put(me.getKey(), me.getValue()) 
					}
				}
			}
			map.addListener(mapChange) 
		}] 
		map.addListener(mapChange) 
		obsList.addListener(listChange) 
	}
	// adding to list should be unique
	def void addUnique(K key, V value) {
		// if a duplicate key just change the value
		val match = obsList.findFirst[ it.key == key ]
		if (match !== null) {
			match.value = value
		} else {
			obsList.add(new AbstractMap.SimpleEntry(key,value)) 
		}
	}
	// for doing lengthy map operations
	def void removeMapListener() {
		map.removeListener(mapChange) 
	}
	// for resyncing list to map after many changes
	def void resetMapListener() {
		obsList.removeListener(listChange) 
		obsList.clear() 
		obsList.addAll(map.entrySet()) 
		obsList.addListener(listChange) 
		map.addListener(mapChange) 
	}
	def ObservableList<Map.Entry<K, V>> getList() {
		return obsList 
	}
	def ObservableMap<K, V> getMap() {
		return map 
	}
	def void removeListListener() {
		obsList.removeListener(listChange) 
	}
	def void resetListListener() {
		map.removeListener(mapChange) 
		map.clear() 
		obsList.forEach([e | map.put(e.getKey(), e.getValue())]) 
		map.addListener(mapChange) 
		obsList.addListener(listChange) 
	}
}