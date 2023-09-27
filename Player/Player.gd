extends CharacterBody2D

signal hit

@export var walk_speed = 400
@export var jump_speed = -1000
@export var gravity = 2000

@onready var ap = $AnimationPlayer
@onready var sprite = $Anim
var is_attacking = false
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect()

func _physics_process(delta):
	velocity.y += gravity * delta
	var horizontal_dir = Input.get_axis("m_left","m_right") 
	velocity.x = horizontal_dir * walk_speed
	if horizontal_dir != 0:
		sprite.flip_h = horizontal_dir == -1
	
	if Input.is_action_pressed('m_jump') and is_on_floor():
		velocity.y = jump_speed 
		
	move_and_slide()
	update_animation(horizontal_dir)

func update_animation(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("walk_right")
	else:
		if velocity.y < 0:
			ap.play("jump")
		else:
			ap.play("fall")
