@tool
@icon("res://addons/dragonforge_camera_2d/assets/textures/icons/component.svg")
@abstract class_name Camera2DComponent extends Node
## Abstract base class for components added to a [Camera2D]. Objects inheriting
## from this class can only be attached to a Camera2D node and will issue
## an editor warning if not.

## The Camera2D object to which this component is attached and operates on.
var camera: Camera2D


# Runs whenver the node is parented or reparented.
func _enter_tree() -> void:
	camera = null
	var parent = get_parent()
	if parent is Camera2D:
		camera = parent
	update_configuration_warnings()


# Overridden built-in function of the [Node] class.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not camera is Camera2D:
		warnings.append("Camera2DComponent only serves to provide modifications to Camera2D derived nodes. Please only use it as a child of a Camera2D to modify it.")
	return warnings
