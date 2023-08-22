extends Node2D

@onready var sfx_volume = 0
@onready var bgm = $bgm
@onready var bgm_battle = $bgm_battle

@onready var during_battle = $during_battle
@onready var during_battle_2 = $during_battle2

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.sfx_woosh.connect(sfx_woosh)
	globs.sfx_punch.connect(sfx_punch)
	globs.sfx_grunt.connect(sfx_grunt)
	
	globs.sfx_battle_done.connect(sfx_battle_done)
	globs.music_volume_changed.connect(music_volume_changed)
	
	globs.sfx_firework.connect(sfx_firework_play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globvars.mute_music: 
		bgm.stop()
		during_battle.stop()
		during_battle_2.stop()
	
	## if BGM stopped playing ##
	if get_parent().BATTLE_PHASE and !globvars.mute_music:
		bgm.stop()
		if !during_battle.is_playing() and !during_battle_2.is_playing():
			var coinflip = randi_range(0, 1)
			if coinflip == 1: during_battle_2.play()
			else: during_battle.play()
	elif !bgm.is_playing() and !bgm_battle.is_playing() and !globvars.mute_music:
		bgm.play()

func sfx_battle_done(won):
	if globvars.mute_music: return
	bgm.stop()
	bgm_battle.play()

func music_volume_changed(new_value):
	bgm.set_volume_db(new_value-30)
	bgm_battle.set_volume_db(new_value-25)
	during_battle.set_volume_db(new_value)
	during_battle_2.set_volume_db(new_value)

### WOOSH ###
@onready var woosh_array = [$wooshes/woosh_1, $wooshes/woosh_2, $wooshes/woosh_3, $wooshes/woosh_4, $wooshes/woosh_5, $wooshes/woosh_6, $wooshes/woosh_7, $wooshes/woosh_8, $wooshes/woosh_9, $wooshes/woosh_10, $wooshes/woosh_11, $wooshes/woosh_12]

func sfx_woosh():
	if globvars.mute_sfx: return
	var new_woosh = woosh_array.pick_random()
	new_woosh.set_volume_db(globvars.volume)
	new_woosh.play()


### PUNCHES & GRUNTS ###
@onready var punch_array = [$punches/punch_1, $punches/punch_2, $punches/punch_3, $punches/punch_4, $punches/punch_5, $punches/punch_6, $punches/punch_7, $punches/punch_8, $punches/punch_9, $punches/punch_10, $punches/punch_11, $punches/punch_12]
@onready var grunt_array = [$punch_grunt/grunt_1, $punch_grunt/grunt_2, $punch_grunt/grunt_3] 

func sfx_punch():
	if globvars.mute_sfx: return
	var new_punch = punch_array.pick_random()
	new_punch.set_volume_db(globvars.volume)
	new_punch.play()
func sfx_grunt():
	if globvars.mute_sfx: return
	var new_grunt = grunt_array.pick_random()
	new_grunt.set_volume_db(globvars.volume)
	new_grunt.play()

@onready var sfx_firework = $sfx_firework

func sfx_firework_play():
	if globvars.mute_sfx: return
	sfx_firework.set_volume_db(globvars.volume)
	sfx_firework.play()
	
