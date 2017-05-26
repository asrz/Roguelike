package model.items;


import java.util.Optional;

import model.Actor;


public class Pickable {

	protected Actor owner;

	protected Optional<Actor> container;

	public Pickable(Actor owner) {
		this(owner, true);
	}
	
	public Pickable(Actor owner, boolean stacks) {
		this.owner = owner;
		owner.setPickable(this);
	}

	public Pickable(Actor owner, Actor container) {
		this(owner, container, true);
	}
	
	public Pickable(Actor owner, Actor container, boolean stacks) {
		this(owner, stacks);

		if (container.getContainer().isPresent()) {
			this.container = Optional.of(container);
			container.getContainer().get().addItem(owner);
		}
	}

	public boolean pickup(Actor container) {
		if (container.getContainer().isPresent()) {
			this.container = Optional.of(container);
			container.getContainer().get().addItem(owner);
			owner.setTile(null);
			return true;
		}
		return false;
	}

	public void drop() {
		if (container.isPresent()) {
			container.get().getContainer().get().removeItem(owner);
			owner.setTile(container.get().getTile());
			this.container = null;
		}
	}

	public Optional<Actor> getContainer() {
		return container;
	}

	public void setContainer(Actor actor) {
		container = Optional.ofNullable(actor);
	}
}
