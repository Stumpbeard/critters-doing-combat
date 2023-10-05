extends TextureRect

var level_info = {"level": 1, "to_next_level": 1, "hp": 0, "strength": 0, "speed": 0, "kill_dollars": 0}
var level_up_scene = preload("res://level_up_pop_up.tscn")
var player_scene = preload("res://ratler.tscn")

var mousle_img = preload("res://mousle.png")
var pizzaling_img = preload("res://pizzaling.png")
var gullmeyer_img = preload("res://gullmeyer.png")
var ratocopter_img = preload("res://ratocopter.png")
var roachmeiser_img = preload("res://roachmeiser.png")
var baggo_img = preload("res://baggo.png")
var demogator_img = preload("res://demogator.png")
var ferroth_img = preload("res://ferroth.png")

var kills = {}

var player

func _ready():
	get_kills_from_game_shell()
	$ShopBuyMenu.scale = Vector2(0, 0)
	player = player_scene.instantiate()
	player.position = Vector2(1076, 600)
	player.in_shop_mode = true
	add_child(player)
	show_kill_counters()
	
func get_kills_from_game_shell():
	var shell = get_node_or_null('/root/GameShell')
	if not shell is GameShell:
		return
	kills = shell.kills
	
	
func show_kill_counters():
	var total_offset = Vector2(0, 0)
	if "Mousle" in kills:
		for kill in kills["Mousle"]:
			var sprite = Sprite2D.new()
			sprite.texture = mousle_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 16
	if "Pizzaling" in kills:
		for kill in kills["Pizzaling"]:
			var sprite = Sprite2D.new()
			sprite.texture = pizzaling_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 16
	if "Gullmeyer" in kills:
		for kill in kills["Gullmeyer"]:
			var sprite = Sprite2D.new()
			sprite.texture = gullmeyer_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 16
	if "Ferroth" in kills:
		for kill in kills["Ferroth"]:
			var sprite = Sprite2D.new()
			sprite.texture = ferroth_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 16
	if "Demogator" in kills:
		for kill in kills["Demogator"]:
			var sprite = Sprite2D.new()
			sprite.texture = demogator_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 16
	if "Rat-O-Copter" in kills:
		for kill in kills["Rat-O-Copter"]:
			var sprite = Sprite2D.new()
			sprite.texture = ratocopter_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 32
	if "Roachmeiser" in kills:
		for kill in kills["Roachmeiser"]:
			var sprite = Sprite2D.new()
			sprite.texture = roachmeiser_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 32
	if "Baggo" in kills:
		for kill in kills["Baggo"]:
			var sprite = Sprite2D.new()
			sprite.texture = baggo_img
			sprite.position = Vector2(0, 616) + total_offset
			$Kills.add_child(sprite)
			total_offset.x += 32

func _on_typing_text_text_done_displaying():
	show_shop_menu()


func show_shop_menu():
	create_tween().tween_property($ShopBuyMenu, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func set_player_info(new_level_info, heals):
	level_info = new_level_info
	$ShopBuyMenu.set_player_info(new_level_info, heals)

func level_up_critter():
	Global.play_chaching()
	player.level_up()
	var level_up_pop = level_up_scene.instantiate()
	level_up_pop.position = player.position
	add_child(level_up_pop)

func _on_shop_buy_menu_bought_hp():
	level_up_critter()


func _on_shop_buy_menu_bought_strength():
	level_up_critter()


func _on_shop_buy_menu_bought_speed():
	level_up_critter()
