extends Spatial
var used_to = false
var room = {
	"generation": null,
	"type": null
	}


func body_entered(body):
	if !used_to and (body.name == "player_0"):
		generation_room()

func generation_room():
	if Global.player_data.doors_open == 40:
		room.generation = load("res://data/rooms/0.end_room.tscn").instance()
		Global.game_data.last_door = 0
		room.generation.global_transform = $position.global_transform
		Global.game_data.room_center.add_child(room.generation)
		used_to = true
	else:
		var random = randi()%60 + 1
		if random <= 15:
			room.generation = load("res://data/rooms/2.zig_zag.tscn").instance()
			room.type = "zig"
		elif random >= 55:
			room.generation = load("res://data/rooms/4.double_one.tscn").instance()
			room.type = "duo"
		elif random >= 40:
			room.generation = load("res://data/rooms/1.up_down.tscn").instance()
			room.type = "uad"
		elif random >= 30:
			room.generation = load("res://data/rooms/5.left_right.tscn").instance()
			room.type = "ral"
		else:
			room.generation = load("res://data/rooms/3.forward.tscn").instance()
			room.type = "for"
		if room.type == Global.game_data.last_door:
			generation_room()
			return
		Global.game_data.last_door = room.type
		room.generation.global_transform = $position.global_transform
		Global.player_data.doors_open += 1
		room.generation.set_name("room_" + str(Global.player_data.doors_open))
		Global.game_data.room_center.add_child(room.generation)
		used_to = true

