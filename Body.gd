extends RigidBody3D

@onready var leg1 = $Leg1
@onready var leg2 = $Leg2
@onready var leg3 = $Leg3
@onready var leg4 = $Leg4

var loopTimer = 0
const MIN_VEL = -3
const MAX_VEL = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.set_time_scale(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func _physics_process(delta: float) -> void:	
	loopTimer += delta
	if loopTimer > 2:
		loopTimer = 0
		loop()

func loop() -> void :
	leg1.set_coxa_velocity(randf_range(MIN_VEL,MAX_VEL))
	leg2.set_coxa_velocity(randf_range(MIN_VEL,MAX_VEL))
	leg3.set_coxa_velocity(randf_range(MIN_VEL,MAX_VEL))
	leg4.set_coxa_velocity(randf_range(MIN_VEL,MAX_VEL))
	
	leg1.set_tibia_velocity(randf_range(MIN_VEL,MAX_VEL))
	leg2.set_tibia_velocity(randf_range(MIN_VEL,MAX_VEL))
	leg3.set_tibia_velocity(randf_range(MIN_VEL,MAX_VEL))
	leg4.set_tibia_velocity(randf_range(MIN_VEL,MAX_VEL))
