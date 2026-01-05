@tool
extends EditorPlugin

const AUTOLOAD_CAMERA_2D_SIGNAL_BUS = "Camera2DSignalBus"
const ZOOM_IN = "zoom_in"
const ZOOM_OUT = "zoom_out"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_CAMERA_2D_SIGNAL_BUS, "res://addons/dragonforge_camera_2d/camera_2d_signal_bus.gd")
	Action.add(ZOOM_IN, Action.joy_axis(JOY_AXIS_RIGHT_Y, Action.AXIS_UP), Action.mouse_button(MOUSE_BUTTON_WHEEL_UP), Action.key(KEY_PAGEUP))
	Action.add(ZOOM_OUT, Action.joy_axis(JOY_AXIS_RIGHT_Y, Action.AXIS_DOWN), Action.mouse_button(MOUSE_BUTTON_WHEEL_DOWN), Action.key(KEY_PAGEDOWN))
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_CAMERA_2D_SIGNAL_BUS)
	Action.remove(ZOOM_IN)
	Action.remove(ZOOM_OUT)
	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")
