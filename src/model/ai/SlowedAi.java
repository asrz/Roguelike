package model.ai;

import model.Actor;
import util.Context;

public class SlowedAi extends Ai {

	private int turnsPerAction;

	private int turn;

	public SlowedAi(Actor owner, int turnsPerAction) {
		super(owner);

		this.turnsPerAction = turnsPerAction;
	}

	public SlowedAi(Actor owner, int turnsLeft, Ai oldAi, int turnsPerAction) {
		super(owner, turnsLeft, oldAi);

		this.turnsPerAction = turnsPerAction;
	}

	@Override
	public void update(Context context) {
		super.update(context);
		turn++;
		if (turnsPerAction == turn) {
			turn = 0;
			getOldAi().update(context);
		}
	}

}
