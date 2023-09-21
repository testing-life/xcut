extends CharacterBody2D

signal hit

@export var walk_speed = 400
@export var jump_speed = -400

var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("m_left"):
		velocity.x -= 1
	if Input.is_action_pressed("m_right"):
		velocity.x += 1
	if Input.is_action_pressed("m_jump") && is_on_floor():		
		velocity.y = jump_speed
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * walk_speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	# poition = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = 'run'
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.flip_v = velocity.y > 0
