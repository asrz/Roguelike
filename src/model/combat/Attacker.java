package model.combat;

import java.util.Optional;

import model.Actor;
import model.Colour;
import model.Dice;
import model.helper.ActorStack;
import model.items.equipment.Weapon;
import view.ScreensController;

public class Attacker {
	private Dice defaultDamage;
	private DamageType defaultDamageType;

	private int bonus;

	protected Actor owner;

	public Attacker(Actor owner, int bonus, Dice defaultDamage, DamageType defaultDamageType) {
		this.owner = owner;
		owner.setAttacker(this);

		this.bonus = bonus;
		this.defaultDamage = defaultDamage;
		this.defaultDamageType = defaultDamageType;
	}

	public Attacker(Actor owner, int bonus) {
		this(owner, bonus, new Dice(1, 4, 0), DamageType.BLUNT);
	}

	public int getBonus() {
		return bonus;
	}

	public void setBonus(int bonus) {
		this.bonus = bonus;
	}

	public void attack(Actor target) {
		if (!target.getDestructible().isPresent()) {
			owner.logIfPlayer(Colour.LIGHTGREY, "%s cannot be attacked.", target.getName());
			return;
		}

		Destructible destructible = target.getDestructible().get();

		int attackRoll = Dice.roll(1, 20, getTotalAttack());
		if (attackRoll < destructible.getAc()) {
			ScreensController.addMessage(Colour.LIGHTGOLDENRODYELLOW, "%s attacks %s but misses.", owner.getName(), target.getName());
		} else {
			int damageRoll = getDamage().roll();
			destructible.takeDamage(damageRoll, getDamageType(), owner);
		}
	}

	private int getTotalAttack() {
		return bonus + getWeapon().map(Weapon::getAttack).orElse(0);
	}

	private Optional<Weapon> getWeapon() {
		return owner.getEquipment().flatMap(eq -> eq.getEquipped("Weapon")).map(ActorStack::peek).flatMap(Actor::getEquipable).map(eq -> (Weapon) eq);
	}

	private Dice getDamage() {
		return getWeapon().map(Weapon::getDamage).orElse(defaultDamage);
	}

	private DamageType getDamageType() {
		return getWeapon().map(Weapon::getDamageType).orElse(defaultDamageType);
	}

}
