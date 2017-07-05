package map

import model.Actor
import model.Colours
import model.Direction
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PUBLIC_GETTER)
class Map {
	Tile[] tiles
	
	int height
	int width
	
	new (int width, int height) {
		this.width = width
		this.height = height
		
		tiles = newArrayOfSize(width * height)
		for (x : 0 ..< width) {
			for (y : 0 ..< height) {
				tiles.set(x * height + y, new Tile(x, y, false))
			}
		}
	}
	
	def Tile getTile(int x, int y) {
		return if (isInBounds(x, y)) {
			tiles.get(x * height + y)
		}
	}
	
	def boolean isInBounds(int x, int y) {
		return !(x < 0 || y < 0 || x >= width || y >= height)
	}
	
	def Tile getTile(Tile src, Direction direction) {
		val x = src.x + direction.x
		val y = src.y + direction.y
		return getTile(x, y)
	}
	
	def void moveActor(Actor actor, Direction direction) {
		val src = actor.tile
		
		val dest = getTile(src, direction)
		
		if (dest === null) {
			return
		}
		
		if (dest.walkable) {
			src.removeActor(actor)
			dest.addActor(actor)
		} else if (actor.attacker !== null) {
			attackMove(actor, direction)
		}
	}
	
	//returns true if a turn has passed
	def interact(Actor actor, Direction direction) {
		val dest = getTile(actor.tile, direction)
		
		val target = dest?.interactableActor
		
		if (target === null) {
			actor.logIfPlayer(Colours::GREY, "There is nothing there to interact with.")
		}
		target.interactable.interact(actor)
	}
	
	def attackMove(Actor actor, Direction direction) {
		val dest = getTile(actor.tile, direction)
		
		val target = dest.getTarget(actor)
		if (target !== null) {
			actor.attacker.attack(target)
		}
	}
	
}