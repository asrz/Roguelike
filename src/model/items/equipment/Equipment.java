package model.items.equipment;


import java.util.Collection;
import java.util.Optional;

import javafx.collections.FXCollections;
import javafx.collections.ObservableMap;
import model.Actor;
import model.Colours;
import model.helper.ActorStack;
import model.items.Pickable;


public class Equipment {

	private Actor owner;

	private ObservableMap<String, ActorStack> equipment;

	public Equipment(Actor owner, Collection<String> slots) {
		this.owner = owner;
		owner.setEquipment(this);

		equipment = FXCollections.observableHashMap();
		for (String slot : slots) {
			equipment.put(slot, null);
		}
	}

	public Optional<ActorStack> getEquipped(String slot) {
		return Optional.ofNullable(equipment.get(slot));
	}

	// returns true if equip is successful
	public boolean equip(ActorStack actorStack) {
		Actor sample = actorStack.peek();
		if (!sample.getEquipable().isPresent()) { // if not equippable
			owner.logIfPlayer(Colours.ALICEBLUE, "The %s cannot be equipped.", actorStack.getName());
			return false;
		}
		
		Equipable equipable = sample.getEquipable().get();
		if (!equipment.containsKey(equipable.getSlot())) { // if this doesn't have the slot.
			owner.logIfPlayer(Colours.AQUA, "You cannot equip the %s.", actorStack.getName());
			return false;
		} else { // equip it
			// if something's already equipped, unequip it
			Optional<ActorStack> equipped = getEquipped(equipable.getSlot());
			// if fails to unequip
			if (!equipped.map(this::unequip).orElse(true)) {
				return false;
			}

			// equip the new thing
			equipment.put(equipable.getSlot(), actorStack);
			actorStack.getActors()
				.stream()
				.map(Actor::getEquipable)
				.map(Optional::get)
				.forEach(e -> e.onEquip(owner));

			// removes the new thing from its current container's inventory
			sample.getPickable()
				.flatMap(Pickable::getContainer)
				.flatMap(Actor::getContainer)
				.ifPresent(container -> container.removeAllByName(actorStack.getName()));

			owner.logIfPlayer(Colours.AQUAMARINE, "You equip the %s.", actorStack.getName());
			return true;
		}
	}

	public boolean unequip(ActorStack equipped) {
		Equipable equipable = equipped.getActors().get(0).getEquipable().get();
		if (equipable.isCursed()) {
			owner.logIfPlayer(Colours.AQUA, "You cannot unequip the %s.", equipped.getName());
			return false;
		}
		
		equipment.put(equipable.getSlot(), null);
		equipped.getActors().stream().map(Actor::getEquipable).map(Optional::get).forEach(e -> e.onUnequip(owner));
		if (owner.getContainer().isPresent()) {
			owner.getContainer().get().addItems(equipped);
		} else {
			owner.getTile().addActorStack(equipped);
		}
		return true;
	}

	public ObservableMap<String, ActorStack> getEquipment() {
		return equipment;
	}

	public boolean hasSlot(String slot) {
		return equipment.containsKey(slot);
	}
}
