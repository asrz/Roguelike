package view.pages.screens.map;


import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.function.Consumer;
import java.util.stream.Collectors;

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.KeyValue;
import javafx.animation.Timeline;
import javafx.beans.binding.Bindings;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.collections.SetChangeListener.Change;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.geometry.Point3D;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.ScrollPane;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import javafx.util.Duration;
import map.Map;
import map.Tile;
import model.Actor;
import model.Colour;
import model.combat.DamageType;
import model.combat.Destructible;
import util.Context;
import util.Util;
import view.ControlledScreen;
import view.GameController;
import view.controls.TileView;

public class MapController implements ControlledScreen {

	@FXML
	private GridPane mapGrid;

	@FXML
	private TextFlow messageBox;

	@FXML
	private ScrollPane scrollPane;

	@FXML
	private VBox characterBox;

	@FXML
	private Label playerNameLabel;

	@FXML
	private ProgressBar hpBar;

	@FXML
	private Label hpBarLabel;

	@FXML
	private Label resistancesLabel;

	@FXML
	private Label vulnerabilitiesLabel;

	@FXML
	private Label immunitiesLabel;

	@FXML
	private Label tileContentsLabel;

	public void draw() {
		Context context = GameController.getContext();
		Map map = context.getMap();

		for (int y = 0; y < map.getHeight(); y++) {
			for (int x = 0; x < map.getWidth(); x++) {
				Tile tile = map.getTile(x, y);
				TileView tileView = new TileView(tile);
				tileView.setOnMouseEntered(new EventHandler<MouseEvent>() {
					@Override
					public void handle(MouseEvent event) {
						List<String> actors = tileView.getTile().getActors().stream().map(Actor::getName).collect(Collectors.toList());
						tileContentsLabel.setText(Util.commaSeparate(actors));
					}
				});
				mapGrid.add(tileView, x, y);
				tileView.requestLayout();
			}
		}

		Actor player = context.getPlayer();
		playerNameLabel.setText(player.getName());

		Destructible destructible = player.getDestructible().get();
		hpBarLabel.textProperty().bind(destructible.hpProperty().asString("HP: %d").concat(destructible.maxHpProperty().asString("/%d")));

		DoubleProperty hpAsDouble = new SimpleDoubleProperty();
		hpAsDouble.bind(destructible.hpProperty());

		hpBar.progressProperty().bind(Bindings.divide(hpAsDouble, destructible.maxHpProperty()));

		// resistancesLabel.setText(getLabelList(destructible.getResistances()));
		destructible.getResistances().addListener((Change<? extends DamageType> c) -> resistancesLabel.setText(getLabelList(c.getSet())));

		// vulnerabilitiesLabel.setText(getLabelList(destructible.getVulnerabilities()));
		destructible.getVulnerabilities().addListener((Change<? extends DamageType> c) -> vulnerabilitiesLabel.setText(getLabelList(c.getSet())));

		// immunitiesLabel.setText(getLabelList(destructible.getImmunities()));
		destructible.getImmunities().addListener((Change<? extends DamageType> c) -> immunitiesLabel.setText(getLabelList(c.getSet())));
	}

	private String getLabelList(Collection<? extends DamageType> damageTypes) {
		return "\t" + damageTypes.stream().map(DamageType::getLabel).collect(Collectors.joining("\n\t"));
	}

	public void takeTurn() {
		Context context = GameController.getContext();

		Iterator<Actor> actors = context.getActors();
		while (actors.hasNext()) {
			actors.next().takeTurn();
		}
	}

	@Override
	public void onLoad(Context context) {
		draw();
		mapGrid.requestLayout();
		addMessage(String.format("Welcome to game, %s", context.getPlayer().getName()), Colour.BLUE);
	}

	public void addMessage(String message, Colour colour) {
		Text text = new Text("\n" + message);
		text.setFill(colour.getColor());
		messageBox.getChildren().add(text);
		scrollPane.setVvalue(scrollPane.getVmax());
	}

	public void targetTile(Consumer<Tile> callback) {
		for (Node node : mapGrid.getChildren()) {
			if (node instanceof TileView) {
				TileView tileView = (TileView) node;
				EventHandler<? super MouseEvent> oldEventHandler = tileView.getOnMouseEntered();
				Timeline timeline = new Timeline(
						new KeyFrame(Duration.seconds(0), e -> tileView.requestLayout(),
								new KeyValue(tileView.getLabel().textProperty(), "X", Interpolator.DISCRETE),
								new KeyValue(tileView.getLabel().textFillProperty(), Colour.YELLOW.getColor(), Interpolator.DISCRETE)),
						new KeyFrame(Duration.millis(750), e -> tileView.requestLayout(),
								new KeyValue(tileView.getLabel().textProperty(), tileView.getTile().getCharacter().toString(), Interpolator.DISCRETE),
								new KeyValue(tileView.getLabel().textFillProperty(), tileView.getTile().getForegroundColor(), Interpolator.DISCRETE)),
						new KeyFrame(Duration.millis(1500)));
				timeline.setCycleCount(Timeline.INDEFINITE);
				tileView.setOnMouseEntered(new EventHandler<MouseEvent>() {
					@Override
					public void handle(MouseEvent event) {
						oldEventHandler.handle(event);
						tileView.unbind();
						timeline.playFromStart();
					}
				});
				tileView.setOnMouseExited(new EventHandler<MouseEvent>() {
					@Override
					public void handle(MouseEvent event) {
						timeline.stop();
						tileView.resetLabel();
					}
				});
				tileView.setOnMouseClicked(new EventHandler<MouseEvent>() {
					@Override
					public void handle(MouseEvent event) {
						timeline.stop();
						tileView.resetLabel();
						Point3D point = event.getPickResult().getIntersectedPoint();
						if (tileView.contains(point.getX(), point.getY())) {
							callback.accept(tileView.getTile());
						}

						for (Node node : mapGrid.getChildren()) {
							TileView tv = (TileView) node;
							tv.setOnMouseEntered(e -> tileContentsLabel
									.setText(Util.commaSeparate(tv.getTile().getActors().stream().map(Actor::getName).collect(Collectors.toList()))));
							tv.setOnMouseExited(e -> {});
							tv.setOnMouseClicked(e -> {});
						}
					};
				});
			}
		}
	}
}
