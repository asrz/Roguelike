package model.combat;

import view.ScreensController
import model.items.equipment.Weapon
import model.Actor
import model.Colours
import model.Component
import model.Dice

class Attacker extends Component {
	Dice defaultDamage
	DamageType defaultDamageType
	int bonus

	new(Actor owner, int bonus, Dice defaultDamage, DamageType defaultDamageType) {
		super(owner)

		this.bonus = bonus;
		this.defaultDamage = defaultDamage;
		this.defaultDamageType = defaultDamageType;
	}

	new(Actor owner, int bonus) {
		this(owner, bonus, new Dice(1, 4, 0), DamageType.BLUNT)
	}

	def attack(Actor target) {
		if (target.destructible === null) {
			owner.logIfPlayer(Colours.LIGHTGREY, '''«target.name» cannot be attacked.''')
			return
		}

		val attackRoll = Dice.roll(1, 20, getTotalAttack());
		if (attackRoll < target.destructible.ac) {
			ScreensController.addMessage(Colours.LIGHTGOLDENRODYELLOW, '''«owner.name» attacks «target.name» but misses.''')
		} else {
			val damageRoll = damage.roll();
			target.destructible.takeDamage(damageRoll, getDamageType(), owner)
		}
	}

	def getTotalAttack() {
		return bonus + weapon?.attack;
	}

	def Weapon getWeapon() {
		return owner.equipment?.getEquipped("Weapon")?.peek?.equipable as Weapon;
	}

	def getDamage() {
		return getWeapon()?.damage ?: defaultDamage
	}

	def DamageType getDamageType() {
		return getWeapon()?.damageType ?: defaultDamageType
	}

}
