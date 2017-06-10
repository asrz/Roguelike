package modelX

import javafx.scene.paint.Color
import xtendfx.beans.FXBindable
import xtendfx.beans.Readonly

@FXBindable
@Readonly
class ColourX {
	String name
	Color color
}