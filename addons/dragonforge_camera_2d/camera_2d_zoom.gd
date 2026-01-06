@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/zoom.svg")
@tool
class_name Camera2DZoom extends Camera2DComponent

@export var zoom_in_max := Vector2(1.0, 1.0)
@export var zoom_out_max := Vector2(0.5, 0.5)
@export var zoom_step := Vector2.ONE
@export var zoom_speed: float = 0.2

var zoom_target := 1.0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("zoom_in"):
		if camera.zoom < zoom_in_max:
			camera.zoom += zoom_step * delta
	if Input.is_action_pressed("zoom_out"):
		if camera.zoom > zoom_out_max:
			camera.zoom -= zoom_step * delta
