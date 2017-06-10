package modelX.combatX;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public enum DamageType {
	PIERCING("Piercing"),
	SLASHING("Slashing"),
	BLUNT("Blunt"),
	POISON("Poison"),
	FIRE("Fire"),
	FROST("Frost"),
	LIGHTNING("Lightning");

	private String label;

	private DamageType(String label) {
		this.label = label;
	}

	public String getLabel() {
		return label;
	}

	public static ObservableList<DamageType> getMagicalTypes() {
		return FXCollections.observableArrayList(POISON, FIRE, FROST, LIGHTNING);
	}

	public static ObservableList<DamageType> getPhysicalTypes() {
		return FXCollections.observableArrayList(PIERCING, SLASHING, BLUNT);
	}

}
