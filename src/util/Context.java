package util;


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import map.Map;
import model.Actor;


public class Context {
	private Map map;
	private Actor player;
	private List<Actor> actors;

	public Context(Map map) {
		this.map = map;
		this.actors = new ArrayList<>();
	}

	public Map getMap() {
		return map;
	}

	public void setMap(Map map) {
		this.map = map;
	}

	public Actor getPlayer() {
		return player;
	}

	public void setPlayer(Actor player) {
		this.player = player;
	}

	public Iterator<Actor> getActors() {
		return new ArrayList<>(actors).iterator();
	}

	public void addActor(Actor actor) {
		actors.add(actor);
	}

	public void removeActor(Actor actor) {
		actors.remove(actor);
	}
}
