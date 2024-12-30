extends Control

@export var bg_color : Color = Color.BLACK
@export var to_scene : PackedScene = null
@export var title_color := Color.BLUE_VIOLET
@export var text_color := Color.WHITE
@export var title_font : FontFile = null
@export var text_font : FontFile = null
@export var Music : AudioStream = null
@export var Use_Video_Audio : bool = false
@export var Video : VideoStream = null
@export var title_font_size : int = 120
@export var text_font_size : int = 90

const section_time := 2.5  # Time before moving to the next section
const line_time := 1.2   # Time for each regular line
const title_extra_delay := 1.0  # Extra delay for titles
const base_speed := 240      # Speed of scrolling
const speed_up_multiplier := 10.0


var is_title := false  # New variable to track if current line is a title


var scroll_speed : float = base_speed
var speed_up := false

@onready var colorrect := $ColorRect
@onready var videoplayer := $VideoPlayer
@onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Treasures Of The Sands (Prototype)",
		"This is our first game. Enjoy."
	],[
		"Programming",
		"Elias Neerbye",
		"Simen Wærstad",
		"Ask Johansen",
		"Lukasz Brzozowski"
	],[
		"Art",
		"Lukasz Brzozowski"
	],[
		"Music",
		"Loreena Mckennit",
		"Suno AI"
	],[
		"Sound Effects",
		"Pixabay & Various other free platforms"
	],[
		"Testers",
		"Ask Johansen",
		"Elias Neerbye",
		"Lukasz Brzozowski",
		"Simen Wærstad"
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with Blender and Adobe Illustrator",
		"https://www.blender.org/about/license/",
		"https://www.adobe.com/legal/terms.html"
	],[
		"Special thanks",
		"Free Content",
		"Good Friends",
		"Crazy Teamwork"
	]
]

func _ready():
	colorrect.color = bg_color
	videoplayer.set_stream(Video)
	if !Use_Video_Audio:
		var stream = AudioStreamPlayer.new()
		stream.set_stream(Music)
		add_child(stream)
		videoplayer.set_volume_db(-80)
		stream.play()
	else:
		videoplayer.set_volume_db(0)
	videoplayer.play()
	

func _process(delta):
	scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		var current_line_time = line_time + (title_extra_delay if is_title else 0)
		if line_timer >= current_line_time:
			line_timer -= current_line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.set_global_position(l.get_global_position() - Vector2(0, scroll_speed))
			if l.get_global_position().y < -l.get_size().y:
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()



func finish():
	if not finished:
		finished = true
		if to_scene != null:
			var path = to_scene.get_path()
			get_tree().change_scene_to_file(path)
		else:
			get_tree().quit()


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)

	if curr_line == 0:
		if title_font != null:
			new_line.add_theme_font_override("font", title_font)
		new_line.add_theme_color_override("font_color", title_color)
		new_line.add_theme_font_size_override("font_size", title_font_size)
		is_title = true
	else:
		if text_font != null:
			new_line.add_theme_font_override("font", text_font)
		new_line.add_theme_color_override("font_color", text_color)
		new_line.add_theme_font_size_override("font_size", text_font_size)
		is_title = false

	$CreditsContainer.add_child(new_line)

	# Position the new line at the bottom of the screen
	var screen_size = get_viewport().get_visible_rect().size
	new_line.set_global_position(Vector2(0, screen_size.y))

	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true
		curr_line = 0  # Reset for the next section




func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
