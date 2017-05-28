package model

import javafx.scene.paint.Color
import xtendfx.beans.FXBindable
import xtendfx.beans.Readonly

@FXBindable
@Readonly
class Colour {
	String name
	Color color
}