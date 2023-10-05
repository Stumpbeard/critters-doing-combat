extends Sprite2D

@export var present_moves: Array[GameShell.Moves] = [GameShell.Moves.BIG_CHOMP, GameShell.Moves.FATBERG, GameShell.Moves.SALVATION, GameShell.Moves.HELLFIRE, GameShell.Moves.WINGSLAP]

var typing_text_scene = preload("res://typing_text.tscn")

var selected_text


# Called when the node enters the scene tree for the first time.
func _ready():
	get_moves_from_game_shell()
	if present_moves.size() < 2:
		visible = false
	var text_offset = Vector2(0, 0)
	var first = true
	for move in present_moves:
		var typing_text = typing_text_scene.instantiate()
		typing_text.reveal = false
		typing_text.text_size = 32
		typing_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		match move:
			GameShell.Moves.BIG_CHOMP:
				typing_text.text = "Big chomp"
			GameShell.Moves.WINGSLAP:
				typing_text.text = "Wingslap"
			GameShell.Moves.FATBERG:
				typing_text.text = "Fatberg"
			GameShell.Moves.SALVATION:
				typing_text.text = "Salvation"
			GameShell.Moves.HELLFIRE:
				typing_text.text = "Hellfire"
		typing_text.position = Vector2(-62, -91) + text_offset
		typing_text.connect("mouse_entered", _on_mouse_entered.bind(typing_text))
		typing_text.connect("mouse_exited", _on_mouse_exited.bind(typing_text))
		typing_text.connect("gui_input", _on_gui_input.bind(typing_text))
		text_offset.y += 35
		add_child(typing_text)
		if first:
			selected_text = typing_text
			first = false
			make_big(typing_text)
		
		
		
func get_moves_from_game_shell():
	var shell = get_node_or_null('/root/GameShell')
	if not shell is GameShell:
		return
	present_moves = shell.bought_moves
	

func make_big(which_text):
	which_text.rotation_degrees = -5
	which_text.scale = Vector2(1.5, 1.5)
	which_text.label_settings.outline_size = 8
	which_text.label_settings.outline_color = "#000000"
	
func make_small(which_text):
	which_text.rotation_degrees = 0
	which_text.scale = Vector2(1, 1)
	which_text.label_settings.outline_size = 0

func _on_mouse_entered(which_text):
	make_big(which_text)
	
func _on_mouse_exited(which_text):
	if which_text != selected_text:
		make_small(which_text)

func _on_gui_input(event, which_text):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if which_text != selected_text:
				make_small(selected_text)
				selected_text = which_text
				make_big(selected_text)
		
func get_selected_move():
	match selected_text.text:
		"Big chomp":
			return Critter.Types.RODENT
		"Wingslap":
			return Critter.Types.BIRD
		"Fatberg":
			return Critter.Types.TRASH
		"Salvation":
			return Critter.Types.HOLY
		"Hellfire":
			return Critter.Types.DEVIL
