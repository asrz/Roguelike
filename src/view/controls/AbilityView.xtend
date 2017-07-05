package view.controls

import java.io.IOException
import javafx.beans.property.ObjectProperty
import javafx.beans.property.SimpleObjectProperty
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Label
import javafx.scene.image.ImageView
import javafx.scene.layout.AnchorPane
import model.abilities.Ability
import view.Page
import view.ScreensController

class AbilityView extends AnchorPane {
	@FXML ImageView abilityIcon
	@FXML Label nameLabel
	@FXML Label costLabel
	@FXML Label descriptionLabel
	
	ObjectProperty<Ability> abilityProperty
	
	new(Ability ability) {
		this.abilityProperty = new SimpleObjectProperty(ability)
		
		val FXMLLoader loader = new FXMLLoader(getClass().getResource("AbilityView.fxml"))
		loader.setRoot(this)
		loader.setController(this)
		try {
			loader.load()
		} catch (IOException e) {
			throw new RuntimeException(e)
		}

		nameLabel.textProperty.bind(ability.nameProperty)
		costLabel.textProperty.bind(ability.costExpression)
		descriptionLabel.textProperty.bind(ability.descriptionProperty)
		abilityIcon.imageProperty.bind(ability.imageProperty);
	}
	
	def getAbility() {
		return abilityProperty.get()
	}
	
	@FXML def onButtonClick() {
		ScreensController::getScreensController().closeWindow(Page::ABILITY_MENU)
		ability.activate()
	}
}