package view.pages.screens.new_game;


import java.io.IOException;

import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import map.Map;
import map.Tile;
import model.Actor;
import model.Colour;
import model.Dice;
import model.Interactable;
import model.ai.AggressiveAi;
import model.ai.Ai;
import model.ai.SlowedAi;
import model.combat.Attacker;
import model.combat.DamageType;
import model.combat.Destructible;
import model.items.Container;
import model.items.Pickable;
import model.items.equipment.Armour;
import model.items.equipment.Equipable;
import model.items.equipment.Equipment;
import model.items.equipment.Weapon;
import model.items.usable.HealingUsable;
import model.items.usable.Usable;
import util.CollectionsUtil;
import util.Context;
import util.ControlUtil;
import view.ControlledScreen;
import view.GameController;
import view.Page;
import view.ScreensController;
import view.pages.dialogs.trade_menu.TradeMenuController;
import view.pages.screens.map.MapController;


public class NewGameController implements ControlledScreen {

	@FXML
	private TextField playerName;

	@FXML
	protected void handleStartGameButtonAction(ActionEvent event) throws IOException {
		Map map = new Map(50, 30);

		Context context = new Context(map);
		GameController.setContext(context);

		Actor player = createPlayer(map, playerName.getText());
		context.setPlayer(player);
		createGoblin(map, player);
		createItems(map, player);

		ScreensController screensController = ScreensController.getScreensController();
		screensController.setScreen(Page.MAP);
	}

	private Actor createPlayer(Map map, String playerName) {
		int centre_x = map.getWidth() / 2;
		int centre_y = map.getHeight() / 2;

		Actor player = new Actor(playerName, '@', Colour.WHITE, true, map.getTile(centre_x, centre_y));
		new Attacker(player, 3);
		new Destructible(player, 25, 15, 0);
		Destructible playerDestructible = player.getDestructible().get();
		playerDestructible.addResistance(DamageType.BLUNT);
		new Container(player);
		new Equipment(player, CollectionsUtil.list("Weapon", "Armour", "Ring", "Ammo"));
		return player;
	}

	private void createGoblin(Map map, Actor player) {
		int x = player.getTile().getX() + 2;
		int y = player.getTile().getY() + 2;
		Actor goblin = new Actor("goblin", 'g', Colour.DARKGREEN, true, map.getTile(x, y));
		new Destructible(goblin, 100, 13, 12);
		new Attacker(goblin, 2, new Dice(1, 4, 1), DamageType.PIERCING);
		// new RandomAi(goblin);
		Ai aggro = new AggressiveAi(goblin, player, 5, false);
		new SlowedAi(goblin, -1, aggro, 2);
		// new PassiveAi(goblin);

	}

	private void createItems(Map map, Actor player) {
		int x = player.getTile().getX() - 2;
		int y = player.getTile().getY() - 2;

		Tile tile = map.getTile(x, y);

		Actor chest = new Actor("Chest", '=', Colour.BROWN, true, tile);
		new Container(chest);
		new Interactable(chest) {
			@Override
			public void interact(Actor user) {
				ScreensController screensController = ScreensController.getScreensController();
				TradeMenuController controller = (TradeMenuController) screensController.getController(Page.TRADE_MENU);
				controller.setTarget(chest);
				screensController.openWindow(Page.TRADE_MENU);
			}
		};

		Actor potion = new Actor("Healing Potion", '&', Colour.VIOLET, false);
		new Pickable(potion, player);
		new HealingUsable(potion, 1, 0, new Dice(2, 4, 2));
		
		potion = new Actor("Healing Potion", '&', Colour.VIOLET, false);
		new Pickable(potion, player);
		new HealingUsable(potion, 1, 0, new Dice(2, 4, 2));
		
		potion = new Actor("Healing Potion", '&', Colour.VIOLET, false);
		new Pickable(potion, chest);
		new HealingUsable(potion, 1, 0, new Dice(2, 4, 2));

		Actor rock = new Actor("Rock", '*', Colour.GREY, false);
		new Pickable(rock, chest);

		Actor sword = new Actor("Sword", '/', Colour.SILVER, false);
		new Pickable(sword, chest);
		new Weapon(sword, 2, new Dice(1, 8, 2), DamageType.SLASHING);

		Actor rainbowSword = new Actor("Rainbow Sword", '/', Colour.AQUAMARINE, false);
		new Pickable(rainbowSword, chest);
		new Weapon(rainbowSword, 3, new Dice(1, 8, 3), DamageType.SLASHING);
		new Usable(rainbowSword) {
			@Override
			public boolean use(Actor user) {
				if (super.use(user)) {
					Weapon weapon = (Weapon) owner.getEquipable().get();
					ObservableList<DamageType> damageTypes = DamageType.getMagicalTypes();
					damageTypes.add(DamageType.SLASHING);
					DamageType damageType = ControlUtil.getPlayerChoice(damageTypes, weapon.getDamageType());
					weapon.setDamageType(damageType);
					return true;
				}
				return false;
			}
		};

		Actor rainbowArmour = new Actor("Rainbow Armour", 'x', Colour.GOLD, false);
		new Pickable(rainbowArmour, chest);
		new Armour(rainbowArmour, 1);
		new Usable(rainbowArmour) {
			@Override
			public boolean use(Actor user) {
				if (super.use(user)) {
					Armour armour = (Armour) owner.getEquipable().get();
					DamageType damageType = ControlUtil.getPlayerChoice(DamageType.getMagicalTypes(), armour.getResistances().stream().findAny().orElse(null));
					armour.getResistances().clear();
					armour.getResistances().add(damageType);
					return true;
				}
				return false;
			}
		};

		Actor lightningBoltScroll = new Actor("Scroll of Lightning Bolt", '#', Colour.YELLOW, false);
		new Pickable(lightningBoltScroll, chest);
		new Usable(lightningBoltScroll, 1, 0) {
			@Override
			public boolean use(Actor user) {
				ScreensController.getScreensController().closeWindow(Page.INVENTORY);
				MapController mapController = (MapController) ScreensController.getScreensController().getController(Page.MAP);
				mapController.targetTile((Tile tile) -> tile.getActors()
						.forEach((Actor a) -> a.getDestructible().ifPresent(d -> d.takeDamage(4, DamageType.LIGHTNING, lightningBoltScroll))));
				return super.use(user);
			}
		};

		Actor cursedRing = new Actor("Ring", 'o', Colour.GOLD, false);
		new Pickable(cursedRing, chest);
		new Equipable(cursedRing, "Ring", true);
		
		for (int i = 0; i < 10; i++) {
			Actor dart = new Actor("Dart", '-', Colour.OLIVE, false);
			new Pickable(dart, chest);
			new Equipable(dart, "Ammo");
		}
	}
}
