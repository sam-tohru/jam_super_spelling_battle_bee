extends Node2D

@onready var word_areas = [$letter_areas/mark_0, $letter_areas/mark_1, $letter_areas/mark_2]
@onready var word_letters = [$letter_areas/mark_0/menu_letter, $letter_areas/mark_1/menu_letter, $letter_areas/mark_2/menu_letter]

@onready var reroll_num = 9
@onready var refresh_stats = $refresh_menu/refresh_stats


# Called when the node enters the scene tree for the first time.
func _ready():
	new_three_letter_word()
	globs.menu_screen.connect(menu_screen)
	
	if globvars.first_jam_info: 
		globvars.first_jam_info = false
		var info_page = load("res://menu/info_page.tscn")
		var info_instance = info_page.instantiate()
		call_deferred('add_child', info_instance)
	

func menu_screen():
	reset_menu()
	self.visible = !self.visible
	globvars.IN_MENU = self.visible

func reset_menu():
	reroll_num = 9
	refresh_stats.text = str(reroll_num)
	# new_three_letter_word()

func new_three_letter_word(): # Changes name here
	var new_word = globvars.three_letter_words.pick_random()
	print(new_word)
	
	var i = 0
	for letter in word_letters:
		var character = new_word.substr(i, 1)
		letter.change_animation(character, reroll_num)
		i += 1
	
	globs.emit_signal('name_change', new_word)


func _on_refresh_menu_pressed():
	reroll_num -= 1
	reroll_num = clamp(reroll_num, 1, 9)
	refresh_stats.text = str(reroll_num)
	new_three_letter_word()


func _on_menu_pressed():
	globs.emit_signal('menu_screen')
	if globvars.first_play_shop: 
		globvars.first_play_shop = false
		globs.emit_signal('shop_round')


func _on_settings_pressed():
	var setting_page = load("res://menu/settings_bg.tscn")
	var setting_instance = setting_page.instantiate()
	call_deferred('add_child', setting_instance)



func _on_reset_pressed():
	globs.emit_signal('screen_shake', 50)
	globvars.MAX_SHOP_STATS = 9
	globvars.first_play_shop = true
	
	get_tree().reload_current_scene()


func _on_menu_2_pressed():
	var setting_page = load("res://menu/info_page.tscn")
	var setting_instance = setting_page.instantiate()
	call_deferred('add_child', setting_instance)
