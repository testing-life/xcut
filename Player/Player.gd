extends CharacterBody2D

signal hit

@export var walk_speed = 400
@export var jump_speed = -1000
@export var gravity = 2000

var is_attacking = false
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = Input.get_axis("m_left","m_right") * walk_speed
	move_and_slide()
	if Input.is_action_pressed('m_jump') and is_on_floor(): 
		velocity.y = jump_speed
