package model.ai

import map.Map
import model.Direction
import util.Context
import model.Actor
import model.Dice

class RandomAi extends Ai {
	new(Actor owner) {
		super(owner)
	}

	override void update(Context context) {
		var Map map = context.getMap()
		var Direction direction = Dice::choice(Direction::values())
		map.moveActor(owner, direction)
		super.update(context)
	}
}
