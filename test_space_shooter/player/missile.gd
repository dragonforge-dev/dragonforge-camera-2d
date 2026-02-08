class_name Missile extends Area2D

@export var speed: float = 750.0
@export var damage: float = 50.0

var direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion: GPUParticles2D = $Explosion
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var flying_sound: AudioStreamPlayer2D = $"Flying Sound"
@onready var explosion_collision_shape_2d: CollisionShape2D = $ExplosionCollisionShape2D


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if process_mode == PROCESS_MODE_DISABLED:
		print("Extra Target!")
		body.hit(damage)
		return
	set_process(false)
	flying_sound.stop()
	body.hit(damage)
	explosion.emitting = true
	explosion_sound.play()
	sprite_2d.hide()
	collision_shape_2d.set_deferred("disabled", true)
	explosion_collision_shape_2d.set_deferred("disabled", false)
	await get_tree().create_timer(max(explosion_sound.stream.get_length(), explosion.lifetime)).timeout
	queue_free()
