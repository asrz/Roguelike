package model.ai;

import map.Map;
import model.Actor;
import model.Dice;
import model.Direction;
import util.Context;

public class RandomAi extends Ai {

	public RandomAi(Actor owner) {
		super(owner);
	}

	@Override
	public void update(Context context) {
		Map map = context.getMap();
		Direction direction = Dice.choice(Direction.values());
		map.moveActor(owner, direction);
		super.update(context);
	}

}
