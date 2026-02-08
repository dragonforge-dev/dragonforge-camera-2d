class_name ShieldHUD extends PanelContainer

const SQUARE_SHADOW = preload("uid://d0u3ff5f86h2m")
const SQUARE_BLUE = preload("uid://bax0sexsma2ri")
const SQUARE_WHITE = preload("uid://bcnfpy0s5vhq8")
const SHINE = preload("uid://n338nfny8ql2")

@export var shine_speed: float = 0.8

var displayed_shields: float = 0
var shields_stack: float = 0
var shields: float = 0
var stack_timer: Timer

@onready var shield_display: HBoxContainer = $"HBoxContainer/Shield Display"
@onready var shield_charge_sound: AudioStreamPlayer = $"Shield Charge Sound"


func _ready() -> void:
	stack_timer = Timer.new()
	stack_timer.wait_time = shine_speed
	stack_timer.one_shot = true
	add_child(stack_timer)
	stack_timer.timeout.connect(_on_stack_timer_timeout)


func calculate(new_shield_count: float) -> void:
	if new_shield_count == shields:
		return
	if new_shield_count > shields:
		var added_shields: float = new_shield_count - shields
		shields += added_shields
		shields_stack += added_shields
	elif new_shield_count < shields:
		var lost_shields: float = shields - new_shield_count
		shields -= lost_shields
		shields_stack -= lost_shields
	if stack_timer.is_stopped():
		stack_timer.start()


func add_shield() -> void:
	var texture_rect: TextureRect
	if displayed_shields >= 100:
		var slot := int((displayed_shields - 100.0) / 10.0)
		texture_rect = shield_display.get_child(slot)
		texture_rect.texture = SQUARE_WHITE
	else:
		var slot := int(displayed_shields / 10.0)
		texture_rect = shield_display.get_child(slot)
		texture_rect.texture = SQUARE_BLUE
	shield_charge_sound.play()
	displayed_shields += 10.0
	texture_rect.material = SHINE.duplicate()
	await get_tree().create_timer(shine_speed).timeout
	texture_rect.material = null


func remove_shield() -> void:
	var texture_rect: TextureRect
	if displayed_shields >= 100:
		var slot := int((displayed_shields - 100.0) / 10.0)
		texture_rect = shield_display.get_child(slot)
		texture_rect.texture = SQUARE_BLUE
	else:
		var slot := int(displayed_shields / 10.0)
		texture_rect = shield_display.get_child(slot)
		texture_rect.texture = SQUARE_SHADOW
	displayed_shields -= 10.0


func _on_stack_timer_timeout() -> void:
	if shields_stack > 0:
		stack_timer.start()
		shields_stack -= 10
		add_shield()
	elif shields_stack < 0:
		stack_timer.start()
		shields_stack += 10
		remove_shield()
