package view.pages.screens.new_game

import java.io.IOException
import javafx.collections.ObservableList
import javafx.event.ActionEvent
import javafx.fxml.FXML
import javafx.scene.control.TextField
import map.Map
import map.Tile
import model.Actor
import model.Colours
import model.Dice
import model.Interactable
import model.abilities.Ability
import model.abilities.RangeType
import model.abilities.Resource
import model.abilities.Target
import model.ai.AggressiveAi
import model.ai.Ai
import model.ai.PlayerAi
import model.ai.RandomAi
import model.combat.Attacker
import model.combat.DamageType
import model.combat.Destructible
import model.helper.Context
import model.items.Container
import model.items.Pickable
import model.items.equipment.Armour
import model.items.equipment.Equipable
import model.items.equipment.Equipment
import model.items.equipment.Weapon
import model.items.usable.HealingUsable
import model.items.usable.Usable
import util.ControlUtil
import util.Util
import view.ControlledScreen
import view.GameController
import view.Page
import view.ScreensController
import view.pages.dialogs.trade_menu.TradeMenuController
import view.pages.screens.map.MapController

import static extension util.CollectionsUtil.*

class NewGameController implements ControlledScreen {
	@FXML TextField playerName

	@FXML def protected void handleStartGameButtonAction(ActionEvent event) throws IOException {
		val Map map = new Map(50, 30)
		val Context context = new Context(map)
		GameController::setContext(context)
		val Actor player = createPlayer(map, playerName.getText())
		context.setPlayer(player)
		createGoblin(map, player)
		createItems(map, player)
		createMeeps(map)
		val ScreensController screensController = ScreensController::getScreensController()
		screensController.setScreen(Page::MAP)
	}

	def private Actor createPlayer(Map map, String playerName) {
		val int centre_x = map.width / 2
		val int centre_y = map.height / 2
		val Actor player = new Actor(playerName, '@', Colours::WHITE, true) => [ player |
			map.getTile(centre_x, centre_y).addActor(player)
			new Attacker(player, 3)
			new Destructible(player, 25, 15, 0)
			new Container(player)
			new PlayerAi(player)
			new Equipment(player, newArrayList("Weapon", "Armour", "Ring", "Ammo"))
			player.resources = newObservableList(
				new Resource("Mana", Colours.BLUE, 100, 50, 1),
				new Resource("Fury", Colours.DARKRED, 100, 50, -1)
			)
			player.abilities = newObservableList(
				new Ability(
					player,
					"Earthquake",
					"generates a shockwave around the user, damaging and stunning nearby units.",
					RangeType.PERSONAL,
					Target.SPHERE,
					10,
					"Mana",
					20,
					Util.loadImage("img", "abilities", "earthquake.png"),
					[ actors.filter[!isPlayer].mapNonNull[destructible].forEach[takeDamage(10, DamageType.BLUNT, player)]]
				),
				new Ability(
					player,
					"Lightning Bolt",
					"shoots a bolt of lightning in a line from the user",
					RangeType.PERSONAL,
					Target.LINE,
					10,
					"Mana",
					25,
					Util.loadImage("img", "abilities", "lightning_bolt.png"),
					[]
				),
				new Ability(
					player,
					"Fireball",
					"throws a ball of fire which explodes upon impact",
					RangeType.RANGED,
					Target.SPHERE,
					3,
					"Mana",
					50,
					Util.loadImage("img", "abilities", "fireball.png"),
					[ actors.mapNonNull[destructible].forEach[takeDamage(Dice.roll(5, 6, 0), DamageType.FIRE, player)] ]
				),
				new Ability(
					player,
					"Heal",
					"Heals the target",
					RangeType.TOUCH,
					Target.ACTOR,
					0,
					"Mana",
					10,
					Util.loadImage("img", "abilities", "heal.png"),
					[ actors.mapNonNull[destructible].forEach[heal(Dice.roll(1, 8, 4))]]
				)
			)
		]
		return player
	}

	def private void createGoblin(Map map, Actor player) {
		val int x = player.getTile().getX() + 2
		val int y = player.getTile().getY() + 2
		val Actor goblin = new Actor("goblin", 'g', Colours::DARKGREEN, true) => [ goblin |
			new Destructible(goblin, 10, 13, 12)
			new Attacker(goblin, 2, new Dice(1, 4, 1), DamageType::PIERCING)
			new RandomAi(goblin);
			val Ai aggro = new AggressiveAi(goblin, player, 5, false)
		]
		map.getTile(x, y).addActor(goblin)
//		new SlowedAi(goblin, -1, aggro, 2)
//		new PassiveAi(goblin);
	}

	def private void createMeeps(Map map) {
		map.tiles.filter[actors.isEmpty].forEach[
			val meep = new Actor("meep", 'o', Colours::BLUE, true)
			it.addActor(meep)
			new Destructible(meep, 1, 0, 0)
		]
	}

	def private void createItems(Map map, Actor player) {
		val int x = player.getTile().getX() - 2
		val int y = player.getTile().getY() - 2
		val Tile tile = map.getTile(x, y)
		val Actor chest = new Actor("Chest", '=', Colours::BROWN, true)
		tile.addActor(chest)
		new Container(chest)
		new Interactable(chest) {
			override void interact(Actor user) {
				val ScreensController screensController = ScreensController::getScreensController()
				val TradeMenuController controller = (screensController.getController(
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
		val Actor rock = new Actor("Rock", '*', Colours::GREY, false)
		new Pickable(rock, chest)
		val Actor sword = new Actor("Sword", '/', Colours::SILVER, false)
		new Pickable(sword, chest)
		new Weapon(sword, 2, new Dice(1, 8, 2), DamageType::SLASHING)
		val Actor rainbowSword = new Actor("Rainbow Sword", '/', Colours::AQUAMARINE, false)
		new Pickable(rainbowSword, chest)
		new Weapon(rainbowSword, 3, new Dice(1, 8, 3), DamageType::SLASHING)
		new Usable(rainbowSword) {
			override use(Actor user) {
				if (super.use(user)) {
					val Weapon weapon = (owner.equipable as Weapon)
					val ObservableList<DamageType> damageTypes = DamageType::getMagicalTypes()
					damageTypes.add(DamageType::SLASHING)
					val DamageType damageType = ControlUtil::getPlayerChoice(damageTypes, weapon.getDamageType())
					weapon.setDamageType(damageType)
					return true
				}
				return false
			}
		}

		val Actor rainbowArmour = new Actor("Rainbow Armour", 'x', Colours::GOLD, false)
		new Pickable(rainbowArmour, chest)
		new Armour(rainbowArmour, 1)
		new Usable(rainbowArmour) {
			DamageType damageType = DamageType.FIRE
			override boolean use(Actor user) {
				if (super.use(user)) {
					val Armour armour = (owner.equipable as Armour)
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
				val MapController mapController = (ScreensController::getScreensController().
					getController(Page::MAP) as MapController)
				mapController.targetTile([Tile tile |
					tile.actors.map[actors].flatten.forEach[
						destructible?.takeDamage(4, DamageType.LIGHTNING, lightningBoltScroll)
					]
				])
				return super.use(user)
			}
		}
		val Actor cursedRing = new Actor("Ring", Character.valueOf('o').charValue, Colours::GOLD, false)
		new Pickable(cursedRing, chest)
		new Equipable(cursedRing, "Ring", true)
		for (i : 1..10) {
			val Actor dart = new Actor("Dart", Character.valueOf('-').charValue, Colours::OLIVE, false)
			new Pickable(dart, chest)
			new Equipable(dart, "Ammo")
		}
	}
}
