extends Node2D

@onready var background = $background

@onready var mark_spawn = $bot/mark_spawn
@onready var mark_leave = $bot/mark_leave
@onready var mid_marker = $mid_marker
@onready var top_marker = $mid_marker/top_marker
@onready var bot_marker = $mid_marker/bot_marker

@onready var bot_markers = [$bot/mark_0, $bot/mark_1, $bot/mark_2, $bot/mark_3, $bot/mark_4, $bot/mark_5, $bot/mark_6]
@onready var bot_letters = [null, null, null, null, null, null, null]

@onready var top_markers = [$top/mark_0, $top/mark_1, $top/mark_2, $top/mark_3, $top/mark_4, $top/mark_5, $top/mark_6]
@onready var top_letters = [null, null, null, null, null, null, null]

@onready var focused_letter = null

@onready var BATTLE_PHASE:bool = false # shop phase vs battle phase
@onready var SETTING_UP:bool = false

@onready var battle_timer = $battle_timer



# Called when the node enters the scene tree for the first time.
func _ready():
	globs.clicked_letter.connect(clicked_letter)
	globs.move_letter_to_top.connect(move_letter_to_top)
	globs.move_letter_to_bot.connect(move_letter_to_bot)
	globs.drop_in_area.connect(drop_in_area)
	
	globs.clear_bot.connect(clear_bot)
	globs.freeze_button.connect(freeze_button)
	globs.menu_screen.connect(menu_screen)
	

func menu_screen():
	self.visible = !self.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	globvars.FOCUSED_LETTER = focused_letter

func clicked_letter(letter):
	# Error Returns #
	if !is_instance_valid(letter): push_error('CLIKED_LETTER ON BOARD IS NOT VALID'); return
	if letter == null: push_error('CLIKED_LETTER ON BOARD IS NULL'); return
	if SETTING_UP: return
	
	# bot letters #
	if letter in bot_letters:
		# Battle Round
		if BATTLE_PHASE: return
		
		# Shop Round (Focus so can freeze OR just move to top?) (maybe if focused & clicked goes into shop)
		if focused_letter == null:  focus_letter(letter)
		elif focused_letter != letter:
			if focused_letter in top_letters: swap_letters(letter, focused_letter)
			else: unfocus_letter(focused_letter); focus_letter(letter)
		elif focused_letter == letter: 
			unfocus_letter(focused_letter)
	
	# top letters #
	elif letter in top_letters:
		if focused_letter == null:  focus_letter(letter)
		elif focused_letter != letter: swap_letters(focused_letter, letter)
		elif focused_letter == letter: 
			unfocus_letter(focused_letter)

func get_letter_row(letter) -> String:
	if letter in bot_letters: return 'bot'
	elif letter in top_letters: return 'top'
	
	return 'null'

func check_if_area_free(letter, marker, in_top) -> bool:
	if marker == -1: return true
	
	if letter in bot_letters: 
		if bot_letters[marker] == null: return true
		if bot_letters[marker] == letter: letter.drop_back() ; return true
		if bot_letters[marker] != letter: return false
	if letter in top_letters:
		if top_letters[marker] == null: return true
		if top_letters[marker] == letter: letter.drop_back() ; return true
		if top_letters[marker] != letter: return false
	
	return false
	
### MOVING LETTERS AROUND ###
func focus_letter(letter):
	if letter == null: return
	
	globvars.change_focus_animation_playing(true)
	focused_letter = letter
	letter.set_focused(true)
	var tween = create_tween()
	tween.tween_property(letter, 'rotation_degrees', -5, 0.1)
	tween.parallel().tween_property(letter, 'scale', Vector2(1.3, 1.3), 0.1)
	tween.tween_property(letter, 'rotation_degrees', 0, 0.1)
	
	tween.tween_callback(letter.letter_focus_timer.bind(true))
	tween.parallel().tween_callback(globvars.change_focus_animation_playing.bind(false))

func unfocus_letter(letter): 
	if letter == null: return
	if globvars.FOCUS_ANIMATION_PLAYING: return
	
	if focused_letter == letter: 
		focused_letter = null
	
	letter.set_focused(false)
	var tween = create_tween()
	tween.tween_callback(letter.letter_focus_timer.bind(false))
	tween.tween_property(letter, 'rotation_degrees', 5, 0.1)
	tween.parallel().tween_property(letter, 'scale', Vector2(1.0, 1.0), 0.1)
	tween.tween_property(letter, 'rotation_degrees', 0, 0.1)

func drop_in_area(letter, marker:int, in_top:bool): 
	## False if swap, True to just move
	# print(check_if_area_free(letter, marker, in_top))
	if in_top:
		if top_letters[marker] == null: move_letter_to_top(letter, marker)
		elif top_letters[marker] == letter: letter.drop_back() ; return
		elif top_letters[marker] != letter:  swap_letters(letter, top_letters[marker])
	else:
		if letter in bot_letters:  letter.drop_back() ; return
		if bot_letters[marker] == null:  move_letter_to_bot(letter, marker)
		elif bot_letters[marker] == letter: letter.drop_back() ; return
		elif bot_letters[marker] != letter: swap_letters(bot_letters[marker], letter)
	
	

func swap_letters(in_letter, out_letter): # Swaps only top letters with each other? and bot-top (top goes back down)
	unfocus_letter(focused_letter)
	print('SWAPPING IN_LETTER: ', in_letter.character, ' | WITH OUT_LETTER: ', out_letter.character)
	
	if in_letter in top_letters: 
		globvars.change_swapping_animation_playing(true)
		var in_pos = top_letters.find(in_letter)
		var out_pos = top_letters.find(out_letter)
		top_letters[in_pos] = out_letter
		top_letters[out_pos] = in_letter
		
		# move tween
		var tween = create_tween()
		tween.tween_property(in_letter, 'rotation_degrees', 5, 0.1)
		tween.parallel().tween_property(in_letter, 'position', top_markers[out_pos].global_position, 0.1)
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
		tween.parallel().tween_property(out_letter, 'rotation_degrees', 5, 0.1)
		tween.parallel().tween_property(out_letter, 'position', top_markers[in_pos].global_position, 0.1)
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
		tween.tween_property(in_letter, 'rotation_degrees', 0, 0.1)
		tween.parallel().tween_property(out_letter, 'rotation_degrees', 0, 0.1)
		tween.tween_callback(globvars.change_swapping_animation_playing.bind(false))
	
	elif in_letter in bot_letters: 
		globvars.change_swapping_animation_playing(true)
		var in_pos = bot_letters.find(in_letter)
		var out_pos = top_letters.find(out_letter)
		bot_letters[in_pos] = out_letter
		top_letters[out_pos] = in_letter
		
		var tween = create_tween()
		tween.tween_property(in_letter, 'rotation_degrees', 5, 0.1)
		tween.parallel().tween_property(in_letter, 'position', top_markers[out_pos].global_position, 0.1)
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
		tween.parallel().tween_property(out_letter, 'rotation_degrees', 5, 0.1)
		tween.parallel().tween_property(out_letter, 'position', bot_markers[in_pos].global_position, 0.1)
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
		tween.tween_property(in_letter, 'rotation_degrees', 0, 0.1)
		tween.parallel().tween_property(out_letter, 'rotation_degrees', 0, 0.1)
		tween.tween_callback(globvars.change_swapping_animation_playing.bind(false))
		
	elif out_letter in bot_letters: 
		globvars.change_swapping_animation_playing(true)
		var in_pos = top_letters.find(in_letter)
		var out_pos = bot_letters.find(out_letter)
		bot_letters[in_pos] = out_letter
		top_letters[out_pos] = in_letter
		
		var tween = create_tween()
		tween.tween_property(in_letter, 'rotation_degrees', 5, 0.1)
		tween.parallel().tween_property(in_letter, 'position', bot_markers[out_pos].global_position, 0.1)
		tween.parallel().tween_property(out_letter, 'rotation_degrees', 5, 0.1)
		tween.parallel().tween_property(out_letter, 'position', top_markers[in_pos].global_position, 0.1)
		tween.tween_property(in_letter, 'rotation_degrees', 0, 0.1)
		tween.parallel().tween_property(out_letter, 'rotation_degrees', 0, 0.1)
		tween.tween_callback(globvars.change_swapping_animation_playing.bind(false))

func move_letter_to_top(letter, marker:int):
	# checks to see if area is free (for dragging) false = not free moves back
	# if check_if_area_free(letter, marker) == false: letter.drop_back() ; return 
	
	# removes letter from what array it's currently in
	if letter in bot_letters: bot_letters[bot_letters.find(letter)] = null
	elif letter in top_letters: top_letters[top_letters.find(letter)] = null
	
	# gets free marker spot if none-provided -> twice so it returns error if fail on get_free_spot
	if marker == -1: marker = get_free_spot('top')
	if marker == -1: push_error('MOVE_LETTER_TO_TOP MARKER FAIL'); return
	
	top_letters[marker] = letter
	if focused_letter == letter: unfocus_letter(letter)
	
	var tween = create_tween()
	tween.tween_property(letter, 'rotation_degrees', 5, 0.1)
	tween.parallel().tween_property(letter, 'position', top_markers[marker].global_position, 0.1)
	tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
	tween.tween_property(letter, 'rotation_degrees', 0, 0.1)

func move_letter_to_bot(letter, marker:int):
	# if check_if_area_free(letter, marker) == false: letter.drop_back() ; return 
	
	# removes letter from what array it's currently in
	if letter in bot_letters: bot_letters[bot_letters.find(letter)] = null
	elif letter in top_letters: top_letters[top_letters.find(letter)] = null
	
	# gets free marker spot if none-provided -> twice so it returns error if fail on get_free_spot
	if marker == -1: marker = get_free_spot('bot')
	if marker == -1: push_error('MOVE_LETTER_TO_BOT MARKER FAIL'); return
	
	bot_letters[marker] = letter
	if focused_letter == letter: unfocus_letter(letter)
	
	var tween = create_tween()
	tween.tween_property(letter, 'rotation_degrees', 5, 0.1)
	tween.parallel().tween_property(letter, 'position', bot_markers[marker].global_position, 0.1)
	tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
	tween.tween_property(letter, 'rotation_degrees', 0, 0.1)

func place_letter_onto_board(letter): ## Places letter onto bot only
	var marker_int = get_free_spot('bot')
	if marker_int == -1: push_error('GET_FREE_SPOT IS FULL IN PLANCE_LETTER_ONTO_BOARD'); return
	
	bot_letters[marker_int] = letter
	place_animation(letter, marker_int)

func get_free_spot(where:String) -> int:
	var marker_int = 0
	var what_array = bot_letters
	if where == 'top': what_array = top_letters
	for letter_slot in what_array:
		if letter_slot == null: 
			return marker_int
		marker_int += 1
	
	return -1

func clear_bot(): # clears all in bot NEED OTHER FOR SHOP RESET IF SO
	if SETTING_UP: push_error('BOARD ALREADY SETTING UP, SHOP_ROUND') ; return
	unfocus_letter(focused_letter)
	var i = 0
	while i < globvars.MAX_LETTERS:
		var letter = bot_letters[i]
		if letter == null: pass
		bot_letters[i] = null 
		leave_animation(letter)
		i += 1
	

### FREEZE & TRASH LETTERS -> no longer freezes just trash ###
func freeze_button():
	# print(focused_letter)
	if focused_letter == null: return
	
#	if focused_letter in bot_letters: # Freeze / Un-Freeze
#		focused_letter.freeze_letter()
#		unfocus_letter(focused_letter)
#	elif focused_letter in top_letters: # Trashes
	
	# Get's rid of top_letters entirely, dedicated trash button
	top_letters[top_letters.find(focused_letter)] = null
	var tween = create_tween()
	leave_animation(focused_letter)

func _on_letters_back_pressed():
	var i = 0
	while i < 7:
		if bot_letters[i] != null:
			move_letter_to_bot(bot_letters[i], i)
			print('cleaning: ', bot_letters[i].character)
		i += 1
	
	i = 0
	while i < 7:
		if top_letters[i] != null:
			move_letter_to_top(top_letters[i], i)
			print('cleaning: ', top_letters[i].character)
		i += 1

####################################################################################################
### ANIMATIONS ###

func place_animation(letter, into_pos): # for general placing on bot only (round start/change shop)
	var tween = create_tween()
	tween.tween_property(letter, 'global_position', bot_markers[into_pos].position, 0.2)
	tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))

func leave_animation(letter): ## KILLS LETTERS
	if letter == null: return
	
	var tween = create_tween()
	tween.tween_property(letter, 'position', mark_leave.position, 0.2)
	tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
	tween.tween_callback(letter.kill_letter)

func _on_ani_timer_timeout():
	var rand_frame = randi_range(0,5)
	while rand_frame == background.frame: rand_frame = randi_range(0,5)
	background.frame = rand_frame

####################################################################################################

### BATTLE PHASE ###
func battle_board():
	## Saves word to SilentWolf ##
	globs.send_word_to_sw(top_letters)
	
	$battle_timer/read_timer.start()
	await $battle_timer/read_timer.timeout
	
	globs.emit_signal('fight_animation')
	battle_timer.start()
	await battle_timer.timeout
	
	
	BATTLE_PHASE = true
	var i = 0
	while BATTLE_PHASE:
		letter_battle()
		battle_timer.start()
		await battle_timer.timeout
		

func letter_battle():
	## Gets letters ##
	var i = 0
	var top_letter = null
	while i < globvars.MAX_LETTERS:
		top_letter = top_letters[i]
		if top_letter != null: break
		i += 1
	var top_arr_spot = i
	i = 0
	var bot_letter = null
	while i < globvars.MAX_LETTERS:
		bot_letter = bot_letters[i]
		if bot_letter != null: break
		i += 1
	var bot_arr_spot = i
	
	## NULL LETTERS = LOST ##
	if top_letter == null and bot_letter == null: print('BOTH LOST') ; globs.emit_signal('after_battle_animations', 'tie') ; BATTLE_PHASE = false ; return
	elif top_letter == null: globs.emit_signal('after_battle_animations', 'lost') ; BATTLE_PHASE = false ; return
	elif bot_letter == null: globs.emit_signal('after_battle_animations', 'won') ; BATTLE_PHASE = false ; return
	
	## DETERMINE WINNER & DO ANIMATION ##
	var top_new_health = top_letter.health - bot_letter.attack 
	var bot_new_health = bot_letter.health - top_letter.attack
	var top_pos = top_letter.global_position
	var bot_pos = bot_letter.global_position
	
	# Tween to move both together
	var tween = create_tween()
	tween.tween_property(top_letter.letter_sprite, 'rotation_degrees', randi_range(-10, -15), 0.2)
	tween.parallel().tween_property(bot_letter.letter_sprite, 'rotation_degrees', randi_range(-5, -15), 0.2)
	
	tween.tween_property(top_letter.letter_sprite, 'global_position', mid_marker.global_position, 0.02)
	tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
	tween.parallel().tween_property(bot_letter.letter_sprite, 'global_position', mid_marker.global_position, 0.02)
	tween.parallel().tween_callback(globs.emit_signal.bind('sfx_woosh'))
	tween.parallel().tween_property(top_letter.letter_sprite, 'rotation_degrees', 0, 0.02)
	tween.parallel().tween_property(bot_letter.letter_sprite, 'rotation_degrees', 0,0.02)
	
	tween.tween_callback(globs.emit_signal.bind('hit_effect'))
	tween.parallel().tween_callback(globs.emit_signal.bind('screen_shake', 10))
	
	# Tween to move back (and death)
	if top_new_health <= 0 and bot_new_health <= 0: 
		top_letters[top_arr_spot] = null
		bot_letters[bot_arr_spot] = null
		tween.tween_callback(globs.emit_signal.bind('sfx_grunt'))
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_grunt'))
		
		tween.tween_property(top_letter.letter_sprite, 'global_position', Vector2(randi_range(-100, 100), top_marker.global_position[1]), 0.1)
		tween.parallel().tween_property(bot_letter.letter_sprite, 'global_position', Vector2(randi_range(-100, 100), bot_marker.global_position[1]), 0.1)
		tween.parallel().tween_property(top_letter.letter_sprite, 'rotation_degrees', 1000, 0.1)
		tween.parallel().tween_property(bot_letter.letter_sprite, 'rotation_degrees', 1000, 0.1)
		
		tween.tween_callback(top_letter.kill_letter)
		tween.tween_callback(bot_letter.kill_letter)
	elif top_new_health <= 0: 
		tween.tween_callback(globs.emit_signal.bind('sfx_punch'))
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_grunt'))
		
		tween.tween_callback(bot_letter.set_letter.bind(bot_letter.character, bot_letter.attack, bot_new_health))
		top_letters[top_arr_spot] = null
		tween.tween_property(top_letter.letter_sprite, 'global_position', Vector2(randi_range(-100, 100), top_marker.global_position[1]), 0.1)
		tween.parallel().tween_property(bot_letter.letter_sprite, 'global_position', bot_pos, 0.1)
		tween.parallel().tween_property(top_letter.letter_sprite, 'rotation_degrees', 1000, 0.1)
		
		tween.tween_callback(top_letter.kill_letter)
	elif bot_new_health <= 0: 
		tween.tween_callback(globs.emit_signal.bind('sfx_punch'))
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_grunt'))
		
		tween.tween_callback(top_letter.set_letter.bind(top_letter.character, top_letter.attack, top_new_health))
		bot_letters[bot_arr_spot] = null
		tween.tween_property(bot_letter.letter_sprite, 'global_position', Vector2(randi_range(-100, 100), bot_marker.global_position[1]), 0.1)
		tween.parallel().tween_property(top_letter.letter_sprite, 'global_position', top_pos, 0.1)
		tween.parallel().tween_property(bot_letter.letter_sprite, 'rotation_degrees', 1000, 0.1)
		
		tween.tween_callback(bot_letter.kill_letter)
	else: 
		tween.tween_callback(globs.emit_signal.bind('sfx_punch'))
		tween.parallel().tween_callback(globs.emit_signal.bind('sfx_punch'))
		
		tween.tween_callback(bot_letter.set_letter.bind(bot_letter.character, bot_letter.attack, bot_new_health))
		tween.tween_callback(top_letter.set_letter.bind(top_letter.character, top_letter.attack, top_new_health))
		tween.tween_property(bot_letter.letter_sprite, 'global_position', bot_pos, 0.1)
		tween.tween_property(top_letter.letter_sprite, 'global_position', top_pos, 0.1)



