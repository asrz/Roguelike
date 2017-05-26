package model.items.equipment;

import javafx.collections.FXCollections;
import javafx.collections.ObservableSet;
import javafx.collections.SetChangeListener.Change;
import model.Actor;
import model.combat.DamageType;
import model.combat.Destructible;
import util.CollectionsUtil;

public class Armour extends Equipable {

	private int acBonus;
	private ObservableSet<DamageType> resistances;
	private ObservableSet<DamageType> vulnerabilities;
	private ObservableSet<DamageType> immunities;

	public Armour(Actor owner, int acBonus) {
		super(owner, "Armour");

		this.acBonus = acBonus;
		resistances = FXCollections.observableSet();
		resistances.addListener((Change<? extends DamageType> c) -> equipper.flatMap(Actor::getDestructible)
				.ifPresent(d -> CollectionsUtil.applyChange(c, d::addResistance, d::removeResistance)));
		vulnerabilities = FXCollections.observableSet();
		vulnerabilities.addListener((Change<? extends DamageType> c) -> equipper.flatMap(Actor::getDestructible)
				.ifPresent(d -> CollectionsUtil.applyChange(c, d::addVulnerability, d::removeVulnerability)));
		immunities = FXCollections.observableSet();
		immunities.addListener((Change<? extends DamageType> c) -> equipper.flatMap(Actor::getDestructible)
				.ifPresent(d -> CollectionsUtil.applyChange(c, d::addImmunity, d::removeImmunity)));
	}

	public int getAcBonus() {
		return acBonus;
	}

	public void setAcBonus(int acBonus) {
		this.acBonus = acBonus;
	}

	public ObservableSet<DamageType> getResistances() {
		return resistances;
	}

	public ObservableSet<DamageType> getVulnerabilities() {
		return vulnerabilities;
	}

	public ObservableSet<DamageType> getImmunities() {
		return immunities;
	}

	@Override
	public void onEquip(Actor equipper) {
		super.onEquip(equipper);
		if (equipper.getDestructible().isPresent()) {
			Destructible destructible = equipper.getDestructible().get();
			resistances.forEach(destructible::addResistance);
			vulnerabilities.forEach(destructible::addVulnerability);
			immunities.forEach(destructible::addVulnerability);
		}
	}

	@Override
	public void onUnequip(Actor equipper) {
		super.onUnequip(equipper);
		if (equipper.getDestructible().isPresent()) {
			Destructible destructible = equipper.getDestructible().get();
			resistances.forEach(destructible::removeResistance);
			vulnerabilities.forEach(destructible::removeVulnerability);
			immunities.forEach(destructible::removeImmunity);
		}
	}
}
