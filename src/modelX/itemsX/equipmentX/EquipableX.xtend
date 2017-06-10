package modelX.itemsX.equipmentX

import javafx.beans.property.SimpleStringProperty
import modelX.ActorX
import modelX.ComponentX
import org.eclipse.xtend.lib.annotations.Accessors
import xtendfx.beans.FXProperty

class EquipableX extends ComponentX {
	@FXProperty String slot
	@Accessors boolean cursed
	
	ActorX equipper
	
	new(ActorX owner, String slot) {
		this(owner, slot, false)
	}
	
	new (ActorX owner, String slot, boolean cursed) {
		super(owner)
		
		slotProperty = new SimpleStringProperty(slot)
		this.cursed = cursed
	}
	
	def onEquip(ActorX equipper) {
		this.equipper = equipper
		
		if (cursed) {
			if (!owner.name.startsWith("Cursed")) {
				owner.name = "Cursed" + owner.name
			}
		}
	}
	
	def onUnequip() {
		this.equipper = null
	}
	
	def isEquipped() {
		return equipper !== null
	}
}