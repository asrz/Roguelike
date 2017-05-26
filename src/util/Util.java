package util;


import java.util.Collection;
import java.util.stream.Collectors;


public class Util {
	public static <T> String commaSeparate(Collection<T> collection) {
		return collection.stream()
				.map(Object::toString)
				.collect(Collectors.joining(", "));
	}
}
