extends Button

@export_file("*.tscn") var test_scene: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(test_scene)
