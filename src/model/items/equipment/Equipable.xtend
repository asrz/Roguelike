package model.items.equipment

import javafx.beans.property.SimpleStringProperty
import org.eclipse.xtend.lib.annotations.Accessors
import xtendfx.beans.FXProperty
import model.Actor
import model.Component

class Equipable extends Component {
	@FXProperty String slot
	@Accessors boolean cursed
	
	Actor equipper
	
	new(Actor owner, String slot) {
		this(owner, slot, false)
	}
	
	new (Actor owner, String slot, boolean cursed) {
		super(owner)
		
		slotProperty = new SimpleStringProperty(slot)
		this.cursed = cursed
	}
	
	def onEquip(Actor equipper) {
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