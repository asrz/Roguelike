package view.pages.dialogs.ability_menu

import java.net.URL
import java.util.ResourceBundle
import javafx.beans.binding.Bindings
import javafx.fxml.FXML
import javafx.fxml.Initializable
import javafx.scene.Node
import javafx.scene.layout.FlowPane
import model.Actor
import model.abilities.Ability
import model.helper.Context
import model.helper.MappedList
import view.ControlledScreen
import view.GameController
import view.controls.AbilityView

class AbilityMenuController implements ControlledScreen, Initializable {
	
	@FXML FlowPane abilitiesFlowPane
	
	Actor player
	
	override initialize(URL location, ResourceBundle resources) {
	}
	
	override onLoad(Context context) {
		if (player === null) {
			player = GameController::context.player
		
			val MappedList<Ability, Node> mappedList = new MappedList(player.abilities, [ new AbilityView(it) ])
			
			Bindings.bindContentBidirectional(abilitiesFlowPane.children, mappedList)
		}
	}
}