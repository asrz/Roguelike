package modelX.aiX

import map.Map
import modelX.ActorX
import modelX.DiceX
import modelX.Direction
import util.Context

class RandomAiX extends AiX {
	new(ActorX owner) {
		super(owner)
	}

	override void update(Context context) {
		var Map map = context.getMap()
		var Direction direction = DiceX::choice(Direction::values())
		map.moveActor(owner, direction)
		super.update(context)
	}
}
