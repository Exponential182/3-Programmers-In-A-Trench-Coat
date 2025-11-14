extends VehicleBody3D


var max_rpm = 5000
var max_torque = 2000
var steering_multiplier = 0.4
#@onready var camera = $"Camera3D"
func _physics_process(delta: float) -> void:
	steering = lerp(steering, Input.get_axis("right","left") * steering_multiplier, 5 * delta)
	var acceleration = Input.get_axis("backward","forward")

	var rpm = $BL_Wheel.get_rpm()
	$BL_Wheel.engine_force = acceleration * max_torque * (1-rpm/max_rpm)
	rpm = $BR_Wheel.get_rpm()
	$BR_Wheel.engine_force = acceleration * max_torque * (1-rpm/max_rpm)
	if not Input.is_action_pressed("forward") and not Input.is_action_pressed("backward"):
		$BR_Wheel.engine_force = lerp($BR_Wheel.engine_force,0.0,5.0)
		$BL_Wheel.engine_force = lerp($BL_Wheel.engine_force,0.0,5.0)
