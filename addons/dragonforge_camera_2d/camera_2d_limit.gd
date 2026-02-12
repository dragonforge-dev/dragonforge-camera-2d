@tool
@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/limit.svg")
## Adding this component to a [Camera2D] restricts it to the to the used area of
## a [TileMapLayer] or [Rect2i].
class_name Camera2DLimit extends Camera2DComponent

## The [TileMapLayer] to use to restrict the atttached [Camera2D]'s limits.
@export var tile_map_layer: TileMapLayer:
	set(value):
		tile_map_layer = value
		if _is_camera_ready and tile_map_layer:
			set_tile_map_layer_limit(tile_map_layer)
		update_configuration_warnings()

var _is_camera_ready = false


func _ready() -> void:
	get_parent().ready.connect(_on_parent_ready)
	if not Camera2DSignalBus.is_node_ready(): 
		await Camera2DSignalBus.ready
	Camera2DSignalBus.update_camera_boundaries.connect(set_tile_map_layer_limit)


func _on_parent_ready() -> void:
	_enter_tree()


## Sets the attached camera's boundaries to be that of the passed [Rect2i]
## [param limit].
func set_limit(limit: Rect2i) -> void:
	camera.limit_top = limit.position.y
	camera.limit_left = limit.position.x
	camera.limit_bottom = limit.end.y
	camera.limit_right = limit.end.x


## Sets the attached camera's boundaries to be that of the used tiles on the
## passed [param tile_map_layer]. [b]NOTE:[/b] It is recommended to use
## [signal Camera2DSignalBus.update_camera_boundaries] to trigger this
## functionality.
func set_tile_map_layer_limit(tile_map_layer: TileMapLayer) -> void:
	var map_boundaries: Rect2i = tile_map_layer.get_used_rect()
	var tile_size: Vector2i
	tile_size.x = tile_map_layer.tile_set.tile_size.x
	tile_size.y = tile_map_layer.tile_set.tile_size.y
	map_boundaries.position *= tile_size
	map_boundaries.size *= tile_size
	set_limit(map_boundaries)


# Configure limits if the node is added during execution instead of in the
# editor.
func _enter_tree() -> void:
	super()
	if camera is Camera2D:
		_is_camera_ready = true
	if tile_map_layer:
		set_tile_map_layer_limit(tile_map_layer)


# Reset camera limits in case we are removing this node from the tree.
func _exit_tree() -> void:
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
