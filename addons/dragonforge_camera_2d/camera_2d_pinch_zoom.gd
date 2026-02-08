@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/pinch.svg")
@tool
class_name Camera2DPinchZoom extends Camera2DComponent

@export var zoom_in_max := 1.0
@export var zoom_out_max := 0.5

var touches := {}
var start_distance := 0.0


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event is InputEventScreenTouch:
			if event.pressed:
				touches[event.index] = event.position
			else:
				touches.erase(event.index)
		elif event is InputEventScreenDrag:
			touches[event.index] = event.position
	
		finger_count_check()


func finger_count_check() -> void:
	if touches.size() == 2:
		var fingers = touches.values()
		pinch_zoom(fingers[0].distance_to(fingers[1]))
	else:
		start_distance = 0.0


func pinch_zoom(current_distance: float) -> void:
	if start_distance == 0.0:
		start_distance = current_distance
	else:
		var zoom_factor: float = current_distance / start_distance
		camera.zoom = clamp(camera.zoom * zoom_factor, Vector2.ONE * zoom_in_max, Vector2.ONE * zoom_out_max)
