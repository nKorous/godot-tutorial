class_name Grid
extends Resource

# Gird's size in rows and columns
export var size := Vector2(20, 20)

# this of a cell in pixels
export var cell_size := Vector2(80, 80)

# half of 'cell_size'
# will  use this to calculate the center of a grid cell in pixels, on the screen
# this is how we can place units in the middle of the cell
var _half_cell_size = cell_size / 2

# return the position of a cell's center in px
# we'll place units and have them move through cells using this function
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size

# Returns the coordinates of the cell on the grid given a position on the map
# this is the complementary of 'calculate_map_position()' above
# when designing a level, you'll place units visually in the editor. we'll use this function to find
# the grid coords they're placed on, and call 'calculate_map_position()' to snap them to the 
# cell's center
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()

# returns true if the 'cell_coordinates' are within the grid
# this methos and the following one allow us to ensure the cursor or units can never go past the
# maps limits
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

# makes the 'grid_position' fit within the grid'd bounds.
# this is a clamp function designed specifically for our grid coordinates.
# the Vector2 class comes with its 'Vector2.clamp()' method, but it doesn't work the same way: it
# limits the vector's length instead of clamping each of the vector's components individually
# that's why we need to code a new method
func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out

# Given Vector2 coords, calculates and returns the corresponding int index. You can use
# this function to convert 2D coords to a 1D array's indices.
#
# There are two cases where you need to convert coords like so
# 1. We'll need it for the AStar algorithm, which requires a unique index for each point on the
# graph it uses to find a path.
# 2. you can use it for performance. More on the below
func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
