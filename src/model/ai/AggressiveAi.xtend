package model.ai

import model.Actor
import model.Direction
import model.helper.Context

class AggressiveAi extends Ai {
	Actor target
	int range // distance at which owner will pursue target
	boolean forgetful

	new(Actor owner, Actor target, int range, boolean forgetful) {
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

	def void setTarget(Actor target) {
		this.target = target
	}
}
