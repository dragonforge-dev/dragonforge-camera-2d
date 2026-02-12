@tool
extends EditorPlugin

const AUTOLOAD_CAMERA_2D_SIGNAL_BUS = "Camera2DSignalBus"
const ZOOM_IN = "zoom_in"
const ZOOM_OUT = "zoom_out"
const MOUSE_WHEEL_ZOOM_IN = "mouse_wheel_zoom_in"
const MOUSE_WHEEL_ZOOM_OUT = "mouse_wheel_zoom_out"
const PAN_LEFT = "pan_left"
const PAN_RIGHT = "pan_right"
const PAN_UP = "pan_up"
const PAN_DOWN = "pan_down"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_CAMERA_2D_SIGNAL_BUS, "res://addons/dragonforge_camera_2d/camera_2d_signal_bus.tscn")
	Action.add(ZOOM_IN, Action.joy_axis(JOY_AXIS_TRIGGER_RIGHT, Action.AXIS_DOWN), Action.key(KEY_PAGEUP))
	Action.add(ZOOM_OUT, Action.joy_axis(JOY_AXIS_TRIGGER_LEFT, Action.AXIS_DOWN), Action.key(KEY_PAGEDOWN))
	Action.add(MOUSE_WHEEL_ZOOM_IN, Action.mouse_button(MOUSE_BUTTON_WHEEL_UP))
	Action.add(MOUSE_WHEEL_ZOOM_OUT, Action.mouse_button(MOUSE_BUTTON_WHEEL_DOWN))
	Action.add(PAN_LEFT, Action.joy_axis(JOY_AXIS_RIGHT_X, Action.AXIS_LEFT), Action.key(KEY_KP_4))
	Action.add(PAN_RIGHT, Action.joy_axis(JOY_AXIS_RIGHT_X, Action.AXIS_RIGHT), Action.key(KEY_KP_6))
	Action.add(PAN_UP, Action.joy_axis(JOY_AXIS_RIGHT_Y, Action.AXIS_UP), Action.key(KEY_KP_8))
	Action.add(PAN_DOWN, Action.joy_axis(JOY_AXIS_RIGHT_Y, Action.AXIS_DOWN), Action.key(KEY_KP_2))
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_CAMERA_2D_SIGNAL_BUS)
	Action.remove(ZOOM_IN)
	Action.remove(ZOOM_OUT)
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")
