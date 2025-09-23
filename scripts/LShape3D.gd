
extends Node3D

@export var cube_size: float = 1.0
@export var gap: float = 0.02
@export var rotation_speed_keys: float = 1.2
@export var rotation_sensitivity_mouse: float = 0.005

var dragging: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO

var cubes: Array[MeshInstance3D] = []

func _ready() -> void:
	# Reseta a rotação do nó principal (Lshape3d)
	rotation = Vector3.ZERO
	_create_shape()
	_center_shape()

	var cam_node := $Camera3D
	if cam_node and cam_node is Camera3D:
		var cam: Camera3D = cam_node as Camera3D
		cam.transform.origin = Vector3(0.0, 2.2 * cube_size, 6.0 * cube_size)
		cam.look_at(Vector3.ZERO, Vector3.UP)
		
		cam.rotation = Vector3.ZERO
		
	set_process(true)
	set_process_input(true)

func _create_shape() -> void:

	var grid_positions: Array[Vector3] = [
		Vector3(0, 0, 0),
		Vector3(0, 1, 0),
		Vector3(0, 2, 0), 
		Vector3(1, 0, 0), 
		Vector3(2, 0, 0)
	]

	var base_mat: StandardMaterial3D = StandardMaterial3D.new()
	base_mat.metallic = 0.1
	base_mat.roughness = 0.6

	for i in range(grid_positions.size()):
		var pos: Vector3 = grid_positions[i]
		var m: MeshInstance3D = MeshInstance3D.new()
		var box: BoxMesh = BoxMesh.new()
		box.size = Vector3.ONE * cube_size
		m.mesh = box

		var mat: StandardMaterial3D = base_mat.duplicate() as StandardMaterial3D
		var hue: float = fmod(float(i) * 0.18, 1.0)
		mat.albedo_color = Color.from_hsv(hue, 0.25, 0.95)
		m.set_surface_override_material(0, mat)

		var world_pos: Vector3 = Vector3(
			pos.x * (cube_size + gap),
			pos.y * (cube_size + gap),
			pos.z * (cube_size + gap)
		)
		m.transform.origin = world_pos

		add_child(m)
		cubes.append(m)

func _center_shape() -> void:
	if cubes.is_empty():
		return
	var minp: Vector3 = Vector3(INF, INF, INF)
	var maxp: Vector3 = Vector3(-INF, -INF, -INF)
	for item in cubes:
		var mi: MeshInstance3D = item as MeshInstance3D
		var c: Vector3 = mi.transform.origin
		minp.x = min(minp.x, c.x); minp.y = min(minp.y, c.y); minp.z = min(minp.z, c.z)
		maxp.x = max(maxp.x, c.x); maxp.y = max(maxp.y, c.y); maxp.z = max(maxp.z, c.z)
	var center: Vector3 = (minp + maxp) * 0.5
	for item in cubes:
		var mi2: MeshInstance3D = item as MeshInstance3D
		mi2.transform.origin -= center

func _input(event: InputEvent) -> void:
	# mouse left button start/stop drag
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_pos = event.position
			else:
				dragging = false

		# roda do mouse para zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_zoom_camera(-0.8)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_zoom_camera(0.8)

	elif event is InputEventMouseMotion:
		if dragging:
			
			var mdelta: Vector2 = event.position - last_mouse_pos
			last_mouse_pos = event.position
			rotate_y(-mdelta.x * rotation_sensitivity_mouse)
			rotate_x(-mdelta.y * rotation_sensitivity_mouse)

func _process(delta: float) -> void:
	 # --- Rotação do teclado ---
	var rotation_x = 0.0
	var rotation_y = 0.0

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		rotation_y += rotation_speed_keys * delta
		print("Tecla A ou Esquerda pressionada")
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		rotation_y -= rotation_speed_keys * delta
		print("Tecla D ou Direita pressionada")
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		rotation_x += rotation_speed_keys * delta
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		rotation_x -= rotation_speed_keys * delta
			
		# Aplica a rotação somente se houver movimento
	if rotation_y != 0.0:
		rotate_y(rotation_y)
	if rotation_x != 0.0:
		rotate_x(rotation_x)

func _zoom_camera(amount: float) -> void:
	var cam_node := $Camera3D
	if cam_node and cam_node is Camera3D:
		var cam: Camera3D = cam_node as Camera3D
		# força tipo Vector3 para o forward
		var forward: Vector3 = -cam.transform.basis.z.normalized()
		cam.translate_object_local(forward * amount)
