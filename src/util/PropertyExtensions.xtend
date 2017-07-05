package util

import javafx.beans.binding.Bindings
import javafx.beans.binding.StringExpression
import javafx.beans.property.IntegerProperty
import javafx.beans.property.Property
import javafx.beans.property.SimpleDoubleProperty
import javafx.beans.value.ObservableValue
import javafx.scene.paint.Color

class PropertyExtensions {
	def static asDouble(Property<Number> property) {
		new SimpleDoubleProperty() => [
			bind(property)
		]
	}
	
	def static darken(ObservableValue<Color> colorProperty) {
		return Bindings.createObjectBinding([ colorProperty.value.darker], colorProperty)
	}
	
	def static StringExpression getRGBCode(ObservableValue<Color> colorProperty) {
		val color = colorProperty.value
		Bindings.createStringBinding([String.format(
			"#%02X%02X%02X",
			( color.red * 255 ) as int,
			( color.green * 255 ) as int,
			( color.blue * 255 ) as int
		)], colorProperty);
	}
	
	def static void operator_add(IntegerProperty property, Integer change) {
		property.set(property.get() + change)
	}
	
	def static void operator_remove(IntegerProperty property, Integer change) {
		property.set(property.get() - change)
	}
}