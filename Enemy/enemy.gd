extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var health = 100
@onready var sprite = $Sprite2D
@onready var ap = $AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction == -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	updateAnimation(direction)
	
func updateAnimation(horizontal_direction):
	if horizontal_direction == 0:
		ap.stop()
	else:
		ap.play("enemy_run")


func _on_hurtbox_area_entered(hitbox):
	print('enemy hurtbox entered by ' + hitbox.get_parent().name)
	health -= hitbox.damage
	if health <= 0:
		print('is dead')
		queue_free()
