extends Node2D

@export var xmin: float = -2.0
@export var xmax: float = 7
@export var step: float = 0.01
@export var scale_xy: float = 50.0
@export var origin: Vector2 = Vector2(320, 240)
@export var show_axes := true
@export var line_width: float = 2.0

@export var a: float = 1.0
@export var b: float = -6.0
@export var c: float = 5.0

#f(x) = y = x^2 + 5x + 4

func _ready() -> void:
	queue_redraw()

func f(x: float) -> float:
	return a * x * x + b * x + c

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color(1, 1, 1))
	
	if show_axes:
		_draw_axes()
	var pts := PackedVector2Array()
	var x := xmin
	while x <= xmax:
		var y := f(x)
		var p := origin + Vector2(x, -y) * scale_xy
		pts.append(p)
		x += step
	draw_polyline(pts, Color(0,0,1), line_width, true)
	_draw_quadratic_features()

func _draw_axes() -> void:
	draw_line(origin + Vector2(xmin, 0) * scale_xy, origin + Vector2(xmax, 0) * scale_xy, Color(0.2, 0.2, 0.2), 1.0)
	draw_line(origin + Vector2(0, -1000), origin + Vector2(0, 1000), Color(0.2, 0.2, 0.2))
	
func _draw_quadratic_features() -> void:
	var delta := b*b - 4.0*a*c
	if delta >= 0.0:
		var r1 := (-b - sqrt(delta)) / (2.0 * a)
		var r2 := (-b + sqrt(delta)) / (2.0 * a)
		_draw_point(Vector2(r1, 0.0), Color(1, 0, 0))
		_draw_point(Vector2(r2, 0.0), Color(1, 0, 0))
	var xv := -b / (2.0 * a)
	var yv := f(xv)
	_draw_point(Vector2(xv, yv), Color(0, 0.6, 0.6))

func _draw_point(p_graph: Vector2, col: Color) -> void:
	var p := origin + Vector2(p_graph.x, -p_graph.y) * scale_xy
	draw_circle(p, 4.0, col)	
