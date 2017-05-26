package util;


import java.util.Optional;
import java.util.function.Consumer;
import java.util.function.Predicate;

import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Dialog;
import javafx.scene.control.ListView;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.util.Callback;


public class ControlUtil {

	public static <T> Callback<CellDataFeatures<T, Button>, ObservableValue<Button>> getButtonFactory(TableColumn<T, Button> column, String label,
			Consumer<T> onClick, Predicate<T> display) {
		return new Callback<CellDataFeatures<T, Button>, ObservableValue<Button>>() {
			@Override
			public ObservableValue<Button> call(CellDataFeatures<T, Button> param) {
				T t = param.getValue();
				if (!display.test(t)) {
					return null;
				}

				Button button = new Button(label);
				button.setOnAction(new EventHandler<ActionEvent>() {
					@Override
					public void handle(ActionEvent event) {
						onClick.accept(t);
					}
				});

				return new SimpleObjectProperty<>(button);
			}
		};
	}

	public static <T> T getPlayerChoice(ObservableList<T> choices, T selected) {
		Dialog<T> dialog = new Dialog<>();
		ListView<T> listView = new ListView<>(choices);
		
		listView.getSelectionModel().select(selected);
		dialog.getDialogPane().getButtonTypes().addAll(ButtonType.CANCEL, ButtonType.OK);
		dialog.getDialogPane().setContent(listView);
		dialog.setResultConverter((ButtonType p) -> p == ButtonType.OK ? listView.getSelectionModel().getSelectedItem() : null);
		
		Optional<T> choice = dialog.showAndWait();
		return choice.orElse(selected);
	}
}
