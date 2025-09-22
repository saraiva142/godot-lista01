extends Node2D

@export var radius: float = 50.0
var color: Color = Color(1, 0, 0) # vermelho

func _ready():
	queue_redraw()

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_PLUS, KEY_KP_PLUS: # Tecla + (tanto no teclado normal quanto no numérico)
				radius += 5.0
				queue_redraw()
			KEY_MINUS, KEY_KP_MINUS: # Tecla -
				radius = max(5.0, radius - 5.0) # evita raio negativo
				queue_redraw()
			KEY_C: # tecla C para trocar cor
				color = Color.randf(), Color.randf(), Color.randf()
				queue_redraw()

func _draw():
	draw_circle(Vector2(200, 200), radius, color)
