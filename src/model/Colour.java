package model;


import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.scene.paint.Color;


public class Colour {

	private StringProperty nameProperty;
	private ObjectProperty<Color> color;

	public Colour(String name, Color color) {
		this.nameProperty = new SimpleStringProperty(name);
		this.color = new SimpleObjectProperty<>(color);
	}

	@Override
	public String toString() {
		return nameProperty + ":" + color.toString();
	}

	public static final Colour TRANSPARENT = new Colour("transparent", Color.TRANSPARENT);
	public static final Colour ALICEBLUE = new Colour("alice blue", Color.ALICEBLUE);
	public static final Colour ANTIQUEWHITE = new Colour("antique white", Color.ANTIQUEWHITE);
	public static final Colour AQUA = new Colour("aqua", Color.AQUA);
	public static final Colour AQUAMARINE = new Colour("aquamarine", Color.AQUAMARINE);
	public static final Colour AZURE = new Colour("azure", Color.AZURE);
	public static final Colour BEIGE = new Colour("beige", Color.BEIGE);
	public static final Colour BISQUE = new Colour("bisque", Color.BISQUE);
	public static final Colour BLACK = new Colour("black", Color.BLACK);
	public static final Colour BLANCHEDALMOND = new Colour("blanched almond", Color.BLANCHEDALMOND);
	public static final Colour BLUE = new Colour("blue", Color.BLUE);
	public static final Colour BLUEVIOLET = new Colour("blue-violet", Color.BLUEVIOLET);
	public static final Colour BROWN = new Colour("brown", Color.BROWN);
	public static final Colour BURLYWOOD = new Colour("burlywood", Color.BURLYWOOD);
	public static final Colour CADETBLUE = new Colour("cadet blue", Color.CADETBLUE);
	public static final Colour CHARTREUSE = new Colour("chartreuse", Color.CHARTREUSE);
	public static final Colour CHOCOLATE = new Colour("chocolate", Color.CHOCOLATE);
	public static final Colour CORAL = new Colour("coral", Color.CORAL);
	public static final Colour CORNFLOWERBLUE = new Colour("cornflowe rblue", Color.CORNFLOWERBLUE);
	public static final Colour CORNSILK = new Colour("cornsilk", Color.CORNSILK);
	public static final Colour CRIMSON = new Colour("crimson", Color.CRIMSON);
	public static final Colour CYAN = new Colour("cyan", Color.CYAN);
	public static final Colour DARKBLUE = new Colour("dark blue", Color.DARKBLUE);
	public static final Colour DARKCYAN = new Colour("dark cyan", Color.DARKCYAN);
	public static final Colour DARKGOLDENROD = new Colour("dark goldenrod", Color.DARKGOLDENROD);
	public static final Colour DARKGRAY = new Colour("dark gray", Color.DARKGRAY);
	public static final Colour DARKGREEN = new Colour("dark green", Color.DARKGREEN);
	public static final Colour DARKGREY = new Colour("dark grey", Color.DARKGREY);
	public static final Colour DARKKHAKI = new Colour("dark khaki", Color.DARKKHAKI);
	public static final Colour DARKMAGENTA = new Colour("dark magenta", Color.DARKMAGENTA);
	public static final Colour DARKOLIVEGREEN = new Colour("dark olivegreen", Color.DARKOLIVEGREEN);
	public static final Colour DARKORANGE = new Colour("dark orange", Color.DARKORANGE);
	public static final Colour DARKORCHID = new Colour("dark orchid", Color.DARKORCHID);
	public static final Colour DARKRED = new Colour("dark red", Color.DARKRED);
	public static final Colour DARKSALMON = new Colour("dark salmon", Color.DARKSALMON);
	public static final Colour DARKSEAGREEN = new Colour("dark seagreen", Color.DARKSEAGREEN);
	public static final Colour DARKSLATEBLUE = new Colour("dark slate blue", Color.DARKSLATEBLUE);
	public static final Colour DARKSLATEGRAY = new Colour("dark slate gray", Color.DARKSLATEGRAY);
	public static final Colour DARKSLATEGREY = new Colour("dark slate grey", Color.DARKSLATEGREY);
	public static final Colour DARKTURQUOISE = new Colour("dark turquoise", Color.DARKTURQUOISE);
	public static final Colour DARKVIOLET = new Colour("dark violet", Color.DARKVIOLET);
	public static final Colour DEEPPINK = new Colour("deep pink", Color.DEEPPINK);
	public static final Colour DEEPSKYBLUE = new Colour("deep sky blue", Color.DEEPSKYBLUE);
	public static final Colour DIMGRAY = new Colour("dim gray", Color.DIMGRAY);
	public static final Colour DIMGREY = new Colour("dim grey", Color.DIMGREY);
	public static final Colour DODGERBLUE = new Colour("dodger blue", Color.DODGERBLUE);
	public static final Colour FIREBRICK = new Colour("firebrick", Color.FIREBRICK);
	public static final Colour FLORALWHITE = new Colour("floral white", Color.FLORALWHITE);
	public static final Colour FORESTGREEN = new Colour("forest green", Color.FORESTGREEN);
	public static final Colour FUCHSIA = new Colour("fuchsia", Color.FUCHSIA);
	public static final Colour GAINSBORO = new Colour("gainsboro", Color.GAINSBORO);
	public static final Colour GHOSTWHITE = new Colour("ghost white", Color.GHOSTWHITE);
	public static final Colour GOLD = new Colour("gold", Color.GOLD);
	public static final Colour GOLDENROD = new Colour("goldenrod", Color.GOLDENROD);
	public static final Colour GRAY = new Colour("gray", Color.GRAY);
	public static final Colour GREEN = new Colour("green", Color.GREEN);
	public static final Colour GREENYELLOW = new Colour("green-yellow", Color.GREENYELLOW);
	public static final Colour GREY = new Colour("grey", Color.GREY);
	public static final Colour HONEYDEW = new Colour("honeydew", Color.HONEYDEW);
	public static final Colour HOTPINK = new Colour("hot pink", Color.HOTPINK);
	public static final Colour INDIANRED = new Colour("indian red", Color.INDIANRED);
	public static final Colour INDIGO = new Colour("indigo", Color.INDIGO);
	public static final Colour IVORY = new Colour("ivory", Color.IVORY);
	public static final Colour KHAKI = new Colour("khaki", Color.KHAKI);
	public static final Colour LAVENDER = new Colour("lavender", Color.LAVENDER);
	public static final Colour LAVENDERBLUSH = new Colour("lavender blush", Color.LAVENDERBLUSH);
	public static final Colour LAWNGREEN = new Colour("lawn green", Color.LAWNGREEN);
	public static final Colour LEMONCHIFFON = new Colour("lemon-chiffon", Color.LEMONCHIFFON);
	public static final Colour LIGHTBLUE = new Colour("light blue", Color.LIGHTBLUE);
	public static final Colour LIGHTCORAL = new Colour("light coral", Color.LIGHTCORAL);
	public static final Colour LIGHTCYAN = new Colour("light cyan", Color.LIGHTCYAN);
	public static final Colour LIGHTGOLDENRODYELLOW = new Colour("light goldenrodyellow", Color.LIGHTGOLDENRODYELLOW);
	public static final Colour LIGHTGRAY = new Colour("light gray", Color.LIGHTGRAY);
	public static final Colour LIGHTGREEN = new Colour("light green", Color.LIGHTGREEN);
	public static final Colour LIGHTGREY = new Colour("light grey", Color.LIGHTGREY);
	public static final Colour LIGHTPINK = new Colour("light pink", Color.LIGHTPINK);
	public static final Colour LIGHTSALMON = new Colour("light salmon", Color.LIGHTSALMON);
	public static final Colour LIGHTSEAGREEN = new Colour("light sea green", Color.LIGHTSEAGREEN);
	public static final Colour LIGHTSKYBLUE = new Colour("light sky blue", Color.LIGHTSKYBLUE);
	public static final Colour LIGHTSLATEGRAY = new Colour("light slate gray", Color.LIGHTSLATEGRAY);
	public static final Colour LIGHTSLATEGREY = new Colour("light slate grey", Color.LIGHTSLATEGREY);
	public static final Colour LIGHTSTEELBLUE = new Colour("light steel blue", Color.LIGHTSTEELBLUE);
	public static final Colour LIGHTYELLOW = new Colour("light yellow", Color.LIGHTYELLOW);
	public static final Colour LIME = new Colour("lime", Color.LIME);
	public static final Colour LIMEGREEN = new Colour("lime green", Color.LIMEGREEN);
	public static final Colour LINEN = new Colour("linen", Color.LINEN);
	public static final Colour MAGENTA = new Colour("magenta", Color.MAGENTA);
	public static final Colour MAROON = new Colour("maroon", Color.MAROON);
	public static final Colour MEDIUMAQUAMARINE = new Colour("medium aquamarine", Color.MEDIUMAQUAMARINE);
	public static final Colour MEDIUMBLUE = new Colour("medium blue", Color.MEDIUMBLUE);
	public static final Colour MEDIUMORCHID = new Colour("medium orchid", Color.MEDIUMORCHID);
	public static final Colour MEDIUMPURPLE = new Colour("medium purple", Color.MEDIUMPURPLE);
	public static final Colour MEDIUMSEAGREEN = new Colour("medium seagreen", Color.MEDIUMSEAGREEN);
	public static final Colour MEDIUMSLATEBLUE = new Colour("medium slateblue", Color.MEDIUMSLATEBLUE);
	public static final Colour MEDIUMSPRINGGREEN = new Colour("medium springgreen", Color.MEDIUMSPRINGGREEN);
	public static final Colour MEDIUMTURQUOISE = new Colour("medium turquoise", Color.MEDIUMTURQUOISE);
	public static final Colour MEDIUMVIOLETRED = new Colour("medium violetred", Color.MEDIUMVIOLETRED);
	public static final Colour MIDNIGHTBLUE = new Colour("midnight blue", Color.MIDNIGHTBLUE);
	public static final Colour MINTCREAM = new Colour("mint cream", Color.MINTCREAM);
	public static final Colour MISTYROSE = new Colour("misty rose", Color.MISTYROSE);
	public static final Colour MOCCASIN = new Colour("moccasin", Color.MOCCASIN);
	public static final Colour NAVAJOWHITE = new Colour("navajo white", Color.NAVAJOWHITE);
	public static final Colour NAVY = new Colour("navy", Color.NAVY);
	public static final Colour OLDLACE = new Colour("old lace", Color.OLDLACE);
	public static final Colour OLIVE = new Colour("olive", Color.OLIVE);
	public static final Colour OLIVEDRAB = new Colour("olive drab", Color.OLIVEDRAB);
	public static final Colour ORANGE = new Colour("orange", Color.ORANGE);
	public static final Colour ORANGERED = new Colour("orange-red", Color.ORANGERED);
	public static final Colour ORCHID = new Colour("orchid", Color.ORCHID);
	public static final Colour PALEGOLDENROD = new Colour("pale goldenrod", Color.PALEGOLDENROD);
	public static final Colour PALEGREEN = new Colour("pale green", Color.PALEGREEN);
	public static final Colour PALETURQUOISE = new Colour("pale turquoise", Color.PALETURQUOISE);
	public static final Colour PALEVIOLETRED = new Colour("pale violet-red", Color.PALEVIOLETRED);
	public static final Colour PAPAYAWHIP = new Colour("papaya whip", Color.PAPAYAWHIP);
	public static final Colour PEACHPUFF = new Colour("peach puff", Color.PEACHPUFF);
	public static final Colour PERU = new Colour("peru", Color.PERU);
	public static final Colour PINK = new Colour("pink", Color.PINK);
	public static final Colour PLUM = new Colour("plum", Color.PLUM);
	public static final Colour POWDERBLUE = new Colour("powder blue", Color.POWDERBLUE);
	public static final Colour PURPLE = new Colour("purple", Color.PURPLE);
	public static final Colour RED = new Colour("red", Color.RED);
	public static final Colour ROSYBROWN = new Colour("rosy brown", Color.ROSYBROWN);
	public static final Colour ROYALBLUE = new Colour("royal blue", Color.ROYALBLUE);
	public static final Colour SADDLEBROWN = new Colour("saddle brown", Color.SADDLEBROWN);
	public static final Colour SALMON = new Colour("salmon", Color.SALMON);
	public static final Colour SANDYBROWN = new Colour("sandy brown", Color.SANDYBROWN);
	public static final Colour SEAGREEN = new Colour("sea green", Color.SEAGREEN);
	public static final Colour SEASHELL = new Colour("seashell", Color.SEASHELL);
	public static final Colour SIENNA = new Colour("sienna", Color.SIENNA);
	public static final Colour SILVER = new Colour("silver", Color.SILVER);
	public static final Colour SKYBLUE = new Colour("sky blue", Color.SKYBLUE);
	public static final Colour SLATEBLUE = new Colour("slate blue", Color.SLATEBLUE);
	public static final Colour SLATEGRAY = new Colour("slate gray", Color.SLATEGRAY);
	public static final Colour SLATEGREY = new Colour("slate grey", Color.SLATEGREY);
	public static final Colour SNOW = new Colour("snow", Color.SNOW);
	public static final Colour SPRINGGREEN = new Colour("spring green", Color.SPRINGGREEN);
	public static final Colour STEELBLUE = new Colour("steel blue", Color.STEELBLUE);
	public static final Colour TAN = new Colour("tan", Color.TAN);
	public static final Colour TEAL = new Colour("teal", Color.TEAL);
	public static final Colour THISTLE = new Colour("thistle", Color.THISTLE);
	public static final Colour TOMATO = new Colour("tomato", Color.TOMATO);
	public static final Colour TURQUOISE = new Colour("turquoise", Color.TURQUOISE);
	public static final Colour VIOLET = new Colour("violet", Color.VIOLET);
	public static final Colour WHEAT = new Colour("wheat", Color.WHEAT);
	public static final Colour WHITE = new Colour("white", Color.WHITE);
	public static final Colour WHITESMOKE = new Colour("white smoke", Color.WHITESMOKE);
	public static final Colour YELLOW = new Colour("yellow", Color.YELLOW);
	public static final Colour YELLOWGREEN = new Colour("yellow-green", Color.YELLOWGREEN);

	public final StringProperty nameProperty() {
		return nameProperty;
	}

	public final String getName() {
		return this.nameProperty().get();
	}

	public final void setName(final String name) {
		this.nameProperty().set(name);
	}

	public final ObjectProperty<Color> colorProperty() {
		return this.color;
	}

	public final Color getColor() {
		return color.get();
	}

	public final void setColor(final Color color) {
		this.colorProperty().set(color);
	}
}
