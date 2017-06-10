package modelX.helperX

import java.util.List
import javafx.beans.binding.Bindings
import javafx.collections.FXCollections
import javafx.collections.ObservableList
import modelX.ActorX
import xtendfx.beans.FXBindable

@FXBindable
class ActorStackX {
	String name
	ObservableList<ActorX> actors
//	int size
//	String fullName
	
	new(ObservableList<ActorX> actors) {
		this(actors.get(0).name, actors)
	}
	
	new(ActorStackX original) {
		this(original.name, FXCollections.observableArrayList())
		this.actors.addAll(original.actors)
	}
	
	new(String name) {
		this(name, FXCollections.observableArrayList())
	}
	
	def add(ActorX actor) {
		if (actor.name != this.name) {
			throw new IllegalArgumentException("Actor's name does not match that of ActorStack.")
		}
		return actors.add(actor)
	}
	
	def remove(ActorX actor) {
		return actors.remove(actor)
	}
	
	def isEmpty() {
		return actors.isEmpty()
	}
	
	def peek() {
		return actors.get(0)
	}
	
	def pop() {
		return actors.remove(0)
	}
	
	def addAll(List<ActorX> actors) {
		if (actors.exists[ name != this.name]) {
			throw new IllegalArgumentException("Actor's name does not match the ActorStack.")
		}
		actors.addAll(actors)
	}
	
	def addAll(ActorStackX actorStack) {
		if (actorStack.name != name) {
			throw new IllegalArgumentException("You cannot add two actor stacks with different names.")
		}
		actors.addAll(actorStack.getActors())
	}
	
	def size() {
		return actors.size()
	}
	
	def override toString() {
		if (size() === 1) {
			return name
		} else {
			return '''«name» («size()»)'''
		}
	}
	
	def contains(ActorX actor) {
		return actors.contains(actor)
	}
	
	def sizeBinding() {
		return Bindings.size(actors)
	}
	
	def fullNameBinding() {
		return Bindings.createStringBinding([ toString ], nameProperty, sizeBinding)
	}
	
	def getFullName() {
		return fullNameBinding.value
	}
}