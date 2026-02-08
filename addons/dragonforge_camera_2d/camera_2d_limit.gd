@tool
@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/limit.svg")
class_name Camera2DLimit extends Camera2DComponent

@export var tile_map_layer: TileMapLayer:
	set(value):
		tile_map_layer = value
		if is_camera_ready and tile_map_layer:
			set_tile_map_layer_limit(tile_map_layer)
		update_configuration_warnings()

var is_camera_ready = false

func _ready() -> void:
	get_parent().ready.connect(_on_parent_ready)


func set_limit(limit: Rect2i) -> void:
	camera.limit_top = limit.position.y
	camera.limit_left = limit.position.x
	camera.limit_bottom = limit.end.y
	camera.limit_right = limit.end.x


## Sets the camera's boundaries to be that of the used tiles on the passed
## TileMapLayer.
func set_tile_map_layer_limit(tile_map_layer: TileMapLayer) -> void:
	var map_boundaries: Rect2i = tile_map_layer.get_used_rect()
	var tile_size: Vector2i
	tile_size.x = tile_map_layer.tile_set.tile_size.x
	tile_size.y = tile_map_layer.tile_set.tile_size.y
	map_boundaries.position *= tile_size
	map_boundaries.size *= tile_size
	set_limit(map_boundaries)


func _on_parent_ready() -> void:
	_enter_tree()


func _enter_tree() -> void:
	super()
	if camera is Camera2D:
		is_camera_ready = true
	if tile_map_layer:
		set_tile_map_layer_limit(tile_map_layer)

func _exit_tree() -> void:
	# Reset camera limits in case we are removing this node from the tree.
	if camera is Camera2D:
		camera.limit_top = -10000000
		camera.limit_left = -10000000
		camera.limit_bottom = 10000000
		camera.limit_right = 10000000

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not camera is Camera2D:
		warnings.append("Camera2DLimit only serves to provide modifications to Camera2D derived nodes. Please only use it as a child of a Camera2D to modify it.")
	if not tile_map_layer:
		warnings.append("A tile map layer must be provided for Camera2DLimit to function. Please attach a TileMapLayer to it!")
	return warnings
