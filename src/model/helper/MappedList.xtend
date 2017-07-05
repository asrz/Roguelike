package model.helper

import java.util.function.Function
import javafx.collections.ObservableList
import javafx.collections.transformation.TransformationList
import javafx.collections.ListChangeListener.Change

class MappedList<T, S> extends TransformationList<S, T> {
	
	Function<T, S> mapper
	
	public new(ObservableList<? extends T> source, Function<T, S> mapper) {
		super(source)
		
		this.mapper = mapper
	}
	
	override getSourceIndex(int index) {
		return index
	}
	
	override protected sourceChanged(Change<? extends T> c) {}
	
	override get(int index) {
		return mapper.apply(source.get(index))
	}
	
	override size() {
		return source.size
	}
	
}