package model.items.equipment;


import model.Actor;
import model.Dice;
import model.Dice;
import model.combat.DamageType;


public class Weapon extends Equipable {

	private int attack;
	private Dice damage;
	private DamageType damageType;

	public Weapon(Actor owner, int attack, Dice damage, DamageType damageType) {
		super(owner, "Weapon");
		this.attack = attack;
		this.damage = damage;
		this.damageType = damageType;
	}

	public Dice getDamage() {
		return damage;
	}

	public DamageType getDamageType() {
		return damageType;
	}

	public void setDamageType(DamageType damageType) {
		this.damageType = damageType;
	}

	public int getAttack() {
		return attack;
	}

}
