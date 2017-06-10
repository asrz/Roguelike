package modelX

import org.eclipse.xtend.lib.annotations.Data
import java.util.Random

@Data
class DiceX {
	static Random rng = new Random();
	
	int dice
	int sides
	int bonus
	
	def roll() {
		var result = 0
		for (i : 1..dice) {
			result += rng.nextInt(sides)+1
		}
		result += bonus
	}
	
	def static <T> choice(T[] choices) {
		val index = rng.nextInt(choices.size());
		choices.get(index);
	}
	
	def static roll(int dice, int sides, int bonus) {
		new DiceX(dice, sides, bonus).roll()
	}
}