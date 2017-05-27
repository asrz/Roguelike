package model.items.usable;


import model.Actor;
import model.Colour;
import model.Dice;
import model.Dice;
import model.combat.Destructible;


public class HealingUsable extends Usable {

	private Dice healing;

	public HealingUsable(Actor owner, int uses, int cooldown, Dice healing) {
		super(owner, uses, cooldown);
		this.healing = healing;
	}

	@Override
	public boolean use(Actor user) {
		if (super.use(user)) {
			if (!user.getDestructible().isPresent()) {
				return false;
			}

			if (user.getDestructible().filter(Destructible::isFullHp).isPresent()) {
				user.logIfPlayer(Colour.LIGHTPINK, "You are already full health.");
				return false;
			}

			int amount = healing.roll();
			int healingDone = user.getDestructible().map(d -> d.heal(amount)).get();
			user.logIfPlayer(Colour.PINK, "You heal for %d hp.", healingDone);
			return true;
		}
		return false;
	}

}
