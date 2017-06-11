package model.items.usable

import model.Actor
import model.Colours
import model.Dice

class HealingUsable extends Usable {
	Dice healing

	new(Actor owner, int uses, int cooldown, Dice healing) {
		super(owner, uses, cooldown)
		this.healing = healing
	}

	override boolean use(Actor user) {
		if (user.destructible === null) {
			return false;
		}
		
		if (user.destructible.isFullHp()) {
			user.logIfPlayer(Colours::LIGHTPINK, "You are already full health.")
			return false
		}
			
		if (super.use(user)) {
			var int amount = healing.roll()
			var int healingDone = user.getDestructible().heal(amount)
			user.logIfPlayer(Colours::PINK, '''You heal for «healingDone» hp.''')
			return true
		}
		return false
	}
}
