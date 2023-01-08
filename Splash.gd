extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var circle_scene = preload("Circle.tscn")
var triangle_scene = preload("Triangle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_circle()
	$Button.grab_focus()
	pass # Replace with function body.

func spawn_circle():
	var circle = circle_scene.instance()
	circle.size = 50 + (randi() % 100)
	circle.colour = Colours.get_rand_colour()
	circle.position = Vector2((randi() % 400) + (randi() % 2) * 600, -circle.size)
	circle.gravity_scale = 1
	circle.mass = circle.size / 100
	add_child(circle)

func spawn_triangle():
	var triangle = triangle_scene.instance()
	var points = [Vector2(-69, 70) * (randf() + 1),
		Vector2(69, 111) * (randf() + 1),
		Vector2(85, -38) * (randf() + 1)]
	triangle.polygon = points
	triangle.colour = Colours.get_rand_colour()
	triangle.position = Vector2((randi() % 400) + (randi() % 2) * 600, -500)
	triangle.rotation = randi() * 6
	triangle.apply_torque_impulse((randf() * 4) - 2)
	add_child(triangle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randi() % 400 == 0:
		print('Ooh I think I\'ll spawn a circle now')
		spawn_circle()
	elif randi() % 300 == 0:
		print('Nah, triangle instead')
		spawn_triangle()
	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Level1.tscn")
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	body.queue_free()
	pass # Replace with function body.
