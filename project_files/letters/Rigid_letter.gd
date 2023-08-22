extends RigidBody2D

var held = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()



func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"): 
		globs.emit_signal("clicked_letter", self)
		pick_up()
	if Input.is_action_just_released("click_left"):
		drop(Input.get_last_mouse_velocity()/4)

func pick_up():
	if held: return
	held = true

func drop(impulse = Vector2.ZERO):
	if held:
		apply_central_impulse(impulse)
		held = false
