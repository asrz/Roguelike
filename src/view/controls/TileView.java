package view.controls;


import java.io.IOException;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.Label;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundFill;
import javafx.scene.layout.VBox;
import map.Tile;
import model.Colour;


public class TileView extends VBox {

	@FXML
	private Label label;

	private ObjectProperty<Tile> tile;

	public TileView(Tile tile) {
		this.tile = new SimpleObjectProperty<>(tile);

		FXMLLoader loader = new FXMLLoader(getClass().getResource("tile_view.fxml"));
		loader.setRoot(this);
		loader.setController(this);

		try {
			loader.load();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		BackgroundFill backgroundFill = new BackgroundFill(tile.getBackgroundColor(), null, null);
		label.setBackground(new Background(backgroundFill));

		label.setText(tile.getCharacter() + "");
		label.textProperty().bind(tile.symbolProperty());

		label.textFillProperty().bind(tile.foregroundColorProperty());
	}

	public Tile getTile() {
		return tile.get();
	}

	public void setLabel(Character ch, Colour colour) {
		boolean visited = false;
		unbind();

		label.setText(ch.toString());
		label.setTextFill(colour.getColor());
		if (ch == 'X') {
			if (visited) {
				label.setText(label.getText());
			}
			visited = true;
		}
	}

	public void unbind() {
		if (label.textProperty().isBound()) {
			label.textProperty().unbind();
		}
		if (label.textFillProperty().isBound()) {
			label.textFillProperty().unbind();
		}
	}

	public void resetLabel() {
		label.textProperty().bind(tile.get().symbolProperty());
		label.textFillProperty().bind(tile.get().foregroundColorProperty());
	}

	public Label getLabel() {
		return label;
	}

}
