package model.combat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableSet;
import model.Actor;
import model.Colours;
import view.ScreensController;

public class Destructible {
	private IntegerProperty maxHp;
	private IntegerProperty hp;
	private IntegerProperty ac;
	private IntegerProperty xp;

	private List<DamageType> _resistances = new ArrayList<>();
	private List<DamageType> _vulnerabilities = new ArrayList<>();
	private List<DamageType> _immunities = new ArrayList<>();

	private ObservableSet<DamageType> resistances = FXCollections.observableSet();
	private ObservableSet<DamageType> vulnerabilities = FXCollections.observableSet();
	private ObservableSet<DamageType> immunities = FXCollections.observableSet();

	protected Actor owner;

	public Destructible(Actor owner, int maxHp, int ac, int xp) {
		this.owner = owner;
		owner.setDestructible(this);

		this.maxHp = new SimpleIntegerProperty(maxHp);
		this.hp = new SimpleIntegerProperty(maxHp);
		this.ac = new SimpleIntegerProperty(ac);
		this.xp = new SimpleIntegerProperty(xp);
	}

	public int getMaxHp() {
		return maxHp.get();
	}

	public void setMaxHp(int maxHp) {
		this.maxHp.set(maxHp);
	}

	public IntegerProperty maxHpProperty() {
		return maxHp;
	}

	public int getHp() {
		return hp.get();
	}

	public void setHp(int hp) {
		this.hp.set(hp);
	}

	public IntegerProperty hpProperty() {
		return hp;
	}

	public int getAc() {
		return ac.get();
	}

	public void setAc(int ac) {
		this.ac.set(ac);
	}

	public IntegerProperty acProperty() {
		return ac;
	}

	public int getXp() {
		return xp.get();
	}

	public void setXp(int xp) {
		this.xp.set(xp);
	}

	public IntegerProperty xpProperty() {
		return xp;
	}

	public ObservableSet<DamageType> getResistances() {
		return resistances;
	}

	public void addResistance(DamageType damageType) {
		_resistances.add(damageType);
		if (!immunities.contains(damageType)) {
			if (vulnerabilities.contains(damageType)) {
				vulnerabilities.remove(damageType);
			} else {
				resistances.add(damageType);
			}
		}
	}

	public void removeResistance(DamageType damageType) {
		_resistances.remove(damageType);
		if (!immunities.contains(damageType)) {
			if (resistances.contains(damageType)) {
				resistances.remove(damageType);
			} else if (_vulnerabilities.contains(damageType)) {
				vulnerabilities.add(damageType);
			}
		}
	}

	public ObservableSet<DamageType> getVulnerabilities() {
		return vulnerabilities;
	}

	public void addVulnerability(DamageType damageType) {
		_vulnerabilities.add(damageType);
		if (!immunities.contains(damageType)) {
			if (resistances.contains(damageType)) {
				resistances.remove(damageType);
			} else {
				vulnerabilities.add(damageType);
			}
		}
	}

	public void removeVulnerability(DamageType damageType) {
		_vulnerabilities.remove(damageType);
		if (!immunities.contains(damageType)) {
			if (vulnerabilities.contains(damageType)) {
				vulnerabilities.remove(damageType);
			} else if (_resistances.contains(damageType)) {
				resistances.add(damageType);
			}
		}
	}

	public ObservableSet<DamageType> getImmunities() {
		return immunities;
	}

	public void addImmunity(DamageType damageType) {
		_immunities.add(damageType);
		immunities.add(damageType);
		resistances.remove(damageType);
		vulnerabilities.remove(damageType);
	}

	public void removeImmunity(DamageType damageType) {
		_immunities.remove(damageType);
		immunities.remove(damageType);
		int resistancesCount = Collections.frequency(_resistances, damageType);
		int vulnerabilitiesCount = Collections.frequency(_vulnerabilities, damageType);

		if (resistancesCount > vulnerabilitiesCount) {
			resistances.add(damageType);
		} else if (resistancesCount < vulnerabilitiesCount) {
			vulnerabilities.add(damageType);
		}
	}

	public int takeDamage(int damage, DamageType damageType, Actor source) {
		if (immunities.contains(damageType)) {
			damage = 0;
		} else if (resistances.contains(damageType)) {
			damage /= 2;
		} else if (vulnerabilities.contains(damageType)) {
			damage *= 2;
		}

		ScreensController.addMessage(Colours.GREEN, "%s hits %s for %d %s damage.", source.getName(), owner.getName(), damage, damageType.getLabel());

		if (damage >= getHp()) {
			damage = getHp();
			setHp(0);
			die(source);
		} else {
			setHp(getHp() - damage);
		}

		return damage;
	}

	private void die(Actor killer) {
		// creates a corpse
		new Actor("dead " + owner.getName(), '%', Colours.DARKRED, false, owner.getTile());

		// removes owner from the map
		owner.destroy();

		ScreensController.addMessage(Colours.RED, "%s is killed by %s.", owner.getName(), killer.getName());
	}

	public boolean isFullHp() {
		return getHp() > getMaxHp();
	}

	public int heal(int amount) {
		if (getMaxHp() - getHp() < amount) { // can't heal above max
			amount = getMaxHp() - getHp();
		}
		setHp(getHp() + amount);
		return amount;
	}

}
