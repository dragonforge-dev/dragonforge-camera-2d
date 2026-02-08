class_name Player extends CharacterBody2D

const LASER = preload("uid://i04oibb7srfk")
const MISSILE = preload("uid://dwga0splhj70t")

@export var background: Sprite2D
@export_group("Ship Stats")
@export var max_speed: float = 1000.0
@export var thrust_power: float = 500.0
@export var drag: float = 0.95
@export var rotation_sensitivity: float = 2.5
@export_category("Weapons")
@export var fire_rate: float = 0.5
@export var missile_fire_rate: float = 0.5
@export_group("Starting Stats", "starting")
@export var starting_health: float = 100.0
@export var starting_shields: float = 0.0
@export var starting_missiles: int = 0
@export_group("Limits", "max")
@export var max_health: float = 100.0
@export var max_shields: float = 200.0
@export var max_missiles: int = 30

var is_gun_ready := true
var is_missile_ready := true
var background_scroll_speed: float = 0.5
var health: float = max_health:
	set(value):
		health = value
		if health <= 0:
			die()
		elif health > max_health:
			health = max_health
var shields: float = 0.0:
	set(value):
		if value <= 0:
			value = 0
			shield_hud.hide()
		elif shields == 0 and value > 0:
			shield_hud.show()
		elif value > max_shields:
			value = max_shields
		shields = value
		shield_hud.calculate(shields)
var missiles: int = 0:
	set(value):
		if value <= 0:
			value = 0
			missile_hud.hide()
		elif missiles == 0 and value > 0:
			missile_hud.show()
		elif value > max_missiles:
			value = max_missiles
		missiles = value
		missile_hud.calculate(missiles)

@onready var thrusters: AnimatedSprite2D = $Thrusters
@onready var thruster_sound: AudioStreamPlayer = $"Thruster Sound"
@onready var fire_laser_sound: AudioStreamPlayer = $"Fire Laser Sound"
@onready var shield: Sprite2D = $Shield
@onready var shield_sound: AudioStreamPlayer = $"Shield Sound"
@onready var gun_port: Marker2D = $"Gun Port"
@onready var parallax_2d: Parallax2D = $"../Parallax2D"
# HUD
@onready var shield_hud: PanelContainer = $"HUD/MarginContainer/Shield HUD"
@onready var missile_hud: MarginContainer = $"HUD/MarginContainer/Missile HUD"
@onready var fire_missile_sound: AudioStreamPlayer = $"Fire Missile Sound"


func _ready() -> void:
	thruster_sound.stream_paused = true
	health = starting_health #For testing
	shields = starting_shields #Forces the HUD calculation
	missiles = starting_missiles # Forces HUD calculation


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("fire") and is_gun_ready:
		is_gun_ready = false
		shoot()
		await get_tree().create_timer(fire_rate).timeout
		is_gun_ready = true
	if Input.is_action_pressed("fire_missile") and is_missile_ready and missiles > 0:
		is_missile_ready = false
		fire_missile()
		await get_tree().create_timer(missile_fire_rate).timeout
		is_missile_ready = true
	
	var rotate_direction: float = Input.get_axis("rotate_left", "rotate_right")
	rotation += rotate_direction * rotation_sensitivity * delta
	
	var thrust := Input.get_action_strength("thrust")
	var thrust_direction := -transform.y
	if thrust:
		velocity += thrust_direction * thrust * thrust_power * delta
		thrusters.show()
		if thruster_sound.stream_paused:
			thruster_sound.play()
		parallax_2d.scroll_offset -= velocity * delta * background_scroll_speed # For static
	else:
		thrusters.hide()
		thruster_sound.stream_paused = true
		parallax_2d.scroll_offset = Vector2.ZERO
	
	# Drag and Max Speed
	velocity *= drag
	velocity.limit_length(max_speed)
	
	move_and_slide()


func shoot() -> void:
	fire_laser_sound.play()
	var laser: Area2D = LASER.instantiate()
	laser.global_position = gun_port.global_position
	laser.global_rotation = global_rotation
	laser.direction = (gun_port.global_position - global_position).normalized()
	add_sibling(laser)


func fire_missile() -> void:
	fire_missile_sound.play()
	var missile: Area2D = MISSILE.instantiate()
	missile.global_position = gun_port.global_position
	missile.global_rotation = global_rotation
	missile.direction = (gun_port.global_position - global_position).normalized()
	add_sibling(missile)
	missiles -= 1


func hit(damage: float) -> void:
	if shields > 0.0:
		shields -= damage
		shield_sound.play()
		var tween: Tween = create_tween()
		tween.tween_property(shield, "modulate:a", 100, 0.15).set_ease(Tween.EASE_OUT)
		tween.chain().tween_property(shield, "modulate:a", 0, 0.15).set_ease(Tween.EASE_IN)
	else:
		health -= damage


func die() -> void:
	print("Game Over")


func add_powerup(power_up: PowerUp) -> void:
	match power_up.power_up_type:
		PowerUp.Type.SHIELD:
			shields += 10.0 * float(power_up.power)
		PowerUp.Type.MISSILE:
			missiles += power_up.power
