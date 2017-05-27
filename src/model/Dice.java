package model;


import java.util.Random;


public class Dice {

	private static Random rng = new Random();

	private int dice;
	private int sides;
	private int bonus;

	public Dice(int dice, int sides, int bonus) {
		this.dice = dice;
		this.sides = sides;
		this.bonus = bonus;
	}

	public int roll() {
		return Dice.roll(this);
	}

	public static int roll(int dice, int sides, int bonus) {
		int result = bonus;

		for (int i = 0; i < dice; i++) {
			result += roll(sides);
		}

		return result;
	}
	
	public int getDice() {
		return dice;
	}
	
	public int getSides() { return sides; }
	
	public int getBonus() {
		return bonus;
	}

	private static int roll(int sides) {
		return rng.nextInt(sides) + 1;
	}

	public static int roll(Dice dice) {
		return roll(dice.getDice(), dice.getSides(), dice.getBonus());
	}

	public static <T> T choice(T[] values) {
		int index = roll(1, values.length, -1);
		return values[index];
	}

}
