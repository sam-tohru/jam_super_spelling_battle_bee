extends Area2D

@onready var held = false
@onready var FROZEN = false
@onready var frozen_rect = $frozen_rect
@onready var frozen_particles = $frozen_rect/frozen_particles

@onready var drag_start_pos = Vector2.ZERO


## Stats ##
@onready var character: String
@onready var attack: int
@onready var health: int

## Labels ##
@onready var character_label = $character_label
@onready var attack_label = $attack_label
@onready var health_label = $health_label

@onready var focus_shake = $focus_shake

@onready var focus_tween

@onready var click_timer = $click_timer

@onready var original_position
@onready var original_marker_area
@onready var original_area_in

@onready var focused = false

@onready var hand = $letter_sprite/hand


# Called when the node enters the scene tree for the first time.
func _ready():
	ready_letter()
	globs.gun_mode_changed.connect(gun_mode_changed)
	hand.visible = globvars.gun_mode

func kill_letter():
	self.queue_free()

func set_focused(to_go: bool):
	focused = to_go

func gun_mode_changed():
	hand.visible = globvars.gun_mode

func set_original_area_in():
	original_position = self.global_position
	if self.has_overlapping_areas():
		for area in self.get_overlapping_areas():
			if area.is_in_group('board_area'): original_area_in = area ; return
func compare_area_in():
	if self.has_overlapping_areas():
		for area in self.get_overlapping_areas():
			if area.is_in_group('trash_area'): globs.emit_signal('freeze_button') ; return
			if area.is_in_group('board_area') and original_area_in != area: return true
	
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held and Input.is_action_pressed("click_left"): 
		var drag_delta = get_global_mouse_position() - drag_start_pos
		global_position = get_global_mouse_position()
		drag_start_pos = global_position

func ready_letter():
	var rand_letter_int = randi_range(0, 25)
	character = globvars.alphabet[rand_letter_int]
	character_label.text = character
	set_letter_sprite(rand_letter_int)
	
	attack = randi_range(1, globvars.MAX_SHOP_STATS)
	health = randi_range(1, globvars.MAX_SHOP_STATS)
	attack_label.text = str(attack)
	health_label.text = str(health)

func set_letter(let: String, att: int, hlth: int):
	character = let
	character_label.text = character
	
	var leter_int = globvars.alphabet.find(let)
	set_letter_sprite(leter_int)
	
	attack = att
	health = hlth
	attack_label.text = str(att)
	health_label.text = str(hlth)

func freeze_letter(): # just returns now as i removed freezing
	return
	if !FROZEN:
		FROZEN = true
		frozen_rect.visible = true
		frozen_particles.emitting = true
	elif FROZEN:
		FROZEN = false
		frozen_rect.visible = false
		frozen_particles.emitting = false

func drop_in_area():
	for area in self.get_overlapping_areas():
		if area.is_in_group('board_area'): 
			if original_area_in != null and area == original_area_in: drop_back() ; return
			if area.is_in_group('top_area'): globs.emit_signal('drop_in_area', self, get_top_area(area), true)
			if area.is_in_group('bot_area'): globs.emit_signal('drop_in_area', self, get_bot_area(area), false)
func drop_back():
	if original_area_in == null: global_position = original_position
	elif original_area_in.is_in_group('top_area'): globs.emit_signal('move_letter_to_top', self, get_top_area(original_area_in))
	elif original_area_in.is_in_group('bot_area'): globs.emit_signal('move_letter_to_bot', self, get_bot_area(original_area_in))

func get_top_area(area_to_check: Area2D):
	if area_to_check.is_in_group('top_0'): return 0
	if area_to_check.is_in_group('top_1'): return 1
	if area_to_check.is_in_group('top_2'): return 2
	if area_to_check.is_in_group('top_3'): return 3
	if area_to_check.is_in_group('top_4'): return 4
	if area_to_check.is_in_group('top_5'): return 5
	if area_to_check.is_in_group('top_6'): return 6
	return -1

func get_bot_area(area_to_check: Area2D):
	if area_to_check.is_in_group('bot_0'): return 0
	if area_to_check.is_in_group('bot_1'): return 1
	if area_to_check.is_in_group('bot_2'): return 2
	if area_to_check.is_in_group('bot_3'): return 3
	if area_to_check.is_in_group('bot_4'): return 4
	if area_to_check.is_in_group('bot_5'): return 5
	if area_to_check.is_in_group('bot_6'): return 6
	return -1


func _input(event):
	if event.is_action_released("click_left") and held and globvars.drag_mode:
		if globvars.SWAPPING_ANIMATION_PLAYING: held = false ; return
		held = false
		if compare_area_in() == false: drop_back()
		else: drop_in_area()
		

func _on_input_event(viewport, event, shape_idx):
	# below is just standard click -> returns and skips everything below
	if Input.is_action_just_pressed("click_left") and !globvars.FOCUS_ANIMATION_PLAYING and !globvars.SWAPPING_ANIMATION_PLAYING and !globvars.IN_MENU: 
		globs.emit_signal("clicked_letter", self)
		if !held and globvars.drag_mode:
			set_original_area_in()
			held = true

func _on_click_timer_timeout():
	return
	if Input.is_action_pressed("click_left"): globs.emit_signal("clicked_letter", self) ; held = true
	# held = true


func letter_focus_timer(to_go: bool):
	if to_go: 
		focus_shake.start()
		focus_tween = create_tween()
		focus_tween.tween_property(self, 'rotation_degrees', randi_range(-5,-15), 0.1)
		focus_tween.tween_property(self, 'rotation_degrees', 0, 0.1)
		focus_tween.tween_property(self, 'rotation_degrees', randi_range(-5,-15), 0.1)
		focus_tween.tween_property(self, 'rotation_degrees', 0, 0.1)
	elif !to_go: focus_shake.stop()

func _on_focus_shake_timeout():
	if focus_tween: focus_tween.kill()
	focus_tween = create_tween()
	focus_tween.tween_property(self, 'rotation_degrees', randi_range(-5,-15), 0.1)
	focus_tween.tween_property(self, 'rotation_degrees', 0, 0.1)
	focus_tween.tween_property(self, 'rotation_degrees', randi_range(5,15), 0.1)
	focus_tween.tween_property(self, 'rotation_degrees', 0, 0.1)


## Sprite & Animation Stuff ##

@onready var sprite_animation_timer = $sprite_animation_timer
@onready var letter_sprite = $letter_sprite
@onready var eye_sprite = $letter_sprite/eye_sprite
@onready var max_eyes = 6
@onready var eye_wag = 0

func set_letter_sprite(letter_int: int):
	letter_sprite.frame = letter_int

func _on_sprite_animation_timer_timeout():
	if focused: 
		# if sprite_animation_timer.wait_time != 0.001: sprite_animation_timer.wait_time == 0.001
		
		var eye_wag_arr = [5, 6, 4, 6]
		eye_wag += 1
		if eye_wag >= 4: eye_wag = 0
		
		eye_sprite.frame = eye_wag_arr[eye_wag]
	else: 
		eye_sprite.frame = randi_range(0, max_eyes) 
		if sprite_animation_timer.wait_time != 0.6: sprite_animation_timer.wait_time == 0.6
	
