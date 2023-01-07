extends Area2D

export var shape: PoolVector2Array setget set_shape

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_shape(new_shape: PoolVector2Array):
	shape = new_shape
	$Polygon2D.polygon = shape
	$CollisionPolygon2D.polygon = shape
	$Line2D.points = shape

# Called when the node enters the scene tree for the first time.
func _ready():
	$Polygon2D.polygon = shape
	$CollisionPolygon2D.polygon = shape
	$Line2D.points = shape
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
