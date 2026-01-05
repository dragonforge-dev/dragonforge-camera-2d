class_name BoundCamera2D extends Camera2D


func _ready() -> void:
	Camera2DSignalBus.update_camera_boundaries.connect(_update_camera_boundaries)


## Sets the camera's boundaries to be that of the used tiles on the passed
## TileMapLayer.
func _update_camera_boundaries(tile_map_layer: TileMapLayer) -> void:
	var map_boundaries: Rect2i = tile_map_layer.get_used_rect()
	var tile_size: Vector2i
	tile_size.x = tile_map_layer.tile_set.tile_size.x
	tile_size.y = tile_map_layer.tile_set.tile_size.y
	map_boundaries.position *= tile_size
	map_boundaries.size *= tile_size
	limit_top = map_boundaries.position.y
	limit_left = map_boundaries.position.x
	limit_bottom = map_boundaries.end.y
	limit_right = map_boundaries.end.x


# TODO: Add edge camera panning
# TODO: Camera gets panning input and fills queue if panning signals are sent to edge of screen
# TODO: Camera shouldn't pan if mouse cursor is outside of window.
# TODO: Camera edge panning should be triple for mouse (compared to old version of game.)
# TODO: The closer the mouse to screen edge, the faster the pan
# TODO: Right stick pan should accelerate after one second. (Maybe smooth panning speed increase? Maybe after 0.5 seconds?)
