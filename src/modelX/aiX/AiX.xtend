package modelX.aiX

import modelX.ActorX
import modelX.ComponentX
import util.Context

abstract class AiX extends ComponentX {
	AiX oldAi
	int turnsLeft // -1 == forever
	
	new(ActorX owner) {
		this(owner, -1, null)
	}

	new(ActorX owner, int turnsLeft, AiX oldAi) {
		super(owner)
		this.oldAi = oldAi
		this.turnsLeft = turnsLeft
	}

	def void update(Context context) {
		updateOldAi()
	}

	def private void updateOldAi() {
		if (oldAi !== null) {
			turnsLeft--
			if (turnsLeft === 0) {
				owner.setAi(oldAi)
				oldAi.updateOldAi()
			}
		}
	}

	def protected AiX getOldAi() {
		return oldAi
	}
}
