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

export var colour = 'green'
export var redraw_shape = false setget set_redraw_shape

var handles = []

func set_redraw_shape(value):
	print("Redrawing shape")
	if !has_node('Polygon2D'):
		return
	var polygon = get_node('Polygon2D') as Polygon2D
	$Line2D.clear_points()
	clear_handles()
	for point in polygon.polygon:
		$Line2D.add_point(point)
		spawn_handle_at(point)

func clear_handles():
	handles = []

func spawn_handle_at(point: Vector2):
	# TODO: spawn handle to click on
	handles.push_back(point)
	pass
