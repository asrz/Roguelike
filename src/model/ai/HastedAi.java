package model.ai;

import java.util.stream.IntStream;

import model.Actor;
import util.Context;

public class HastedAi extends Ai {

	private int actionsPerTurn;

	public HastedAi(Actor owner, int actionsPerTurn) {
		super(owner);

		this.actionsPerTurn = actionsPerTurn;
	}

	public HastedAi(Actor owner, int turnsLeft, Ai oldAi, int actionsPerTurn) {
		super(owner, turnsLeft, oldAi);

		this.actionsPerTurn = actionsPerTurn;
	}

	@Override
	public void update(Context context) {
		super.update(context);
		IntStream.range(0, actionsPerTurn).forEach(i -> getOldAi().update(context));
	}

}
