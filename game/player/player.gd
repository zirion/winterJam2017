extends KinematicBody2D

export var player_speed = 2000
var input_states = preload('res://utils/input_states.gd')
var velocity = Vector2()
var fuAttackArea = null
var fdAttackArea = null
var enemies_on_area = []
var FacingDirection 
var FutureFacingDirection
var PreviousFacingDirection
var attack_btn = input_states.new('attack_btn') 

func attack(target_area):
	enemies_on_area = target_area.get_overlapping_bodies()
	for enemy in enemies_on_area:
		if enemy.is_in_group("enemies"):
			enemy.disable()
	
func _ready():
	FacingDirection = "up"
	fuAttackArea = get_node("FuAttackArea")
	fdAttackArea = get_node("FdAttackArea")
	set_fixed_process(true)

func _fixed_process(delta):
	PreviousFacingDirection = FacingDirection
	FacingDirection = FutureFacingDirection
		
	var attack_area
	if FacingDirection == "up":
		attack_area = fuAttackArea
	else:
		attack_area = fdAttackArea
	
	if attack_btn.check() == 2: # JUST PRESSED
		attack(attack_area)
	
	velocity.x = 0
	velocity.y = 0
	get_node("AnimatedSprite/AnimationPlayer").play("idle")
	
	if (Input.is_action_pressed("walk_left")):
		velocity.x = -player_speed
		get_node("AnimatedSprite/AnimationPlayer").play("left")
	elif (Input.is_action_pressed("walk_right")):
		velocity.x = player_speed
		
	if (Input.is_action_pressed("walk_up")):
		FutureFacingDirection = "up"
		velocity.y = -player_speed
	elif (Input.is_action_pressed("walk_down")):
		velocity.y = player_speed
		FutureFacingDirection = "down"
		get_node("AnimatedSprite/AnimationPlayer").play("down")
		
	if (Input.is_action_pressed("walk_down") and Input.is_action_pressed("walk_right")):
		get_node("AnimatedSprite/AnimationPlayer").play("down_right")

	var motion = velocity * delta
	motion = move(motion)
	
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)