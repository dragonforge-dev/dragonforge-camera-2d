@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/pinch.svg")
@tool
## Adding this component to a [Camera2D] allows the user to zoom in and out on
## a touch screen using pinch zoom. For zoom support with other input methods
## (mouse wheel, keyboard, or controller), see the [Camera2DZoom] component.
class_name Camera2DPinchZoom extends Camera2DComponent

## The amount the player can zoom in. 1.0 means they cannot zoom in, and
## anything higher allows zooming in.
@export_range(1.0, 5.0, 0.01) var zoom_in_max := 1.0
## The amount the player can zoom out. 1.0 means they cannot zoom out, and
## anything lower allows zooming out.
@export_range(0.001, 1.0, 0.01) var zoom_out_max := 0.5

var _touches := {}
var _start_distance := 0.0


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event is InputEventScreenTouch:
			if event.pressed:
				_touches[event.index] = event.position
			else:
				_touches.erase(event.index)
		elif event is InputEventScreenDrag:
			_touches[event.index] = event.position
	
		_finger_count_check()


func _finger_count_check() -> void:
	if _touches.size() == 2:
		var fingers = _touches.values()
		_pinch_zoom(fingers[0].distance_to(fingers[1]))
	else:
		_start_distance = 0.0


func _pinch_zoom(current_distance: float) -> void:
	if _start_distance == 0.0:
		_start_distance = current_distance
	else:
		var zoom_factor: float = current_distance / _start_distance
		camera.zoom = clamp(camera.zoom * zoom_factor, Vector2.ONE * zoom_in_max, Vector2.ONE * zoom_out_max)
