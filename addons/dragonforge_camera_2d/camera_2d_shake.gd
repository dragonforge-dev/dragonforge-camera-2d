@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/shake.svg")
@tool
class_name Camera2DShake extends Camera2DComponent

## The duration in seconds for the screen shake and controller vibration.
@export var duration: float = 0.5
## The duration in seconds the screen shake stops before starting again when
## [member is_shaking] is set to `true`.
@export var interval: float = 0.5
## The instenseity of the screen shake.
@export var intensity: float = 1.0
## The intensity of the controller vibration with the weak motors.
## A value of 0.0 is off.
## Hard-coded to only shake the first connected controller.
## (Typically located at the top of the controller.)
@export_range(0.0, 1.0, 0.01) var controller_weak_vibration: float = 0.5
## The intensity of the controller vibration with the strong motors.
## A value of 0.0 is off.
## Hard-coded to only shake the first connected controller.
## (Typically located at the bottom of the controller.)
@export_range(0.0, 1.0, 0.01) var controller_strong_vibration: float = 0.5

var _is_shaking: bool = false
var _is_shake_complete: bool = true
var _tween: Tween
var _interval_timer: Timer


func _ready() -> void:
	_interval_timer = Timer.new()
	_interval_timer.one_shot = true
	add_child(_interval_timer)


func _process(_delta: float) -> void:
	if _is_shaking:
		shake()


## Shakes the screen once and vibrates the default controller.
func shake() -> void:
	if not _interval_timer.is_stopped(): # Can't start a new shake in the middle of an existing shake.
		return
	_interval_timer.start(duration + interval)
	vibrate_controller()
	shake_screen()


## Starts continuous shaking.
func start() -> void:
	shake()
	_is_shaking = true


## Stops continuous shaking.
func stop() -> void:
	_is_shaking = false
	_tween.kill()
	camera.offset = Vector2.ZERO
	Input.stop_joy_vibration(0)
	_interval_timer.stop()


## Shakes the screen for the set [member duration] at the [member intensity] set.
func shake_screen() -> void:
	_tween = create_tween()
	_tween.tween_property(camera, "offset", Vector2(randf_range(-2, -1) * intensity, randf_range(2, 1) * intensity), duration / 5)
	_tween.tween_property(camera, "offset", Vector2(randf_range(2, 1) * intensity, randf_range(-2, -1) * intensity), duration / 5)
	_tween.tween_property(camera, "offset", Vector2(randf_range(-2, -1) * intensity, randf_range(-2, -1) * intensity), duration / 5)
	_tween.tween_property(camera, "offset", Vector2(randf_range(2, 1) * intensity, randf_range(2, 1) * intensity), duration / 5)
	_tween.tween_property(camera, "offset", Vector2.ZERO, duration / 5)


## Vibrates the connected [member device] (default to the first connected
## device) for the set [member duration] at the intensity set by
## [member controller_weak_vibration] and [member controller_strong_vibration].
## (Typically controlling the top and bottom vibration motors respectively.)
func vibrate_controller(device: int = 0) -> void:
	if controller_weak_vibration or controller_strong_vibration:
		Input.start_joy_vibration(device, controller_weak_vibration, controller_strong_vibration, duration)
