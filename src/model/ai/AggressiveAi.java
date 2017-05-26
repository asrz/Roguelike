package model.ai;

import model.Actor;
import model.Direction;
import util.Context;

public class AggressiveAi extends Ai {

	private Actor target;
	private int range; // distance at which owner will pursue target
	private boolean forgetful;

	public AggressiveAi(Actor owner, Actor target, int range, boolean forgetful) {
		super(owner);

		this.target = target;
		this.range = range;
		this.forgetful = forgetful;
	}

	@Override
	public void update(Context context) {
		super.update(context);

		if (target != null) {
			if (owner.getDistance(target) < range) {
				// move towards target

				int dx = target.getTile().getX() - owner.getTile().getX();
				int dy = target.getTile().getY() - owner.getTile().getY();
				Direction direction = Direction.getDirection(dx, dy);
				context.getMap().moveActor(owner, direction);
			} else if (forgetful) {
				this.target = null;
			}
		}
	}

	public void setTarget(Actor target) {
		this.target = target;
	}

}
