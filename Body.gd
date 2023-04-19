class_name Quadruped
extends RigidBody3D

@onready var leg1 = $Leg1
@onready var leg2 = $Leg2
@onready var leg3 = $Leg3
@onready var leg4 = $Leg4

var loopTimer = 0
var index = 0

const MIN_VEL = -3
const MAX_VEL = 3
const ARRAY_LENGTH = 20

var data = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.set_time_scale(1)
	initialize_data_with_random_numbers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$DistanceFromCenter.text = str(snapped(abs(position.z),0.01))
	$DistanceTraveled.text = str(snapped(position.x,0.01))
	
	
func _physics_process(delta: float) -> void:
	loopTimer += delta
	if loopTimer > 0.05:
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
	if index >= ARRAY_LENGTH: index = 0

func initialize_data_with_random_numbers() -> void:
	data.clear()
	
	data["Leg1Femur"] = []
	data["Leg2Femur"] = []
	data["Leg3Femur"] = []
	data["Leg4Femur"] = []
	data["Leg1Tibia"] = []
	data["Leg2Tibia"] = []
	data["Leg3Tibia"] = []
	data["Leg4Tibia"] = []
	
	for i in ARRAY_LENGTH:
		for key in data.keys():
			data[key].append(randf_range(MIN_VEL,MAX_VEL))
			
