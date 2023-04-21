class_name Quadruped
extends RigidBody3D

@onready var leg1 = $Leg1
@onready var leg2 = $Leg2
@onready var leg3 = $Leg3
@onready var leg4 = $Leg4

@onready var fitnessLabel = $Fitness

var loopTimer = 0
var index = 0



var data = {}
var running = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fitnessLabel.text = str(snapped(calculate_fitness(),0.01))
	
	
func _physics_process(delta: float) -> void:
	if !running: return
	
	loopTimer += delta
	if loopTimer > 0.2:
		loopTimer = 0
		loop()

func loop() -> void :
	leg1.set_femur_velocity(data["Leg1Femur"][index])
	leg2.set_femur_velocity(data["Leg2Femur"][index])
	leg3.set_femur_velocity(data["Leg3Femur"][index])
	leg4.set_femur_velocity(data["Leg4Femur"][index])
	
	leg1.set_tibia_velocity(data["Leg1Tibia"][index])
	leg2.set_tibia_velocity(data["Leg2Tibia"][index])
	leg3.set_tibia_velocity(data["Leg3Tibia"][index])
	leg4.set_tibia_velocity(data["Leg4Tibia"][index])
	
	index += 1
	if index >= Manager.ARRAY_LENGTH: index = 0

func randomize_data() -> void:
	data.clear()
	
	data["Leg1Femur"] = []
	data["Leg2Femur"] = []
	data["Leg3Femur"] = []
	data["Leg4Femur"] = []
	data["Leg1Tibia"] = []
	data["Leg2Tibia"] = []
	data["Leg3Tibia"] = []
	data["Leg4Tibia"] = []
	
	for i in Manager.ARRAY_LENGTH:
		for key in data.keys():
			data[key].append(randf_range(Manager.MIN_VEL,Manager.MAX_VEL))
			

func calculate_fitness() -> float:
	var distanceTraveled = position.z
	var distanceFromCenter = abs(position.x)
	var fitness = 0
	
	fitness += distanceTraveled * 10
	fitness -= distanceFromCenter * 2
	
	if distanceTraveled < 0: fitness -= 100
	
	return snapped(fitness,0.01)
	
func is_survivor():
	$AnimationPlayer.play("survivor")
