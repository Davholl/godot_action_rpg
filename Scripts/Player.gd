extends KinematicBody2D

const MAX_SPEED = 120;
const ACCELERATION = 500;
const FRICTION = 500;

onready var animationPlayer = $AnimationPlayer;
onready var animationTree = $AnimationTree;
onready var animationState = animationTree.get("parameters/playback");

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE;
var velocity = Vector2.ZERO;

func _ready():
	animationTree.active = true;
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta);
		ATTACK:
			attack_state(delta);
		ROLL:
			roll_state(delta);
	change_state();
	
func change_state():
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK;
			
func attack_state(delta):
	animationState.travel("Attack");
	velocity = Vector2.ZERO;
	pass

func attack_animation_finish():
	state = MOVE;

func roll_state(delta):
	pass

func roll_animation_finish():
	pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") -  Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector);
		animationTree.set("parameters/Run/blend_position", input_vector);
		animationTree.set("parameters/Attack/blend_position", input_vector);
	
		animationState.travel("Run");
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
		animationState.travel("Idle");
		
	velocity = move_and_slide(velocity);
