class_name Pickup extends Area2D

@export var power_ups: Array[PowerUp]
@export var power_up: PowerUp

var radar_icon: Texture2D

@onready var base_sprite: Sprite2D = %"Base Sprite"
@onready var secondary_sprite: Sprite2D = %"Secondary Sprite"
@onready var pickup_sound: AudioStreamPlayer2D = $"Pickup Sound"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collection_effect: GPUParticles2D = $"Collection Effect"


func _ready() -> void:
	if power_ups:
		power_up = power_ups.pick_random()
	base_sprite.texture = power_up.base_sprite
	radar_icon = power_up.radar_icon
	var particle_material: ParticleProcessMaterial = collection_effect.process_material.duplicate()
	collection_effect.process_material = particle_material
	particle_material.color = power_up.color
	if power_up.secondary_sprite:
		secondary_sprite.texture = power_up.secondary_sprite
	if power_up.pickup_sound:
		pickup_sound.stream = power_up.pickup_sound
	body_entered.connect(_on_player_pickup)


func _on_player_pickup(body: Player) -> void:
	base_sprite.hide()
	collision_shape_2d.set_deferred("disabled", true)
	collection_effect.emitting = true
	pickup_sound.play()
	body.add_powerup(power_up)
	await get_tree().create_timer(max(pickup_sound.stream.get_length(), collection_effect.lifetime)).timeout
	queue_free()
