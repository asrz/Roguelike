package model.items.usable;


import model.Actor;
import model.Colours;
import view.ScreensController;


public abstract class Usable {

	protected Actor owner;
	private int uses; // number of uses before destroying 0 = infinite
	private int cooldown; // number of turns between uses. 0 = infinite
	private int currentCooldown;

	public Usable(Actor owner, int uses, int cooldown) {
		this.owner = owner;
		this.owner.setUsable(this);
		this.uses = uses;
		this.cooldown = cooldown;
		this.currentCooldown = cooldown;
	}

	public Usable(Actor owner) {
		this(owner, 0, 0);
	}

	public boolean use(Actor user) {
		ScreensController.addMessage(Colours.BLUE, "%s attempts to uses the %s.", user.getName(), owner.getName());

		if (currentCooldown > 0) {
			user.logIfPlayer(Colours.BLANCHEDALMOND, "You cannot use %s yet.", owner.getName());
			return false;
		}

		if (uses > 0) {
			uses--;
			if (uses == 0) {
				user.logIfPlayer(Colours.LIGHTSKYBLUE, "%s has been used up.", owner.getName());
				destroy();
				return false;
			}
		}
		currentCooldown = cooldown;
		return true;
	}

	public void destroy() {
		owner.destroy();
	}
}
