package map;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener.Change;
import javafx.collections.ObservableList;
import javafx.collections.transformation.SortedList;
import javafx.scene.paint.Color;
import model.Actor;
import model.Colour;
import model.helper.ActorStack;

public class Tile {

	private ObservableList<Actor> _actors;
	private SortedList<Actor> actors;

	private static Colour wallColour = Colour.BLACK;
	private static Colour floorColour = Colour.GREEN;

	private int x;
	private int y;

	private boolean wall;
	private boolean explored;

	private StringProperty symbolProperty;
	private ObjectProperty<Color> foregroundColorProperty;

	public Tile(int x, int y, boolean wall) {
		this.x = x;
		this.y = y;
		this.wall = false;
		this.explored = true;

		this.symbolProperty = new SimpleStringProperty(".");
		this.foregroundColorProperty = new SimpleObjectProperty<>(Colour.WHITE.getColor());

		_actors = FXCollections.observableArrayList();
		actors = new SortedList<>(_actors, Comparator.comparingInt(Actor::getDisplayPriority));

		actors.addListener(this::onActorsChange);
	}

	public int getX() {
		return x;
	}

	public void setX(int x) {
		this.x = x;
	}

	public int getY() {
		return y;
	}

	public void setY(int y) {
		this.y = y;
	}

	public boolean isWall() {
		return wall;
	}

	public void setWall(boolean wall) {
		this.wall = wall;
	}

	public boolean isExplored() {
		return explored;
	}

	public void setExplored(boolean explored) {
		this.explored = explored;
	}

	public Color getBackgroundColor() {
		// Colour colour = wall ? wallColour : floorColour;
		// return colour.getColor();
		return Colour.BLACK.getColor();
	}

	public boolean addActor(Actor actor) {
		return _actors.add(actor);
	}

	public boolean removeActor(Actor actor) {
		return _actors.remove(actor);
	}

	public Character getCharacter() {
		if (actors.isEmpty()) {
			return '.';
		} else {
			return actors.get(0).getCharacter();
		}
	}

	public ObjectProperty<Color> foregroundColorProperty() {
		return foregroundColorProperty;
	}

	public StringProperty symbolProperty() {
		return symbolProperty;
	}

	private void onActorsChange(Change<? extends Actor> c) {
		ObservableList<? extends Actor> list = c.getList();
		if (list.size() > 0) {
			Actor actor = list.get(0);
			symbolProperty.set(actor.getCharacter() + "");
			foregroundColorProperty.set(actor.getColour().getColor());
		} else {
			symbolProperty.set(".");
			foregroundColorProperty.set(Colour.WHITE.getColor());
		}
	}

	public boolean doesBlock() {
		if (wall) {
			return true;
		}

		for (Actor actor : actors) {
			if (actor.isBlocks()) {
				return true;
			}
		}

		return false;
	}

	public Optional<Actor> getTarget() {
		return actors.stream().filter(a -> a.getDestructible().isPresent()).findFirst();
	}

	public List<Actor> getActors() {
		return actors;
	}

	public long getDistance(Tile other) {
		int dx = getX() - other.getX();
		int dy = getY() - other.getY();
		return Math.round(Math.sqrt(dx * dx + dy * dy));
	}

	public Color getForegroundColor() {
		return foregroundColorProperty.get();
	}

	public void addActorStack(ActorStack equipped) {
		_actors.addAll(equipped.getActors());
	}

}
