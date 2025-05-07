extends KinematicBody

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		var r = get_rotation();
		r.y = r.y + 0.01;
		set_rotation(r);
	if Input.is_action_pressed("ui_right"):
		var r = get_rotation();
		r.y = r.y - 0.01;
		set_rotation(r);
	if Input.is_action_pressed("ui_up"):
		var t = get_global_transform().basis.z;
		t = t.normalized()*(-1);
		move_and_slide(t*2.0);
	if Input.is_action_pressed("ui_down"):
		var t = get_global_transform().basis.z
		t = t.normalized()*(-1);
		move_and_slide(t*-2.0);
