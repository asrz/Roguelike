package modelX.combatX

import javafx.beans.property.SimpleIntegerProperty
import modelX.ActorX
import modelX.ColoursX
import modelX.ComponentX
import view.ScreensController
import xtendfx.beans.FXBindable

@FXBindable(constructors = false)
class DestructibleX extends ComponentX {
	int maxHp
	int hp
	int ac
	int xp
	
	new (ActorX owner, int hp, int ac) {
		this(owner, hp, ac, 0)
	}
	
	new (ActorX owner, int hp, int ac, int xp) {
		super(owner)
		
		this.hpProperty = new SimpleIntegerProperty(hp)
		this.maxHpProperty = new SimpleIntegerProperty(hp)
		this.acProperty = new SimpleIntegerProperty(ac)
		this.xpProperty = new SimpleIntegerProperty(xp)
	}
	
	def takeDamage(int damage, DamageType damageType, ActorX source) {
		if (damage >= hp) {
			hp = 0
			ScreensController.addMessage(ColoursX.GREEN, '''«source.name» hits «owner.name» for «damage» «damageType.label» damage.''')
			die(source)
		} else {
			ScreensController.addMessage(ColoursX.GREEN, '''«source.name» hits «owner.name» for «damage» «damageType.label» damage.''')
			hp = hp - damage
		}
	}
	
	def private die(ActorX killer) {
		//creates a corpse
		val corpse = new ActorX("dead " + owner.name, '%', ColoursX.DARKRED, false)
		corpse.tile = owner.tile
		
		//removes owner from the map
		owner.destroy()
		
		ScreensController.addMessage(ColoursX.RED, '''«owner.name» is killed by «killer.name».''')
	}
	
	def isFullHp() {
		return hp >= maxHp
	}
	
	def heal(int amount) {
		val healing = Math.min(amount, maxHp - hp)
		
		hp = hp + healing
		return healing
	}
}