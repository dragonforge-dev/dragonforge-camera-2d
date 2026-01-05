class_name Action extends Object
## Helper class to create and add actions when a plugin is activated, and
## likewise remove actions when the plugin is deactivated.
## [br] [br]
## Plugin Example Code:
## [codeblock]
## @tool
## extends EditorPlugin
##
## const AUTOLOAD_CAMERA_2D_SIGNAL_BUS = "Camera2DSignalBus"
## const MOVE_UP = "move_up"
## const MOVE_DOWN = "move_down"
## const MOVE_LEFT = "move_left"
## const MOVE_RIGHT = "move_left"
## const JUMP = "jump"
## const FIRE = "fire"
##
##
## func _enable_plugin() -> void:
##	Action.add(MOVE_UP, Action.joy_axis(JOY_AXIS_LEFT_Y, Action.AXIS_UP), Action.key(KEY_UP), Action.key(KEY_W))
##	Action.add(MOVE_DOWN, Action.joy_axis(JOY_AXIS_LEFT_Y, Action.AXIS_DOWN), Action.key(KEY_DOWN), Action.key(KEY_S))
##	Action.add(MOVE_LEFT, Action.joy_axis(JOY_AXIS_LEFT_X, Action.AXIS_LEFT), Action.key(KEY_LEFT), Action.key(KEY_A))
##	Action.add(MOVE_RIGHT, Action.joy_axis(JOY_AXIS_LEFT_X, Action.AXIS_RIGHT), Action.key(KEY_RIGHT), Action.key(KEY_D))
##	Action.add(JUMP, Action.joy_button(JOY_BUTTON_A), Action.mouse_button(MOUSE_BUTTON_RIGHT), Action.key(KEY_SPACE))
##	Action.add(FIRE, Action.joy_axis(JOY_AXIS_TRIGGER_RIGHT), Action.mouse_button(MOUSE_BUTTON_LEFT), Action.key(KEY_CTRL))
##	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")
##
##
## func _disable_plugin() -> void:
##	Action.remove(MOVE_UP)
##	Action.remove(MOVE_DOWN)
##	Action.remove(MOVE_LEFT)
##	Action.remove(MOVE_RIGHT)
##	Action.remove(JUMP)
##	Action.remove(FIRE)
##	print_rich("[color=yellow][b]WARNING[/b][/color]: Project must be reloaded for InputMap changes to appear. [color=ivory][b]Project -> Reload Current Project[/b][/color]")
## [/codeblock]

const AXIS_UP = -1
const AXIS_DOWN = 1
const AXIS_LEFT = -1
const AXIS_RIGHT = 1


## Returns an [InputEventJoypadMotion] event. Valid [param input] values are in
## [enum @GlobalScope.JoyAxis]. Valid [param direction] values are
## [member AXIS_UP], [member AXIS_DOWN], [member AXIS_LEFT], and
## [member AXIS_RIGHT]. [param device] indicates which gamepad device this
## action listens to and defaults to -1 (all gamepad devices).
static func joy_axis(input: JoyAxis, direction: int = 0, device: int = -1) -> InputEventJoypadMotion:
	var event = InputEventJoypadMotion.new()
	event.axis = input
	event.axis_value = direction
	event.device = device
	return event


## Returns an [InputEventJoypadButton] event. Valid [param input] values are in
## [enum @GlobalScope.JoyButton]. [param device] indicates which gamepad device
## this action listens to and defaults to -1 (all gamepad devices).
static func joy_button(input: JoyButton, device: int = -1) -> InputEventJoypadButton:
	var event = InputEventJoypadButton.new()
	event.button_index = input
	event.device = device # -1 is all devices
	return event


## Returns an [InputEventKey] event. Valid [param input] values are in
## [enum @GlobalScope.Key].
static func key(input: Key) -> InputEventKey:
	var event = InputEventKey.new()
	event.physical_keycode = input
	return event


## Returns an [InputEventMouseButton] event. Valid [param input] values are in
## [enum @GlobalScope.MouseButton]. [param device] indicates which pointer
## device this action listens to and defaults to -1 (all pointer devices).
static func mouse_button(input: MouseButton, device: int = -1) -> InputEventMouseButton:
	var event = InputEventMouseButton.new()
	event.button_index = input
	event.device = device # -1 is all devices
	return event


## Adds [param action] to the [InputMap]. The [param events] argument accepts
## [float], [InputEventJoypadButton], [InputEventJoypadMotion], [InputEventKey],
## and [InputEventMouseButton]. It will ignore everything else.
## [br][br]
## If a [float] is provided, the deadzone for the controller 
## will be set to that value.
## [br][br]
## Supported [InputEvent]s can be passed by using the functions
## [method joy_axis], [method joy_button], [method key],
## and [method mouse_button]. Alternately, they can be created manually
## and passed in.
## 
## [codeblock]
## const MOVE_UP = "move_up"
##
## Action.add(MOVE_UP, Action.joy_axis(JOY_AXIS_LEFT_Y, Action.AXIS_UP), Action.key(KEY_UP), Action.key(KEY_W))
## [/codeblock]
static func add(action: StringName, ...events: Array) -> void:
	var input_map = {
		"deadzone": 0.2,
		"events": []
	}
	
	for event in events:
		if event is float:
			input_map["deadzone"] = event
		elif event is InputEvent:
			input_map["events"].append(event)
	
	ProjectSettings.set_setting("input/" + action, input_map)
	ProjectSettings.save()


## Removes an action and all associated [InputEvent]s from the [InputMap].
## 
## [codeblock]
## const MOVE_UP = "move_up"
##
## Action.remove(MOVE_UP)
## [/codeblock]
static func remove(action: StringName) -> void:
	ProjectSettings.set_setting("input/" + action, null)
	ProjectSettings.save()
