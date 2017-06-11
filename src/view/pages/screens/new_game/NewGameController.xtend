package view.pages.screens.new_game

import java.io.IOException
import javafx.collections.ObservableList
import javafx.event.ActionEvent
import javafx.fxml.FXML
import javafx.scene.control.TextField
import map.Map
import map.Tile
import model.combat.DamageType
import util.Context
import util.ControlUtil
import view.ControlledScreen
import view.GameController
import view.Page
import view.ScreensController
import view.pages.dialogs.trade_menu.TradeMenuController
import view.pages.screens.map.MapController
import model.ai.AggressiveAi
import model.ai.Ai
import model.ai.RandomAi
import model.combat.Attacker
import model.combat.Destructible
import model.items.equipment.Armour
import model.items.equipment.Equipable
import model.items.equipment.Equipment
import model.items.equipment.Weapon
import model.items.usable.HealingUsable
import model.items.usable.Usable
import model.items.Container
import model.items.Pickable
import model.Actor
import model.Colours
import model.Dice
import model.Interactable

class NewGameController implements ControlledScreen {
	@FXML TextField playerName

	@FXML def protected void handleStartGameButtonAction(ActionEvent event) throws IOException {
		var Map map = new Map(50, 30)
		var Context context = new Context(map)
		GameController::setContext(context)
		var Actor player = createPlayer(map, playerName.getText())
		context.setPlayer(player)
		createGoblin(map, player)
		createItems(map, player)
		var ScreensController screensController = ScreensController::getScreensController()
		screensController.setScreen(Page::MAP)
	}

	def private Actor createPlayer(Map map, String playerName) {
		var int centre_x = map.width / 2
		var int centre_y = map.height / 2
		var Actor player = new Actor(playerName, '@', Colours::WHITE, true)
		map.getTile(centre_x, centre_y).addActor(player)
		new Attacker(player, 3)
		val playerDestructible = new Destructible(player, 25, 15, 0)
//		var DestructibleX playerDestructible = player.destructible
//		playerDestructible.addResistance(DamageType::BLUNT)
		new Container(player)
		new Equipment(player, newArrayList("Weapon", "Armour", "Ring", "Ammo"))
		return player
	}

	def private void createGoblin(Map map, Actor player) {
		var int x = player.getTile().getX() + 2
		var int y = player.getTile().getY() + 2
		var Actor goblin = new Actor("goblin", Character.valueOf('g').charValue, Colours::DARKGREEN, true)
		map.getTile(x, y).addActor(goblin)
		new Destructible(goblin, 10, 13, 12)
		new Attacker(goblin, 2, new Dice(1, 4, 1), DamageType::PIERCING)
		new RandomAi(goblin);
		val Ai aggro = new AggressiveAi(goblin, player, 5, false)
//		new SlowedAi(goblin, -1, aggro, 2)
//		new PassiveAi(goblin);
	}

	def private void createItems(Map map, Actor player) {
		var int x = player.getTile().getX() - 2
		var int y = player.getTile().getY() - 2
		var Tile tile = map.getTile(x, y)
		val Actor chest = new Actor("Chest", '=', Colours::BROWN, true)
		tile.addActor(chest)
		new Container(chest)
		new Interactable(chest) {
			override void interact(Actor user) {
				var ScreensController screensController = ScreensController::getScreensController()
				var TradeMenuController controller = (screensController.getController(
					Page::TRADE_MENU) as TradeMenuController)
				controller.setTarget(chest)
				screensController.openWindow(Page::TRADE_MENU)
			}
		}
		var Actor potion = new Actor("Healing Potion", '&', Colours::VIOLET, false)
		new Pickable(potion, player)
		new HealingUsable(potion, 1, 0, new Dice(2, 4, 2))
		potion = new Actor("Healing Potion", Character.valueOf('&').charValue, Colours::VIOLET, false)
		new Pickable(potion, player)
		new HealingUsable(potion, 1, 0, new Dice(2, 4, 2))
		potion = new Actor("Healing Potion", Character.valueOf('&').charValue, Colours::VIOLET, false)
		new Pickable(potion, chest)
		new HealingUsable(potion, 1, 0, new Dice(2, 4, 2))
		var Actor rock = new Actor("Rock", '*', Colours::GREY, false)
		new Pickable(rock, chest)
		var Actor sword = new Actor("Sword", '/', Colours::SILVER, false)
		new Pickable(sword, chest)
		new Weapon(sword, 2, new Dice(1, 8, 2), DamageType::SLASHING)
		var Actor rainbowSword = new Actor("Rainbow Sword", '/', Colours::AQUAMARINE, false)
		new Pickable(rainbowSword, chest)
		new Weapon(rainbowSword, 3, new Dice(1, 8, 3), DamageType::SLASHING)
		new Usable(rainbowSword) {
			override use(Actor user) { 
				if (super.use(user)) {
					var Weapon weapon = (owner.equipable as Weapon)
					var ObservableList<DamageType> damageTypes = DamageType::getMagicalTypes()
					damageTypes.add(DamageType::SLASHING)
					var DamageType damageType = ControlUtil::getPlayerChoice(damageTypes, weapon.getDamageType())
					weapon.setDamageType(damageType)
					return true
				}
				return false
			}
		}
		
		var Actor rainbowArmour = new Actor("Rainbow Armour", 'x', Colours::GOLD, false)
		new Pickable(rainbowArmour, chest)
		new Armour(rainbowArmour, 1)
		new Usable(rainbowArmour) {
			DamageType damageType = DamageType.FIRE
			override boolean use(Actor user) {
				if (super.use(user)) {
					var Armour armour = (owner.equipable as Armour)
					damageType = ControlUtil::getPlayerChoice(DamageType::getMagicalTypes(), damageType)
//					armour.getResistances().stream().findAny().orElse(null))
//					armour.getResistances().clear()
//					armour.getResistances().add(damageType)
					return true
				}
				return false
			}
		}
		val Actor lightningBoltScroll = new Actor("Scroll of Lightning Bolt", '#', Colours::YELLOW, false)
		new Pickable(lightningBoltScroll, chest)
		new Usable(lightningBoltScroll, 1, 0) {
			override boolean use(Actor user) {
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
		var Actor cursedRing = new Actor("Ring", Character.valueOf('o').charValue, Colours::GOLD, false)
		new Pickable(cursedRing, chest)
		new Equipable(cursedRing, "Ring", true)
		for (var int i = 0; i < 10; i++) {
			var Actor dart = new Actor("Dart", Character.valueOf('-').charValue, Colours::OLIVE, false)
			new Pickable(dart, chest)
			new Equipable(dart, "Ammo")
		}
	}
}
