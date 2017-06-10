package modelX.combatX;

import modelX.ActorX
import modelX.ColoursX
import modelX.ComponentX
import modelX.DiceX
import modelX.itemsX.equipmentX.WeaponX
import view.ScreensController

class AttackerX extends ComponentX {
	DiceX defaultDamage
	DamageType defaultDamageType
	int bonus

	new(ActorX owner, int bonus, DiceX defaultDamage, DamageType defaultDamageType) {
		super(owner)

		this.bonus = bonus;
		this.defaultDamage = defaultDamage;
		this.defaultDamageType = defaultDamageType;
	}

	new(ActorX owner, int bonus) {
		this(owner, bonus, new DiceX(1, 4, 0), DamageType.BLUNT)
	}

	def attack(ActorX target) {
		if (target.destructible === null) {
			owner.logIfPlayer(ColoursX.LIGHTGREY, '''«target.name» cannot be attacked.''')
			return
		}

		val attackRoll = DiceX.roll(1, 20, getTotalAttack());
		if (attackRoll < target.destructible.ac) {
			ScreensController.addMessage(ColoursX.LIGHTGOLDENRODYELLOW, '''«owner.name» attacks «target.name» but misses.''')
		} else {
			val damageRoll = damage.roll();
			target.destructible.takeDamage(damageRoll, getDamageType(), owner)
		}
	}

	def getTotalAttack() {
		return bonus + weapon?.attack;
	}

	def WeaponX getWeapon() {
		return owner.equipment?.getEquipped("Weapon")?.peek?.equipable as WeaponX;
	}

	def getDamage() {
		return getWeapon()?.damage ?: defaultDamage
	}

	def DamageType getDamageType() {
		return getWeapon()?.damageType ?: defaultDamageType
	}

}
