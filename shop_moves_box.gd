extends Sprite2D

@export var bought_moves: Array[GameShell.Moves] = [GameShell.Moves.HELLFIRE]

var fading_text_scene = preload("res://fading_text.tscn")
var kills = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	get_moves_from_game_shell()
	get_kills_from_game_shell()
	for move in bought_moves:
		match move:
			GameShell.Moves.BIG_CHOMP:
				$BigChomp/Cost.visible = false
				$BigChomp/SoldOut.visible = true
			GameShell.Moves.WINGSLAP:
				$Wingslap/Cost.visible = false
				$Wingslap/SoldOut.visible = true
			GameShell.Moves.FATBERG:
				$Fatberg/Cost.visible = false
				$Fatberg/SoldOut.visible = true
			GameShell.Moves.SALVATION:
				$Salvation/Cost.visible = false
				$Salvation/SoldOut.visible = true
			GameShell.Moves.HELLFIRE:
				$Hellfire/Cost.visible = false
				$Hellfire/SoldOut.visible = true
				
	for child in get_children():
		child.connect("mouse_entered", _on_text_mouse_entered.bind(child))
		child.connect("mouse_exited", _on_text_mouse_exited.bind(child))
		child.connect("gui_input", _on_text_mouse_input.bind(child))


func get_moves_from_game_shell():
	var shell = get_node_or_null('/root/GameShell')
	if not shell is GameShell:
		return
	bought_moves = shell.bought_moves
	
func get_kills_from_game_shell():
	var shell = get_node_or_null('/root/GameShell')
	if not shell is GameShell:
		return
	kills = shell.kills


func _on_text_mouse_entered(text):
	create_tween().tween_property(text, "scale", Vector2(1.1, 1.1), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	text.z_index = 1

func _on_text_mouse_exited(text):
	create_tween().tween_property(text, "scale", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	text.z_index = 0
	
func switch_to_sold_out(text):
	Global.play_chaching()
	text.get_node("Cost").visible = false
	text.get_node("SoldOut").visible = true
	var fading_text = fading_text_scene.instantiate()
	var roll = randi() % 3
	match roll:
		0:
			fading_text.text = "Cha-ching!"
		1:
			fading_text.text = "Score!"
		2:
			fading_text.text = "New move!"
	text.add_child(fading_text)
	
func not_enough(text):
	Global.play_error()
	var fading_text = fading_text_scene.instantiate()
	var roll = randi() % 3
	match roll:
		0:
			fading_text.text = "Not enough!"
		1:
			fading_text.text = "Come back later!"
		2:
			fading_text.text = "Fight more!"
	text.add_child(fading_text)
	
func _on_text_mouse_input(event, text):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if text.get_node('SoldOut').visible:
				var fading_text = fading_text_scene.instantiate()
				var roll = randi() % 3
				match roll:
					0:
						fading_text.text = "Sold out!"
					1:
						fading_text.text = "No can do!"
					2:
						fading_text.text = "Pick another!"
				text.add_child(fading_text)
			else:
				
				match text.name:
					"BigChomp":
						if "Rat-O-Copter" in kills && kills["Rat-O-Copter"] >= 1:
							bought_moves.append(GameShell.Moves.BIG_CHOMP)
							switch_to_sold_out(text)
						else:
							not_enough(text)
					"Wingslap":
						if "Baggo" in kills && kills["Baggo"] >= 1:
							bought_moves.append(GameShell.Moves.WINGSLAP)
							switch_to_sold_out(text)
						else:
							not_enough(text)
					"Fatberg":
						if "Roachmeiser" in kills && kills["Roachmeiser"] >= 1:
							bought_moves.append(GameShell.Moves.FATBERG)
							switch_to_sold_out(text)
						else:
							not_enough(text)
					"Salvation":
						if "Ferroth" in kills && kills["Ferroth"] >= 10:
							bought_moves.append(GameShell.Moves.SALVATION)
							switch_to_sold_out(text)
						else:
							not_enough(text)
					"Hellfire":
						if "Demogator" in kills && kills["Demogator"] >= 10:
							bought_moves.append(GameShell.Moves.HELLFIRE)
							switch_to_sold_out(text)
						else:
							not_enough(text)
