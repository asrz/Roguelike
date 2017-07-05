package model

import javafx.beans.binding.Bindings
import javafx.beans.binding.StringExpression
import javafx.scene.paint.Color
import xtendfx.beans.FXBindable
import xtendfx.beans.Readonly

@FXBindable
@Readonly
class Colour {
	String name
	Color color
	
	def StringExpression getRGBCode() {
		Bindings.createStringBinding([String.format(
			"#%02X%02X%02X",
			( color.red * 255 ) as int,
			( color.green * 255 ) as int,
			( color.blue * 255 ) as int
		)], colorProperty);
	}
}