class_name Radar extends Area2D

signal radar_updated

var objects_detected: Array[Node2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_body_entered(body: Node2D) -> void:
	objects_detected.append(body)
	radar_updated.emit()


func _on_body_exited(body: Node2D) -> void:
	objects_detected.erase(body)
	radar_updated.emit()


func _on_area_entered(area: Area2D) -> void:
	objects_detected.append(area)
	radar_updated.emit()


func _on_area_exited(area: Area2D) -> void:
	objects_detected.erase(area)
	radar_updated.emit()
