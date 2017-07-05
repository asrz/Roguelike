package model.ai

import model.Actor
import model.helper.Context

class HastedAi extends Ai {
	int actionsPerTurn

	new(Actor owner, int actionsPerTurn) {
		super(owner)
		this.actionsPerTurn = actionsPerTurn
	}

	new(Actor owner, int turnsLeft, Ai oldAi, int actionsPerTurn) {
		super(owner, turnsLeft, oldAi)
		this.actionsPerTurn = actionsPerTurn
	}

	override void update(Context context) {
		super.update(context)
		(0 ..< actionsPerTurn).forEach[oldAi.update(context)]
	}
}
