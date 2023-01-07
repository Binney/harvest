extends Area2D

export var shape: PoolVector2Array setget set_shape
export var colour: Color = Color8(255, 255, 255) setget set_colour
export var show_line = false setget show_line

export var parent_1: String # node path
export var parent_2: String # node path

func set_intersection_between(mother: String, father: String):
	# this is a very heteronormative game ok
	parent_1 = mother
	parent_2 = father

func set_shape(new_shape: PoolVector2Array):
	shape = new_shape
	$Polygon2D.polygon = shape
	$CollisionPolygon2D.polygon = shape
	$Line2D.points = shape

func set_colour(new_colour: Color):
	colour = new_colour
	$Polygon2D.color = colour

func show_line(show):
	if show:
		$Line2D.show()
	else:
		$Line2D.hide()

func get_polygon():
	return $Polygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	$Polygon2D.polygon = shape
	$CollisionPolygon2D.polygon = shape
	$Line2D.points = shape
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
