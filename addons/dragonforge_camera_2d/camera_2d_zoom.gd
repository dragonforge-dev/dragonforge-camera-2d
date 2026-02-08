@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/zoom.svg")
@tool
class_name Camera2DZoom extends Camera2DComponent

const ZOOM_IN = "zoom_in"
const ZOOM_OUT = "zoom_out"
const MOUSE_WHEEL_ZOOM_IN = "mouse_wheel_zoom_in"
const MOUSE_WHEEL_ZOOM_OUT = "mouse_wheel_zoom_out"

@export var zoom_in_max := 1.0
@export var zoom_out_max := 0.5
@export var controller_zoom_speed: float = 1.0
@export var mouse_zoom_step: float = 0.2
@export var mouse_zoom_speed: float = 0.1


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Input.is_action_pressed(ZOOM_IN):
			if camera.zoom < zoom_in_max * Vector2.ONE:
				camera.zoom += Vector2.ONE * controller_zoom_speed * delta
		if Input.is_action_pressed(ZOOM_OUT):
			if camera.zoom > zoom_out_max * Vector2.ONE:
				camera.zoom -= Vector2.ONE * controller_zoom_speed * delta


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event is InputEventMouseButton:
			if event.is_action_pressed(MOUSE_WHEEL_ZOOM_IN):
				zoom(-mouse_zoom_step)
			if event.is_action_pressed(MOUSE_WHEEL_ZOOM_OUT):
				zoom(mouse_zoom_step)


func zoom(zoom_step: float) -> void:
	var zoom_level = clampf(camera.zoom.x - zoom_step, zoom_out_max, zoom_in_max)
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(zoom_level, zoom_level), mouse_zoom_speed)
