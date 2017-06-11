package view.pages.screens.new_game

import java.io.IOException
import javafx.collections.ObservableList
import javafx.event.ActionEvent
import javafx.fxml.FXML
import javafx.scene.control.TextField
import map.Map
import map.Tile
import modelX.ActorX
import modelX.ColoursX
import modelX.DiceX
import modelX.InteractableX
import modelX.aiX.AggressiveAiX
import modelX.aiX.AiX
import modelX.aiX.RandomAiX
import modelX.combatX.AttackerX
import modelX.combatX.DamageType
import modelX.combatX.DestructibleX
import modelX.itemsX.ContainerX
import modelX.itemsX.PickableX
import modelX.itemsX.equipmentX.ArmourX
import modelX.itemsX.equipmentX.EquipableX
import modelX.itemsX.equipmentX.EquipmentX
import modelX.itemsX.equipmentX.WeaponX
import modelX.itemsX.usableX.HealingUsableX
import modelX.itemsX.usableX.UsableX
import util.Context
import util.ControlUtil
import view.ControlledScreen
import view.GameController
import view.Page
import view.ScreensController
import view.pages.dialogs.trade_menu.TradeMenuController
import view.pages.screens.map.MapController

class NewGameController implements ControlledScreen {
	@FXML TextField playerName

	@FXML def protected void handleStartGameButtonAction(ActionEvent event) throws IOException {
		var Map map = new Map(50, 30)
		var Context context = new Context(map)
		GameController::setContext(context)
		var ActorX player = createPlayer(map, playerName.getText())
		context.setPlayer(player)
		createGoblin(map, player)
		createItems(map, player)
		var ScreensController screensController = ScreensController::getScreensController()
		screensController.setScreen(Page::MAP)
	}

	def private ActorX createPlayer(Map map, String playerName) {
		var int centre_x = map.width / 2
		var int centre_y = map.height / 2
		var ActorX player = new ActorX(playerName, '@', ColoursX::WHITE, true)
		map.getTile(centre_x, centre_y).addActor(player)
		new AttackerX(player, 3)
		val playerDestructible = new DestructibleX(player, 25, 15, 0)
//		var DestructibleX playerDestructible = player.destructible
//		playerDestructible.addResistance(DamageType::BLUNT)
		new ContainerX(player)
		new EquipmentX(player, newArrayList("Weapon", "Armour", "Ring", "Ammo"))
		return player
	}

	def private void createGoblin(Map map, ActorX player) {
		var int x = player.getTile().getX() + 2
		var int y = player.getTile().getY() + 2
		var ActorX goblin = new ActorX("goblin", Character.valueOf('g').charValue, ColoursX::DARKGREEN, true)
		map.getTile(x, y).addActor(goblin)
		new DestructibleX(goblin, 10, 13, 12)
		new AttackerX(goblin, 2, new DiceX(1, 4, 1), DamageType::PIERCING)
		new RandomAiX(goblin);
		val AiX aggro = new AggressiveAiX(goblin, player, 5, false)
//		new SlowedAi(goblin, -1, aggro, 2)
//		new PassiveAi(goblin);
	}

	def private void createItems(Map map, ActorX player) {
		var int x = player.getTile().getX() - 2
		var int y = player.getTile().getY() - 2
		var Tile tile = map.getTile(x, y)
		val ActorX chest = new ActorX("Chest", '=', ColoursX::BROWN, true)
		tile.addActor(chest)
		new ContainerX(chest)
		new InteractableX(chest) {
			override void interact(ActorX user) {
				var ScreensController screensController = ScreensController::getScreensController()
				var TradeMenuController controller = (screensController.getController(
					Page::TRADE_MENU) as TradeMenuController)
				controller.setTarget(chest)
				screensController.openWindow(Page::TRADE_MENU)
			}
		}
		var ActorX potion = new ActorX("Healing Potion", '&', ColoursX::VIOLET, false)
		new PickableX(potion, player)
		new HealingUsableX(potion, 1, 0, new DiceX(2, 4, 2))
		potion = new ActorX("Healing Potion", Character.valueOf('&').charValue, ColoursX::VIOLET, false)
		new PickableX(potion, player)
		new HealingUsableX(potion, 1, 0, new DiceX(2, 4, 2))
		potion = new ActorX("Healing Potion", Character.valueOf('&').charValue, ColoursX::VIOLET, false)
		new PickableX(potion, chest)
		new HealingUsableX(potion, 1, 0, new DiceX(2, 4, 2))
		var ActorX rock = new ActorX("Rock", '*', ColoursX::GREY, false)
		new PickableX(rock, chest)
		var ActorX sword = new ActorX("Sword", '/', ColoursX::SILVER, false)
		new PickableX(sword, chest)
		new WeaponX(sword, 2, new DiceX(1, 8, 2), DamageType::SLASHING)
		var ActorX rainbowSword = new ActorX("Rainbow Sword", '/', ColoursX::AQUAMARINE, false)
		new PickableX(rainbowSword, chest)
		new WeaponX(rainbowSword, 3, new DiceX(1, 8, 3), DamageType::SLASHING)
		new UsableX(rainbowSword) {
			override use(ActorX user) { 
				if (super.use(user)) {
					var WeaponX weapon = (owner.equipable as WeaponX)
					var ObservableList<DamageType> damageTypes = DamageType::getMagicalTypes()
					damageTypes.add(DamageType::SLASHING)
					var DamageType damageType = ControlUtil::getPlayerChoice(damageTypes, weapon.getDamageType())
					weapon.setDamageType(damageType)
					return true
				}
				return false
			}
		}
		
		var ActorX rainbowArmour = new ActorX("Rainbow Armour", 'x', ColoursX::GOLD, false)
		new PickableX(rainbowArmour, chest)
		new ArmourX(rainbowArmour, 1)
		new UsableX(rainbowArmour) {
			DamageType damageType = DamageType.FIRE
			override boolean use(ActorX user) {
				if (super.use(user)) {
					var ArmourX armour = (owner.equipable as ArmourX)
					damageType = ControlUtil::getPlayerChoice(DamageType::getMagicalTypes(), damageType)
//					armour.getResistances().stream().findAny().orElse(null))
//					armour.getResistances().clear()
//					armour.getResistances().add(damageType)
					return true
				}
				return false
			}
		}
		val ActorX lightningBoltScroll = new ActorX("Scroll of Lightning Bolt", '#', ColoursX::YELLOW, false)
		new PickableX(lightningBoltScroll, chest)
		new UsableX(lightningBoltScroll, 1, 0) {
			override boolean use(ActorX user) {
				ScreensController::getScreensController().closeWindow(Page::INVENTORY)
				var MapController mapController = (ScreensController::getScreensController().
					getController(Page::MAP) as MapController)
				mapController.targetTile([Tile tile |
					tile.actors.map[actors].flatten.forEach[
						destructible?.takeDamage(4, DamageType.LIGHTNING, lightningBoltScroll)
					]
				])
				return super.use(user)
			}
		}
		var ActorX cursedRing = new ActorX("Ring", Character.valueOf('o').charValue, ColoursX::GOLD, false)
		new PickableX(cursedRing, chest)
		new EquipableX(cursedRing, "Ring", true)
		for (var int i = 0; i < 10; i++) {
			var ActorX dart = new ActorX("Dart", Character.valueOf('-').charValue, ColoursX::OLIVE, false)
			new PickableX(dart, chest)
			new EquipableX(dart, "Ammo")
		}
	}
}
