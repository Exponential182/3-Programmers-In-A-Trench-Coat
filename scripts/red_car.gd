extends VehicleBody3D


var max_rpm = 500
var max_torque = 200
var engine_force_multiplier = 100
var steering_multiplier = 0.4
@onready var camera = $"Camera3D"
func _physics_process(delta: float) -> void:
	steering = lerp(steering, Input.get_axis("right","left") * steering_multiplier, 5 * delta)
	var acceleration = Input.get_axis("backward","forward")
	var rpm = $BL_Wheel.get_rpm()
	$BL_Wheel.engine_force = acceleration * max_torque * (1-rpm/max_rpm)
	rpm = $BR_Wheel.get_rpm()
	$BR_Wheel.engine_force = acceleration * max_torque * (1-rpm/max_rpm)
