package model.ai;

import model.Actor;

public class PassiveAi extends Ai {

	public PassiveAi(Actor owner, int turnsLeft, Ai oldAi) {
		super(owner, turnsLeft, oldAi);
	}

	public PassiveAi(Actor owner) {
		super(owner);
	}

}
