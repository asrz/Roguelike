package model.ai

import util.Context
import model.Actor
import model.Component

abstract class Ai extends Component {
	Ai oldAi
	int turnsLeft // -1 == forever
	
	new(Actor owner) {
		this(owner, -1, null)
	}

	new(Actor owner, int turnsLeft, Ai oldAi) {
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

	def protected Ai getOldAi() {
		return oldAi
	}
}
