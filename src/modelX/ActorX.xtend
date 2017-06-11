package modelX

import map.Tile
import modelX.aiX.AiX
import modelX.combatX.AttackerX
import modelX.combatX.DestructibleX
import modelX.itemsX.ContainerX
import modelX.itemsX.PickableX
import modelX.itemsX.equipmentX.EquipableX
import modelX.itemsX.equipmentX.EquipmentX
import modelX.itemsX.usableX.UsableX
import org.eclipse.xtend.lib.annotations.Accessors
import view.GameController
import view.ScreensController
import util.Context

@Accessors
class ActorX {
	String name;
	Character character;
	ColourX colour;
	boolean blocks;
	
	AiX ai
	AttackerX attacker
	ContainerX container
	DestructibleX destructible
	EquipableX equipable
	EquipmentX equipment
	InteractableX interactable
	PickableX pickable
	UsableX usable
	
	Tile tile
	
	boolean destroyed
	
	new (String name, Character character, ColourX colour, boolean blocks) {
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
	
	def getDistance(ActorX target) {
		return getTile().getDistance(target.getTile());
	}

	def logIfPlayer(ColourX colour, String message) {
		if (isPlayer()) {
			log(colour, message)
		}
	}
	
	def log(ColourX colour, String message) {
		ScreensController.addMessage(colour, message)
	}
	
	def setComponent(ComponentX comp) {
		switch(comp) {
			AiX : ai = comp
			AttackerX : attacker = comp
			ContainerX : container = comp
			DestructibleX : destructible = comp
			EquipableX : equipable = comp
			EquipmentX : equipment = comp
			InteractableX : interactable = comp
			PickableX : pickable = comp
			UsableX : usable = comp
			default : throw new IllegalArgumentException("Unknown Component Type: " + comp.class)
		}
	}
	
	def update(Context context) {
		if (!destroyed) {
			ai?.update(context);
		}
	}
	
}
