package util

import java.nio.file.Paths
import java.util.Collection
import javafx.scene.image.Image

class Util {
	def static <T> String commaSeparate(Collection<T> collection) {
		return collection.map[toString].join(", ")
	}

	def static Image loadImage(String... pathComponents) {
		val path = Paths.get("res", pathComponents)
		val absolutePath = path.toAbsolutePath
		val image = new Image(absolutePath.toUri().toString())

		return image
	}
}
