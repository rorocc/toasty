extends CharacterBody2D


const SPEED = 300.0
var currentSpeed = 300
const minSpeed = 30

#Jumping
const JUMP_VELOCITY = -400.0
const max_jumps : int = 2
var jumps_left : int = 2

#Slide
var inSlide : bool = false
const slideDecel : float = 0.50
const butteredslideDecel : float = 0.99

#WallSlide
var currentWallSlideSpeed : float
const maxWallSlideSpeed : float = 120
const wallSlideAcc : float = 10


func _ready() -> void:
	Gm.player = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = max_jumps

	if !Input.is_anything_pressed():
		$AnimationPlayer.current_animation = "Idle"
	else:
		$AnimationPlayer.stop()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jumps_left > 0):
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)


#Slide
	if Input.is_action_just_pressed("slide") && inSlide == false:
		inSlide = true
		scale.y = 0.7

	
	if inSlide == true:
		#play slide animation hier please
		if currentSpeed > minSpeed:
			if Gm.butterAmount > 0:
				currentSpeed *= butteredslideDecel
				Gm.butterAmount -= delta * 20
			else:
				currentSpeed *= slideDecel
			
		
		if Input.is_action_just_released("slide"):
			scale.y = 1

			inSlide = false
			currentSpeed = SPEED
	
#Wall stick
	if is_on_wall() && Input.get_axis("left", "right") && velocity.y > 0:
		print("wallSlide", velocity.y )
		jumps_left = max_jumps
		
		
		if velocity.y < maxWallSlideSpeed:
			currentWallSlideSpeed += wallSlideAcc * delta
		
		velocity.y = 0 + currentWallSlideSpeed
	else:
		currentWallSlideSpeed = 0
	move_and_slide()
