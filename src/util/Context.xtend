package util

import java.util.List
import map.Map
import modelX.ActorX
import org.eclipse.xtend.lib.annotations.Accessors

class Context {
	@Accessors(PUBLIC_GETTER)           Map map
	@Accessors                          ActorX player
	@Accessors(PUBLIC_GETTER)           List<ActorX> actors
	                                    List<ActorX> toAdd
	                                    List<ActorX> toRemove

	new(Map map) {
		this.map = map
		this.actors = newArrayList()
		this.toAdd = newArrayList()
		this.toRemove = newArrayList()
	}

	def addActor(ActorX actor) {
		return toAdd.add(actor)
	}

	def removeActor(ActorX actor) {
		return toRemove.remove(actor)
	}
	
	def void update() {
		actors.forEach[ update(this) ]
		
		actors.removeAll(toRemove)
		actors.addAll(toAdd)
		toRemove.clear()
		toAdd.clear()
	}
}
