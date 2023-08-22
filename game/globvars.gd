extends Node


@onready var MAX_LETTERS = 7
@onready var MAX_SHOP_STATS = 9 # Need to Reset when goes into battle-round
@onready var MENU_MAX_SHOP_STATS = 9
@onready var first_play_shop = true
@onready var first_jam_info = true

@onready var alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
@onready var valid_words: Dictionary
@onready var three_letter_words = []

@onready var FOCUS_ANIMATION_PLAYING:bool = false
@onready var SWAPPING_ANIMATION_PLAYING: bool = false
@onready var PLAYER_HOLDING_LETTER: bool = false
@onready var FOCUSED_LETTER = null

@onready var IN_MENU = true

@onready var volume = 0
@onready var music_volume = 0
@onready var drag_mode = false
@onready var gun_mode = false

@onready var mute_music = true
@onready var mute_sfx = false

## Silent Wolf stuff ##
@onready var sw_name = 'aaa'
func name_change(new_text: String): sw_name = new_text

@onready var sw_letters: Dictionary
@onready var sw_all_users_name = 'all_users'
@onready var sw_all_users: Array

func _ready():
	globs.name_change.connect(name_change)
	
	### LOADS WORDS INTO VALID_WORDS ###
	var words_file = FileAccess.open("res://words_dictionary.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse = json_object.parse(words_file.get_as_text())
	
	for word in json_object.get_data():
		if word.length() == 3: three_letter_words.append(word)
		
		if word.length() > MAX_LETTERS: continue
		else: valid_words[word] = 1
	

func change_focus_animation_playing(to_go): FOCUS_ANIMATION_PLAYING = to_go
func change_swapping_animation_playing(to_go): SWAPPING_ANIMATION_PLAYING = to_go
