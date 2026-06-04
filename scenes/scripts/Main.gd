extends Control

var tiles := []

const PIPE_SCENE = preload("res://scenes/board/Pipe.tscn")

@onready var grid = $GridContainer

func _ready():
	for y in range(6):
		var row := []
		
		for x in range(6):
			var tile = PIPE_SCENE.instantiate()
			
			tile.set_grid_position(x, y)
			
			grid.add_child(tile)
			row.append(tile)
			
		tiles.append(row)
