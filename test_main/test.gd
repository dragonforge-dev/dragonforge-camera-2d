extends Control

@onready var space_shooter: Button = $"MarginContainer/HBoxContainer/Space Shooter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space_shooter.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
