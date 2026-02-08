class_name RadarHUDPlayer extends MarginContainer

const DOT_WHITE = preload("uid://lmk3ndm1psx7")
const PLAYER_LIFE_1_BLUE = preload("uid://dji7g5q1kxem5")
const METEOR_BROWN_TINY_2 = preload("uid://bj17fiyg18xpe")
const PILL_BLUE = preload("uid://bokfiryn2vgx6")

@export var radar: Radar

var radar_range: float = 4000
var display_range: float = 200


func _ready() -> void:
	radar.radar_updated.connect(_on_radar_updated)


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		queue_redraw()


func _on_radar_updated() -> void:
	queue_redraw()


func _draw() -> void:
	for object in radar.objects_detected:
		var p: Vector2 = object.global_position - radar.global_position
		
		var position_on_radar: Vector2 = (p / radar_range) * display_range
		position_on_radar += get_size() / 2
		if object is Player:
			#position_on_radar -= PLAYER_LIFE_1_BLUE.get_size() / 2
			
			draw_set_transform(position_on_radar, object.rotation, Vector2(0.75, 0.75))
			draw_texture(PLAYER_LIFE_1_BLUE, Vector2.ZERO - PLAYER_LIFE_1_BLUE.get_size() / 2)
