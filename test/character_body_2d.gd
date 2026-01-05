extends CharacterBody2D

@export var rotation_sensitivity: float = 5.0


func _physics_process(delta: float) -> void:
	var rotate_direction = Input.get_axis("rotate_up", "rotate_down")
	rotation += rotate_direction * rotation_sensitivity * delta
