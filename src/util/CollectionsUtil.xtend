package util

import java.util.Comparator
import java.util.function.Consumer
import java.util.function.Function
import javafx.collections.ObservableList
import javafx.collections.SetChangeListener.Change
import javafx.collections.transformation.SortedList

class CollectionsUtil {
	def static <T> void applyChange(Change<? extends T> change, Consumer<T> onElementAdded, Consumer<T> onElementRemoved) {
		if (change.wasRemoved()) {
			onElementRemoved.accept(change.getElementRemoved())
		}
		if (change.wasAdded()) {
			onElementAdded.accept(change.getElementAdded())
		}
	}
	
	def static <T, C extends Comparable<? super C>> newSortedList(ObservableList<T> list, Function<? super T, ? extends C> comparatorFunction) {
		return new SortedList(list, Comparator::comparing(comparatorFunction));
	}
}
