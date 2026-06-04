extends Control

enum PipeType {
	STRAIGHT,
	CORNER
}

var pipe_type: PipeType = PipeType.STRAIGHT
var rotation_state := 0
var grid_x := 0
var grid_y := 0

func _ready():
	custom_minimum_size = Vector2(64, 64)
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	if randi() % 2 == 0:
		pipe_type = PipeType.STRAIGHT
	else:
		pipe_type = PipeType.CORNER
	
	rotation_state = randi() % 4
	queue_redraw()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		rotation_state = (rotation_state + 1) % 4
		queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.12, 0.12, 0.16))

	match pipe_type:
		PipeType.STRAIGHT:
			draw_straight()
		PipeType.CORNER:
			draw_corner()

func draw_straight():
	var center := size / 2.0
	var thickness := 10.0
	
	if rotation_state % 2 == 0:
		draw_line(Vector2(0, center.y), Vector2(size.x, center.y), Color.WHITE, thickness)
	else:
		draw_line(Vector2(center.x, 0), Vector2(center.x, size.y), Color.WHITE, thickness)

func draw_corner():
	var center := size / 2.0
	var thickness := 10.0

	var dirs = [
		[Vector2.LEFT, Vector2.UP],
		[Vector2.UP, Vector2.RIGHT],
		[Vector2.RIGHT, Vector2.DOWN],
		[Vector2.DOWN, Vector2.LEFT],
	]

	for dir in dirs[rotation_state]:
		draw_line(center, center + dir * center, Color.WHITE, thickness)

func get_connections() -> Array[Vector2i]:
	if pipe_type == PipeType.STRAIGHT:
		if rotation_state % 2 == 0:
			return [Vector2i.LEFT, Vector2i.RIGHT]
		else:
			return [Vector2i.UP, Vector2i.DOWN]
	
	if pipe_type == PipeType.CORNER:
		var dirs = [
			[Vector2i.LEFT, Vector2i.UP],      # ┘
			[Vector2i.UP, Vector2i.RIGHT],     # └
			[Vector2i.RIGHT, Vector2i.DOWN],   # ┌
			[Vector2i.DOWN, Vector2i.LEFT],    # ┐
		]
		
		return dirs[rotation_state]

	return []

func set_grid_position(x: int, y: int):
	grid_x = x
	grid_y = y
