extends Node2D

@export var radius: float = 50.0
@export var min_radius: float = 5.0
@export var step: float = 5.0
@export var color: Color = Color(1, 0, 0)

var center: Vector2 = Vector2.ZERO
var _last_viewport_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	_update_center()
	queue_redraw()

func _process(delta: float) -> void:
	# Atualiza o centro se a janela mudou de tamanho
	var size := get_viewport_rect().size
	if size != _last_viewport_size:
		_last_viewport_size = size
		_update_center()
		queue_redraw()

	# Leitura das ações (Input Map)
	var changed := false
	if Input.is_action_just_pressed("radius_increase"):
		radius += step
		changed = true
	if Input.is_action_just_pressed("radius_decrease"):
		radius = max(min_radius, radius - step)
		changed = true
	if Input.is_action_just_pressed("color_change"):
		color = Color(randf(), randf(), randf())
		changed = true

	if changed:
		queue_redraw()

func _update_center() -> void:
	center = get_viewport_rect().size * 0.5

func _draw() -> void:
	draw_circle(center, radius, color)
