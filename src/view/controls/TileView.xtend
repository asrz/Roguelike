package view.controls

import java.io.IOException
import javafx.beans.property.ObjectProperty
import javafx.beans.property.SimpleObjectProperty
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Label
import javafx.scene.layout.Background
import javafx.scene.layout.BackgroundFill
import javafx.scene.layout.VBox
import map.Tile
import model.Colour

class TileView extends VBox {
	@FXML Label label
	ObjectProperty<Tile> tileProperty

	new(Tile tile) {
		this.tileProperty = new SimpleObjectProperty(tile)
		
		val FXMLLoader loader = new FXMLLoader(getClass().getResource("tile_view.fxml"))
		loader.setRoot(this)
		loader.setController(this)
		try {
			loader.load()
		} catch (IOException e) {
			throw new RuntimeException(e)
		}

		val BackgroundFill backgroundFill = new BackgroundFill(tile.backgroundColour.color, null, null)
		label.setBackground(new Background(backgroundFill))
		label.setText(tile.symbol.toString)
		resetLabel()
	}

	def Tile getTile() {
		return tileProperty.get()
	}

	def void setLabel(Character ch, Colour colour) {
		var visited = false
		unbind()
		label.setText(ch.toString())
		label.setTextFill(colour.getColor())
		if (ch === Character.valueOf('X').charValue) {
			if (visited) {
				label.setText(label.getText())
			}
			visited = true
		}
	}

	def void unbind() {
		if (label.textProperty().isBound()) {
			label.textProperty().unbind()
		}
		if (label.textFillProperty().isBound()) {
			label.textFillProperty().unbind()
		}
	}

	def void resetLabel() {
		label.textProperty().bind(tile.symbolProperty().asString())
		label.textFillProperty().bind(tile.foregroundColorProperty())
	}

	def Label getLabel() {
		return label
	}
}
