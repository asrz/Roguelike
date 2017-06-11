package modelX.itemsX.usableX

import modelX.ActorX
import modelX.ColoursX
import modelX.DiceX

class HealingUsableX extends UsableX {
	DiceX healing

	new(ActorX owner, int uses, int cooldown, DiceX healing) {
		super(owner, uses, cooldown)
		this.healing = healing
	}

	override boolean use(ActorX user) {
		if (user.destructible === null) {
			return false;
		}
		
		if (user.destructible.isFullHp()) {
			user.logIfPlayer(ColoursX::LIGHTPINK, "You are already full health.")
			return false
		}
			
		if (super.use(user)) {
			var int amount = healing.roll()
			var int healingDone = user.getDestructible().heal(amount)
			user.logIfPlayer(ColoursX::PINK, '''You heal for «healingDone» hp.''')
			return true
		}
		return false
	}
}
