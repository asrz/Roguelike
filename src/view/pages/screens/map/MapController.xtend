package view.pages.screens.map

import java.util.Collection
import java.util.function.Consumer
import javafx.animation.Interpolator
import javafx.animation.KeyFrame
import javafx.animation.KeyValue
import javafx.animation.Timeline
import javafx.beans.binding.Bindings
import javafx.event.EventHandler
import javafx.fxml.FXML
import javafx.geometry.Point3D
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ProgressBar
import javafx.scene.control.ScrollPane
import javafx.scene.input.MouseEvent
import javafx.scene.layout.GridPane
import javafx.scene.layout.StackPane
import javafx.scene.layout.VBox
import javafx.scene.paint.Color
import javafx.scene.text.Text
import javafx.scene.text.TextFlow
import javafx.util.Duration
import map.Tile
import model.Actor
import model.Colours
import model.abilities.Resource
import model.combat.DamageType
import model.combat.Destructible
import model.helper.Context
import model.helper.FXBinding
import model.helper.MappedList
import view.ControlledScreen
import view.GameController
import view.controls.TileView

import static extension util.PropertyExtensions.*

class MapController implements ControlledScreen {
	@FXML GridPane mapGrid
	@FXML TextFlow messageBox
	@FXML ScrollPane scrollPane
	@FXML VBox characterBox
	@FXML Label playerNameLabel
	@FXML ProgressBar hpBar
	@FXML Label hpBarLabel
	@FXML VBox resourceBars
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
		
		var Actor player = context.player
		playerNameLabel.text = player.name
		var Destructible destructible = player.destructible
		hpBarLabel.textProperty().bind(
			destructible.hpProperty().asString("HP: %d").concat(destructible.maxHpProperty().asString("/%d"))
		)
		hpBar.progressProperty().bind(Bindings::divide(destructible.hpProperty.asDouble, destructible.maxHpProperty.asDouble))

		val resourceBarList = new MappedList(player.resources, [resourceToProgressBar])
		Bindings.bindContent(resourceBars.children, resourceBarList)

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
	
	def private StackPane resourceToProgressBar(Resource resource) {
		new StackPane => [
			children += new ProgressBar => [
				progressProperty.bind(Bindings.divide(resource.currentProperty.asDouble, resource.maxProperty.asDouble))
				val styleBinding = Bindings.format("-fx-accent: %s; -fx-control-inner-background: %s; -fx-text-box-border: black;", 
					FXBinding.nestedBinding(resource.colourProperty, [get().colorProperty], [RGBCode]),
					FXBinding.nestedBinding(resource.colourProperty, [get().colorProperty], [darken], [RGBCode])
				)
				styleProperty.bind(styleBinding)
			]
			children += new Label => [
				textProperty.bind(Bindings.createStringBinding([resource.toString], 
					resource.nameProperty, resource.currentProperty, resource.maxProperty
				))
				textFill = Colours.WHITE.color
			]
		]
	}
	
	def private String getLabelList(Collection<? extends DamageType> damageTypes) {
		return damageTypes.map[ label ].join("\n\t")
	}

	override void onLoad(Context context) {
		draw()
		mapGrid.requestLayout()
		addMessage(Colours::BLUE.color, '''Welcome to game, «context.player.name»''')
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
						new KeyValue(tileView.label.textFillProperty(), Colours::YELLOW.color, Interpolator::DISCRETE)
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
