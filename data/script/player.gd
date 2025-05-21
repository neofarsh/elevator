extends KinematicBody
var vector = {
	"direction": Vector3(),
	"input_axis": Vector2(),
	"velocity": Vector3(),
	"snap": Vector3()
	}
var speed = {
	"base": 10,
	"normal": 10,
	"sprint": 16,
	"fov_normal": 70,
	"fov_multiplier": 1.2
	}

#ready
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#movement
func _physics_process(delta) -> void:
	vector.input_axis = Input.get_vector("move_down", "move_up", "move_left", "move_right")
	direction_input()
	if vector.input_axis != Vector2(0,0):
		if !$interface_layer.menu_use:
			$camera_node/anim_player.play("walking")
		else:
			$camera_node/anim_player.play("RESET", 0.2)
	else:
		$camera_node/anim_player.play("RESET", 0.2)
	if is_on_floor():
		vector.snap = -get_floor_normal() - get_floor_velocity() * delta
		if vector.velocity.y < 0:
			vector.velocity.y = 0
		if Input.is_action_just_pressed("move_jump"):
			vector.snap = Vector3.ZERO
			vector.velocity.y = 10.0 #jump_height
	else:
		if vector.snap != Vector3.ZERO && vector.velocity.y != 0:
			vector.velocity.y = 0
		vector.snap = Vector3.ZERO
		vector.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * 3.0 * delta

	if $interface_layer.menu_use:
		pass
	elif is_on_floor() and Input.is_action_pressed("move_sprint") and vector.input_axis.x >= 0.5:
		speed.base = speed.sprint
		$camera_node/anim_player.playback_speed = 1.25
		$camera_node.set_fov(lerp($camera_node.fov, speed.fov_normal * speed.fov_multiplier, delta * 8))
	else:
		speed.base = speed.normal
		$camera_node/anim_player.playback_speed = 1
		$camera_node.set_fov(lerp($camera_node.fov, speed.fov_normal, delta * 8))

	accelerate(delta)
	vector.velocity = move_and_slide_with_snap(vector.velocity, vector.snap, #base_devel
		Vector3.UP, #vector_up
		true, #stop_on_slote
		4, deg2rad(45.0)) #floor_angle
func direction_input() -> void:
	vector.direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if !$interface_layer.menu_use:
		if vector.input_axis.x >= 0.5:
			vector.direction -= aim.z
		if vector.input_axis.x <= -0.5:
			vector.direction += aim.z
		if vector.input_axis.y <= -0.5:
			vector.direction -= aim.x
		if vector.input_axis.y >= 0.5:
			vector.direction += aim.x
	vector.direction.y = 0
	vector.direction = vector.direction.normalized()
func accelerate(delta: float) -> void:
	var temp_vel = vector.velocity
	temp_vel.y = 0
	var temp_accel: float
	var target: Vector3 = vector.direction * speed.base
	
	if vector.direction.dot(temp_vel) > 0:
		temp_accel = 8 #acceleration
	else:
		temp_accel = 10 #deceleration
	if not is_on_floor():
		temp_accel *= 0.3 #air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	vector.velocity.x = temp_vel.x
	vector.velocity.z = temp_vel.z

#instrument
func _input(event):
	if event.is_action_pressed("use_item"):
		$audio/se/flashlight.play()
		$camera_node/flashlight/light.visible = !$camera_node/flashlight/light.visible
