extends Area2D

#export var shape: PoolVector2Array setget set_shape
export var colour: Color = Color8(255, 255, 255) setget set_colour, get_colour
export var show_line = false setget show_line
#export var shape: ConvexPolygonShape2D setget set_polygon

export var parent_1: String # node path
export var parent_2: String # node path

func set_intersection_between(mother: String, father: String):
	# this is a very heteronormative game ok
	parent_1 = mother
	parent_2 = father

#func set_shape(new_shape: PoolVector2Array):
#	shape = new_shape
#	$Polygon2D.polygon = shape
#	$CollisionPolygon2D.polygon = shape
#	$Line2D.points = shape

func set_colour(new_colour: Color):
	colour = new_colour
	#$Polygon2D.color = colour
	var actual_shape = get_node('Polygon')
	if actual_shape == null or not actual_shape is Polygon2D: return # intersection shape
	actual_shape.color = new_colour

func get_colour():
	var actual_shape = get_node('Polygon')
	if actual_shape == null or not actual_shape is Polygon2D: return # intersection shape
	print('Got colour ' + actual_shape.color.to_html(false))
	return actual_shape.color

func show_line(show):
	if show:
		$Line2D.show()
	else:
		$Line2D.hide()

func set_polygon(polygon: PoolVector2Array):
#	shape = new_shape
	#$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon
	$Line2D.points = polygon

func get_polygon():
	return $CollisionPolygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	var actual_shape = get_node('Polygon')
	if actual_shape == null or not actual_shape is Polygon2D: return # intersection shape
	#assert(actual_shape != null and actual_shape is Polygon2D, 'Must provide a child node of type Polygon2D')

	#$Polygon2D.polygon = shape
	$CollisionPolygon2D.polygon = actual_shape.polygon
	$Line2D.points = actual_shape.polygon
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
