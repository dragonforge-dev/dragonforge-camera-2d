@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/pan.svg")
@tool
## Adding this component to a [Camera2D] allows the user to pan the camera
## using the mouse with edge detection (moving the mouse to the edge of the
## screen), keyboard, controller, or touch screen.
class_name Camera2DPan extends Camera2DComponent

## The speed of keyboard and controller panning mesured in pixels.
@export var pan_speed := 60.0
## The speed at which the screen pans when the user drags the screen.
@export var touch_pan_speed := 1.0
## The number of pixels at the edge of the acreen that trigger edge scrolling.
@export var edge_scroll_margin := 50.0
## The number of pixels panned by edge scrolling per second.
@export var edge_scroll_speed := 800.0

var _touch_points: Dictionary = {}
var _camera_boundaries: Rect2


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var new_position = _handle_panning()
		if new_position == Vector2.ZERO:
			new_position = _handle_edge_movement(delta)
		_camera_boundaries.position = Vector2(camera.limit_left, camera.limit_top)
		_camera_boundaries.end = Vector2(camera.limit_right, camera.limit_bottom)
		camera.position = (camera.position + new_position).clamp(_camera_boundaries.position, _camera_boundaries.end)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		_touch_points[event.index] = event.position
		if _touch_points.size() == 1:
			var new_position = -event.relative * touch_pan_speed
			camera.position = (camera.position + new_position).clamp(_camera_boundaries.position, _camera_boundaries.end)


func _handle_panning() -> Vector2:
	var pan_direction = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	return pan_direction * pan_speed


func _handle_edge_movement(delta: float) -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var visible_screen_size = get_viewport().get_visible_rect().size
	var pan_direction := Vector2.ZERO
	
	if mouse_pos.x < edge_scroll_margin:
		pan_direction.x -= 1
	elif mouse_pos.x > visible_screen_size.x - edge_scroll_margin:
		pan_direction.x += 1
	
	if mouse_pos.y < edge_scroll_margin:
		pan_direction.y -= 1
	elif mouse_pos.y > visible_screen_size.y - edge_scroll_margin:
		pan_direction.y += 1
	
	return pan_direction * edge_scroll_speed * delta
