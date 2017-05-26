package map;

import java.util.Optional;

import model.Actor;
import model.Direction;
import view.GameController;

public class Map {

	Tile[] tiles;

	private int height;
	private int width;

	public Map(int width, int height) {
		this.width = width;
		this.height = height;

		tiles = new Tile[width * height];

		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				tiles[x * height + y] = new Tile(x, y, false);
			}
		}
	}

	public Tile getTile(int x, int y) {
		return tiles[x * height + y];
	}

	public boolean isInBounds(int x, int y) {
		return !(x < 0 || y < 0 || x >= width || y >= height);
	}

	public int getHeight() {
		return height;
	}

	public int getWidth() {
		return width;
	}

	public void moveActor(Actor actor, Direction direction) {
		Tile src = actor.getTile();
		int x = src.getX() + direction.getX();
		int y = src.getY() + direction.getY();

		if (canWalk(x, y)) {
			Tile dest = GameController.getContext().getMap().getTile(x, y);
			actor.setTile(dest);
		} else if (actor.getAttacker().isPresent()) {
			Optional<Actor> target = getTile(x, y).getTarget();
			target.filter(t -> t != actor).ifPresent(t -> actor.getAttacker().get().attack(t));
		}
	}

	private boolean canWalk(int x, int y) {
		if (isInBounds(x, y)) {
			Tile tile = getTile(x, y);
			return !tile.doesBlock();
		} else {
			return false;
		}
	}

	// returns true if a turn has passed
	public boolean interact(Actor actor, Direction direction) {
		Tile src = actor.getTile();
		int x = src.getX() + direction.getX();
		int y = src.getY() + direction.getY();

		if (isInBounds(x, y)) {
			Tile dest = GameController.getContext().getMap().getTile(x, y);
			Actor target = dest.getActors().stream().filter(a -> a.getInteractable().isPresent()).findFirst().orElse(null);
			if (target == null) {
				return false;
			}

			target.getInteractable().get().interact(actor);
			return true;
		}
		return false;
	}

}
