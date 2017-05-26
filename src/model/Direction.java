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

	public void setX(int x) {
		this.x = x;
	}

	public int getY() {
		return y;
	}

	public void setY(int y) {
		this.y = y;
	}

	public int getZ() {
		return z;
	}

	public void setZ(int z) {
		this.z = z;
	}

	public static Direction getDirection(int x, int y) {
		int x2 = (x == 0 ? 0 : (x > 0 ? 1 : -1));
		int y2 = (y == 0 ? 0 : (y > 0 ? 1 : -1));

		switch (x2) {
			case -1:
				switch (y2) {
					case -1:
						return NORTHWEST;
					case 0:
						return WEST;
					case 1:
						return SOUTHWEST;
				}
			case 0:
				switch (y2) {
					case -1:
						return NORTH;
					case 0:
						return ZERO;
					case 1:
						return SOUTH;
				}
			case 1:
				switch (y2) {
					case -1:
						return NORTHEAST;
					case 0:
						return EAST;
					case 1:
						return SOUTHEAST;
				}
		}
		return ZERO;
	}
}
