package util;

import java.util.function.Predicate;

public class Predicates {
	
	public static <T> Predicate<T> not(Predicate<T> predicate) {
		return predicate.negate();
	}
	
	public static <T> Predicate<T> constant(boolean result) {
		return t -> result;
	}
}
