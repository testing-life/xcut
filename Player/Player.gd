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
	print(velocity.x)
	move_and_slide()
	if velocity.x != 0:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	if Input.is_action_pressed('m_jump') and is_on_floor(): 
		velocity.y = jump_speed
		
	if Input.is_action_just_pressed("f_cut"):
		$AnimatedSprite2D.play("fight")
