extends CharacterBody2D

enum State {IDLE, WALK, JUMP, DUCK, HURT}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hurt_velocity: Vector2 = Vector2(-400, -150)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var state: State = State.IDLE
var hurt_timer: Timer
var hurt_delay_timer: Timer


func _ready() -> void:
	hurt_timer = Timer.new()
	hurt_timer.one_shot = true
	add_child(hurt_timer)
	hurt_timer.timeout.connect(_on_hurt_timeout)
	
	hurt_delay_timer = Timer.new()
	hurt_delay_timer.one_shot = true
	add_child(hurt_delay_timer)


func _physics_process(delta: float) -> void:
	if state == State.HURT:
		var new_velocity: Vector2 = hurt_velocity
		if animated_sprite_2d.flip_h:
			new_velocity.x *= -1
		velocity = new_velocity
	# Add the gravity.
	if not is_on_floor():
		if state != State.HURT:
			state = State.JUMP
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = State.JUMP
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("duck") and is_on_floor():
		state = State.DUCK
		collision_shape_2d.shape.height = 69.0
	if Input.is_action_just_released("duck"):
		state = State.IDLE
		collision_shape_2d.shape.height = 91.0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0.0:
			if state == State.DUCK:
				velocity.x = velocity.x * 0.8
			else:
				state = State.WALK
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0.0 and state != State.DUCK and state != State.HURT:
			state = State.IDLE
	
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
		_flip_node(collision_shape_2d, direction)
	
	animate()
	move_and_slide()


func _flip_node(node_2d: Node2D, direction_float: float) -> void:
	node_2d.position.x = abs(node_2d.position.x)
	if direction_float < 0:
		node_2d.position.x *= -1


func animate() -> void:
	match state:
		State.IDLE:
			animated_sprite_2d.play("idle")
		State.WALK:
			animated_sprite_2d.play("walk")
		State.JUMP:
			animated_sprite_2d.play("jump")
		State.DUCK:
			animated_sprite_2d.play("duck")
		State.HURT:
			animated_sprite_2d.play("hurt")


func hurt() -> void:
	if hurt_delay_timer.is_stopped():
		state = State.HURT
		hurt_timer.start(0.2)
		hurt_delay_timer.start(1.0)


func _on_hurt_timeout() -> void:
	state = State.IDLE
