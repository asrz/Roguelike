package model;


import java.util.Optional;

import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import map.Tile;
import model.ai.Ai;
import model.combat.Attacker;
import model.combat.Destructible;
import model.items.Container;
import model.items.Pickable;
import model.items.equipment.Equipable;
import model.items.equipment.Equipment;
import model.items.usable.Usable;
import view.GameController;
import view.ScreensController;


public class Actor {

	private StringProperty name;
	private ObjectProperty<Character> character;
	private ObjectProperty<Colour> colour;
	private BooleanProperty blocks;

	private Optional<Destructible> destructible = Optional.empty();
	private Optional<Attacker> attacker = Optional.empty();
	private Optional<Container> container = Optional.empty();
	private Optional<Pickable> pickable = Optional.empty();
	private Optional<Ai> ai = Optional.empty();
	private Optional<Equipable> equipable = Optional.empty();
	private Optional<Equipment> equipment = Optional.empty();
	private Optional<Usable> usable = Optional.empty();
	private Optional<Interactable> interactable = Optional.empty();

	private Tile tile;

	private boolean destroyed = false;

	public Actor(String name, char character, Colour colour, boolean blocks) { // only use this if this actor will have a pickable in a container
		this(name, character, colour, blocks, null);
	}

	public Actor(String name, char character, Colour colour, boolean blocks, Tile tile) {
		this.name = new SimpleStringProperty(name);
		this.character = new SimpleObjectProperty<>(character);
		this.colour = new SimpleObjectProperty<>(colour);
		this.blocks = new SimpleBooleanProperty(blocks);

		this.equipment = Optional.empty();

		this.tile = tile;
		if (tile != null) {
			tile.addActor(this);
		}
		GameController.getContext().addActor(this);
	}

	public String getName() {
		return name.get();
	}

	public void setName(String name) {
		this.name.set(name);
	}

	public StringProperty nameProperty() {
		return name;
	}

	public char getCharacter() {
		return character.get();
	}

	public void setCharacter(char character) {
		this.character.set(character);
	}

	public ObjectProperty<Character> characterProperty() {
		return character;
	}

	public Colour getColour() {
		return colour.get();
	}

	public void setColour(Colour colour) {
		this.colour.set(colour);
	}

	public ObjectProperty<Colour> colourProperty() {
		return colour;
	}

	public boolean isBlocks() {
		return blocks.get();
	}

	public void setBlocks(boolean blocks) {
		this.blocks.set(blocks);
	}

	public BooleanProperty blocksProperty() {
		return blocks;
	}

	public Optional<Destructible> getDestructible() {
		return destructible;
	}

	public void setDestructible(Destructible destructible) {
		this.destructible = Optional.ofNullable(destructible);
	}

	public Optional<Attacker> getAttacker() {
		return attacker;
	}

	public void setAttacker(Attacker attacker) {
		this.attacker = Optional.ofNullable(attacker);
	}

	public Optional<Container> getContainer() {
		return container;
	}

	public void setContainer(Container container) {
		this.container = Optional.ofNullable(container);
	}

	public Optional<Pickable> getPickable() {
		return pickable;
	}

	public void setPickable(Pickable pickable) {
		this.pickable = Optional.ofNullable(pickable);
	}

	public Optional<Ai> getAi() {
		return ai;
	}

	public void setAi(Ai ai) {
		this.ai = Optional.ofNullable(ai);
	}

	public Optional<Equipable> getEquipable() {
		return equipable;
	}

	public void setEquipable(Equipable equipable) {
		this.equipable = Optional.ofNullable(equipable);
	}

	public Optional<Equipment> getEquipment() {
		return equipment;
	}

	public void setEquipment(Equipment equipment) {
		this.equipment = Optional.ofNullable(equipment);
	}

	public Optional<Usable> getUsable() {
		return usable;
	}

	public void setInteractable(Interactable interactable) {
		this.interactable = Optional.ofNullable(interactable);
	}

	public Optional<Interactable> getInteractable() {
		return interactable;
	}

	public void setUsable(Usable usable) {
		this.usable = Optional.ofNullable(usable);
	}

	public int getDisplayPriority() {
		if (equals(GameController.getContext().getPlayer())) {
			return 0;
		} else if (ai.isPresent()) {
			return 1;
		} else if (attacker.isPresent()) {
			return 2;
		} else if (pickable.isPresent()) {
			return 3;
		} else if (destructible.isPresent()) {
			return 4;
		} else {
			return 5;
		}
	}

	public Tile getTile() {
		return tile;
	}

	public void setTile(Tile tile) {
		if (getTile() != null) {
			getTile().removeActor(this);
		}

		this.tile = tile;

		if (tile != null) {
			tile.addActor(this);
		}
	}

	public void takeTurn() {
		if (!destroyed) {
			ai.ifPresent(a -> a.update(GameController.getContext()));
		}
	}

	public void destroy() {
		destroyed = true;
		if (tile != null) {
			tile.removeActor(this);
		}
		pickable.flatMap(Pickable::getContainer)
				.flatMap(Actor::getContainer)
				.ifPresent(container -> container.removeItem(this));
		GameController.getContext().removeActor(this);
		if (isPlayer()) {
			GameController.getStage().close();
		}
	}

	public boolean isPlayer() {
		return equals(GameController.getContext().getPlayer());
	}

	@Override
	public String toString() {
		return name.get();
	}

	public long getDistance(Actor target) {
		return getTile().getDistance(target.getTile());
	}

	public void logIfPlayer(Colour colour, String message, Object... args) {
		if (isPlayer()) {
			ScreensController.addMessage(colour, message, args);
		}
	}

}
