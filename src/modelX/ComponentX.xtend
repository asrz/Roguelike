package modelX

abstract class ComponentX {
	protected ActorX owner
	
	protected new(ActorX owner) {
		this.owner = owner
		owner.setComponent(this)
	}
}