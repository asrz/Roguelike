package model.items.equipment

import java.util.Collection
import javafx.collections.FXCollections
import javafx.collections.ObservableMap
import org.eclipse.xtend.lib.annotations.Accessors
import model.helper.ActorStack
import model.Actor
import model.Colours
import model.Component

@Accessors(PUBLIC_GETTER)
class Equipment extends Component {
	ObservableMap<String, ActorStack> equipment
	
	new (Actor owner, Collection<String> slots) {
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
	
	def equip(ActorStack actorStack) {
		val sample = actorStack.peek()
		val equipable = sample.equipable

		if (equipable === null) {
			owner.logIfPlayer(Colours.ALICEBLUE, '''The «sample.name» cannot be equipped.''')
			return false
		}
		
		if (!hasSlot(equipable.slot)) {
			owner.logIfPlayer(Colours.AQUA, '''You cannot equip the «sample.name».''')
			return false
		}
		
		val equipped = getEquipped(equipable.slot)
		
		if ( equipped !== null && equipped.unequip === false) {
			return false
		}
		
		equipment.put(equipable.slot, actorStack)
		actorStack.actors.map[ equipable].forEach[ onEquip(owner) ]
		
		sample.pickable.container.container.removeAllByName(sample.name)
	
		owner.logIfPlayer(Colours.AQUAMARINE, '''You equip the «sample.name».''')	
		return true
	}
	
	def unequip(ActorStack actorStack) {
		val equipable = actorStack.peek.equipable
		
		if (equipable.cursed) {
			owner.logIfPlayer(Colours.AQUA, '''You cannot unequip the «actorStack.name».''')
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