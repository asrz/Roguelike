package model.ai;

import model.Actor;
import util.Context;

public abstract class Ai {

	protected Actor owner;

	private Ai oldAi;
	private int turnsLeft; // -1 == forever

	public Ai(Actor owner) {
		this.owner = owner;
		owner.setAi(this);
	}

	public Ai(Actor owner, int turnsLeft, Ai oldAi) {
		this(owner);

		this.oldAi = oldAi;
		this.turnsLeft = turnsLeft;
	}

	public void update(Context context) {
		updateOldAi();
	}

	private void updateOldAi() {
		if (oldAi != null) {
			turnsLeft--;
			if (turnsLeft == 0) {
				owner.setAi(oldAi);
				oldAi.updateOldAi();
			}
		}
	}

	protected Ai getOldAi() {
		return oldAi;
	}
}
