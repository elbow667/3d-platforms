extends RigidBody

onready var healthbar = $HealthBar3D/Viewport/ProgressBar
onready var health = $Health
var hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health.connect("changed", healthbar, "set_value")
	health.connect("max_changed", healthbar, "set_max")
	health.initialize()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit:
		health.current -= 10
		print(health.current)
		hit = false		
		if health.current <= 0:
			print("dead")
			queue_free()



