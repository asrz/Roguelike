package modelX.aiX

import modelX.ActorX
import util.Context

class HastedAiX extends AiX {
	int actionsPerTurn

	new(ActorX owner, int actionsPerTurn) {
		super(owner)
		this.actionsPerTurn = actionsPerTurn
	}

	new(ActorX owner, int turnsLeft, AiX oldAi, int actionsPerTurn) {
		super(owner, turnsLeft, oldAi)
		this.actionsPerTurn = actionsPerTurn
	}

	override void update(Context context) {
		super.update(context)
		(0 ..< actionsPerTurn).forEach[oldAi.update(context)]
	}
}
