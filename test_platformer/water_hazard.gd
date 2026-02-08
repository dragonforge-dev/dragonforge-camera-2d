extends Area2D

@onready var camera_2d_shake: Camera2DShake = $"../CharacterBody2D/Camera2D/Camera2DShake"


func _on_body_entered(body: Node2D) -> void:
	print_rich("[wave amp=50.0 freq=4.0 connected=1][color=light_sky_blue]Water Hazard Triggered[/color][/wave]")
	await get_tree().create_timer(0.1).timeout
	camera_2d_shake.start()
	body.hurt()


func _on_body_exited(_body: Node2D) -> void:
	camera_2d_shake.stop()
