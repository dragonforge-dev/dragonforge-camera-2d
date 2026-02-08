class_name Asteroid extends RigidBody2D

@export var health: float = 40.0:
	set(value):
		health = value
		if health <= 0.0:
			die()
@export var textures: Array[Texture2D]
@export var collision_shapes: Array[PackedVector2Array]
@export var collision_damage: float = 10.0
@export var debris: PackedScene
@export var min_debris: int = 2
@export var max_debris: int = 4

var rotation_speed: float
var drift_direction: Vector2 = Vector2.ZERO

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var explosion: GPUParticles2D = $Explosion
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound
@onready var explosion_2: GPUParticles2D = $Explosion2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var asteroid_type: int = randi_range(0, textures.size() - 1)
	sprite_2d.texture = textures[asteroid_type]
	collision_polygon_2d.polygon = collision_shapes[asteroid_type]
	rotation_speed = randf_range(-5, 5)
	body_entered.connect(_on_hit_player)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	if not drift_direction.is_zero_approx():
		drift_direction = drift_direction.move_toward(Vector2.ZERO, delta)
		global_position += drift_direction
		if drift_direction.is_zero_approx():
			drift_direction = Vector2.ZERO


func hit(damage: float) -> void:
	health -= damage


func die() -> void:
	explosion_sound.play()
	explosion.emitting = true
	explosion_2.emitting = true
	sprite_2d.hide()
	collision_polygon_2d.set_deferred("disabled", true)
	if debris:
		for i in randi_range(min_debris, max_debris):
			var new_debris: Node2D = debris.instantiate()
			if new_debris is Asteroid:
				var impulse: Vector2 = Vector2(randf_range(-40.0, 40.0), randf_range(-40.0, 40.0))
				new_debris.global_position = global_position + impulse
				new_debris.drift_direction = impulse.normalized() * randf_range(-2.5, 2.5)
			else:
				new_debris.global_position = global_position
			call_deferred("add_sibling", new_debris)
	await get_tree().create_timer(max(explosion_sound.stream.get_length(), explosion.lifetime, explosion_2.lifetime)).timeout
	queue_free()


func _on_hit_player(body: Player) -> void:
	body.hit(collision_damage)
