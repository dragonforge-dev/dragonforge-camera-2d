class_name RadarHUD extends MarginContainer

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
		draw_set_transform(position_on_radar, 0.0, Vector2(0.75, 0.75))
		if object is Player:
			continue
		elif object is Asteroid:
			position_on_radar -= METEOR_BROWN_TINY_2.get_size() / 2
			draw_texture(METEOR_BROWN_TINY_2, Vector2.ZERO)
		elif object is Pickup:
			position_on_radar -= object.radar_icon.get_size() / 2
			draw_texture(object.radar_icon, Vector2.ZERO)
		else:
			draw_texture(DOT_WHITE, Vector2.ZERO)
