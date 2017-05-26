package util;


import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

import javafx.collections.SetChangeListener.Change;


public class CollectionsUtil {

	public static <T> List<T> list(@SuppressWarnings("unchecked") T... args) {
		List<T> result = new ArrayList<>(args.length);
		for (T arg : args) {
			result.add(arg);
		}
		return result;
	}

	public static <T> void applyChange(Change<? extends T> change, Consumer<T> onElementAdded, Consumer<T> onElementRemoved) {
		if (change.wasRemoved()) {
			onElementRemoved.accept(change.getElementRemoved());
		}
		if (change.wasAdded()) {
			onElementAdded.accept(change.getElementAdded());
		}
	}
}
