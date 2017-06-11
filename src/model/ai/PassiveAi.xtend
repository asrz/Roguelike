package model.ai

import model.Actor

class PassiveAi extends Ai {
	new(Actor owner, int turnsLeft, Ai oldAi) {
		super(owner, turnsLeft, oldAi)
	}

	new(Actor owner) {
		super(owner)
	}
}
