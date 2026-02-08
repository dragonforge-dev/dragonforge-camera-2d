class_name PowerUp extends Resource

enum Type {
	SHIELD,
	MISSILE,
}

@export var color: Color
@export var base_sprite: Texture2D
@export var secondary_sprite: Texture2D
@export var power_up_type: Type
@export var pickup_sound: AudioStream
@export var power: int = 1
@export var radar_icon: Texture2D
