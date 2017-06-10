package modelX.itemsX.usableX

import modelX.ActorX
import modelX.ColoursX
import modelX.ComponentX

class UsableX extends ComponentX {
	int uses // number of uses before destroying 0 = infinite
	int cooldown // number of turns between uses. 0 = infinite
	int currentCooldown
	
	new (ActorX owner, int uses, int cooldown) {
		super(owner)
		this.uses = uses
		this.cooldown = cooldown
		this.currentCooldown = 0
	}
	
	new (ActorX owner) {
		this(owner, 0, 0)
	}
	
	def use(ActorX user) {
		owner.log(ColoursX.BLUE, '''«user.name» attempts to uses the «owner.name».''')
		
		if (currentCooldown > 0) {
			user.logIfPlayer(ColoursX.BLANCHEDALMOND, '''You cannot use «owner.name» yet.''')
			return false
		}
		
		if (uses > 0) {
			uses--
			if (uses === 0) {
				user.logIfPlayer(ColoursX.LIGHTSKYBLUE, '''«owner.name» has been used up.''')
				owner.destroy()
			}
		}
		currentCooldown = cooldown
		return true
	}
}
