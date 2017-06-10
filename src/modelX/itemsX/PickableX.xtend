package modelX.itemsX

import modelX.ActorX
import modelX.ComponentX
import org.eclipse.xtend.lib.annotations.Accessors

class PickableX extends ComponentX {
	@Accessors protected ActorX container
	
	int stackLimit
	
	new (ActorX owner) {
		this(owner, 1)
	}
	
	new (ActorX owner, int stackLimit) {
		this(owner, null, stackLimit)
	}
	
	new (ActorX owner, ActorX container) {
		this(owner, container, 1)
	}
	
	new (ActorX owner, ActorX container, int stackLimit) {
		super(owner)
		
		this.container = container
		container?.container?.addItem(owner)
		
		this.stackLimit = stackLimit
	}
	
	//returns true if this was picked up
	def pickup(ActorX container) {
		this.container = container
		container?.container?.addItem(owner)
		owner.tile = null
		return container !== null
	}
	
	def drop() {
		container?.container?.removeItem(owner)
		owner.tile = container?.tile
		container = null
	}
}