package model.abilities

import model.Colour
import model.Colours
import xtendfx.beans.FXBindable
import static extension util.PropertyExtensions.*

@FXBindable
class Resource {
	String name
	Colour colour
	int max
	int current
	int change
	
	def void update() {
		currentProperty += change
		if (current < 0) {
			current = 0
		} else if (current > max) {
			current = max
		}
		
		if (current === 55) {
			colour = Colours.GREEN;
		}
	}
	
	override toString() {
		return String.format("%s: %d/%d", name, current, max)
	}
}