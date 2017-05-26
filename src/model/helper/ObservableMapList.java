package model.helper;

import java.util.AbstractMap;
import java.util.Map;

import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.MapChangeListener;
import javafx.collections.ObservableList;
import javafx.collections.ObservableMap;

public class ObservableMapList<K, V> {
	private final ObservableList<Map.Entry<K, V>> obsList;
	private final ObservableMap<K, V> map;
	private final MapChangeListener<K, V> mapChange;
	private final ListChangeListener<Map.Entry<K, V>> listChange;

	public ObservableMapList(ObservableMap<K, V> map) {
		this.map = map;
		obsList = FXCollections.observableArrayList(map.entrySet());

		mapChange = new MapChangeListener<K, V>() {
			@Override
			public void onChanged(MapChangeListener.Change<? extends K, ? extends V> change) {
				obsList.removeListener(listChange);
				if (change.wasAdded())
					obsList.add(new AbstractMap.SimpleEntry<>(change.getKey(), change.getValueAdded()));
				if (change.wasRemoved()) {
					// obsList.remove(new AbstractMap.SimpleEntry(change.getKey(),change.getValueRemoved()));
					// ^ doesn't work always, use loop instead
					for (Map.Entry<K, V> me : obsList) {
						if (me.getKey().equals(change.getKey())) {
							obsList.remove(me);
							break;
						}
					}
				}
				obsList.addListener(listChange);
			}
		};

		listChange = (ListChangeListener.Change<? extends Map.Entry<K, V>> change) -> {
			map.removeListener(mapChange);
			while (change.next()) {
				// maybe check for uniqueness here
				if (change.wasRemoved()) {
					for (Map.Entry<K, V> me : change.getRemoved()) {
						map.remove(me.getKey());
					}
				}
				if (change.wasAdded()) {
					for (Map.Entry<K, V> me : change.getAddedSubList()) {
						map.put(me.getKey(), me.getValue());
					}
				}
			}
			map.addListener(mapChange);
		};

		map.addListener(mapChange);
		obsList.addListener(listChange);
	}

	// adding to list should be unique
	public void addUnique(K key, V value) {
		boolean isFound = false;
		// if a duplicate key just change the value
		for (Map.Entry<K, V> me : obsList) {
			if (me.getKey().equals(key)) {
				isFound = true;
				me.setValue(value);
				break;// only first match
			}
		}
		if (!isFound) // add new entry
			obsList.add(new AbstractMap.SimpleEntry<>(key, value));
	}
	
	// for doing lengthy map operations
	public void removeMapListener() {
		map.removeListener(mapChange);
	}

	// for resyncing list to map after many changes
	public void resetMapListener() {
		obsList.removeListener(listChange);
		obsList.clear();
		obsList.addAll(map.entrySet());
		obsList.addListener(listChange);
		map.addListener(mapChange);
	}
	
	public ObservableList<Map.Entry<K,V>> getList() {
		return obsList;
	}
	
	public ObservableMap<K, V> getMap() {
		return map;
	}

	public void removeListListener() {
		obsList.removeListener(listChange);
	}
	
	public void resetListListener() {
		map.removeListener(mapChange);
		map.clear();
		obsList.forEach(e -> map.put(e.getKey(), e.getValue()));
		map.addListener(mapChange);
		obsList.addListener(listChange);
	}
}
