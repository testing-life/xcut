extends CharacterBody2D

signal hit

@export var walk_speed = 400
@export var jump_speed = -1000
@export var gravity = 2000
@export var health = 50;
@onready var ap = $AnimationPlayer
@onready var sprite = $Anim

var is_attacking = false
var screen_size
var attacks = ['attack1','attack2']
var is_dead = false;
var is_damaged = false;
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
	
	if Input.is_action_just_pressed('f_cut'):
		attack()
		
	move_and_slide()
	update_animation(horizontal_dir)

func update_animation(horizontal_direction):
	if health != 0:
		if is_attacking == false:
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
		else:
			ap.play('attack1')
	else:
		ap.play("death")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'attack1':
		is_attacking = false # Replace with function body.
	if anim_name == 'wound':
		is_damaged = false;
	if anim_name == 'death':
		is_dead = true
		get_tree().reload_current_scene();
		
func attack():
	is_attacking = true

func _on_hitbox_area_entered(hurtbox):
	print('player hurtbox entered by ' + hurtbox.get_parent().name)


func _on_hurtbox_area_entered(hitbox):
	print('player hitbox entered by ' + hitbox.get_parent().name)
	if health > 0:
		health -= hitbox.damage;
		is_damaged = true
		
