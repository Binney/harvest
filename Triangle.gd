extends Area2D

export var points: PoolVector2Array
export var color: Color = Color8(62, 155, 137)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_polygon():
	return $Polygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionPolygon2D.polygon = points
	$Polygon2D.polygon = points
	$Polygon2D.color = color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
