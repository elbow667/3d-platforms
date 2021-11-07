extends Spatial

var fps = preload("res://FirstPerson.tscn")

onready var playerSpawnPoint = $WorldLevel1/SpawnPoint.translation

# Called when the node enters the scene tree for the first time.
func _ready():
	
	## Spawn player
	var player = fps.instance()
	add_child(player)
	#player.translation = Vector3(0, 100, 0)
	player.translation = playerSpawnPoint


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


