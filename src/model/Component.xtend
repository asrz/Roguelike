package model

abstract class Component {
	protected Actor owner
	
	protected new(Actor owner) {
		this.owner = owner
		owner.setComponent(this)
	}
}