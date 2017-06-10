package modelX.itemsX.equipmentX

import java.util.Collection
import javafx.collections.FXCollections
import javafx.collections.ObservableMap
import modelX.ActorX
import modelX.ColoursX
import modelX.ComponentX
import modelX.helperX.ActorStackX
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PUBLIC_GETTER)
class EquipmentX extends ComponentX {
	ObservableMap<String, ActorStackX> equipment
	
	new (ActorX owner, Collection<String> slots) {
		super(owner)
		
		equipment = FXCollections.observableHashMap
		slots.forEach[ slot | equipment.put(slot, null)]
	}
	
	def getEquipped(String slot) {
		return equipment.get(slot)
	}
	
	def hasSlot(String slot) {
		return equipment.containsKey(slot)
	}
	
	def equip(ActorStackX actorStack) {
		val sample = actorStack.peek()
		val equipable = sample.equipable

		if (equipable === null) {
			owner.logIfPlayer(ColoursX.ALICEBLUE, '''The «sample.name» cannot be equipped.''')
			return false
		}
		
		if (!hasSlot(equipable.slot)) {
			owner.logIfPlayer(ColoursX.AQUA, '''You cannot equip the «sample.name».''')
			return false
		}
		
		val equipped = getEquipped(equipable.slot)
		
		if ( equipped !== null && equipped.unequip === false) {
			return false
		}
		
		equipment.put(equipable.slot, actorStack)
		actorStack.actors.map[ equipable].forEach[ onEquip(owner) ]
		
		sample.pickable.container.container.removeAllByName(sample.name)
	
		owner.logIfPlayer(ColoursX.AQUAMARINE, '''You equip the «sample.name».''')	
		return true
	}
	
	def unequip(ActorStackX actorStack) {
		val equipable = actorStack.peek.equipable
		
		if (equipable.cursed) {
			owner.logIfPlayer(ColoursX.AQUA, '''You cannot unequip the «actorStack.name».''')
			return false
		}
		
		equipment.put(equipable.slot, null)
		actorStack.actors.map[ equipable ].forEach[ onUnequip() ]
		if (owner.container !== null) {
			owner.container.addItems(actorStack)
		} else {
			owner.tile.addActorStack(actorStack)
		}
		return true
	}
}