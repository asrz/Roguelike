package view.pages.screens.map

import java.util.Collection
import java.util.function.Consumer
import javafx.animation.Interpolator
import javafx.animation.KeyFrame
import javafx.animation.KeyValue
import javafx.animation.Timeline
import javafx.beans.binding.Bindings
import javafx.beans.property.DoubleProperty
import javafx.beans.property.SimpleDoubleProperty
import javafx.event.EventHandler
import javafx.fxml.FXML
import javafx.geometry.Point3D
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ProgressBar
import javafx.scene.control.ScrollPane
import javafx.scene.input.MouseEvent
import javafx.scene.layout.GridPane
import javafx.scene.layout.VBox
import javafx.scene.paint.Color
import javafx.scene.text.Text
import javafx.scene.text.TextFlow
import javafx.util.Duration
import map.Tile
import modelX.ActorX
import modelX.ColoursX
import modelX.combatX.DamageType
import modelX.combatX.DestructibleX
import util.Context
import view.ControlledScreen
import view.GameController
import view.controls.TileView

class MapController implements ControlledScreen {
	@FXML GridPane mapGrid
	@FXML TextFlow messageBox
	@FXML ScrollPane scrollPane
	@FXML VBox characterBox
	@FXML Label playerNameLabel
	@FXML ProgressBar hpBar
	@FXML Label hpBarLabel
	@FXML Label resistancesLabel
	@FXML Label vulnerabilitiesLabel
	@FXML Label immunitiesLabel
	@FXML Label tileContentsLabel

	def void draw() {
		var Context context = GameController::getContext()
		for (y : 0 ..< context.map.height) {
			for (x : 0 ..< context.map.width) {
				val tile = context.map.getTile(x, y)
				val tileView = new TileView(tile)
				tileView.onMouseEntered = [ tileContentsLabel.text = tileView.tile.actors.map[ fullName ].join(", ") ]
				mapGrid.add(tileView, x, y)
				tileView.requestLayout() //TODO is this necessary 
			}
		}
		
		var ActorX player = context.player
		playerNameLabel.text = player.name
		var DestructibleX destructible = player.destructible
		hpBarLabel.textProperty().bind(
			destructible.hpProperty().asString("HP: %d").concat(destructible.maxHpProperty().asString("/%d"))
		)
		var DoubleProperty hpAsDouble = new SimpleDoubleProperty()
		hpAsDouble.bind(destructible.hpProperty())
		hpBar.progressProperty().bind(Bindings::divide(hpAsDouble, destructible.maxHpProperty()))

//		// resistancesLabel.setText(getLabelList(destructible.getResistances()));
//		destructible.getResistances().addListener([Change<? extends DamageType> c |
//			resistancesLabel.setText(getLabelList(c.getSet()))
//		])
//
//		// vulnerabilitiesLabel.setText(getLabelList(destructible.getVulnerabilities()));
//		destructible.getVulnerabilities().addListener([Change<? extends DamageType> c |
//			vulnerabilitiesLabel.setText(getLabelList(c.getSet()))
//		])
//
//		// immunitiesLabel.setText(getLabelList(destructible.getImmunities()));
//		destructible.getImmunities().addListener([Change<? extends DamageType> c |
//			immunitiesLabel.setText(getLabelList(c.getSet()))
//		])
	}
	
	def private String getLabelList(Collection<? extends DamageType> damageTypes) {
		return damageTypes.map[ label ].join("\n\t")
	}

	def void takeTurn() {
		GameController::getContext().update()
	}

	override void onLoad(Context context) {
		draw()
		mapGrid.requestLayout()
		addMessage(ColoursX::BLUE.color, '''Welcome to game, «context.player.name»''')
	}

	def void addMessage(Color color, String message) {
		val String message2 = if (!message.endsWith("\n")) {
			message + "\n"
		} else {
			message
		}
		var Text text = new Text(message2)
		text.setFill(color)
		messageBox.children.add(text)
		scrollPane.setVvalue(scrollPane.getVmax())
	}

	def void targetTile(Consumer<Tile> callback) {
		for (Node node : mapGrid.children) {
			if (node instanceof TileView) {
				val TileView tileView = (node as TileView)
				val EventHandler<? super MouseEvent> oldEventHandler = tileView.getOnMouseEntered()
				val Timeline timeline = new Timeline(
					new KeyFrame(Duration::seconds(0), [tileView.requestLayout()],
						new KeyValue(tileView.label.textProperty(), "X", Interpolator::DISCRETE),
						new KeyValue(tileView.label.textFillProperty(), ColoursX::YELLOW.color, Interpolator::DISCRETE)
					),
					new KeyFrame(Duration::millis(750), [tileView.requestLayout()],
						new KeyValue(tileView.label.textProperty(), tileView.tile.symbol.toString(), Interpolator::DISCRETE),
						new KeyValue(tileView.label.textFillProperty(), tileView.tile.foregroundColour.color, Interpolator::DISCRETE)
					), 
					new KeyFrame(Duration::millis(1500))
				)
				timeline.setCycleCount(Timeline::INDEFINITE)
				tileView.onMouseEntered = [MouseEvent event|
					oldEventHandler.handle(event)
					tileView.unbind()
					timeline.playFromStart()
				]
				tileView.onMouseExited = [MouseEvent event|timeline.stop(); tileView.resetLabel()]
				tileView.onMouseClicked = [MouseEvent event|
					timeline.stop()
					tileView.resetLabel()
					var Point3D point = event.pickResult.intersectedPoint
					if (tileView.contains(point.x, point.y)) {
						callback.accept(tileView.tile)
					}
					for (Node child : mapGrid.getChildren()) {
						val TileView tv = (child as TileView)
						tv.onMouseEntered = [ tileContentsLabel.text = tv.tile.actors.map[ name ].join("\n") ]
						tv.onMouseExited = []
						tv.onMouseClicked = []
					}
				]
			}
		}
	}
}
