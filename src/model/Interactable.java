package model;


public abstract class Interactable {

	protected Actor owner;

	public Interactable(Actor owner) {
		this.owner = owner;
		owner.setInteractable(this);
	}

	public abstract void interact(Actor user);

}
