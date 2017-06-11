package map

import model.Direction
import org.eclipse.xtend.lib.annotations.Accessors
import model.Actor

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
		return tiles.get(x * height + y)
	}
	
	def boolean isInBounds(int x, int y) {
		return !(x < 0 || y < 0 || x >= width || y >= height)
	}
	
	def void moveActor(Actor actor, Direction direction) {
		val src = actor.tile
		val x = src.x + direction.x
		val y = src.y + direction.y
		
		if(!isInBounds(x, y)) {
			return
		}
		
		val dest = getTile(x, y)
		
		if (canWalk(x, y)) {
			src.removeActor(actor)
			dest.addActor(actor)
		} else if (actor.attacker !== null) {
			val target = dest.getTarget(actor)
			if (target !== null) {
				actor.attacker.attack(target)
			}
		}
	}
	
	def canWalk(int x, int y) {
		if (!isInBounds(x, y)) {
			return false
		}
		
		val tile = getTile(x, y)
		return !tile.walkable
	}
	
	//returns true if a turn has passed
	def interact(Actor actor, Direction direction) {
		val src = actor.tile
		val x = src.x + direction.x
		val y = src.y + direction.y
		
		if (isInBounds(x, y)) {
			val dest = getTile(x, y)
			val target = dest.getInteractableActor()
			
			if (target !== null) {
				target.interactable.interact(actor)
				return true
			}
		}
		return false
	}
}