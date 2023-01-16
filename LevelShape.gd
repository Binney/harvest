extends Node2D

# These shapes are the fundamental shapes that define a level.
# Just add 'em in and pick your colour and handles.
# They'll intersect with each other to form visible colour zones according
# to the mixing rules.
# By default, they:
# - Aren't subject to physics/gravity
# - Have drag handles at each vertex that the user can move (assuming they're
#   in view, that is!)

tool

enum colours {
	TURQUOISE,
	DEEP_RED,
	PINK,
	BLUE,
	GOLD,
	ORANGE,
	BLACK,
	BG_COLOUR,
	ANSWER_RED,
	FINAL_WHITE
}

export (colours) var colour = colours.TURQUOISE setget set_colour, get_colour
export var redraw_shape = false setget set_redraw_shape

signal shape_changed

var handles = []

func get_polygon():
	return $CollisionPolygon2D.polygon

func set_colour(value):
	print('Changed colour to ' + str(value))
	colour = value
	emit_signal('shape_changed')

func get_colour():
	return colour

# Not actually a getter, just a way of allowing the dev to trigger redraws in the editor
func set_redraw_shape(value):
	print("Redrawing shape")
	if !has_node('Polygon2D'):
		return
	var polygon = get_node('Polygon2D') as Polygon2D
	$Line2D.clear_points()
	$CollisionPolygon2D.polygon = polygon.polygon
	clear_handles()
	for point in polygon.polygon:
		$Line2D.add_point(point)
		spawn_handle_at(point)
	$Line2D.add_point(polygon.polygon[0])
	emit_signal('shape_changed')

func clear_handles():
	handles = []

func spawn_handle_at(point: Vector2):
	# TODO: spawn handle to click on
	handles.push_back(point)
	pass


func _on_Polygon2D_draw():
	pass
	# TODO reinstate once script no longer freaking out
	#set_redraw_shape(true)
