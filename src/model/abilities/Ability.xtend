package model.abilities

import java.util.List
import java.util.function.Consumer
import javafx.beans.binding.Bindings
import javafx.beans.binding.StringExpression
import javafx.scene.image.Image
import map.Tile
import model.Actor
import model.Colours
import model.helper.ActorStack
import util.ControlUtil
import view.GameController
import view.Page
import view.ScreensController
import view.pages.screens.map.MapController
import xtendfx.beans.FXBindable

import static extension util.CollectionsUtil.*

@FXBindable
class Ability {
	Actor owner
	
	String name
	String description
	
	RangeType rangeType
	Target target
	int range //radius when rangeType === SPHERE, length when rangeType === LINE, etc.
	
	String resourceName
	int resourceAmount
	
	Image image
	
	Consumer<ActorStack> useFunction
	
	def StringExpression getCostExpression() {
		return Bindings.concat(resourceNameProperty, " ", resourceAmountProperty);
	}
	
	def activate() {
		val resource = owner.resources.findFirst[ name == resourceName]
		if (resource === null) {
			owner.logIfPlayer(Colours.DARKVIOLET, '''You cannot use «name».''')
			return
		} else if (resource.current < resourceAmount) {
			owner.logIfPlayer(Colours.DARKVIOLET, '''You do not have enough «resourceName».''')
			return
		}
		
		resource.current = resource.current - resourceAmount
		owner.log(Colours.VIOLET, '''«owner.name» uses «name».''')
		
		switch(rangeType) {
			case PERSONAL: activateFrom(owner.tile)
			case RANGED: {
				var MapController mapController = (ScreensController::getScreensController().
					getController(Page::MAP) as MapController)
				mapController.targetTile[activateFrom]
			}
			case TOUCH: {
				var MapController mapController = (ScreensController::getScreensController().
					getController(Page::MAP) as MapController)
				mapController.targetTile[activateFrom]
			}
		}
	}
	
	def activateFrom(Tile srcTile) {
		val map = GameController.context.map
		val List<ActorStack> actorstacks = switch(target) {
			case ACTOR: {
				newArrayList(ControlUtil.getPlayerChoice(srcTile.actors, null))
			}
			case SPHERE: {
				val x = srcTile.x
				val y = srcTile.y
				val product2 = (x-range..x+range).product(y-range..y+range)
				(product2)
				.mapNonNull[ pair |
					map.getTile(pair.key, pair.value)
				].filter[ tile |
					tile.getDistance(srcTile) <= range
				].flatMap[actors]
				.toList
			}
		}
		activate(actorstacks)
	}
	
	def activate(ActorStack... actorStacks) {
		actorStacks.forEach[ actorStack | useFunction.accept(actorStack) ]
	}
	
}