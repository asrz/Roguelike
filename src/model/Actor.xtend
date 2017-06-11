package model

import map.Tile
import org.eclipse.xtend.lib.annotations.Accessors
import view.GameController
import view.ScreensController
import util.Context
import model.ai.Ai
import model.combat.Attacker
import model.combat.Destructible
import model.items.equipment.Equipable
import model.items.equipment.Equipment
import model.items.usable.Usable
import model.items.Container
import model.items.Pickable

@Accessors
class Actor {
	String name;
	Character character;
	Colour colour;
	boolean blocks;
	
	Ai ai
	Attacker attacker
	Container container
	Destructible destructible
	Equipable equipable
	Equipment equipment
	Interactable interactable
	Pickable pickable
	Usable usable
	
	Tile tile
	
	boolean destroyed
	
	new (String name, Character character, Colour colour, boolean blocks) {
		this.name = name
		this.character = character
		this.colour = colour
		this.blocks = blocks
		GameController::context.addActor(this);
	}
	
	def getDisplayPriority() {
		if (isPlayer) {
			return 0;
		} else if (ai !== null) {
			return 1;
		} else if (attacker !== null) {
			return 2;
		} else if (pickable !== null) {
			return 3;
		} else if (destructible !== null) {
			return 4;
		} else {
			return 5;
		}
	}
	
	def destroy() {
		destroyed = true;
		tile?.removeActor(this);
		pickable?.container?.container?.removeItem(this)
		GameController::context.removeActor(this)
		if (isPlayer) {
			GameController.getStage().close();
		}
	}

	def isPlayer() {
		return this.equals(GameController.getContext().getPlayer());
	}
	
	def override toString() {
		return name;
	}
	
	def getDistance(Actor target) {
		return getTile().getDistance(target.getTile());
	}

	def logIfPlayer(Colour colour, String message) {
		if (isPlayer()) {
			log(colour, message)
		}
	}
	
	def log(Colour colour, String message) {
		ScreensController.addMessage(colour, message)
	}
	
	def setComponent(Component comp) {
		switch(comp) {
			Ai : ai = comp
			Attacker : attacker = comp
			Container : container = comp
			Destructible : destructible = comp
			Equipable : equipable = comp
			Equipment : equipment = comp
			Interactable : interactable = comp
			Pickable : pickable = comp
			Usable : usable = comp
			default : throw new IllegalArgumentException("Unknown Component Type: " + comp.class)
		}
	}
	
	def update(Context context) {
		if (!destroyed) {
			ai?.update(context);
		}
	}
	
}
