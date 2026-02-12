@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/zoom.svg")
@tool
## Adding this component to a [Camera2D] allows the user to zoom in and out
## using the mouse wheel, keyboard, or controller. For pinch zoom support, see
## the [Camera2DPinchZoom] component.
class_name Camera2DZoom extends Camera2DComponent

## Remap the "zoom_in" [Action] to change the controls to zoom in.
const ZOOM_IN = "zoom_in"
## Remap the "zoom_out" [Action] to change the controls to zoom out.
const ZOOM_OUT = "zoom_out"
## Zoom in [Action] only used by the wheel mouse.
const MOUSE_WHEEL_ZOOM_IN = "mouse_wheel_zoom_in"
## Zoom out [Action] only used by the wheel mouse.
const MOUSE_WHEEL_ZOOM_OUT = "mouse_wheel_zoom_out"

## The amount the player can zoom in. 1.0 means they cannot zoom in, and
## anything higher allows zooming in.
@export_range(1.0, 5.0, 0.01) var zoom_in_max := 1.0
## The amount the player can zoom out. 1.0 means they cannot zoom out, and
## anything lower allows zooming out.
@export_range(0.001, 1.0, 0.01) var zoom_out_max := 0.5
## The speed at which the controller (and keyboard keys) adjust the zoom level.
@export var controller_zoom_speed: float = 1.0
## The amount the zoom level is changed for every click of the wheel mouse.
@export var mouse_zoom_step: float = 0.2
## The amount of time it takes for the mouse wheel zoom animation to play for
## each zoom step.
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
				_zoom_by_step(-mouse_zoom_step)
			if event.is_action_pressed(MOUSE_WHEEL_ZOOM_OUT):
				_zoom_by_step(mouse_zoom_step)


# Used by the mouse wheel code to zoom in and out by a certain step.
func _zoom_by_step(zoom_step: float) -> void:
	var zoom_level = clampf(camera.zoom.x - zoom_step, zoom_out_max, zoom_in_max)
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(zoom_level, zoom_level), mouse_zoom_speed)
