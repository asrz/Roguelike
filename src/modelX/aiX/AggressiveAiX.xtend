package modelX.aiX

import modelX.ActorX
import modelX.Direction
import util.Context

class AggressiveAiX extends AiX {
	ActorX target
	int range // distance at which owner will pursue target
	boolean forgetful

	new(ActorX owner, ActorX target, int range, boolean forgetful) {
		super(owner)
		this.target = target
		this.range = range
		this.forgetful = forgetful
	}

	override void update(Context context) {
		super.update(context)
		if (target !== null) {
			if (owner.getDistance(target) < range) {
				// move towards target
				var int dx = target.tile.x - owner.tile.x
				var int dy = target.tile.y - owner.tile.y
				var Direction direction = Direction::getDirection(dx, dy)
				context.map.moveActor(owner, direction)
			} else if (forgetful) {
				this.target = null
			}
		}
	}

	def void setTarget(ActorX target) {
		this.target = target
	}
}
