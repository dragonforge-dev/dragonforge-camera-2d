@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/pan.svg")
@tool
class_name Camera2DPan extends Camera2DComponent

@export var pan_speed = 40.0
const TOUCH_PAN_SPEED = 1.0
const EDGE_SCROLL_MARGIN = 50.0
const EDGE_SCROLL_SPEED = 20.0

var touch_points: Dictionary = {}
var _camera_boundaries: Rect2


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		var new_position = _handle_panning()
		if new_position == Vector2.ZERO:
			new_position = _handle_edge_movement()
		camera.position = (camera.position + new_position).clamp(_camera_boundaries.position, _camera_boundaries.end)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		if touch_points.size() == 1:
			var new_position = -event.relative * TOUCH_PAN_SPEED
			camera.position = (camera.position + new_position).clamp(_camera_boundaries.position, _camera_boundaries.end)


func _handle_panning() -> Vector2:
	var pan_direction = Input.get_vector("pan_camera_left", "pan_camera_right", "pan_camera_up", "pan_camera_down")
	return pan_direction * pan_speed


func _handle_edge_movement() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var visible_screen_size = get_viewport().get_visible_rect().size
	var pan_direction := Vector2.ZERO
	
	if mouse_pos.x < EDGE_SCROLL_MARGIN:
		pan_direction.x -= 1
	elif mouse_pos.x > visible_screen_size.x - EDGE_SCROLL_MARGIN:
		pan_direction.x += 1
	
	if mouse_pos.y < EDGE_SCROLL_MARGIN:
		pan_direction.y -= 1
	elif mouse_pos.y > visible_screen_size.y - EDGE_SCROLL_MARGIN:
		pan_direction.y += 1
	
	return pan_direction * EDGE_SCROLL_SPEED
