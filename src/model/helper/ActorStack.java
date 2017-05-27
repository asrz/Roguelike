package model.helper;

import java.util.List;

import javafx.beans.binding.Bindings;
import javafx.beans.binding.IntegerBinding;
import javafx.beans.binding.StringBinding;
import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import model.Actor;

public class ActorStack {
	private StringProperty nameProperty;
	private ObservableList<Actor> _actors;
	private ListProperty<Actor> actors;
	private IntegerBinding sizeBinding;
	private StringBinding fullNameBinding;
	
	public ActorStack(ObservableList<Actor> actors) {
		this(actors.get(0).getName(), actors);
	}

	public ActorStack(ActorStack original) {
		this(original.getName());
		this.actors.addAll(original.getActors());
	}
	
	public ActorStack(String name) {
		this(name, FXCollections.observableArrayList());
	}
	
	public ActorStack(String name, ObservableList<Actor> actors) {
		this.nameProperty = new SimpleStringProperty(name);
		this._actors = actors;
		this.actors = new SimpleListProperty<>(_actors);
		sizeBinding = Bindings.size(actors);
		fullNameBinding = getFullNameBinding();
	}

	public ObservableList<Actor> getActors() {
		return actors.get();
	}
	
	public ListProperty<Actor> actorsProperty() {
		return actors;
	}
	
	public String getName() {
		return nameProperty.get();
	}
	
	public StringProperty nameProperty() {
		return nameProperty;
	}
	
	public IntegerBinding sizeBinding() {
		return sizeBinding;
	}
	
	public StringBinding fullNameBinding() {
		return fullNameBinding;
	}
	
	public int size() {
		return sizeBinding.get();
	}
	
	public void add(Actor actor) {
		if (!actor.getName().equals(nameProperty.get())) {
			throw new IllegalArgumentException("Actor's name does not match that of ActorStack");
		}
		
		actors.add(actor);
	}
	
	public boolean remove(Actor actor) {
		return actors.remove(actor);
	}

	public boolean isEmpty() {
		return actors.isEmpty();
	}
	
	public Actor peek() {
		return actors.get(0);
	}

	public Actor pop() {
		return actors.remove(0);
	}

	public void addAll(List<Actor> actors) {
		this.actors.addAll(actors);
	}
	
	@Override
	public String toString() {
		if (size() == 1) {
			return getName();
		} else {
			return String.format("%s (%d)", getName(), size());
		}
	}
	
	
	private StringBinding getFullNameBinding() {
		return Bindings.createStringBinding(this::toString, nameProperty, sizeBinding);
	}
}

