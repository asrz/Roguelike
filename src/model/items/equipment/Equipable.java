package model.items.equipment;

import java.util.Optional;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import model.Actor;

public class Equipable {
	private Actor owner;

	private StringProperty slot;

	private boolean cursed;

	protected Optional<Actor> equipper;

	public Equipable(Actor owner, String slot) {
		this(owner, slot, false);
	}

	public Equipable(Actor owner, String slot, boolean cursed) {
		this.owner = owner;
		this.owner.setEquipable(this);

		this.equipper = Optional.empty();
		this.slot = new SimpleStringProperty(slot);

		this.cursed = cursed;
	}

	public String getSlot() {
		return slot.get();
	}

	public StringProperty slotProperty() {
		return slot;
	}

	public void onEquip(Actor equipper) {
		this.equipper = Optional.of(equipper);

		if (cursed) {
			if (!owner.getName().startsWith("Cursed")) {
				owner.setName("Cursed " + owner.getName());
			}
		}
	}

	public void onUnequip(Actor equipper) {
		this.equipper = Optional.empty();
	}

	public boolean isEquipped() {
		return equipper.isPresent();
	}

	public boolean isCursed() {
		return cursed;
	}
}
