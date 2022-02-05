extends Spatial

var fps = preload("res://FirstPerson.tscn")

# dictionary of Vector3 coordinates for specific objects
onready var playerSpawnPoints = {
tunnel= $SpawnPoints/SpawnPoint.translation,
rooftop= $SpawnPoints/SpawnPoint2.translation,
farcorner= $SpawnPoints/SpawnPoint3.translation
}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	## Spawn player
	
	var random_key = get_random_key()
	print(random_key)
	var playerSpawnPoint = playerSpawnPoints[random_key]
	
	
	#print(playerSpawnPoint)
	var player = fps.instance()
	add_child(player)
	#player.translation = Vector3(0, 100, 0)
	#player.translation = playerSpawnPoint
	player.translation = playerSpawnPoint


# returns the name of a key in the dictionary
func get_random_key():
	var random_id = randi() % playerSpawnPoints.size()
	var random_key = playerSpawnPoints.keys()[random_id]
	return random_key

