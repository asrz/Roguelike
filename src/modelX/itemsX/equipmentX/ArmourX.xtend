package modelX.itemsX.equipmentX

import modelX.ActorX

class ArmourX extends EquipableX {
	int acBonus
//	ObservableSet<DamageType> resistances
//	ObservableSet<DamageType> vulnerabilities
//	ObservableSet<DamageType> immunities

	new(ActorX owner, int acBonus) {
		super(owner, "Armour")
		this.acBonus = acBonus
//		resistances = FXCollections::observableSet()
//		resistances.addListener([Change<? extends DamageType> c |
//			equipper.flatMap(ActorgetDestructible).ifPresent([d |
//				CollectionsUtil.applyChange(c, daddResistance, dremoveResistance)
//			])
//		])
//		vulnerabilities = FXCollections::observableSet()
//		vulnerabilities.addListener([Change<? extends DamageType> c |
//			equipper.flatMap(ActorgetDestructible).ifPresent([d |
//				CollectionsUtil.applyChange(c, daddVulnerability, dremoveVulnerability)
//			])
//		])
//		immunities = FXCollections::observableSet()
//		immunities.addListener([Change<? extends DamageType> c |
//			equipper.flatMap(ActorgetDestructible).ifPresent([d |
//				CollectionsUtil.applyChange(c, daddImmunity, dremoveImmunity)
//			])
//		])
	}

	def int getAcBonus() {
		return acBonus
	}

	def void setAcBonus(int acBonus) {
		this.acBonus = acBonus
	}

//	override void onEquip(ActorX equipper) {
//		super.onEquip(equipper)
//		if (equipper.getDestructible().isPresent()) {
//			var Destructible destructible = equipper.getDestructible().get()
//			resistances.forEach(destructibleaddResistance)
//			vulnerabilities.forEach(destructibleaddVulnerability)
//			immunities.forEach(destructibleaddVulnerability)
//		}
//	}
//
//	override void onUnequip(Actor equipper) {
//		super.onUnequip(equipper)
//		if (equipper.getDestructible().isPresent()) {
//			var Destructible destructible = equipper.getDestructible().get()
//			resistances.forEach(destructibleremoveResistance)
//			vulnerabilities.forEach(destructibleremoveVulnerability)
//			immunities.forEach(destructibleremoveImmunity)
//		}
//	}
}
