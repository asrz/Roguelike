package modelX.aiX

import modelX.ActorX

class PassiveAiX extends AiX {
	new(ActorX owner, int turnsLeft, AiX oldAi) {
		super(owner, turnsLeft, oldAi)
	}

	new(ActorX owner) {
		super(owner)
	}
}
