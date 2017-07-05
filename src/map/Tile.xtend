package map

import javafx.beans.binding.Bindings
import javafx.beans.property.ReadOnlyIntegerWrapper
import javafx.beans.property.SimpleBooleanProperty
import javafx.beans.property.SimpleListProperty
import javafx.beans.property.SimpleObjectProperty
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.collections.ObservableList
import javafx.collections.transformation.SortedList
import util.CollectionsUtil
import xtendfx.beans.FXBindable
import xtendfx.beans.Hidden

import static extension util.CollectionsUtil.*
import model.helper.ActorStack
import model.Actor
import model.Colours
import model.Colour
import model.helper.FXBinding

@FXBindable
class Tile {
	int x
	int y
	
	boolean wall
	boolean explored = true
	
	char symbol = '.'
	Colour foregroundColour = Colours.WHITE
	Colour backgroundColour = Colours.BLACK
	
	@Hidden private ObservableList<ActorStack> _actors = FXCollections.observableArrayList;
	SortedList<ActorStack> actors = null
	
	new (int x, int y, boolean wall) {
		xProperty = new ReadOnlyIntegerWrapper(x)
		yProperty = new ReadOnlyIntegerWrapper(y)
		wallProperty = new SimpleBooleanProperty(wall)
		exploredProperty = new SimpleBooleanProperty(_initExplored)
		symbolProperty = new SimpleObjectProperty<Character>(_initSymbol);
		backgroundColourProperty = new SimpleObjectProperty<Colour>(_initBackgroundColour);
		foregroundColourProperty = new SimpleObjectProperty<Colour>(_initForegroundColour);
		_actors = FXCollections.observableArrayList;
		_actors.addListener[ ListChangeListener.Change<? extends ActorStack> change |
			val list = change.getList()
			if (list.size() > 0) {
				val actor = list.minBy[ peek().displayPriority].peek()
				symbolProperty.set(actor.character)
				foregroundColourProperty.set(actor.colour)
			} else {
				symbolProperty.set(_initSymbol)
				foregroundColourProperty.set(_initForegroundColour)
			}
		]
		_actorsProperty = new SimpleListProperty(_actors)
		actorsProperty = new SimpleObjectProperty<SortedList<ActorStack>>(CollectionsUtil.newSortedList(_actors, [ peek().displayPriority]))
	}

	def removeActor(Actor actor) {
		actor.tile = null
		for (stack : actors) {
			if (stack.contains(actor)) {
				val result = stack.remove(actor);
				if (stack.isEmpty()) {
					_actors.remove(stack)
				}
				return result
			}
		}
		return false;
	}
	
	def removeActorStack(ActorStack actorStack) {
		actorStack.actors.forEach[ tile = null ]
		return _actors.remove(actorStack)
	}
	
	def addActor(Actor actor) {
		new ActorStack(FXCollections.observableArrayList(actor)).addActorStack
	}
	
	def addActorStack(ActorStack actorStack) {
		actorStack.actors.forEach[ tile = this ]
		
		for (stack : actors) {
			if (stack.name == actorStack.name) {
				stack.addAll(actorStack)
				return;
			}
		}
		_actors.add(actorStack);
	}
	
	def getTarget(Actor actor) {
		return actors
			.flatMap[ actors ]
			.filter[ destructible !== null ]
			.findFirst[ it !== actor ]
	}
	
	def getDistance(Tile other) {
		val dx = x - other.x;
		val dy = y - other.y
		return Math.round(Math.sqrt(dx * dx + dy * dy));
	}
	
	def getWalkable() {
		if (wall) {
			return false
		}
		
		return !actors.flatMap[ actors ].exists[ blocks ]
	}
	
	def getInteractableActor() {
		return actors.flatMap[ actors ].findFirst[ interactable !== null]
	}
	
	def foregroundColorProperty() {
		return FXBinding.nestedBinding(foregroundColourProperty, [get().colorProperty]);
	}
	
}