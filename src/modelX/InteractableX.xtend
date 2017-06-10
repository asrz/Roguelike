package modelX

abstract class InteractableX extends ComponentX {
	new(ActorX owner) {
		super(owner)
	}

	def abstract void interact(ActorX user);
}