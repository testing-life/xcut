extends CharacterBody2D


@export var speed = 50.0
@export var health = 30
@onready var sprite = $Sprite2D
@onready var ap = $AnimationPlayer
@onready var floorCast = $FloorCast
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true;
var player = null;
var is_attacking = false;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if !floorCast.is_colliding() && is_on_floor():
		flip()
			
	velocity.x = speed

	if player:
		if player.position.x < position.x && facing_right:
			flip()
		position += (player.position - position)/abs(speed) 
		if global_transform.origin.x - player.global_transform.origin.x < 62: 
			is_attacking = true
		else:
			is_attacking = false
			
	move_and_slide()
	updateAnimation(velocity.x)
	
func flip():
	facing_right = !facing_right
	sprite.flip_h = !facing_right
	if facing_right:
		speed = abs(speed) 
		floorCast.position.x = 22
		$Hitbox/HitBoxShape.position.x = 42
	else:
		floorCast.position.x = -22
		$Hitbox/HitBoxShape.position.x = -42
		speed = abs(speed)  * -1
			
func updateAnimation(horizontal_direction):
	if is_attacking == false:
		if horizontal_direction == 0:
			ap.stop()
		else:
			ap.play("enemy_run")
	else:
		ap.play('enemy_attack')


func _on_hurtbox_area_entered(hitbox):
	print('enemy hurtbox entered by ' + hitbox.get_parent().name)
	health -= hitbox.damage
	if health <= 0:
		print('is dead')
		queue_free()

func _on_player_detection_area_body_entered(body):
	print(body.name)
	if body.name == 'Player':
		player = body
	
func _on_player_detection_area_body_exited(body):
	if body.name == 'Player':
		player = null
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'enemy_attack':
		is_attacking = false
