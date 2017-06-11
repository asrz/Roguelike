package model

abstract class Interactable extends Component {
	new(Actor owner) {
		super(owner)
	}

	def abstract void interact(Actor user);
}