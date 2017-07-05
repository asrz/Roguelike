package model.combat

import javafx.beans.property.SimpleIntegerProperty
import view.ScreensController
import xtendfx.beans.FXBindable
import model.Actor
import model.Colours
import model.Component

@FXBindable(constructors = false)
class Destructible extends Component {
	int maxHp
	int hp
	int ac
	int xp
	
	new (Actor owner, int hp, int ac) {
		this(owner, hp, ac, 0)
	}
	
	new (Actor owner, int hp, int ac, int xp) {
		super(owner)
		
		this.hpProperty = new SimpleIntegerProperty(hp)
		this.maxHpProperty = new SimpleIntegerProperty(hp)
		this.acProperty = new SimpleIntegerProperty(ac)
		this.xpProperty = new SimpleIntegerProperty(xp)
	}
	
	def takeDamage(int damage, DamageType damageType, Actor source) {
		if (damage >= hp) {
			hp = 0
			ScreensController.addMessage(Colours.GREEN, '''«source.name» hits «owner.name» for «damage» «damageType.label» damage.''')
			die(source)
		} else {
			ScreensController.addMessage(Colours.GREEN, '''«source.name» hits «owner.name» for «damage» «damageType.label» damage.''')
			hp = hp - damage
		}
	}
	
	def private die(Actor killer) {
		//creates a corpse
		val corpse = new Actor("dead " + owner.name, '%', Colours.DARKRED, false)
		owner.tile.addActor(corpse)
		
		//removes owner from the map
		owner.preDestroy()
		
		ScreensController.addMessage(Colours.RED, '''«owner.name» is killed by «killer.name».''')
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