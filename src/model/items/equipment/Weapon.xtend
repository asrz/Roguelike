package model.items.equipment

import model.combat.DamageType
import org.eclipse.xtend.lib.annotations.Accessors
import model.Actor
import model.Dice

@Accessors
class Weapon extends Equipable {
	int attack
	Dice damage
	DamageType damageType
	
	new (Actor owner, int attack, Dice damage, DamageType damageType) {
		super(owner, "Weapon")
		this.attack = attack
		this.damage = damage
		this.damageType = damageType
	}
}