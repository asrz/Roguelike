package model.helper

import java.util.List
import map.Map
import org.eclipse.xtend.lib.annotations.Accessors
import model.Actor

class Context {
	@Accessors(PUBLIC_GETTER)           Map map
	@Accessors                          Actor player
	@Accessors(PUBLIC_GETTER)           List<Actor> actors
	                                    List<Actor> toAdd
	                                    List<Actor> toRemove

	new(Map map) {
		this.map = map
		this.actors = newArrayList()
		this.toAdd = newArrayList()
		this.toRemove = newArrayList()
	}

	def addActor(Actor actor) {
		return toAdd.add(actor)
	}

	def removeActor(Actor actor) {
		toRemove.add(actor)
	}
	
	def void update() {
		actors.forEach[ update(this) ]
		
		toRemove.forEach[ destroy() ]
		actors.removeAll(toRemove)
		actors.addAll(toAdd)
		toRemove.clear()
		toAdd.clear()
	}
}
