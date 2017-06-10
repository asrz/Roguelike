package modelX.itemsX.equipmentX

import modelX.ActorX
import modelX.DiceX
import modelX.combatX.DamageType
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class WeaponX extends EquipableX {
	int attack
	DiceX damage
	DamageType damageType
	
	new (ActorX owner, int attack, DiceX damage, DamageType damageType) {
		super(owner, "Weapon")
		this.attack = attack
		this.damage = damage
		this.damageType = damageType
	}
}