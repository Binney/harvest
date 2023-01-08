extends Area2D

export(Colours.SHAPE_COLOURS) var colour = Colours.SHAPE_COLOURS.GOLD setget set_colour, get_colour
export var show_line = false setget show_line

export var parent_1: String # node path
export var parent_2: String # node path

func set_intersection_between(mother: String, father: String):
	# this is a very heteronormative game ok
	parent_1 = mother
	parent_2 = father

func set_colour(new_colour: int):
	colour = new_colour
	print('Setting shape colour to ' + str(new_colour))
	var actual_shape = get_node('Polygon') as Polygon2D
	if not actual_shape:
		print('no polygon')
		return
	actual_shape.color = Color(Colours.to_hex(colour))

func get_colour():
	return colour

func show_line(show):
	if show:
		$Line2D.show()
	else:
		$Line2D.hide()

func set_polygon(polygon: PoolVector2Array):
	$CollisionPolygon2D.polygon = polygon
	$Line2D.points = polygon

func get_polygon():
	return $CollisionPolygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	var actual_shape = get_node('Polygon') as Polygon2D
	if not actual_shape: return # TODO throw with a useful message?

	$CollisionPolygon2D.polygon = actual_shape.polygon
	$Line2D.points = actual_shape.polygon
	pass # Replace with function body.


