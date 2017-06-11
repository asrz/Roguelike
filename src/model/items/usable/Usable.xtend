package model.items.usable

import model.Actor
import model.Colours
import model.Component

class Usable extends Component {
	int uses // number of uses before destroying 0 = infinite
	int cooldown // number of turns between uses. 0 = infinite
	int currentCooldown
	
	new (Actor owner, int uses, int cooldown) {
		super(owner)
		this.uses = uses
		this.cooldown = cooldown
		this.currentCooldown = 0
	}
	
	new (Actor owner) {
		this(owner, 0, 0)
	}
	
	def use(Actor user) {
		owner.log(Colours.BLUE, '''«user.name» attempts to uses the «owner.name».''')
		
		if (currentCooldown > 0) {
			user.logIfPlayer(Colours.BLANCHEDALMOND, '''You cannot use «owner.name» yet.''')
			return false
		}
		
		if (uses > 0) {
			uses--
			if (uses === 0) {
				user.logIfPlayer(Colours.LIGHTSKYBLUE, '''«owner.name» has been used up.''')
				owner.destroy()
			}
		}
		currentCooldown = cooldown
		return true
	}
}
