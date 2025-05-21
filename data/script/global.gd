extends Node
var player_data = {
	"doors_open": 0
	}
var game_data = {
	"multiplayer": false,
	"last_door": null,
	"room_center": null
	}

func _ready():
	set_name("global")
	randomize()
