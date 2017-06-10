package modelX.aiX

import modelX.ActorX
import util.Context

class SlowedAiX extends AiX {
	int turnsPerAction
	int turn

	new(ActorX owner, int turnsPerAction) {
		super(owner)
		this.turnsPerAction = turnsPerAction
	}

	new(ActorX owner, int turnsLeft, AiX oldAi, int turnsPerAction) {
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
