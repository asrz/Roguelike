package model.ai

import util.Context
import model.Actor

class SlowedAiX extends Ai {
	int turnsPerAction
	int turn

	new(Actor owner, int turnsPerAction) {
		super(owner)
		this.turnsPerAction = turnsPerAction
	}

	new(Actor owner, int turnsLeft, Ai oldAi, int turnsPerAction) {
		super(owner, turnsLeft, oldAi)
		this.turnsPerAction = turnsPerAction
	}

	override void update(Context context) {
		super.update(context)
		turn++
		if (turnsPerAction === turn) {
			turn = 0
			getOldAi().update(context)
		}
	}
}
