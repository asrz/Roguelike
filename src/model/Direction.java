package model;


public enum Direction {
	ZERO(0, 0, 0),

	NORTH(0, -1, 0),
	SOUTH(0, 1, 0),
	WEST(-1, 0, 0),
	EAST(1, 0, 0),

	UP(0, 0, 1),
	DOWN(0, 0, -1),

	SOUTHWEST(-1, 1, 0),
	SOUTHEAST(1, 1, 0),
	NORTHWEST(-1, -1, 0),
	NORTHEAST(1, -1, 0);

	private int x;
	private int y;
	private int z;

	Direction(int x, int y, int z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public int getX() {
		return x;
	}

	public int getY() {
		return y;
	}

	public int getZ() {
		return z;
	}

	public static Direction getDirection(int x, int y) {
		int x2 = (x == 0 ? 0 : (x > 0 ? 1 : -1));
		int y2 = (y == 0 ? 0 : (y > 0 ? 1 : -1));

		for (Direction direction : values()) {
			if (direction.getX() == x2 && direction.getY() == y2) {
				return direction;
			}
		}
		return ZERO;
	}
}
