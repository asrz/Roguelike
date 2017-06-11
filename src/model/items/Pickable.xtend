package model.items

import org.eclipse.xtend.lib.annotations.Accessors
import model.Actor
import model.Component

class Pickable extends Component {
	@Accessors protected Actor container
	
	int stackLimit
	
	new (Actor owner) {
		this(owner, 1)
	}
	
	new (Actor owner, int stackLimit) {
		this(owner, null, stackLimit)
	}
	
	new (Actor owner, Actor container) {
		this(owner, container, 1)
	}
	
	new (Actor owner, Actor container, int stackLimit) {
		super(owner)
		
		this.container = container
		container?.container?.addItem(owner)
		
		this.stackLimit = stackLimit
	}
	
	//returns true if this was picked up
	def pickup(Actor container) {
		this.container = container
		container?.container?.addItem(owner)
		owner.tile.removeActor(owner)
		return container !== null
	}
	
	def drop() {
		container?.container?.removeItem(owner)
		container?.tile?.addActor(owner)
		container = null
	}
}