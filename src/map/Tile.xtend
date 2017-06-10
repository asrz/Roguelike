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
import modelX.ActorX
import modelX.ColourX
import modelX.ColoursX
import modelX.helperX.ActorStackX
import util.CollectionsUtil
import xtendfx.beans.FXBindable
import xtendfx.beans.Hidden

@FXBindable
class Tile {
	int x
	int y
	
	boolean wall
	boolean explored = true
	
	char symbol = '.'
	ColourX foregroundColour = ColoursX.WHITE
	ColourX backgroundColour = ColoursX.BLACK
	
	@Hidden private ObservableList<ActorStackX> _actors = FXCollections.observableArrayList;
	SortedList<ActorStackX> actors = null
	
	new (int x, int y, boolean wall) {
		xProperty = new ReadOnlyIntegerWrapper(x)
		yProperty = new ReadOnlyIntegerWrapper(y)
		wallProperty = new SimpleBooleanProperty(wall)
		exploredProperty = new SimpleBooleanProperty(_initExplored)
		symbolProperty = new SimpleObjectProperty<Character>(_initSymbol);
		backgroundColourProperty = new SimpleObjectProperty<ColourX>(_initBackgroundColour);
		foregroundColourProperty = new SimpleObjectProperty<ColourX>(_initForegroundColour);
		_actors = FXCollections.observableArrayList;
		_actors.addListener[ ListChangeListener.Change<? extends ActorStackX> change |
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
		actorsProperty = new SimpleObjectProperty<SortedList<ActorStackX>>(CollectionsUtil.newSortedList(_actors, [ peek().displayPriority]))
	}

	def removeActor(ActorX actor) {
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
	
	def addActor(ActorX actor) {
		new ActorStackX(FXCollections.observableArrayList(actor)).addActorStack
	}
	
	def addActorStack(ActorStackX actorStack) {
		for (stack : actors) {
			if (stack.name == actorStack.name) {
				stack.addAll(actorStack)
				return;
			}
		}
		_actors.add(actorStack);
	}
	
	def getTarget(ActorX actor) {
		return actors
			.map[ actors ]
			.flatten
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
			return true
		}
		
		return actors.map[ actors ].flatten.exists[ blocks ]
	}
	
	def getInteractableActor() {
		return actors.map[ actors ].flatten.findFirst[ interactable !== null]
	}
	
	def foregroundColorProperty() {
		Bindings.createObjectBinding([
			return foregroundColour.color
		], foregroundColourProperty)
	}
	
}