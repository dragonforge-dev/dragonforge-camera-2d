class_name Laser extends Area2D

@export var speed: float = 1000.0
@export var damage: float = 10.0

var direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion: GPUParticles2D = $Explosion
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	set_process(false)
	body.hit(damage)
	explosion.emitting = true
	explosion_sound.play()
	sprite_2d.hide()
	collision_shape_2d.set_deferred("disabled", true)
	await get_tree().create_timer(max(explosion_sound.stream.get_length(), explosion.lifetime)).timeout
	queue_free()
