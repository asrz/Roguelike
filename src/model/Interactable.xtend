package model

abstract class Interactable {
	protected Actor owner;

	new(Actor owner) {
		this.owner = owner;
		owner.setInteractable(this);
	}

	def abstract void interact(Actor user);
}