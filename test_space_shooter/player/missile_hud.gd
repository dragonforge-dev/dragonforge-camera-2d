extends MarginContainer

const SPACE_MISSILES_015 = preload("uid://c637g2i6ahrbr")
const PIXEL_DISSOLVE = preload("uid://b4lmpewqpq4bc")

@export var dissolve_speed := 0.5

var displayed_missiles: int = 0
var missile_stack: int = 0
var missiles: int = 0
var stack_timer: Timer

@onready var missile_display: GridContainer = %"Missile Display"
@onready var add_missile_sound: AudioStreamPlayer = $"Add Missile Sound"


func _ready() -> void:
	stack_timer = Timer.new()
	stack_timer.wait_time = dissolve_speed
	stack_timer.one_shot = true
	add_child(stack_timer)
	stack_timer.timeout.connect(_on_stack_timer_timeout)


func calculate(new_missile_count: int) -> void:
	if new_missile_count == missiles:
		return
	if new_missile_count > missiles:
		var added_missiles: int = new_missile_count - missiles
		missiles += added_missiles
		missile_stack += added_missiles
	elif new_missile_count < missiles:
		var used_missiles: int = missiles - new_missile_count
		missiles -= used_missiles
		missile_stack -= used_missiles
	if stack_timer.is_stopped():
		stack_timer.start()


func add_missile() -> void:
	add_missile_sound.play()
	var texture_rect := TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(10.0, 20.0)
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	texture_rect.texture = SPACE_MISSILES_015
	texture_rect.material = PIXEL_DISSOLVE.duplicate()
	texture_rect.material.set_shader_parameter("progress", 1.0)
	missile_display.add_child(texture_rect)
	var tween: Tween = create_tween()
	tween.tween_property(texture_rect, "material:shader_parameter/progress", 0.0, dissolve_speed)
	displayed_missiles += 1


func remove_missile() -> void:
	displayed_missiles -= 1
	var missile: TextureRect = missile_display.get_child(-1)
	var tween: Tween = create_tween()
	tween.tween_property(missile, "material:shader_parameter/progress", 1.0, dissolve_speed)
	await get_tree().create_timer(dissolve_speed).timeout
	missile.queue_free()


func _on_stack_timer_timeout() -> void:
	if missile_stack > 0:
		stack_timer.start()
		missile_stack -= 1
		add_missile()
	elif missile_stack < 0:
		stack_timer.start()
		missile_stack += 1
		remove_missile()
